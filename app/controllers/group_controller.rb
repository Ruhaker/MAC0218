class GroupController < ApplicationController

  #
  # Returns whether given user can modify given group
  #
  def can_modify?(group)
    # Get root group
    curr_group = group
    while curr_group.group
      curr_group = curr_group.group
    end

    # Verify if can be modified by current user
    user = get_logged_user()
    return unless user

    if user.class.name == "Student"
      # If student, must be part of this student's plan
      return false unless curr_group.plan
      return false unless user == curr_group.plan.student

    elsif user.class.name == "Supervisor"
      # If supervisor, must supervise course that has this group
      return false unless user.courses.find(curr_group.course.id)
    else
      # If unknown class, do nothing
      return
    end

    return true
  end

  def create
    # Must be POST request to create group
    return unless request.post?

    # Receives parameters from the group creation page
    group_parent_id     = params[:parent_group_id]
    group_name          = params[:name]
    group_min_credits   = params[:min_credits]
    group_min_subjects  = params[:min_subjects]

    # Fallback to default values for nil parameters
    group_name          = ""  unless group_name
    group_min_credits   = nil unless group_min_credits
    group_min_subjects  = nil unless group_min_subjects
    
    # Check if user can modify given parent group
    parent_group = Group.find(group_parent_id)
    return unless parent_group
    return unless can_modify? parent_group

    # Create group and sets parent
    group = Group.create!(
      :name         => group_name,
      :min_credits  => group_min_credits,
      :min_subjects => group_min_subjects
    )

    Group.find(group_parent_id).groups << group

    redirect_back fallback_location: "/"
  end

  def modify
    # Must be POST request to create group
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
