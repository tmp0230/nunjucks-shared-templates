// Generated by CoffeeScript 1.4.0
(function() {
  var env, nunjucks;

  nunjucks = require('nunjucks');

  env = new nunjucks.Environment(new nunjucks.FileSystemLoader(['public/tpl', 'templates']));

  exports.configure = function(app) {
    return env.express(app);
  };

  exports.env = env;

}).call(this);
