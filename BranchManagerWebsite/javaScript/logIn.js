import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, collection, getDocs, query, where } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
import {getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js";


// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyAWSHSS6v0pG5VxrmfXElArcMpjBT5o6hg",
    authDomain: "app-be149.firebaseapp.com",
    projectId: "app-be149",
    storageBucket: "app-be149.appspot.com",
    messagingSenderId: "18569998394",
    appId: "1:18569998394:web:c8efa4c8b656702c1cc503"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Access Firestore
const db = getFirestore(app);
const auth = getAuth();
async function checkRequests(email, password) {
    // Check if the email exists in the "branchManager" collection
    const branchManagerRef = collection(db, "branchManager");
    const branchManagerQuery = query(branchManagerRef, where("email", "==", email));
    const branchManagerQuerySnapshot = await getDocs(branchManagerQuery);
    console.log("Entered check requests");

    if (!branchManagerQuerySnapshot.empty) {
        // The email exists in the "branchManager" collection
        console.log("branchManagerQuerySnapshot not empty");
        signInWithEmailAndPassword(auth, email, password)
  .then(async (userCredential) => {
    
    // User is signed in.
    console.log("signInWithEmailAndPassword");
    const user = userCredential.user;
    console.log(user);
    // Check if the email exists in the "Station_Requests" collection
    const stationRequestsRef = collection(db, "Station_Requests");
    const stationRequestsQuery = query(stationRequestsRef, where("email", "==", email));
    const stationRequestsQuerySnapshot = await getDocs(stationRequestsQuery);
    console.log("stationRequestsQuerySnapshot");
    console.log("stationRequestsQuerySnapshot.empty: " + stationRequestsQuerySnapshot.empty);
    if (!stationRequestsQuerySnapshot.empty) {
        // The email exists in the "Station_Requests" collection
        console.log("stationRequestsQuerySnapshot");

        // Check if the request is accepted
        const data = stationRequestsQuerySnapshot.docs[0].data(); // Assuming there's only one matching document
        if (data.accepted === true) {
            // Redirect to the homepage
            setTimeout(function () {
                window.location.href = "homepagePM.html";
            }, 3000);
        } else {
            // Redirect to the waiting for approval page
            setTimeout(function () {
                window.location.href = "waitApproval.html";
            }, 3000);
        }
        // if pending
    } else {
        // Email doesn't exist in "Station_Requests" collection
        alert("you have not applied yet");
        setTimeout(function () {
            window.location.href = "waitApproval.html";
        }, 3000);
    }
  })
  .catch((error) => {
    // Handle errors, such as incorrect password or non-existent user.
    alert(error);
    console.log("Handle errors, such as incorrect password or non-existent user.");
  });

        
    } else {
        // Email doesn't exist in "branchManager" collection
        alert("Please register");
    }
}



document.getElementById("login-form").addEventListener("submit", async function (event) {
    event.preventDefault();
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;
    await checkRequests(email, password);
});

