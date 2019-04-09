const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const router = require('./router.js');

app.listen(3000, function () {
    console.log('Server running at http://localhost:3000');
});
app.use(bodyParser.json());
app.use('/', router);
app.use(express.static(__dirname + '/public'));