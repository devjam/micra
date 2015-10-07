'use strict'

path = require 'path'
express = require 'express'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

serveStatic = require 'serve-static'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
flash = require 'connect-flash'

module.exports = (conf)->
  router = express.Router()
  admin = express()
  admin.set 'views', __dirname + '/views'
  admin.set 'view engine', 'jade'
  admin.set 'x-powered-by', false

  login = (req, res, next)->
    next()

  if conf.admin.username && conf.admin.password
    passport.use new LocalStrategy (username, password, done)->
      return done null, false if conf.admin.username != username
      return done null, false if conf.admin.password != password
      done null, conf.admin
    passport.serializeUser (user, done)->
      done null, user.username
    passport.deserializeUser (id, done)->
      done null, conf.admin

    router.get '/login', (req, res)->
      return res.redirect conf.admin.path if req.isAuthenticated()
      res.render 'login',
        path: conf.admin.path
        message: req.flash 'error'

    router.post '/login', passport.authenticate 'local',
      successRedirect: conf.admin.path
      failureRedirect: conf.admin.path + '/login'
      failureFlash: '入力が正しくありません'

    login = (req, res, next)->
      return next() if req.isAuthenticated()
      res.redirect conf.admin.path + '/login'

    router.get '/logout', (req, res)->
      req.logout()
      res.redirect conf.admin.path + '/login'

  router.get '/', login, (req, res)->
    res.send 'admin index'

  router.get '/add', login, (req, res)->
    res.send 'admin add'

  router.get '/edit', login, (req, res)->
    res.send 'admin edit'

    # after update
    # filename = require.resolve path.join conf.basedir, conf.src, '/jj'
    # if require.cache[filename]
    #   delete require.cache[filename]

  admin.use serveStatic __dirname + '/public'
  admin.use cookieParser()
  admin.use bodyParser.json()
  admin.use bodyParser.urlencoded extended: false
  admin.use session
    secret: 'ankug1ai6wioeh78fajflka5skdfnj1aks0jla4wrtag2a'
    resave: false
    saveUninitialized: false
  admin.use flash()
  admin.use passport.initialize()
  admin.use passport.session()
  admin.use router

  admin
