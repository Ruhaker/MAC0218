class GroupController < ApplicationControllerAPI
  #
  # Returns whether given user can retrieve given group
  #
  def can_retrieve?(group)
    # Get root group
    curr_group = group
    while curr_group.group
      curr_group = curr_group.group
    end

    # If it's a course's base group, anyone can fetch it
    return true if curr_group.course

    # Get logged in user
    user = get_logged_user()
    return false unless user

    if user.is? "student"
      # If student, must be part of a plan owned by this student
      return false unless curr_group.plan
      return false unless user == curr_group.plan.student
    else
      # Otherwise, can't
      return false
    end

    return true
  end

  #
  # Returns whether given user can modify given group
  #
  def can_modify?(group, allow_root = true)
    # Get root group
    curr_group = group
    while curr_group.group
      curr_group = curr_group.group
    end

    # If group is root and can't be root, can't edit
    return false if curr_group == group && !allow_root

    # Get logged in user
    user = get_logged_user()
    return false unless user

    if user.is? "student"
      # If student, must be part of this student's plan
      return false unless curr_group.plan
      return false unless user == curr_group.plan.student

    elsif user.is? "supervisor"
      # If supervisor, must supervise course that has this group
      return false unless user.courses.find(curr_group.course.id)
    else
      # If unknown class, can't modify
      return false
    end

    return true
  end

  #
  # Build dictionary from group
  #
  def build_group_data(group, depth = 6)
    result = {}

    return result if depth == 0

    # Group data
    result[:type]           = 'group'
    result[:id]             = group.id
    result[:name]           = group.name
    result[:min_credits]    = group.min_credits
    result[:min_subjects]   = group.min_subjects
    result[:can_modify]     = can_modify? group
    result[:index]          = group.index
    result[:children]       = []
    result[:done_credits]   = 0
    result[:done_subjects]  = 0
    result[:visualizing]    = group.visualizing

    # Subgroups data
    group.groups.each do |child_group|
      child_group_data = build_group_data(child_group, depth - 1)
      result[:done_credits] += child_group_data[:done_credits]
      result[:done_subjects] += 1 if\
        child_group_data[:progress_cred] == 2 || child_group_data[:progress_subj] == 2
      result[:children].push(child_group_data)
    end

    # Subjects data
    group.group_indices.each do |child_index|
      child_subject = child_index.subject

      subject = {}
      subject[:type]      = 'subject'
      subject[:id]        = child_index.id
      subject[:subj_id]   = child_subject.id
      subject[:code]      = child_subject.code
      subject[:name]      = child_subject.name
      subject[:index]     = child_index.index
      subject[:progress]  = nil

      # Fetch subject progress if is student
      if @user && @user.is?('student')
        relationship = SubjectStudent.find_by(:student_id => @user.id, :subject_id => child_subject.id)
        if relationship
          subject[:progress]      = relationship.progress
          result[:done_credits]  += child_subject.credits_class + child_subject.credits_work if subject[:progress] == 2
          result[:done_subjects] += 1 if subject[:progress] == 2
        end
      end

      result[:children].push subject
    end

    # Progress for credits
    if result[:min_credits] && result[:min_credits] > 0
      result[:progress_cred]  = 0 if result[:done_credits] < result[:min_credits]
      result[:progress_cred]  = 2 if result[:done_credits] >= result[:min_credits]
    else
      result[:progress_cred]  = nil
    end

    # Progress for subjects
    if result[:min_subjects] && result[:min_subjects] > 0
      result[:progress_subj]  = 0 if result[:done_subjects] < result[:min_subjects]
      result[:progress_subj]  = 2 if result[:done_subjects] >= result[:min_subjects]
    else
      result[:progress_subj]  = nil
    end

    # Sort data by indexes
    result[:children] = result[:children].sort_by { |child| child[:index] or 0 }

    return result
  end

  def fetch
    begin
      # Must be POST request to retrieve group
      return unless request.post?

      # Receives parameters
      group_id = get_param(:group_id)

      # Check if user can retrieve group
      group = Group.find_by(:id => group_id)

      if !group
        @status_code = 404
        raise 'Group was not found'
      end

      if !(can_retrieve? group)
        @status_code = 403
        raise 'User not allowed to fetch this group'
      end

      # Build response data
      @response[:group] = build_group_data(group)

    rescue Exception => e
        @status_code = 500 unless @status_code
        @response[:status] = 'error'
        @response[:error]  = "#{e}"
        @response[:bt]  = "#{e.backtrace}"
    else
        @status_code = 200
        @response[:status]  = 'success'
    end

    render :json => @response, :status => @status_code
  end

  def update
    begin
      # Must be POST request to retrieve group
      return unless request.post?

      # Receives parameters
      group_id          = get_param(:group_id)
      new_parent        = get_param(:parent_id, false)
      new_name          = get_param(:name, false)
      new_min_credits   = get_param(:min_credits, false)
      new_min_subjects  = get_param(:min_subjects, false)
      new_index         = get_param(:index, false)
      new_visualizing   = get_param(:visualizing, false)

      changes = {}
      changes[:group_id]      = new_parent if new_parent
      changes[:name]          = new_name if new_name
      changes[:min_credits]   = new_min_credits if new_min_credits
      changes[:min_subjects]  = new_min_subjects if new_min_subjects
      changes[:index]         = new_index if new_index
      changes[:visualizing]   = new_visualizing if new_visualizing != nil

      if changes.size == 0
        @status_code = 400
        raise 'At least one change is required'
      end

      # Check if user can retrieve group
      group = Group.find_by(:id => group_id)

      if !group
        @status_code = 404
        raise 'Group was not found'
      end

      if !(can_modify? group)
        @status_code = 403
        raise 'User not allowed to fetch this group'
      end

      if changes[:group_id] && !group.group
        @status_code = 400
        raise 'Can\'t change parent_id of root group'
      end

      # If changing parent, check if can modify parent group
      if new_parent
        parent = Group.find_by(:id => new_parent)

        if !parent
          @status_code = 404
          raise 'Parent group was not found'
        end

        if !(can_modify? parent)
          @status_code = 403
          raise 'User not allowed to modify parent group'
        end
      end

      # Change data in group
      group.update(changes)

      if !group.valid?
        @status_code = 400
        raise 'Invalid changes'
      end

      # Save changes
      group.save
    rescue Exception => e
      @status_code = 500 unless @status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 200
      @response[:status]  = 'success'
    end

    render :json => @response, :status => @status_code
  end

  def update_index
    begin
      # Must be POST request to retrieve group
      return unless request.post?

      # Receives parameters
      index_id          = get_param(:index_id)
      new_group         = get_param(:group_id, false)
      new_index         = get_param(:index, false)

      changes = {}
      changes[:group_id]      = new_group if new_group
      changes[:index]         = new_index if new_index

      if changes.size == 0
        @status_code = 400
        raise 'At least one change is required'
      end

      # Check if user can retrieve index
      index = GroupIndex.find_by(:id => index_id)

      if !index
        @status_code = 404
        raise 'Index was not found'
      end

      if !(can_modify? index.group)
        @status_code = 403
        raise 'User not allowed to modify this index'
      end

      # If changing parent, check if can modify parent group
      if new_group
        parent = Group.find_by(:id => new_group)

        if !parent
          @status_code = 404
          raise 'Parent group was not found'
        end

        if !(can_modify? parent)
          @status_code = 403
          raise 'User not allowed to modify parent group'
        end
      end

      # Change data in group
      index.update(changes)

      if !index.valid?
        @status_code = 400
        raise 'Invalid changes'
      end

      # Save changes
      index.save
    rescue Exception => e
      @status_code = 500 unless @status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 200
      @response[:status]  = 'success'
    end

    render :json => @response, :status => @status_code
  end

  def create
    begin
      # Must be POST request to create group
      return unless request.post?

      # Receives parameters from the group creation page
      group_parent_id     = get_param(:parent_group_id)
      group_name          = get_param(:name)
      group_min_credits   = get_param(:min_credits, false)
      group_min_subjects  = get_param(:min_subjects, false)
      group_ordering      = get_param(:ordering)

      # Check if user can modify given parent group
      parent_group = Group.find(group_parent_id)

      if !parent_group
        @status_code = 404
        raise 'Parent group was not found'
      end

      if !(can_modify? parent_group)
        @status_code = 403
        raise 'Cannot edit this group with this user'
      end

      # Create group and sets parent
      group = Group.create(
        :name         => group_name,
        :min_credits  => group_min_credits,
        :min_subjects => group_min_subjects,
        :index        => group_ordering
      )

      if !group
        @status_code = 500
        raise 'Failed to create group'
      end

      Group.find(group_parent_id).groups << group

      @response[:id] = group.id
    rescue Exception => e
      @status_code = 500 unless @status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 200
      @response[:status]  = 'success'
    end

    render :json => @response, :status => @status_code
  end

  def destroy
    begin
      # Must be POST request to create group
      return unless request.post?

      # Receives parameters from the group deletion page
      group_id = get_param(:group_id)

      # Check if user can modify given group
      group = Group.find_by(:id => group_id)
      if !group
        @status_code = 404
        raise 'Group was not found'
      end

      if !can_modify?(group, false)
        @status_code = 403
        raise 'User can\'t modify this group'
      end

      # Destroy given group
      group.destroy
    rescue Exception => e
      @status_code = 500 unless @status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 200
      @response[:status]  = 'success'
    end

    render :json => @response, :status => @status_code
  end

  def destroy_index
    begin
      # Must be POST request to create group
      return unless request.post?

      # Receives parameters from the group deletion page
      index_id = get_param(:index_id)

      # Check if user can modify given group
      index = GroupIndex.find_by(:id => index_id)
      if !index
        @status_code = 404
        raise 'Group was not found'
      end

      if !can_modify?(index.group)
        @status_code = 403
        raise 'User can\'t modify this group'
      end

      # Destroy given index
      index.destroy
    rescue Exception => e
      @status_code = 500 unless @status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 200
      @response[:status]  = 'success'
    end

    render :json => @response, :status => @status_code
  end

  def add_subject
    begin
      # Must be POST request to create group
      return unless request.post?

      # Receives parameters
      group_id   = get_param(:group_id)
      subject_id = get_param(:subject_id)
      ordering   = get_param(:ordering)

      # Check if user can modify given group
      group = Group.find(group_id)

      if !group
        @status_code = 404
        raise 'Group was not found'
      end

      if !can_modify?(group)
        @status_code = 403
        raise 'User can\'t modify this group'
      end

      # Gets subject
      subject = Subject.find(subject_id)

      if !group
        @status_code = 404
        raise 'Subject was not found'
      end

      # Adds to group
      group.subjects << subject

      group.save
      subject.save

      # Finally, set index
      relationship = GroupIndex.find_by(:group_id => group.id, :subject_id => subject.id)

      if !relationship
        raise 'Index was not created'
      end

      relationship.index = ordering

      if !relationship.valid?
        @status_code = 400
        raise 'Given ordering was invalid'
      end

      relationship.save
    rescue Exception => e
      @status_code = 500 unless @status_code
      @response[:status] = 'error'
      @response[:error]  = "#{e}"
    else
      @status_code = 200
      @response[:status]  = 'success'
    end

    render :json => @response, :status => @status_code

  end

  def rem_subject
    # Must be POST request to create group
    return unless request.post?

    # Receives parameters
    group_id   = params[:group_id]
    subject_id = params[:subject_id]

    return unless group_id
    return unless subject_id

    # Check if user can modify given group
    group = Group.find(group_id)
    return unless group
    return unless can_modify? group

    # Adds subject to group
    subject = Subject.find(subject_id)
    return unless subject

    group.subjects.delete(subject)

    redirect_back fallback_location: "/"
  end
end
