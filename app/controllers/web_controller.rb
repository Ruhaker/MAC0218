class WebController < ApplicationController
  include Auth

  def home
    return
    # Retrieves logged-in user
    @user = get_logged_user()

    # Retrieves courses
    @courses = Course.all

    # Retrieves subjects
    @subjects = Subject.all

    # TODO: Get this thing decently
    # Fetch user's current course (Just gets first course for now)
    @current_course = @user.courses[0] if @user

    # If specified, load another course
    @current_course = @user.courses.find(params[:course_id]) if params[:course_id]

    case @user.class.name
    # If it is a student
    when "Student"
      # Load course's base group
      @base = @current_course ? @current_course.group : nil

      # Load user's personal group
      @personal = @current_course ? @user.plans.find_by!({:course_id => @current_course.id}).group : nil

    # If it is a supervisor
    when "Supervisor"
      # Only load course's base group
      @base = @current_course ? @current_course.group : nil

    # If neither
    else
      puts "User of invalid type #{@user.class}!"
    end

    # Pass user class name
    @user_type = @user.class.name
  end

  def profile
  end
end
