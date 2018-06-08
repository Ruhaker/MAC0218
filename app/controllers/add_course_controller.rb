class AddCourseController < ApplicationController
  def create

    # Receives parameters from the course creation page
    course_name   = param[:name]
    course_credits       = param[:credits]
    course_teaching_unit = param[:teaching_unit]
    corse_expected_time = param[:expected_time]

    # Fallback to default values for nil parameters
    course_name   = "" unless course_name
    course_credits       = 0  unless credits
    course_teaching_unit = "" unless teaching_unit
    course_expected_time = 0 unless expected_time

    # Create a course
    Course.create! ({
      :name          => course_name
      :credits       => course_credits
      :teaching_unit => course_teaching_unit
      :expected_time => course_expected_time
    })

  end
end