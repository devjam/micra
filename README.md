<p align="center">
  <img height="150" width="250" src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Brookesia_micra_on_a_match_head.jpg/250px-Brookesia_micra_on_a_match_head.jpg">
</p>

# micra
it's a small api server.

## Install

```bash
$ npm install micra
```

## Usage

```js
var micra = require('micra');
var config = {};
micra(config);
```

### config
#### api
Type: `Object` Default: {}  
using [Express Route paths](http://expressjs.com/guide/routing.html#route-paths) for the object `key`.  
the object `value` will be returned from server as JSON.

```js
var config = {
  api: {
    '/': {
      type: 'config object',
      path: '/'
    },
    '/function/:a?/:b?': function(req) {
      return {
        type: 'config function',
        path: req.path,
        params: req.params
      };
    }
  }
};
```

#### src
Type: `String` Default: ''  
outputting data by `.js`, `.coffee` and `.json` files in the `src` directory.

```js
var config = {
  src: '/api'
};
```

/api/js.js
```js
module.exports = {
  type: 'file object',
  path: '/js'
};

// output
// http://example.com/js
// {"type":"file object","path":"/js"}
```

/api/coffee.coffee
```coffee
module.exports =
  type: 'file object'
  path: '/coffee'

# output
# http://example.com/coffee
# {"type":"file object","path":"/js"}
```

/api/json.json
```json
{
  "type": "file object",
  "path":"/json"
}

// output
// http://example.com/json
// {"type":"file object","path":"/json"}
```

/api/function/js.js
```js
module.exports = function(req){
  return {
    type: 'file function',
    path: req.path,
    query: req.query
  };
}

// output
// http://example.com/function/js
// {"type":"file function","path":"/function/js","query":{}}
//
// http://example.com/function/js?key=val
// {"type":"file function","path":"/function/js","query":{"key":"val"}}
```

/api/function/coffee.coffee
```coffee
module.exports = (req)->
  type: 'file function'
  path: req.path
  query: req.query

# output
# http://example.com/function/coffee
# {"type":"file function","path":"/function/coffee","query":{}}
#
# http://example.com/function/coffee?key=val
# {"type":"file function","path":"/function/coffee","query":{"key":"val"}}
```

#### port
Type: `Integer` Default: 8888  
set any port number.

#### hostname
Type: `String` Default: null  
set any host name.

#### basedir
Type: `String` Default: process.cwd()  
change base directory of server.

#### origin
Type: `String` or `Array` or `null` Default: '\*'  
change `Access-Control-Allow-Origin` header.  
for example
- null (it allows only same domain with server.)
- '\*' (it allows all domains.)
- 'http://example.com'  
- 'http://example.com https://example.com http://sub.example.com'  
- ['http://example.com', 'https://example.com', 'http://sub.example.com']  

#### default
Type: `Object` or `null` Default: {}  
if the URL path is undefined, the server will return the default data.

## License
[MIT](http://opensource.org/licenses/MIT)
