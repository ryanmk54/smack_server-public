class ApiController < ActionController::API
  def receive_project_input
    @project = Project.new params[:id],params[:options], params[:code]
    render json: [:id => params[:id], :result => 'pending']
  end

  def send_project_output
  end
end
