express = require 'express'
request = require 'request'

app = express()
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.cookieSession(secret: process.env.SESSION_SECRET || 'test')

oAuthClientId = process.env.CLIENT_ID
oAuthClientSecret = process.env.CLIENT_SECRET

app.get '/', (req, res) ->
  res.render 'index.jade', me: req.session.me

app.get '/auth', (req, res) ->
  console.log "-----> NEW REQUEST"
  code = req.param('code')
  if code
    request.post
      url: 'http://iiens.eu/oauth/token'
      form:
        client_id: oAuthClientId
        client_secret: oAuthClientSecret
        grant_type: 'authorization_code'
        redirect_uri: 'https://sxb-or.herokuapp.com/auth'
        code: code
      (err, response, body) ->
        body = JSON.parse(body)
        unless body.access_token?
          console.log body
          res.send body
        else
          console.log "avec acces token #{body.access_token}"
          request
            url: "http://api.iiens.eu/users/me?access_token=#{body.access_token}"
            (err, response, me) ->
              req.session.me = JSON.parse(me).avatar.url
              res.redirect '/'

app.get '/auth/ares', (req, res) ->
  res.redirect "http://iiens.eu/oauth/authorize?response_type=code&client_id=#{oAuthClientId}&client_secret=#{oAuthClientSecret}&redirect_uri=https://sxb-or.herokuapp.com/auth"

app.listen process.env.PORT || 3000
