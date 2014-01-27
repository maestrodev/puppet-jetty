require 'spec_helper'

describe 'jetty' do

  let(:params) {{
    :version => "9.0.4.v20130625",
    :home    => "/opt",
    :user    => "jettyuser",
    :group   => "jettygroup"
  }}

  it { should compile.with_all_deps }

  it { should contain_file("/opt/jetty").with_ensure("/opt/jetty-distribution-9.0.4.v20130625") }
  it { should contain_service("jetty").with_ensure("running") }
  it { should contain_exec("jetty_untar").with_command(/chown -R jettyuser:jettygroup/) }

end
