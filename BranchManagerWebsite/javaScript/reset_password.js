
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
import {getAuth, sendPasswordResetEmail } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js";


// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyAWSHSS6v0pG5VxrmfXElArcMpjBT5o6hg",
    authDomain: "app-be149.firebaseapp.com",
    projectId: "app-be149",
    storageBucket: "app-be149.appspot.com",
    messagingSenderId: "18569998394",
    appId: "1:18569998394:web:c8efa4c8b656702c1cc503"
};

const app = initializeApp(firebaseConfig);

const auth = getAuth();


// Get references to form and input elements
const resetPasswordForm = document.getElementById("reset-password-form");
const emailInput = document.getElementById("email");
const countdown = document.getElementById("countdown");
const timer = document.getElementById("timer");
const sendButton = document.getElementById("send");

// Define a variable to keep track of the countdown time
let countdownTime = 30; // 30 seconds

resetPasswordForm.addEventListener("submit", function (e) {
  e.preventDefault();

  const emailAddress = emailInput.value;

  sendPasswordResetEmail(auth, emailAddress)
    .then(() => {
      // Password reset email sent successfully
      sendButton.disabled = true;
      countdown.style.display = "block"; // Show the countdown timer
      startCountdown(); // Start the countdown timer
    })
    .catch((error) => {
      // Handle errors
      console.error("Error sending password reset email: " + error.message);
      alert("Password reset email could not be sent. Check your email address.");
    });

  // Clear the input field
  emailInput.value = "";
});

function startCountdown() {
  const countdownInterval = setInterval(function () {
    countdownTime--;
    timer.textContent = countdownTime;

    if (countdownTime === 0) {
      clearInterval(countdownInterval);
      sendButton.disabled = false;
      countdown.style.display = "none"; // Hide the countdown timer
      countdownTime = 30; // Reset the countdown time for future use
    }
  }, 1000); // Update every second
}
