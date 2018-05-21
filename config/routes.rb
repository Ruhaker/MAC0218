Rails.application.routes.draw do
  get 'supervisor/create'

  get 'student/create'

  get 'user/list'

  get 'user/new_session'
  post 'user/new_session'
  get 'user/close_session'
  post 'user/close_session'

  root 'user#list'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
