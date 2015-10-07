'use strict'
compact = require '../'
compact
  basedir: __dirname
  src: '/api'
  admin:
    path: '/admin'
    username: 'test'
    password: 'test'

  api:
    '/':
      val: '/'
    '/hoge':
      val: 'hoge'
    '/func': ->
      val: 'func'
