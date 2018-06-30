Rails.application.routes.draw do

  post 'plan/create'

  post 'plan/fetch'

  post 'subject/list'

  post 'subject/fetch'
  post 'subject/enroll'

  get 'subject/create'
  post 'subject/create'

  post 'subject/change_progress'

  get 'course/enroll'
  post 'course/enroll'

  # Paths for dealing with groups
  post 'group/fetch'
  post 'group/create'
  post 'group/update'
  post 'group/update_index'
  post 'group/destroy'
  post 'group/destroy_index'

  post 'group/add_subject'

  post 'group/rem_subject'

  # Paths for dealing with courses
  post 'course/fetch'
  post 'course/list'

  get 'course/create'
  post 'course/create'

  get 'course/enroll'
  post 'course/enroll'

  get 'course/assign'
  post 'course/assign'

  # Paths for creating users
  get  'supervisor/create'
  post 'supervisor/create'
  post 'supervisor/list'
  post 'supervisor/assign'

  get  'student/create'
  post 'student/create'

  # Paths for debugging
  get 'user/list'

  # Session management
  post 'user/new_session'
  post 'user/close_session'

  # User actions
  post 'user/fetch'

  # Paths for web
  #get 'web/home'
  #get 'web/profile'

  # Main page for now
  #get 'web/home'
  #root 'web#home'
  root to: 'web#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
