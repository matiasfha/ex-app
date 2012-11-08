//Load the requirejs optimizer
var requirejs = require('/Users/msdark/.rvm/gems/ruby-1.9.3-p194/gems/requirejs-rails-0.9.0/bin/r.js'),
  //Set up basic config, include config that is
  //common to all the optimize() calls.
  basConfig = {
  "baseUrl": "/Users/msdark/Development/dandoodev/tmp/assets"
};

// Function used to mix in baseConfig to a new config target
function mix(target) {
  for (var prop in basConfig) {
    if (basConfig.hasOwnProperty(prop)) {
      target[prop] = basConfig[prop];
    }
  }
  return target;
}

var module_specs = [
{
  "name": "application",
  "out": "/Users/msdark/Development/dandoodev/public/assets/application.js"
},
];

// Do a series of builds of individual files, using the args suggested by:
// http://requirejs.org/docs/optimization.html#onejs
//
// r.js will eventually need a nested call idiom to handle async 
// builds.  Anticipating that need.
var async_runner = module_specs.reduceRight(function(prev, curr) {
  return function (buildReportText) { 
    requirejs.optimize(mix(curr), prev);
  };
}, function(buildReportText) {} );

async_runner();
