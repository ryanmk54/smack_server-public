require 'rest-client'


class ApiController < ActionController::API

  def receive_project_input
    begin
      RestClient.post(
	"#{request.remote_ip}:3000/job_started",
	{
	  :id => id,
	  :output => 'pending',
	  :eta => 5000
        }.to_json,
	{content_type: :json, accept_headers: :json }
      )
    rescue => e
      puts e.message
    end

    @project = Project.new(
      params[:id].to_s,
      params[:options],
      Base64.strict_decode64( params[:input] ),
      request.remote_ip
    )

    @project.run do
      @project.post_service_output
      @project.remove_project_directory
    end
  end


end

