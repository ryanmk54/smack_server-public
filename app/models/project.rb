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
    self.output = nil
    self.return_ip = return_ip
    self.completed = false
    self.write_to_file_system( code )
  end

  def run
    filenames = Dir.entries(self.path)
    ['..', '.', '__MACOSX'].each { |filename|
      if filenames.include?( filename )
        filenames.delete( filename )
      end
      if /.txt$/ === filename
        filenames.delete(filename)
      end    
    }

    filenames = filenames.map { |f| File.join(self.path, f) }
    filenames.each { |f| puts f }
    r, w = IO.pipe
    pid = spawn("smack #{filenames.join(' ')};", :out => w)
    Process.waitpid( pid )
    w.close
    self.output = r.read
    r.close
    self.completed = true
  end

  def post_service_output
    if self.completed
      begin
        post_url = File.join(
          self.return_ip + ':3000',
          'projects',
          self.id,
          'receive_service_output'
        )
        RestClient.post(post_url,
        {
          :id => self.id,
          :output =>self.output
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

  def write_to_file_system( code )
    FileUtils.mkdir(self.path) unless File.directory?(self.path)
    zipped_contents = code
    file = open(File.join(self.path, 'content'), 'a+:ASCII-8BIT')
    file.write(zipped_contents)
    file.close
    Zip::File.open(File.join(self.path, 'content')) { |zipfile|
      Zip::File.foreach(File.join(self.path,'content')) { |entry|
        zipfile.extract(entry, File.join(self.path, entry.name))
      }
    }
    File.delete(File.join(self.path, 'content'))
  end

  def prime_project_directory
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




