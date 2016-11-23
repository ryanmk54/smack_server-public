require 'test_helper'

class APIControllerTest < ActionDispatch::IntegrationTest


  def test_receive_project
    get '/receive_project_input', params: {'id': 2, 'options': {}, 'code': 'hello'}
    assert_equal 200, status
    body = JSON.parse(response.body)
    assert_equal '2', body['id']
    assert_equal 'pending', body['result']
  end

  def test_send_project_output

  end
end
