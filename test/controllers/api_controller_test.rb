require 'test_helper'
require 'base64'

class APIControllerTest < ActionDispatch::IntegrationTest


  def test_receive_project
    simple_c = Base64.encode64( File.open( 'test/resources/simple.c' ).read )
    get '/receive_project_input', params: {'id': 2, 'options': {}, 'code': simple_c }
    assert_equal 200, status
    body = JSON.parse(response.body)
    assert_equal '2', body['id']
    assert_equal 'pending', body['result']
  end

  def test_send_project_output

  end
end
