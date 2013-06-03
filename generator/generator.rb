#!/usr/bin/ruby

require 'rubygems'
require 'xcodeproj'
require 'json'

data    = JSON.parse gets
project = Xcodeproj::Project.new()
target  = project.new_target :application, 'App', :ios, data[:version]
scheme  = Xcodeproj::XCScheme.new 'App', target
prefix  = data["prefix"] || ''

data["files"].each_pair do |path, action|
	if action.casecmp('embed') == 0 then
		target.resources_build_phase.add_file_reference project.new_file path
	else
		target.source_build_phase.add_file_reference project.new_file path
	end
end

data["frameworks"].each do |framework|
	target.frameworks_build_phase.add_file_reference project.add_system_framework framework, target
end

config = {
	"OTHER_LDFLAGS"     => (data["links"].map { |link| "-#{link}" }.join ' '),
	"INFOPLIST_FILE"    => data["plist"],
	"GCC_PREFIX_HEADER" => prefix
}

target.build_configuration_list.build_settings('Release').merge! config
target.build_configuration_list.build_settings('Debug')  .merge! config

project.save_as "App.xcodeproj"
scheme.save_as "App.xcodeproj"