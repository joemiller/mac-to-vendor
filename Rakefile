require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.libs.push 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc 'Using the get-oui util from arp-scan, download the latest ieee-oui.txt from the ieee'
task :get_oui do
  sh "time get-oui -v -f #{File.dirname(__FILE__)}/db/ieee-oui.txt"
  sh "time get-iab -v -f #{File.dirname(__FILE__)}/db/ieee-iab.txt"
end

desc 'Using the get-iab util from arp-scan, download the latest ieee-iab.txt from the ieee'
task :get_iab do
  sh "time get-iab -v -f #{File.dirname(__FILE__)}/db/ieee-iab.txt"
end

desc 'Fetch and update IEEE databases'
task :update => [:get_oui, :get_iab]

task :default => :test
