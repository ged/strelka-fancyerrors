#!/usr/bin/env rspec -cfd -b

BEGIN {
	require 'pathname'
	basedir = Pathname( __FILE__ ).dirname.parent
	libdir = basedir + 'lib'

	$LOAD_PATH.unshift( libdir.to_s ) unless $LOAD_PATH.include?( libdir.to_s )
}

require 'rspec'
require 'mongrel2/testing'
require 'strelka'
require 'strelka/app'
require 'strelka/logging'
require 'strelka/app/fancyerrors'
require 'strelka/behavior/plugin'


class ArrayLogger
	### Create a new ArrayLogger that will append content to +array+.
	def initialize( array )
		@array = array
	end

	### Write the specified +message+ to the array.
	def write( message )
		@array << message
	end

	### No-op -- this is here just so Logger doesn't complain
	def close; end

end # class ArrayLogger


class FancyErrorTestingApp < Strelka::App
	include Strelka::Constants

	plugins :routing, :fancyerrors


	# Set defaults for all arguments to avoid having to provide them every time
	def initialize( appid='fancyerrors-test', sspec=TEST_SEND_SPEC, rspec=TEST_RECV_SPEC )
		super
	end

	get 'server' do |req|
		finish_with HTTP::SERVER_ERROR, "This response intentionally left blank."
	end

	get 'client' do |req|
		finish_with HTTP::BAD_REQUEST, "You call that a request?!"
	end
end


describe Strelka::App::FancyErrors do

	TEST_SEND_SPEC = 'tcp://127.0.0.1:9997'
	TEST_RECV_SPEC = 'tcp://127.0.0.1:9996'

	before( :all ) do
		Strelka.log.level = Logger::FATAL

		# Only do this when executing from a spec in TextMate
		if ENV['HTML_LOGGING'] || (ENV['TM_FILENAME'] && ENV['TM_FILENAME'] =~ /_spec\.rb/)
			Thread.current['logger-output'] = []
			logdevice = ArrayLogger.new( Thread.current['logger-output'] )
			Strelka.logger = Logger.new( logdevice )
			# Strelka.logger.level = level
			Strelka.logger.formatter = Strelka::Logging::HtmlFormatter.new( Strelka.logger )
			Mongrel2.logger = Strelka.logger
		end

		@request_factory = Mongrel2::RequestFactory.new( route: '' )
	end

	before( :each ) do
		@app = FancyErrorTestingApp.new
	end


	it_should_behave_like( "A Strelka::App Plugin" )


	it "renders server errors using the server error template" do
		req = @request_factory.get( '/server' )
		res = @app.handle( req )

		res.body.should =~ /server error template/i
	end

	it "renders client errors using the client error template" do
		req = @request_factory.get( '/client' )
		res = @app.handle( req )

		res.body.should =~ /client error template/i
	end

	it "renders errors using the existing layout template if one is set" do
		@app.layout = Inversion::Template.new( '<!-- common layout --><?attr body ?>' )

		req = @request_factory.get( '/client' )
		res = @app.handle( req )

		res.body.should =~ /common layout/i
	end

end

