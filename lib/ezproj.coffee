exports._matchers   = []
exports._version    = null
exports._frameworks = []
exports._defines    = []
exports._links      = []
exports._plist      = null
exports._prefix     = null

exports.target = (target) ->
	exports._version = target

exports.framework = exports.frameworks = (frameworks...) ->
	exports._frameworks.push framework for framework in frameworks

exports.define = exports.defines = (defines...) ->
	exports._defines.push define for define in defines

exports.link = exports.links = (links...) ->
	exports._links.push link for link in links

exports.match = (pattern, fn) ->
	exports._matchers.push
		pattern: pattern
		fn:      fn

exports.plist = (plist) ->
	exports._plist = plist

exports.prefix = (prefix) ->
	exports._prefix = prefix

exports.build = 'build'
exports.embed = 'embed'