#!/usr/bin/env rspec -cfd -b

BEGIN {
	require 'pathname'
	basedir = Pathname( __FILE__ ).dirname.parent
	libdir = basedir + 'lib'

	$LOAD_PATH.unshift( libdir.to_s ) unless $LOAD_PATH.include?( libdir.to_s )
}

require 'rspec'
require 'strelka'
require 'strelka/app'
require 'strelka/constants'
require 'mongrel2/testing'
require 'loggability/spechelpers'
require 'strelka/app/fancyerrors'
require 'strelka/behavior/plugin'


### Mock with RSpec
RSpec.configure do |c|
	include Strelka::Constants

	c.mock_with( :rspec )

	c.include( Loggability::SpecHelpers )
	c.include( Mongrel2::SpecHelpers )
	c.include( Strelka::Constants )
end


describe Strelka::App::FancyErrors do

	TEST_SEND_SPEC = 'tcp://127.0.0.1:9997'
	TEST_RECV_SPEC = 'tcp://127.0.0.1:9996'

	before( :all ) do
		setup_logging()
	end

	let( :request_factory ) { Mongrel2::RequestFactory.new(route: '') }

	let( :appclass ) do
		Class.new( Strelka::App ) do
			include Strelka::Constants

			plugins :routing,
			        :fancyerrors


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
	end


	after( :all ) do
		reset_logging()
	end


	it_should_behave_like( "A Strelka Plugin" )


	it "renders server errors using the server error template" do
		req = request_factory.get( '/server' )
		res = appclass.new.handle( req )

		expect( res.body.read ).to match( /server error template/i )
	end

	it "renders client errors using the client error template" do
		req = request_factory.get( '/client' )
		res = appclass.new.handle( req )

		expect( res.body.read ).to match( /client error template/i )
	end

	it "renders errors using the existing layout template if one is set" do
		app = appclass.new
		app.layout = Inversion::Template.new( '<!-- common layout --><?attr body ?>' )

		req = request_factory.get( '/client' )
		res = app.handle( req )

		expect( res.body.read ).to match( /common layout/i )
	end

end

