const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

const admin = require('firebase-admin');

// Hello world (to check in Postman)
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors({ origin: true }));

app.get('/hello-world', (req, res) => {
  return res.status(200).send('Hello World!');
});

exports.app = functions.https.onRequest(app);

// Database calls

// Key here
var serviceAccount = require("PATH-TO-FILE.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://covid-relief-1d6c0.firebaseio.com"
});

// create
const db = admin.firestore();
app.post('/api/create', (req, res) => {
    (async () => {
        try {
          await db.collection('items').doc('/' + req.body.id + '/')
              .create({item: req.body.item});
          return res.status(200).send();
        } catch (error) {
          console.log(error);
          return res.status(500).send(error);
        }
      })();
  });

// read 
app.get('/api/read/:item_id', (req, res) => {
  (async () => {
      try {
          const document = db.collection('usuario').doc(req.params.item_id);
          let item = await document.get();
          let response = item.data();
          return res.status(200).send(response);
      } catch (error) {
          console.log(error);
          return res.status(500).send(error);
      }
      })();
  });

// update
app.put('/api/update/:item_id', (req, res) => {
  (async () => {
      try {
          const document = db.collection('usuario').doc(req.params.item_id);
          await document.update({
              item: req.body.item
          });
          return res.status(200).send();
      } catch (error) {
          console.log(error);
          return res.status(500).send(error);
      }
      })();
  });