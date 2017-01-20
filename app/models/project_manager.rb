require 'singleton'
class ProjectManager
	include Singleton

	def initialize
		@projects = {}
	end

	def check_status_for_project(id)
		return @projects[id].completed
	end

	def remove_project_from_queue(id)
		@projects.delete(id)
	end

	def queue_request(id, options, input, remote_ip)

	end

end