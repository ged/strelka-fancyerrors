# -*- ruby -*-
# vim: set nosta noet ts=4 sw=4:
# encoding: utf-8

require 'loggability'
require 'configurability'
require 'inversion'

require 'strelka' unless defined?( Strelka )
require 'strelka/app' unless defined?( Strelka::App )


# Fancy/useful error output for Strelka appliation development. This plugin
# uses the Strelka default :errors and :templating plugins.
module Strelka::App::FancyErrors
	extend Loggability,
	       Configurability,
	       Strelka::MethodUtilities,
	       Strelka::Plugin


	# Loggability API -- log to Strelka's logger
	log_to :strelka


	# Library version constant
	VERSION = '0.1.0'

	# Version-control revision constant
	REVISION = %q$Revision$


	# Configurability API -- set the config section that affects this plugin
	config_key :fancyerrors

	# Strelka::Plugin API -- ensure this plugin sees requests before it's routed
	run_before :routing, :errors
	run_after  :templating


	# The data directory in the project if that exists, otherwise the gem datadir
	DEFAULT_DATADIR = if ENV['FANCYERRORS_DATADIR']
			Pathname( ENV['FANCYERRORS_DATADIR'] )
		elsif File.directory?( 'data/strelka-fancyerrors' )
			Pathname( 'data/strelka-fancyerrors' )
		elsif path = Gem.datadir('strelka-fancyerrors')
			Pathname( path )
		else
			raise ScriptError, "can't find the data directory!"
		end


	# Configurability configuration defaults
	CONFIG_DEFAULTS = {
		templates_dir: DEFAULT_DATADIR + 'templates',
	}


	##
	# The path to the error templates
	singleton_attr_accessor :templates_dir
	self.templates_dir = CONFIG_DEFAULTS[:templates_dir]


	### Configurability API -- Configure the plugin
	def self::configure( config=nil )
		if config
			self.log.debug "Configuring fancy error templates: %p" % [ config ]
			self.templates_dir = Pathname( config[:templates_dir] ) if config[:templates_dir]
		end
	end


	### Inclusion callback -- add the plugin's templates directory right before activation
	### so loading the config doesn't clobber it.
	def self::included( mod )
		# Add the plugin's template directory to Inversion's template path
		Inversion::Template.template_paths.push( self.templates_dir )

		super
	end


	# Class-level functionality
	module ClassMethods
		extend Loggability
		log_to :strelka

		### Extension callback -- overridden to also install dependencies.
		def self::extended( obj )
			super
			self.log.debug "Setting up fancy error responses."

			# Load the plugins this one depends on if they aren't already
			obj.plugins :errors, :templating

			# Set up templates for error views
			obj.templates \
				fancy_error_layout: 'error-layout.tmpl',
				fancy_server_error: 'server-error.tmpl',
				fancy_client_error: 'client-error.tmpl'

			obj.on_status( 400..499 ) {|res,info| self.fancy_error_template(:fancy_client_error, res, info) }
			obj.on_status( 500..599 ) {|res,info| self.fancy_error_template(:fancy_server_error, res, info) }

		end

	end # module ClassMethods


	### Load the template that corresponds to +key+ and populate it with the given
	### +status_info+. If the application has a layout template, wrap it in that.
	### Otherwise, use a simple default layout template.
	def fancy_error_template( key, response, status_info )
		self.log.info "[:fancyerrors] Handling %d status response." % [ status_info[:status] ]
		content = self.template( key )
		content.status_info = status_info
		self.log.debug "  error content template loaded from %s" % [ content.source_file || 'memory' ]

		# If there's a layout template, just return the template as-is so
		# templating will wrap it correctly
		return content if self.layout
		self.log.debug "  using the fancyerrors layout template."

		# Otherwise, wrap it in a simple layout of our own
		layout = self.template( :fancy_error_layout )
		layout.body = content
		layout.status_info = status_info

		self.log.debug "  error layout template loaded from %s" % [ layout.source_file || 'memory' ]

		# :templating method
		self.set_common_attributes( layout, response.request )

		return layout
	end

end # module Strelka::App::Errors



