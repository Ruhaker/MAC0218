class CourseController < ApplicationController
  include Auth
  
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

  end

  def enroll
    # Must be POST request to create course
    return unless request.post?

    # Retrieves current user
    user = get_logged_user()
    return unless user

    # Logged in user must be a student
    return unless user.class.name == "Student"

    # Receives parameters from the course creation page
    course_id          = params[:course_id]
    student_id         = params[:student_id]

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
  end
end