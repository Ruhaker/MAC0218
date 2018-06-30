class ApplicationControllerAPI < ActionController::API
  include Auth
  include Util

  before_action :retrieve_user
  before_action :setup_response

  def retrieve_user
    @user = get_logged_user()
  end

  def setup_response
    @status_code = nil
    @response = {}
  end

  def protect_against_forgery?
    return false
  end
end
