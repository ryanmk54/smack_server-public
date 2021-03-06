require 'test_helper'
require 'base64'
require 'zip'

class APIControllerTest < ActionDispatch::IntegrationTest

  def test_receive_project
    base_directory = Rails.root
    self.zip_test_project
    self.post_test_request
    assert_equal 200, status
    puts "Response JSON Received:"
    puts body.to_s
    body = JSON.parse(response.body)
    assert_equal '2', body['id']
    
  end

  def zip_test_project
    Dir.chdir('test/resources')
    Zip::File.open('contents.zip', Zip::File::CREATE) {
        |zipfile|
      zipfile.get_output_stream('simple.c') { |f|
        f.puts(
            open('simple.c') { |file|
              file.read
            }
        )
      }
    }
  end

  def post_test_request
    f = open('contents.zip', 'a+')
    encoded_project = Base64.strict_encode64(f.read)
    f.close
    post '/job_started', params: {'id': 2, 'options': {}, 'code': encoded_project }
  end

  def get_actual_output
    output =  Base64.strict_decode64( JSON.parse(body)['output'] )
    actual_output = Zip::InputStream.open(StringIO.new(output)) { |io| 
      io.get_next_entry
      io.read
     }
     actual_output
  end

  def get_expected_output
    expected_output = File.open('test/resources/simple_output') { |file| file.read}
  end

end
