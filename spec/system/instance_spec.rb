require 'spec_helper_system'

describe 'instance test: 1 instance' do
  it 'define should work without errors' do
    pp = <<-EOS
      varnish::instance { 'default': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 2
      r.refresh
      r.exit_code.should be_zero
    end
  end
end
