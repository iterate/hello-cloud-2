import express from 'express';
import http from 'http';

const app = express();

app.get('/', (req, res) => {
    res.send(`<h1>Hello Cloud 2.0</h1><h2>NODE_ENV=${process.env.NODE_ENV}</h2>`);
});

http.createServer(app).listen(80, () => {
    console.log("Listen on 0.0.0.0:80");
});

process.on('SIGINT', function() {
    process.exit();
});
