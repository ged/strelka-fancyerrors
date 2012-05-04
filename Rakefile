#!/usr/bin/env rake

begin
	require 'hoe'
rescue LoadError
	abort "This Rakefile requires 'hoe' (gem install hoe)"
end

# Sign gems
Hoe.plugin :signing
Hoe.plugin :mercurial
Hoe.plugin :deveiate

hoespec = Hoe.spec 'strelka-fancyerrors' do
	self.readme_file = 'README.rdoc'
	self.history_file = 'History.rdoc'
	self.extra_rdoc_files = FileList[ '*.rdoc' ]

	self.developer 'Michael Granger', 'ged@FaerieMUD.org'

	self.dependency 'strelka', '~> 0.0.1.pre'
	self.dependency 'inversion', '~> 0.9'
	self.dependency 'hoe-deveiate', '~> 0.1', :developer

	self.spec_extras[:licenses] = ["BSD"]
	self.spec_extras[:rdoc_options] = ['-f', 'fivefish', '-t', 'Strelka Web Application Toolkit']
	self.require_ruby_version( '>=1.9.2' )
	self.hg_sign_tags = true if self.respond_to?( :hg_sign_tags= )
	self.check_history_on_release = true if self.respond_to?( :check_history_on_release= )

	self.rdoc_locations << "deveiate:/usr/local/www/public/code/#{remote_rdoc_dir}"
end

ENV['VERSION'] ||= hoespec.spec.version.to_s

# Ensure the specs pass before checking in
task 'hg:precheckin' => [:check_manifest, :check_history, :spec]

# Rebuild the ChangeLog immediately before release
task :prerelease => [:check_manifest, :check_history, 'ChangeLog']

task :check_manifest => 'ChangeLog'


desc "Build a coverage report"
task :coverage do
	ENV["COVERAGE"] = 'yes'
	Rake::Task[:spec].invoke
end

