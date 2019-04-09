const express = require('express');
const router = express.Router();
const path = require('path');
const entity = require('./entity.js');

router.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, 'public/index.html'));
});

router.get('/getPosts', function(req, res) {
    var skip = req.query.skip;
    var top = req.query.top;
    var filterConfig = JSON.parse(req.query.filterConfig);
    res.writeHead(200, {'content-type': 'application/json'});
    res.write(JSON.stringify(entity.getPosts(skip, top, filterConfig)));
    res.end();
});

router.get('/getPost', function(req, res) {
    var postId = req.query.postId;
    res.writeHead(200, {'content-type': 'application/json'});
    res.write();
    res.end();
});

router.post('/addPost', function(req, res) {
    var post = req.body;
    console.log('/addPost' + post);
    if(entity.addPost(post)) {
        res.writeHead(201);
        res.end();
    }
    else {
        res.writeHead(400);
        res.end();
    }
});

router.put('/editPost', function (req, res) {

});

router.delete('/removePost', function (req, res) {

});

module.exports = router;