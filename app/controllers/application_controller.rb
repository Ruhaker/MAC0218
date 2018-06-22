class ApplicationController < ActionController::Base
  include Auth

  protect_from_forgery with: :exception
  before_action :retrieve_user

  def retrieve_user
    @user = get_logged_user()
  end
end
