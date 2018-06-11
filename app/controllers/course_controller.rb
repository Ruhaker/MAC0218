class CourseController < ApplicationController
  include Auth
  
  #
  # Creates a new course
  #
  # For now, any supervisor can create courses, but this will change later.
  #
  def create
    # Must be POST request to create course
    return unless request.post?

    # Receives parameters from the course creation page
    course_name          = params[:name]
    course_credits       = params[:credits]
    course_teaching_unit = params[:teaching_unit]
    corse_expected_time  = params[:expected_time]

    # Fallback to default values for nil parameters
    course_name          = "" unless course_name
    course_credits       = 0  unless course_credits
    course_teaching_unit = "" unless course_teaching_unit
    course_expected_time = 0  unless course_expected_time
    
    # Retrieves current user and checks if it is a supervisor
    user = get_logged_user()
    return unless user
    return unless user.is? "supervisor"

    # Create a course
    course = Course.new({
      :name          => course_name,
      :credits       => course_credits,
      :teaching_unit => course_teaching_unit,
      :expected_time => course_expected_time
    })

    base_group = Group.create!({
      :name         => "Grade",
      :min_credits  => nil,
      :min_subjects => nil
    })

    course.group = base_group
    course.save

    redirect_back fallback_location: "/"
  end

  #
  # Enroll a student in a course.
  #
  # For now, students may only enroll themselves in a course.
  # Supervisors may only enroll students in the courses they manage.
  #
  def enroll
    # Must be POST request to create course
    return unless request.post?

    # Retrieves current user
    user = get_logged_user()
    return unless user

    # Receives parameters from the course creation page
    # If logged in user is a student
    if user.is? "student"
      # He can enroll only himself
      student_id = user.id
      course_id  = params[:course_id]

    # If a supervisor
    elsif user.is? "supervisor"
      # Get parameters
      student_id = params[:student_id]
      course_id  = params[:course_id]

      # Only allowed to enroll students in courses he supervises
      return unless user.courses.find(course_id)
    else
      # If unknown class, do nothing
      return
    end

    # Create plan
    plan = Plan.new

    group = Group.create!(
      :name         => "Pessoal",
      :min_credits  => nil,
      :min_subjects => nil
    )

    plan.course  = Course.find(course_id)
    plan.student = Student.find(student_id)
    plan.group   = group

    plan.save

    redirect_back fallback_location: "/"
  end

  #
  # Assigns a course to a supervisor's management
  #
  # For now, any supervisor can assign himself to any course.
  # This will change later.
  #
  def assign
    # Must be POST request to create course
    return unless request.post?

    # Retrieves current user
    user = get_logged_user()
    return unless user
    return unless user.is? "supervisor"

    # Receives parameters from the course creation page
    course_id  = params[:course_id]
    
    # Get course
    course = Course.find(course_id)

    # Assign
    user.courses << course

    redirect_back fallback_location: "/"
  end
end