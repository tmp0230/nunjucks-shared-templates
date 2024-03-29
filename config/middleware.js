// Generated by CoffeeScript 1.4.0
(function() {
  var express, flash, path;

  express = require('express');

  flash = require('connect-flash');

  path = require('path');

  exports.configure = function(app) {
    app.enable('verbose errors');
    if ('production' === app.settings.env) {
      app.disable('verbose errors');
    }
    app.set('port', process.env.PORT || 3000);
    app.use(express.responseTime());
    app.use(express.favicon(path.join(__dirname, '../public/img/favicon.ico')));
    app.use(express.logger('dev'));
    app.use(express.cookieParser('catman cat'));
    app.use(express.session({
      secret: 'keyboard cat',
      cookie: {
        maxAge: 600000
      }
    }));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(flash());
    app.use(function(req, res, next) {
      res.locals.flash = function() {
        return req.flash() || {};
      };
      return next();
    });
    app.use(function(req, res, next) {
      var shadow;
      shadow = {
        json: res.json,
        redirect: res.redirect
      };
      res.json = function(content) {
        var body, flashes, _ref;
        flashes = req.flash() || [];
        body = {
          content: content,
          flash: flashes,
          hasError: !!((_ref = flashes.error) != null ? _ref.length : void 0)
        };
        return shadow.json.apply(res, [body]);
      };
      res.redirect = function(url) {
        var body, flashes;
        if (req.xhr) {
          flashes = req.flash() || [];
          body = {
            content: null,
            flash: flashes,
            redirect: url
          };
          return shadow.json.apply(res, [body]);
        } else {
          return shadow.redirect.apply(res, [url]);
        }
      };
      return next();
    });
    app.use(app.router);
    app.use('/static', require('less-middleware')({
      src: path.join(__dirname, '../public'),
      dest: path.join(__dirname, '../compiled')
    }));
    app.use('/static', require('connect-coffee-script')({
      src: path.join(__dirname, '../public'),
      dest: path.join(__dirname, '../compiled')
    }));
    app.use('/static', express["static"](path.join(__dirname, '../public')));
    app.use('/static', express["static"](path.join(__dirname, '../compiled')));
    app.use(function(req, res, next) {
      res.status(404);
      if (req.accepts('html')) {
        res.render('error/404.html', {
          url: req.url
        });
        return;
      }
      if (req.accepts('json')) {
        res.send({
          error: 'Not found'
        });
        return;
      }
      return res.type('txt').send('Not found');
    });
    return app.use(function(err, req, res, next) {
      res.status(err.status || 500);
      return res.render('error/500.html', {
        error: err
      });
    });
  };

}).call(this);
