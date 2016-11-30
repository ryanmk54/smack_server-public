require 'base64'
require 'rest-client'
require 'zip'

class ApiController < ActionController::API
  #def receive_project_input
  #  files = Base64.strict_decode64( params[:code] )
  #  file = File.new('input.c', 'a+')
  #  file.write files
  #  file.close
  #  r, w = IO.pipe
  #  pid = spawn("smack #{File.absolute_path(file.path)}", :out => w)
  #  Process.waitpid( pid )
  #  w.close
  #  render :json => {:id => params[:id], :result => Base64.strict_encode64( r.read ) }
  #  r.close
 
    # SmackJob.perform project
  #end

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
    r, w = IO.pipe    
    pid = spawn("smack #{filenames.join(' ')};", :out => w)
    Process.waitpid( pid )
    w.close
    output_string = r.read
    r.close
    puts 'here'
    Zip::File.open('output', Zip::File::CREATE) { |zipfile|
      zipfile.get_output_stream('results.txt') { |f| f.puts output_string }
    }
    encoded_output = Base64.strict_encode64 File.open('output', 'rb') { |f| f.read }
    puts 'encoded output'
    puts encoded_output
    #zipfile = Zip::File.open('output', Zip::File::CREATE)
    #puts zipfile.get_input_stream.read
    #encoded_output = Base64.strict_encode64(zipfile.read('results.txt'))
    #zipfile.close
    render :json => {:id => params[:id], :output => encoded_output }
    puts 'done' 
  end

  def send_project_output project
    require 'rest-client'
    end

  private
  def extract_project filepath
    Zip::ZipFile.open(file_path) { |zip_file|
      zip_file.each { |f|
      f_path=File.join("destination_path", f.name)
      FileUtils.mkdir_p(File.dirname(f_path))
      zip_file.extract(f, f_path) unless File.exist?(f_path)
    }} 
  end
end
