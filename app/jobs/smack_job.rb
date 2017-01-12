require 'zip'
class SmackJob < ApplicationJob
  queue_as :default

  def perform( project )
  end


end