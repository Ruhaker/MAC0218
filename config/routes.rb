Rails.application.routes.draw do

  get 'subject/enroll'
  post 'subject/enroll'

  get 'subject/create'
  post 'subject/create'

  get 'course/enroll'
  post 'course/enroll'

  # Paths for dealing with groups 
  get 'group/create'
  post 'group/create'

  get 'group/modify'

  get 'group/destroy'
  post 'group/destroy'
  
  post 'group/add_subject'
  
  post 'group/rem_subject'

  # Paths for dealing with courses
  get 'course/create'
  post 'course/create'
  
  get 'course/enroll'
  post 'course/enroll'
  
  get 'course/assign'
  post 'course/assign'

  # Paths for creating users
  get  'supervisor/create'
  post 'supervisor/create'

  get  'student/create'
  post 'student/create'

  # Paths for debugging
  get 'user/list'

  # Session management
  get  'user/new_session'
  post 'user/new_session'
  get  'user/close_session'
  post 'user/close_session'

  # Paths for web
  get 'web/home'
  get 'web/profile'
  
  # Main page for now
  get 'web/home'
  root 'web#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
