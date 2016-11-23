require 'base64'
class ApiController < ActionController::API
  def receive_project_input
    @project = Project.new params[:id],params[:options], params[:code]
    render :json => {:id => params[:id], :result => 'pending'}
    # SmackJob.perform project
  end

  def send_project_output project
    require 'rest-client'
    response = RestClient.post(
        'some_url',
      {
      :id => project.id,
      :result => 'done',
      :output => Base64.encode64(project.output)
      }.to_json,
      {content_type: :json, accept_headers: :json}
    )
  end
end
