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
  def can_modify?(group)
    # Get root group
    curr_group = group
    while curr_group.group
      curr_group = curr_group.group
    end

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
  def build_group_data(group)
    result = {}

    # Group data
    result[:type]         = 'group'
    result[:id]           = group.id
    result[:name]         = group.name
    result[:min_credits]  = group.min_credits
    result[:min_subjects] = group.min_subjects
    result[:can_modify]   = can_modify? group
    result[:children]     = []

    # Subgroups data
    group.groups.each do |child_group|
      result[:children].push(build_group_data(child_group))
    end

    # Get logged in user
    user = get_logged_user()

    # Subjects data
    group.subjects.each do |child_subject|
      subject = {}
      subject[:type]      = 'subject'
      subject[:id]        = child_subject.id
      subject[:code]      = child_subject.code
      subject[:name]      = child_subject.name
      subject[:progress]  = nil

      # Fetch subject progress if is student
      if user && user.is?('student')
        relationship = SubjectStudent.find_by(:student_id => user.id, :subject_id => child_subject.id)
        if relationship
          subject[:progress] = relationship.progress
        end
      end

      result[:children].push subject
    end

    return result
  end

  def fetch
    response = {}
    status_code = nil

    begin
      # Must be POST request to retrieve group
      return unless request.post?

      # Receives parameters
      group_id = params[:group_id]

      if group_id == nil
        status_code = 400
        raise 'group_id is required'
      end

      # Check if user can retrieve group
      group = Group.find_by(:id => group_id)

      if !group
        status_code = 404
        raise 'Group was not found'
      end

      if !(can_retrieve? group)
        status_code = 403
        raise 'User not allowed to fetch this group'
      end

      # Build response data
      response[:group] = build_group_data(group)

    rescue Exception => e
      status_code = 500 if status_code == nil
      response[:status] = 'error'
      response[:error]  = "#{e}"
    else
      status_code = 200
      response[:status] = 'success'
    end

    render :json => response, :status => status_code
  end

  def update
    response = {}
    status_code = nil

    begin
      # Must be POST request to retrieve group
      return unless request.post?

      # Receives parameters
      group_id          = params[:group_id]
      new_name          = params[:name]
      new_min_credits   = params[:min_credits]
      new_min_subjects  = params[:min_subjects]

      changes = {}
      changes[:name]          = new_name if new_name
      changes[:min_credits]   = new_min_credits if new_min_credits
      changes[:min_subjects]  = new_min_subjects if new_min_subjects

      if changes.size == 0
        status_code = 400
        raise 'At least one change is required'
      end

      if group_id == nil
        status_code = 400
        raise 'group_id is required'
      end

      # Check if user can retrieve group
      group = Group.find_by(:id => group_id)

      if !group
        status_code = 404
        raise 'Group was not found'
      end

      if !(can_modify? group)
        status_code = 403
        raise 'User not allowed to fetch this group'
      end

      # Change data in group
      group.update(changes)

      if !group.valid?
        status_code = 400
        raise 'Invalid changes'
      end

      # Save changes
      group.save
    rescue Exception => e
      status_code = 500 if status_code == nil
      response[:status] = 'error'
      response[:error]  = "#{e}"
    else
      status_code = 200
      response[:status] = 'success'
    end

    render :json => response, :status => status_code
  end

  def create
    response = {}
    status_code = 200

    begin
      # Must be POST request to create group
      return unless request.post?

      # Receives parameters from the group creation page
      group_parent_id     = params[:parent_group_id]
      group_name          = params[:name]
      group_min_credits   = params[:min_credits]
      group_min_subjects  = params[:min_subjects]

      if group_parent_id == nil
        status_code = 400
        raise 'parent_group_id is required'
      end

      # Fallback to default values for nil parameters
      group_name          = ""  unless group_name
      group_min_credits   = nil unless group_min_credits
      group_min_subjects  = nil unless group_min_subjects

      # Check if user can modify given parent group
      parent_group = Group.find(group_parent_id)

      if !parent_group
        status_code = 404
        raise 'Parent group was not found'
      end

      if !(can_modify? parent_group)
        status_code = 403
        raise 'Cannot edit this group with this user'
      end

      # Create group and sets parent
      group = Group.create(
        :name         => group_name,
        :min_credits  => group_min_credits,
        :min_subjects => group_min_subjects
      )

      if group
        status_code = 500
        raise 'Failed to create group'
      end

      Group.find(group_parent_id).groups << group

    rescue Exception => e
      response[:status] = 'error'
      response[:error]  = "#{e}"
    else
      status_code = 201
      response[:status] = 'success'
    end

    render :json => response, :status => status_code
  end

  def modify
    # Must be POST request to modify group
    return unless request.post?
  end

  def destroy
    # Must be POST request to create group
    return unless request.post?

    # Receives parameters from the group deletion page
    group_id = params[:group_id]

    # Check if user can modify given group
    group = Group.find(group_id)
    return unless group
    return unless can_modify? group

    # Can't destroy root group
    return unless group.group

    # Destroy given group
    group.destroy
    
    redirect_back fallback_location: "/"
  end

  def add_subject
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

    group.subjects << subject
    
    redirect_back fallback_location: "/"

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
