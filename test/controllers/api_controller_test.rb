require 'test_helper'
require 'base64'
require 'zip'

class APIControllerTest < ActionDispatch::IntegrationTest
  def setup
    
    if Dir.exists?('/home/ubuntu/projects/2')  
       base_directory = Dir.pwd
      Dir.chdir('/home/ubuntu/projects/2')
      Dir.entries(Dir.pwd).each do |filename|
        if (filename != '.' and filename != '..') 
          File.delete(filename)
        end
      end
      Dir.chdir('/home/ubuntu/projects')
      Dir.delete('2')
      Dir.chdir(base_directory)
    end
  end

  def test_receive_project
    base_directory = Dir.pwd
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
    f = open('contents.zip', 'a+')
    encoded_project = Base64.strict_encode64(f.read)
    f.close
    get '/receive_project_input', params: {'id': 2, 'options': {}, 'code': encoded_project }
    assert_equal 200, status
    body = JSON.parse(response.body)
    assert_equal '2', body['id']
    output =  Base64.strict_decode64( body['output'] )
    puts 'output'
    puts output
    actual_output = Zip::InputStream.open(StringIO.new(output)) { |io| 
      io.get_next_entry
      io.read
     }
    puts 'actual_output'
    puts actual_output
    Dir.chdir(base_directory)
    expected_output = File.open('test/resources/simple_output') { |file| file.read}
    assert_equal actual_output.to_s, expected_output
  end

  def make_zip

  end

end
