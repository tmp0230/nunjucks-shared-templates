express = require('express')
flash = require('connect-flash')
path = require('path')

exports.configure = (app) ->

    # our custom "verbose errors" setting
    # which we can use in the templates
    # via settings['verbose errors']
    app.enable('verbose errors');

    # disable them in production
    # use $ NODE_ENV=production node examples/error-pages
    if ('production' == app.settings.env)
        app.disable('verbose errors');

    app.set('port', process.env.PORT || 3000)
    app.use(express.responseTime())
    app.use(express.favicon(path.join(__dirname, '../public/img/favicon.ico')))
    app.use(express.logger('dev'))
    app.use(express.cookieParser('catman cat'));
    app.use(express.session({ secret: 'keyboard cat', cookie: { maxAge: 600000 }}))

    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(flash());
    app.use((req, res, next) ->
        res.locals.flash = () -> return req.flash() || {}
        next()
    )
    app.use((req, res, next) -> #monkey patch express to properly handle json flashes and redirects
      shadow = {json: res.json, redirect: res.redirect}

      res.json = (content) -> #make json respond in the format we expect and preserve flashes
        flashes = req.flash() || []
        body = {content: content, flash: flashes, hasError: !!flashes.error?.length}
        shadow.json.apply(res, [body])

      res.redirect = (url) -> #make redirect behave properly when we expect a json response
        if req.xhr
          flashes = req.flash() || []
          body = {content: null, flash: flashes, redirect: url}
          shadow.json.apply(res, [body])
        else
          shadow.redirect.apply(res, [url])

      next()
    )

    app.use(app.router)
    app.use('/static', require('less-middleware')({
        src: path.join(__dirname, '../public'),
        dest: path.join(__dirname, '../compiled')
    }))
    app.use('/static', require('connect-coffee-script')({
        src: path.join(__dirname, '../public'),
        dest: path.join(__dirname, '../compiled')
    }));

    app.use('/static', express.static(path.join(__dirname, '../public')))
    app.use('/static', express.static(path.join(__dirname, '../compiled')))

    app.use((req, res, next) ->
        res.status(404);

        # respond with html page
        if (req.accepts('html'))
            res.render('error/404.html', { url: req.url })
            return

        # respond with json
        if (req.accepts('json'))
            res.send({ error: 'Not found' })
            return

        # default to plain-text. send()
        res.type('txt').send('Not found')
    )
  # maybe this instead? ->  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
    app.use((err, req, res, next) ->
        # we may use properties of the error object
        # here and next(err) appropriately, or if
        # we possibly recovered from the error, simply next().
        res.status(err.status || 500)
        res.render('error/500.html', { error: err })
    )

