require 'base64'
require 'rest-client'
require 'zip'

class ApiController < ActionController::API

  def receive_project_input
    begin
      RestClient.post(
            "#{request.remote_ip}:3000/job_started",
          {
          :id => params[:id],
          :output => 'pending',
          # TODO: come up with way to estimate time
          :eta => 5000
          }.to_json,
          {content_type: :json, accept_headers: :json}
       )
     rescue => e
       puts 'failed to send job_started'
       puts e.message
     end
    Dir.chdir('/home/ubuntu/projects')
    Dir.mkdir(params[:id])
    Dir.chdir(params[:id])
    zipped_contents = Base64.strict_decode64( params[:code] )
    
    Zip::InputStream.open(StringIO.new(zipped_contents)) { |zio|
      while( entry = zio.get_next_entry)
        File.open(entry.name, 'a+') { |f| f.puts zio.read }
      end
    }
    
    filenames = Dir.entries(Dir.pwd)
    filenames.delete('.')
    filenames.delete('..')

    r, w = IO.pipe
    
    pid = spawn("smack #{filenames.join(' ')};", :out => w)
    
    Process.waitpid( pid )
    
    w.close
    output_string = r.read
    r.close

    Zip::File.open('output', Zip::File::CREATE) { |zipfile|
      zipfile.get_output_stream('results.txt') { |f| f.puts output_string }
    }
    encoded_output = Base64.strict_encode64 File.open('output', 'rb') { |f| f.read }

    render :json => {:id => params[:id], :output => encoded_output }
  end
end

