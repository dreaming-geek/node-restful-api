require 'coffee-script/register'

express = require 'express'
app = express()
bodyParser = require 'body-parser'

mongoose = require 'mongoose'

mongoose.connect 'YOUR_MONGO_URI'

Bear = require './app/models/bear'

app.use bodyParser()

port = process.env.PORT or 8080

# Routes
router = express.Router()

# middleware for all requests
router.use (req, res, next) ->
    console.log 'Stuff is happening'
    next() 

router.get '/', (req, res) ->
    res.json
        message: 'welcome to the app'

# creates a bear
router.route '/bears'
    .post (req, res) ->
        bear = new Bear()
        bear.name = req.body.name
        bear.save (err) ->
            if err
                res.send err
            res.json
                message: 'Bear created'
    # gets all the bears
    .get (req, res) ->
        Bear.find (err, bears) ->
            if err
                res.send err
            res.json bears

router.route '/bears/:bear_id'
    .get (req, res) ->
        Bear.findById req.params.bear_id, (err, bear) ->
            if err
                res.send err
            res.json bear
    # update a single bear
    .put (req, res) ->
        Bear.findById req.params.bear_id, (err, bear) ->
            if err
                res.send err
            bear.name = req.body.name
            bear.save (err) ->
                if err
                    res.send err
                res.json
                    message: 'Bear updated'
    # delete a bear
    .delete (req, res) ->
        Bear.remove
            _id: req.params.bear_id
            (err, bear) ->
                if err
                    res.send err
                res.json
                    message: 'Successfully deleted'

# Register the routes
# all routes will start with /api
app.use '/api', router

# Start the server
app.listen port
console.log 'Go to port ' + port
