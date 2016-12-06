require 'rest-client'


class ApiController < ActionController::API

  def receive_project_input
    id = params[:id]
      render :json => {
	    :id => id,
	    :output => 'pending',
	    :eta => 5000
    }

    @project = Project.new(
      params[:id],
      params[:options],
      params[:code],
      remote.ip
    )

    project.run do
      project.post_service_output
      project.remove_project_directory
    end
  end


end

