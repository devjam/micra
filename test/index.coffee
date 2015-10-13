'use strict'
micra = require '../'

micra
  basedir: __dirname
  src: '/api'
  # admin:
  #   path: '/admin'
  #   username: 'test'
  #   password: 'test'

  api:
    '/':
      type: 'config object'
      path: '/'

    '/function/:a?/:b?': (req)->
      type: 'config function has params'
      path: req.path
      params: req.params
