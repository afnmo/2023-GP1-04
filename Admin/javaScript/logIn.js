// import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
// import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js";
// import { getFirestore, collection, getDocs, query, where, addDoc, doc, updateDoc } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

// // Your web app's Firebase configuration
// const firebaseConfig = {
//     apiKey: "AIzaSyAWSHSS6v0pG5VxrmfXElArcMpjBT5o6hg",
//     authDomain: "app-be149.firebaseapp.com",
//     projectId: "app-be149",
//     storageBucket: "app-be149.appspot.com",
//     messagingSenderId: "18569998394",
//     appId: "1:18569998394:web:c8efa4c8b656702c1cc503"
// };
// // Initialize Firebase
// const app = initializeApp(firebaseConfig);
// // Get Auth instance
// const auth = getAuth(app);
// const loginForm = document.getElementById("login-form");


// async function checkRequests(email, password) {
 
//   // Simplified email validation (more robust validation recommended)
//   if (!email.includes('@') || !email.includes('.')) {

//     alert("Please enter a valid email address.");
//     return false; // Prevent further processing
//   }

//   // Password validation is implemented here (e.g., minimum length, complexity)
//   if (password.length < 6) {
//     alert("Password must be at least 6 characters long.");
//     return false; // Prevent further processing
//   }
  
//   // Simulate admin credentials verification (replace with your authentication logic)
//   return email === "admin@example.com" && password === "secure_password"; 
// }

// loginForm.addEventListener("submit", async function (event) {
//   event.preventDefault(); // Prevent default form submission

//   const email = document.getElementById("email").value;
//   const password = document.getElementById("password").value;

//   try {
//     await signInWithEmailAndPassword(auth, email, password);
//     // User is signed in (admin in this case)
//     window.location.href = "index.html"; // Redirect to index.html $change to home or dashbord for admin$
//   } catch (error) {
//     if (error.code === "auth/user-not-found") {
//       // User not registered
//      alert("Please register first.");
//      // showAlert("Please register");
//     } else {
//       // Other login errors
//       console.error("Error logging in admin:", error);
//       // Handle other errors (e.g., display more specific error messages)
//     }
//   }
// // });












// import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
// import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js";
// import { getFirestore, collection, getDocs, query, where, addDoc, doc, updateDoc } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

// // Your web app's Firebase configuration
// const firebaseConfig = {
//     apiKey: "AIzaSyAWSHSS6v0pG5VxrmfXElArcMpjBT5o6hg",
//     authDomain: "app-be149.firebaseapp.com",
//     projectId: "app-be149",
//     storageBucket: "app-be149.appspot.com",
//     messagingSenderId: "18569998394",
//     appId: "1:18569998394:web:c8efa4c8b656702c1cc503"
// };
// // Initialize Firebase
// const app = initializeApp(firebaseConfig);
// // Get Auth instance
// const auth = getAuth(app);
// const loginForm = document.getElementById("login-form");


// async function checkRequests(email, password) {
//   // Simplified email validation (more robust validation recommended)
//   if (!email || !password) {
//     alert("Please fill in both email and password fields.");
//     return false; // Prevent further processing
//   }
// //  //Simplified email validation (more robust validation recommended)
// //   if (!email.includes('@') || !email.includes('.')) {

// //     showAlert("Please enter a valid email address.");
// //     return false; // Prevent further processing
// //   }

//   // Password validation is implemented here (e.g., minimum length, complexity)
//   if (password.length < 6) {
//     showAlert("Password must be at least 6 characters long.");
//     return false; // Prevent further processing
//   }
//   // Simulate admin credentials verification (replace with your authentication logic)
//   try {
//     const userCredential = await signInWithEmailAndPassword(auth, email, password);
//     const user = userCredential.user;
//     if (user) {
//       // User is signed in
//       window.location.href = "index.html"; // Redirect to index.html $change to home or dashbord for admin$
//     } else {
//       // User not registered
//       showAlert("Incorrect email or password.");
//     }
//   } catch (error) {
//     // Other login errors
//     console.error("Error logging in admin:", error);
//     showAlert("Please register");
//   }
// }

// loginForm.addEventListener("submit", async function (event) {
//   event.preventDefault(); // Prevent default form submission

//   const email = document.getElementById("email").value;
//   const password = document.getElementById("password").value;

//   await checkRequests(email, password);
// });


import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js";
import { getFirestore, collection, getDocs, query, where, addDoc, doc, updateDoc } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

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
// Get Auth instance
const auth = getAuth(app);
const loginForm = document.getElementById("login-form");

loginForm.addEventListener("submit", async function (event) {
  event.preventDefault(); // Prevent default form submission

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  await checkRequests(email, password);

async function checkRequests(email, password) {
  // Simplified email validation (more robust validation recommended)
  if (!email || !password) {
    alert("Please fill in both email and password fields.");
    return false; // Prevent further processing
  }
//Password validation is implemented here (e.g., minimum length, complexity)
  if (password.length < 6) {
    showAlert("Password must be at least 6 characters long.");
    return false; // Prevent further processing
  }
  // Simulate admin credentials verification (replace with your authentication logic)
  try {
    
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;
    if (user) {
      // User is signed in
      window.location.href = "index.html"; // Redirect to index.html $change to home or dashbord for admin$
    } else{

      // User not registered
      alert("Incorrect email or password.");
    }
  }
   catch (error) {
    // Other login errors
    console.error("Error logging in admin:", error);
    showAlert("Please register");  }
}


});



// change alert style
function showAlert(message) {
  var overlay = document.createElement('div');
  overlay.style.position = 'fixed';
  overlay.style.top = '0';
  overlay.style.left = '0';
  overlay.style.width = '100%';
  overlay.style.height = '100%';
  overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
  overlay.style.display = 'flex';
  overlay.style.alignItems = 'center';
  overlay.style.justifyContent = 'center';
  overlay.style.zIndex = '9999';

  var customAlert = document.createElement('div');
  customAlert.style.backgroundColor = '#fff';
  customAlert.style.padding = '20px';
  customAlert.style.border = '1px solid #ccc';
  customAlert.style.boxShadow = '0 0 10px rgba(0, 0, 0, 0.2)';
  customAlert.style.textAlign = 'center';
  customAlert.style.display = 'flex';
  customAlert.style.flexDirection = 'column'; // Align items in a column

  var header = document.createElement('div');
  header.style.display = 'flex';
  header.style.alignItems = 'center';
  header.style.marginBottom = '10px'; // Spacing between header and message

  var imgElement = document.createElement('img');
  imgElement.src = '../images/logo_no_bkg.png'; // Add your image path here
  imgElement.style.width = '50px';
  imgElement.style.marginRight = '10px'; // Space between image and text

  var headerText = document.createElement('span');
  headerText.textContent = '91 Website'; // Your header text
  headerText.style.color = '#000';

  var messageElement = document.createElement('span');
  messageElement.textContent = message;
  messageElement.style.color = '#000';

  var closeButton = document.createElement('button');
  closeButton.textContent = 'OK';
  closeButton.style.padding = '3px 8px'; // Adjust button size
  closeButton.style.cursor = 'pointer';
  closeButton.style.border = 'none';
  closeButton.style.backgroundColor = 'rgba(248, 167, 26)';
  closeButton.style.color = '#fff';
  closeButton.style.marginTop = '10px';
  closeButton.style.alignSelf = 'flex-end'; // Align button to the right

  closeButton.addEventListener('click', function () {
    document.body.removeChild(overlay);
  });

  header.appendChild(imgElement);
  header.appendChild(headerText);
  customAlert.appendChild(header);
  customAlert.appendChild(messageElement);
  customAlert.appendChild(closeButton);
  overlay.appendChild(customAlert);
  document.body.appendChild(overlay);
}