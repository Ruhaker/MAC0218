Rails.application.routes.draw do
  get 'web/home'

  get 'web/profile'

  # Paths for creating users
  get  'supervisor/create'
  post 'supervisor/create'

  get  'student/create'
  post 'student/create'

  # Session management
  get  'user/new_session'
  post 'user/new_session'
  get  'user/close_session'
  post 'user/close_session'

  # Main page for now (Allows only basic auth)
  get 'user/list'
  root 'user#list'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
