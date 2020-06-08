title 'Tests to confirm gawk works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'gawk')
plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
plan_pkg_ident = ((plan_installation_directory.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]
plan_pkg_version = (plan_pkg_ident.match /^#{plan_origin}\/#{plan_name}\/(?<version>.*)\//)[:version]

control 'core-plans-gawk-works' do
  impact 1.0
  title 'Ensure gawk works as expected'
  desc '
  Verify gawk by ensuring (1) its installation directory exists and (2) that
  it returns the expected version
  '
  
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  
  describe command("DEBUG=true; hab pkg exec #{plan_pkg_ident} gawk --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /GNU Awk #{plan_pkg_version}/ }
    its('stderr') { should be_empty }
  end
end
