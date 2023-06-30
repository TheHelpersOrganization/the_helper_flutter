importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js");

// For Firebase JS SDK v7.20.0 and later, measurementId is optional
var firebaseConfig = {
    apiKey: "AIzaSyCHjOPxYW7UaNz6xS41cWQ2ut-Gw7TkcBs",
    authDomain: "thehelpers-9cf70.firebaseapp.com",
    projectId: "thehelpers-9cf70",
    storageBucket: "thehelpers-9cf70.appspot.com",
    messagingSenderId: "731958532525",
    appId: "1:731958532525:web:2ef061d3b2287b5f462924",
    measurementId: "G-33YY6HLNBW"
  };

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();