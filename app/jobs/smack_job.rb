class SmackJob < ApplicationJob
  queue_as :default


  def perform project
    # append the results
    # Execute the SMACK process...
  end

  after_perform do |job|

  end

  after_perform do
end