class WebController < ApplicationController
  include Auth

  def home
    # Retrieves logged-in user
    @user = get_logged_user()

    # Fetch user's current course
    puts "{#{@user.courses.join ', '}} "

    case @user.class.name
    # If it is a student
    when "Student"
      # Load course's base group
      @base = @user.courses[0] ? @user.courses[0].group : nil

      # Load user's personal group
      @personal = @user.courses[0] ? @user.courses[0].plans : nil

    # If it is a supervisor
    when "Supervisor"
      # Only load course's base group

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
