require 'rake/testtask'
require_relative 'lib/mac_address_db'

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.libs.push 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc 'Using the get-oui util from arp-scan, download the latest ieee-oui.txt and ieee-iab.txt from the ieee'
task :update do
  # sh "time get-oui -v -f #{File.dirname(__FILE__)}/db/ieee-oui.txt"
  # sh "time get-iab -v -f #{File.dirname(__FILE__)}/db/ieee-iab.txt"
  # get-oui/get-iab cannot follow redirects. Workaround by specifying the final URL manually:
  # https://github.com/royhills/arp-scan/issues/35
  sh "time get-oui -v -f #{File.dirname(__FILE__)}/db/ieee-oui.txt -u http://standards-oui.ieee.org/oui/oui.txt"
  sh "time get-iab -v -f #{File.dirname(__FILE__)}/db/ieee-iab.txt -u http://standards-oui.ieee.org/iab/iab.txt"

  db = MacAddressDB.new("#{File.dirname(__FILE__)}/db/macaddrs.sqlite")
  db.reset
  Dir['db/*.txt'].each do |f|
    db.load_data(f)
  end
end

desc 'lint the cloudbuild.yaml file. requires "cloud-build-local" installed (https://cloud.google.com/cloud-build/docs/build-debug-locally)'
task :cloudbuild_lint do
  sh 'cloud-build-local -substitutions=PROJECT_ID="joe-mac-to-vendor" .'
end

desc 'execute a local GCB build. requires "cloud-build-local" installed (https://cloud.google.com/cloud-build/docs/build-debug-locally)'
task :cloudbuild_local do
  sh 'cloud-build-local -substitutions=PROJECT_ID="joe-mac-to-vendor" -dryrun=false .'
end

task :default => :test
