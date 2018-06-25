class PlanController < ApplicationControllerAPI
  def create
  end

  def fetch
    response = {}
    status_code = nil

    begin
      # Must be POST request
      return unless request.post?

      # Receives parameters
      plan_id = params[:plan_id]

      if plan_id == nil
        status_code = 400
        raise 'plan_id is required'
      end

      # Find plan
      plan = Plan.find_by(:id => plan_id)

      if !plan
        status_code = 404
        raise 'Plan was not found'
      end

      # Check permissions
      user = get_logged_user()
      return false unless user

      if plan.student != user
        status_code = 403
        raise 'User not allowed to fetch this plan'
      end

      # Build response data
      response[:plan] = {}
      response[:plan][:id]          = plan.id
      response[:plan][:group_id]    = plan.group.id
      response[:plan][:c_group_id]  = plan.course.group.id

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
end
