require 'zip'
require 'zlib'
require 'stringio'
require 'fileutils'


class Project

  attr_accessor :id, :options, :path, :output, :return_ip, :completed

  def initialize( id, options, code, return_ip )
    @id = id
    @options = options
    @path = Rails.root.join('public', 'system', 'projects', self.id.to_s)
    @output = nil
    @return_ip = return_ip
    @completed = false
    @write_to_file_system( code )
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
    self.start_time = Time.now.getutc
    pid = spawn("smack #{filenames.join(' ')};", :out => w)
    Process.waitpid( pid )
    w.close
    self.output = r.read
    r.close
    self.completed = true
    self.finish_time = Time.now.getutc
  end

  def 

  # def post_service_output

  # end

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




