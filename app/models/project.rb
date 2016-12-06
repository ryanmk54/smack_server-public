require 'zip'
require 'zlib'
require 'stringio'
require 'fileutils'


class Project

  attr_accessor :id, :options, :path, :output, :return_ip, :completed

  def initialize( id, options, code, return_ip )
    self.id = id
    self.options = options
    self.path = Rails.root.join('public', 'system', 'projects', self.id.to_s)
    self.output. = nil
    self.return_ip = return_ip
    self.completed = false
    write_to_file_system( code )
  end

  def run
    filenames = Dir.entries(Dir.pwd)
    ['..', '.', '__MACOSX'].each { |filename|
      path = File.join(self.path, filename)
      if filenames.include?( filename )
        filenames.delete( filename )
      end
    }

    pid = spawn("smack #{self.filenames.join(' ')};", :out => w)
    Process.waitpid( pid )
    w.close
    self.output = r.read
    r.close
    self.completed = true
    yield
  end

  def post_service_output
    if self.completed?
      begin
        post_url = File.join(
          self.remote_ip + ':',
          'projects',
          self.id,
          'receive_service_output'
        )
        RestClient.post(post_url,
        {
          :id => params[:id],
          :output => output_string
        }.to_json,
        {
          content_type: :json,
          accept_headers: :json
        })
      rescue => e
        puts 'Error while sending service output'
        puts e.message
      end
    end
  end

  private

  def write_to_file_system( code )
    self.prime_project_directory()
    zipped_contents = Base64.strict_decode64( code )
    file = open(File.join(self.path, 'content'), 'a+:ASCII-8BIT')
    file.write(zipped_contents)
    file.close
    Zip::File.open(File.join(self.path, 'content')) { |zipfile|
      Zip::File.foreach('content') { |entry|
        zipfile.extract(entry, entry.name)
      }
    }
    File.delete(File.join(self.path, 'content'))
  end

  def prime_project_directory
    FileUtils.mkdir(self.path) unless File.directory?(self.path)
  end

  def remove_project_directory
    FileUtils.rm_rf(self.path)
  end

end


# needed for unzipping from IOStream
class StringIO
  def path
  end
end




