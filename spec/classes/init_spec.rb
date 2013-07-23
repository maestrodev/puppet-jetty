require 'spec_helper'

describe 'jetty' do

  it { should contain_service("jetty").with_ensure("running") }

end
