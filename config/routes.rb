Rails.application.routes.draw do
  get 'supervisor/create'

  get 'student/create'

  get 'user/new_session'
  get 'user/end_session'
  get 'user/get_sessions'
  get 'user/create'
  get 'user/modify'
  get 'user/profile'
  get 'user/delete'

  root 'user#list'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
