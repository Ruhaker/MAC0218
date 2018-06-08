class GroupController < ApplicationController
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

    group = Group.create!(
      :name         => group_name,
      :min_credits  => group_min_credits,
      :min_subjects => group_min_subjects
    )

    Group.find(group_parent_id).groups << group

  end

  def modify
    # Must be POST request to create group
    return unless request.post?
  end

  def destroy
    # Must be POST request to create group
    return unless request.post?
  end
end
