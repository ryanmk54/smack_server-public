require 'rest-client'
module ActionController
  class ServiceRequest
  end

  def notifyCompletedService
    ActiveSupport::Notifications.subscribe('render') do |project|
    if project.completed
      begin
        # redirect??
        post_url = File.join(
          project.return_ip + ':3000',
          'projects',
          project.id,
          'receive_service_output'
        )
        RestClient.post(post_url,
        {
          :id => project.id,
          :output => project.output
        }.to_json,
        {
          content_type: :json,
          accept_headers: :json
        })
      rescue => e
        puts 'Error while sending service output'
        puts e.message
      end
      project.remove_project_directory
    end
  end    
end



class ApiController < ActionController::API

  def receive_project_input
    ActiveSupport::Notifications.instrument('render',        
      project: @project = 
        Project.new( 
          params[:id].to_s, 
          params[:options], 
          Base64.strict_decode64( params[:input] ),
          request.remote_ip
        )

    do 
      @project.run
  end

end

