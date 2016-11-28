require 'test_helper'
require 'base64'

class APIControllerTest < ActionDispatch::IntegrationTest


  def test_receive_project
    input = File.open('test/resources/simple.c')
    output = File.open('test/resources/simple_output')
    output_contents = output.read
    simple_c = Base64.strict_encode64( input.read )
    input.close
    output.close
    get '/receive_project_input', params: {'id': 2, 'options': {}, 'code': simple_c } 
    assert_equal 200, status
    body = JSON.parse(response.body)
    assert_equal '2', body['id']
    puts Base64.strict_decode64( body['output'] )
  end


end
