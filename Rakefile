#!/usr/bin/env rake

begin
	require 'hoe'
rescue LoadError
	abort "This Rakefile requires 'hoe' (gem install hoe)"
end

GEMSPEC = 'strelka-fancyerrors.gemspec'

# Sign gems
Hoe.plugin :signing
Hoe.plugin :mercurial
Hoe.plugin :deveiate

hoespec = Hoe.spec 'strelka-fancyerrors' do
	self.readme_file = 'README.rdoc'
	self.history_file = 'History.rdoc'
	self.extra_rdoc_files = FileList[ '*.rdoc' ]
	self.license 'BSD-3-Clause'

	self.developer 'Michael Granger', 'ged@FaerieMUD.org'

	self.dependency 'strelka', '~> 0.15'
	self.dependency 'inversion', '~> 1.0'
	self.dependency 'loggability', '~> 0.14'

	self.dependency 'hoe-deveiate', '~> 0.9', :developer

	self.require_ruby_version( '>=2.3.4' )
	self.hg_sign_tags = true if self.respond_to?( :hg_sign_tags= )
	self.check_history_on_release = true if self.respond_to?( :check_history_on_release= )

	self.rdoc_locations << "deveiate:/usr/local/www/public/code/#{remote_rdoc_dir}"
end

ENV['VERSION'] ||= hoespec.spec.version.to_s

# Ensure the specs pass before checking in
task 'hg:precheckin' => [ :check_history, :check_manifest, :spec, :gemspec ]


desc "Build a coverage report"
task :coverage do
	ENV["COVERAGE"] = 'yes'
	Rake::Task[:spec].invoke
end

if Rake::Task.task_defined?( '.gemtest' )
	Rake::Task['.gemtest'].clear
	task '.gemtest' do
		$stderr.puts "Not including a .gemtest until I'm confident the test suite is idempotent."
	end
end

# Use the fivefish formatter for docs generated from development checkout
if File.directory?( '.hg' )
	require 'rdoc/task'

	Rake::Task[ 'docs' ].clear
	RDoc::Task.new( 'docs' ) do |rdoc|
		rdoc.main = "README.rdoc"
		rdoc.rdoc_files.include( "*.rdoc", "ChangeLog", "lib/**/*.rb" )
		rdoc.generator = :fivefish
		rdoc.title = "Strelka-FancyErrors: Fancy error handler for Strelka apps"
		rdoc.rdoc_dir = 'doc'
	end
end


task :gemspec => GEMSPEC
file GEMSPEC => __FILE__
task GEMSPEC do |task|
	spec = $hoespec.spec
	spec.files.delete( '.gemtest' )
	spec.signing_key = nil
	spec.cert_chain = Rake::FileList[ 'certs/*.pem' ].to_a
	spec.version = "#{spec.version.bump}.0.pre#{Time.now.strftime("%Y%m%d%H%M%S")}"
	File.open( task.name, 'w' ) do |fh|
		fh.write( spec.to_ruby )
	end
end

CLOBBER.include( GEMSPEC.to_s )
task :default => :gemspec



# Add admin app testing directories to the clobber list
CLOBBER.include( 'static', 'run', 'logs', 'strelka.sqlite' )


