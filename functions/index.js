const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors({ origin: true }));

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
      await db.collection('usuarios').doc('/' + req.body.email + '/')
        .create({
          username:req.body.username, 
          password: req.body.password, 
          origin: req.body.origin, 
          creation:req.body.creation, 
          state:req.body.state
        });
      await db.collection('perfiles').doc('/' + req.body.email + '/')
        .create({
          name:req.body.name, 
          country: req.body.country, 
          birthday: req.body.birthday, 
          gender: req.body.gender, 
          type:req.body.type, 
          phone:req.body.phone, 
          creation:req.body.creation, 
          state:req.body.state
        });
      return res.status(200).send();
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

// read (usuarios)
app.get('/api/read/:email', (req, res) => {
  (async () => {
      try {
          const document = db.collection('usuarios').doc(req.params.email);
          let username = await document.get();
          let response = username.data();
          return res.status(200).send(response);
      } catch (error) {
          console.log(error);
          return res.status(500).send(error);
      }
      })();
  });

// read (perfiles)
app.get('/api/read/:email', (req, res) => {
  (async () => {
    try {
      const document = db.collection('perfiles').doc(req.params.email);
      let birthday = await document.get();
      let response = birthday.data();
      return res.status(200).send(response);
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});

// update
app.put('/api/update/:email', (req, res) => {
  (async () => {
      try {
          const document = db.collection('usuarios').doc(req.params.email);
          await document.update({
              state: req.body.state
          });
          return res.status(200).send();
      } catch (error) {
          console.log(error);
          return res.status(500).send(error);
      }
      })();
  });

// update (perfiles)
app.put('/api/update/:email', (req, res) => {
  (async () => {
    try {
      const document = db.collection('perfiles').doc(req.params.email);
      await document.update({
        name:req.body.name, 
        country: req.body.country, 
        birthday: req.body.birthday, 
        gender: req.body.gender, 
        type:req.body.type, 
        phone:req.body.phone
        });
      return res.status(200).send();
    } catch (error) {
      console.log(error);
      return res.status(500).send(error);
    }
  })();
});
