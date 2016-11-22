# require 'rails_helper'
require 'rails_helper.rb'
require 'spec_helper.rb'

RSpec.describe ApiController, type: :controller do
  it 'creates Project objects when it receives project requests from the routing server' do
    get 'receive_project_input', params: {id: 2, options: {}, code: 'hello'}
  end
end
