coffee  = require 'coffee-script'
fs      = require 'fs'
path    = require 'path'
program = require 'commander'
ezproj  = require './lib/ezproj'
glob    = require 'glob'
async   = require 'async'
{spawn} = require 'child_process'

program
	.version('ezproj 0.1.0')
	.parse  (process.argv)

file = program.args[0] ? "ezproj"
root = path.dirname file

fs.readFile file, (err, data) ->
	data = data.toString()
	coffee.eval data, 
		sandbox: ezproj

	data =
		version:    ezproj._version
		frameworks: ezproj._frameworks
		defines:    ezproj._defines
		links:      ezproj._links
		plist:      ezproj._plist
		prefix:     ezproj._prefix
		files:      {}

	match = (matcher, callback) ->
		glob matcher.pattern, { cwd: root }, (err, files) ->
			data.files[file] = matcher.fn file for file in files
			callback()

	async.each ezproj._matchers, match, (err) ->
		generator = spawn "#{__dirname}/generator/generator.rb"

		generator.stdin.write JSON.stringify data
		generator.stdin.end()

		generator.stdout.on 'data', (data) ->
			console.log data.toString()

		generator.stderr.on 'data', (data) ->
			console.log data.toString()

		generator.on 'exit', (code) ->