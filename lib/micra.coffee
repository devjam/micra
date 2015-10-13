'use strict'

util = require 'util'
path = require 'path'
express = require 'express'

# isFunction = (fn)->
#   '[object Function]' == ({}).toString.call fn

module.exports = (conf)->
  conf = util._extend
    port: 8888
    hostname: null
    basedir: process.cwd()
    origin: '*'
    default: {}
    api: {}
    src: ''
    admin:
      path: null
      username: ''
      password: ''
  , conf

  app = express()
  app.set 'x-powered-by', false

  if conf.admin && conf.admin.path
    admin = require './admin/'
    app.use conf.admin.path, admin conf

  if conf.origin
    app.use (req, res, next)->
      origin = if util.isArray conf.origin then conf.origin.join ' ' else conf.origin
      res.header 'Access-Control-Allow-Origin', origin
      next()

  do ->
    for route, data of conf.api
      app.get route, do (data)->
        (req, res)->
          res.json if util.isFunction data then data req else data

  app.get '*', (req, res)->
    filename = path.join conf.basedir, conf.src, req.path
    # console.log filename
    try
      data = require filename
      # delete require.cache[filename]#require.resolve('./path/to.ext')
    catch err
      data = conf.default
    res.json if util.isFunction data then data req else data

  app.listen conf.port, conf.hostname

  hostname = if conf.hostname then conf.hostname else 'localhost'
  console.log 'Server running at http://' + hostname + ':' + conf.port
