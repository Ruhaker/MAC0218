class AddCourseController < ApplicationController
  def create

    # Receives parameters from the course creation page
    course_name   = param[:name]
    credits       = param[:credits]
    teaching_unit = param[:teaching_unit]
    expected_time = param[:expected_time]

    # Fallback to default values for nil parameters
    course_name   = "" unless course_name
    credits       = 0  unless credits
    teaching_unit = "" unless teaching_unit
    expected_time = 0 unless expected_time

    # Create a course
    Course.create! ({
      :name          => course_name
      :credits       => credits
      :teaching_unit => teaching_unit
      :expected_time => expected_time
    })

  end
end