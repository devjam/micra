'use strict'

util = require 'util'
path = require 'path'
express = require 'express'

# isFunction = (fn)->
#   '[object Function]' == ({}).toString.call fn

module.exports = (conf)->
  conf = util._extend
    port: 8888
    basedir: process.cwd()
    src: ''
    admin:
      path: null
      username: ''
      password: ''
  , conf

  app = express()
  app.set 'x-powered-by', false

  do ->
    for route, data of conf.api
      app.get route, do (data)->
          (req, res)->
            data = data req if util.isFunction data
            res.json data

  if conf.admin && conf.admin.path
    admin = require './admin/'
    app.use conf.admin.path, admin conf

  app.get '*', (req, res)->
    filename = path.join conf.basedir, conf.src, req.path
    # console.log filename
    try
      data = require filename
      # delete require.cache[filename]#require.resolve('./path/to.ext')
    catch err
      data = {}
    data = data req if util.isFunction data
    res.json data

  app.listen conf.port
  console.log 'Server running at http://localhost:' + conf.port
