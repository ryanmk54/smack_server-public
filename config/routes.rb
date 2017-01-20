Rails.application.routes.draw do

  post '/job_started', to: 'api#receive_project_input'

  # namespace :api, defaults: {format: :json } do
  #
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
