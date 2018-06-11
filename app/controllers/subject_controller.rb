class SubjectController < ApplicationController
  def create
  	# Must be POST request to create subject
    return unless request.post?

    # Receives parameters from the subject creation page
    subject_code            = params[:code]
    subject_name            = params[:name]
    subject_credits_class   = params[:credits_class]
    subject_credits_work    = params[:credits_work]
    subject_workload        = params[:workload]
    subject_description     = params[:description]

    # Fallback to default values for nil parameters
    subject_code            = "" unless subject_code
    subject_name            = "" unless subject_name
    subject_credits_class   = nil unless subject_credits_class
    subject_credits_work    = nil unless subject_credits_work
    subject_workload        = nil unless subject_workload
    subject_description     = "" unless subject_description

    subject = Subject.create!(
      :code    			=> subject_code,
      :name   			=> subject_name,
      :credits_class    => subject_credits_class,
      :credits_work     => subject_credits_work,
      :workload   		=> subject_workload,
      :description   	=> subject_description
    )
  end

  def enroll

  end
end
