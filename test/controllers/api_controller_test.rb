require 'test_helper'
require 'base64'
require 'zip'

class APIControllerTest < ActionDispatch::IntegrationTest


  def test_receive_project
    Zip::File.open('test/resources/contents.zip', Zip::File::CREATE) {
        |zipfile|
      zipfile.get_output_stream('simple.c') { |f|
        f.puts(
            open('test/resources/simple.c') { |file|
              file.read
            }
        )
      }
    }
    f = open('test/resources/contents.zip', 'a+')
    encoded_project = Base64.strict_encode64(f.read)
    f.close

    get '/receive_project_input', params: {'id': 2, 'options': {}, 'code': encoded_project }
    assert_equal 200, status
    body = JSON.parse(response.body)
    assert_equal '2', body['id']
    # puts Base64.strict_decode64( body['output'] )
    # input = File.open('test/resources/simple.c')
    # output = File.open('test/resources/simple_output')
    # output_contents = output.read
    # simple_c = Base64.strict_encode64( input.read )
    # input.close
    # output.close

  end

  def make_zip

  end

end
