require 'zip'
class SmackJob < ApplicationJob
  queue_as :default


  def perform( project )
    files = Zip.unzip_project project.@code, project.@id
    output, err, s = Open3.capture3('SMACK', :stdin_data => files, :binmode => true)
    if s.success?
      project.@results = output
    end
    # TODO: handle error
    # filenames = self.get_input_file_names project.@id
    # output = self.start_smack_process filenames
  end

  # private
  # def unzip_project( code )
  #   files = Base64.decode code, id
  #   project_directory = File.dirname "/projects/#{id}"
  #   unless File.directory? project_directory
  #     FileUtils.mkdir project_directory
  #   end
  #   Dir.chdir project_directory
  #   files.each do |file|
  #     File.new(file.basename file)
  #   end
  # end
  #
  # def get_input_file_names( id )
  #   return Dir["#{id}**/*.rb"]
  # end
  #
  # def start_smack_process( input_files )
  #   `smack#{input_files.join(' ')}`
  # end
end