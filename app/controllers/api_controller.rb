require 'rest-client'


class ApiController < ActionController::API

  def receive_project_input
  
  Thread.new do 
    @project = Project.new(
      params[:id].to_s,
      params[:options],
      Base64.strict_decode64( params[:input] ),
      request.remote_ip
    )

    @project.run
    @project.post_service_output
    @project.remove_project_directory
    FileUtils.rm_rf(params[:id].to_s)
    Dir.chdir(Rails.root)   
  end

  render :json => {
    :id => params[:id].to_s,
    :output => 'pending',
    :eta => 5000
     }

  end
end

