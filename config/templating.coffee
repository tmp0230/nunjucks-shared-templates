nunjucks = require('nunjucks')

env = new nunjucks.Environment(new nunjucks.FileSystemLoader(['public/tpl', 'templates']));

exports.configure = (app) ->
  env.express(app);

exports.env = env