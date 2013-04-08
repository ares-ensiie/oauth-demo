express = require 'express'
request = require 'request'

app = express()
app.use require('connect-assets')()
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.cookieSession(secret: process.env.SESSION_SECRET || 'test')

oAuthClientId = process.env.CLIENT_ID
oAuthClientSecret = process.env.CLIENT_SECRET

if process.env.NODE_ENV == "production"
  iiensURL = "http://iiens.eu"
  apiIiensURL = "http://api.iiens.eu"
  oauthDemoURL = "http://oauth-demo.iiens.eu"
else
  iiensURL = process.env.IIENS_URL || "http://ares-web.dev"
  apiIiensURL = process.env.IIENS_API_URL || "http://api.ares-web.dev"
  oauthDemoURL = process.env.OAUTH_DEMO_URL || "http://oauth-demo.dev"

app.get '/', (req, res) ->
  res.render 'index.jade', me: req.session.me, token: req.session.access_token, api_url: apiIiensURL

app.get '/auth', (req, res) ->
  code = req.param('code')
  if code
    request.post
      url: iiensURL + '/oauth/token'
      form:
        client_id: oAuthClientId
        client_secret: oAuthClientSecret
        grant_type: 'authorization_code'
        redirect_uri: oauthDemoURL + '/auth'
        code: code
      (err, response, body) ->
        body = JSON.parse(body)
        unless body.access_token?
          console.log body
          res.send body
        else
          request
            url: apiIiensURL + "/users/self?access_token=#{body.access_token}"
            (err, response, me) ->
              req.session.me = JSON.parse(me)
              req.session.access_token = body.access_token
              res.redirect '/'

app.get '/auth/ares', (req, res) ->
  res.redirect iiensURL + "/oauth/authorize?response_type=code&client_id=#{oAuthClientId}&client_secret=#{oAuthClientSecret}&redirect_uri=" + oauthDemoURL + "/auth"

app.post '/api_request', (req, res) ->
  request
    url: apiIiensURL + req.body.endpoint + "?access_token=" + req.session.access_token +
      "&client_id=" + oAuthClientId + "&client_secret=" + oAuthClientSecret
    (err, response, data) ->
      if response.statusCode == 200
        res.send data
      else if response.statusCode == 401
        req.session.access_token = null
        req.session.me = null
        res.status(401)
        res.send("Unauthorize")
      else
        console.log("Erreur API : " + response.statusCode)
        res.send "Erreur"

app.listen process.env.PORT || 3000
