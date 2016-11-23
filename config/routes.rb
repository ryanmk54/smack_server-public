Rails.application.routes.draw do

  get '/receive_project_input', to: 'api#receive_project_input'

  # namespace :api, defaults: {format: :json } do
  #
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
