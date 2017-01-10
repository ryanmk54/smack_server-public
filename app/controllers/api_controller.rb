require 'base64'
require 'rest-client'
require 'zip'
require 'zlib'
require 'stringio'

class StringIO
  def path
  end
end

class ApiController < ActionController::API
  def receive_project_input
    puts "received request from #{request.remote_ip}#"
    id = params[:id]
    render :json => {
	:id => id,
	:output => 'pending',
	:eta => 5000
    }    
    puts "project id is #{id}"
    Dir.chdir('/home/ubuntu/projects')
    Dir.mkdir(id.to_s)
    Dir.chdir(id.to_s)
    zipped_contents = Base64.strict_decode64( params[:input] )
    file = open('content', 'a+:ASCII-8BIT')
    file.write(zipped_contents)
    file.close
    Zip::File.open('content') { |zipfile|
      Zip::File.foreach('content') { |entry|
        zipfile.extract(entry, entry.name)    
      }
    }
    File.delete('content')
    filenames = Dir.entries(Dir.pwd)
    filenames.delete('.')
    filenames.delete('..')
    filenames.delete('__MACOSX') if filenames.include?('__MACOSX')    

    r, w = IO.pipe
    
    pid = spawn("smack #{filenames.join(' ')};", :out => w)
    
    Process.waitpid( pid )
    
    w.close
    output_string = r.read
    r.close

    begin
      post_url = "#{request.remote_ip}:3000/projects/#{id}/receive_service_output"
      puts "posting to #{post_url}"
      puts params[:id]
      RestClient.post(post_url,
	{
	  :id => params[:id],
	  :output => output_string
	}.to_json, {content_type: :json, accept_headers: :json})
    rescue => e
	puts 'Error while sending service output'
        puts e.message
    end
    FileUtils.rm_rf(params[:id].to_s)
    Dir.chdir(Rails.root)   
  end
end

