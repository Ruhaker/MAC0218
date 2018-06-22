class ApplicationControllerAPI < ActionController::API
  include Auth

  before_action :retrieve_user

  def retrieve_user
    @user = get_logged_user()
  end

  def protect_against_forgery?
    return false
  end
end
