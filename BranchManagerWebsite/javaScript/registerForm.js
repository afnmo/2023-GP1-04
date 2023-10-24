// import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
// import { getFirestore, collection, getDocs, addDoc } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
// import { getAuth, createUserWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js";

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

// // Access Firestore
// const db = getFirestore(app);
// const auth = getAuth();

// // Specify the name of the collection you want to read from
// const collectionName = "Station_Requests";


// async function checkEmailExists(email) {
//     const collectionRef = collection(db, collectionName);

//     const querySnapshot = await getDocs(collectionRef);

//     let emailExists = false;

//     querySnapshot.forEach((doc) => {
//         const data = doc.data();
//         if (data.email === email) {
//             console.log("Email already exists");
//             emailExists = true;
//         }
//     });

//     return emailExists;
// }


// async function generateRandomPassword() {
//     // Generate a random password here (e.g., a combination of letters and numbers)
//     const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//     const passwordLength = 8;
//     let randomPassword = '';
//     for (let i = 0; i < passwordLength; i++) {
//         const randomIndex = Math.floor(Math.random() * charset.length);
//         randomPassword += charset.charAt(randomIndex);
//     }
//     return randomPassword;
// }

// async function Addrequests() {
//     const firtsName = document.getElementById("FirstName").value;
//     const lastName = document.getElementById("LastName").value;
//     const email = document.getElementById("Email").value;
//     const stationName = document.getElementById("StationName").value;
//     const stationLocation = document.getElementById("GoogleMapUrl").value;

//     // Generate a random password for the user
//     const password = await generateRandomPassword();

//     const data = {
//         first_name: firtsName,
//         last_name: lastName,
//         email: email,
//         station_name: stationName,
//         station_location: stationLocation,
//         accepted: true,
//     };

//     try {
//         // Create a user with Firebase Authentication
//         const userCredential = await createUserWithEmailAndPassword(auth, email, password);
//         const user = userCredential.user;
//         console.log("User registered:", user);

//         // Define a reference to the Firestore collection
//         const collectionRef = collection(db, collectionName);

//         // Add the user data to Firestore
//         await addDoc(collectionRef, data);

//         console.log("Document successfully written");
//         document.getElementById("registrationForm").reset();
//         alert("Thank you for completing the registration process with 91.com. \nPlease await our approval for access.");

//         // Redirect after a certain delay
//         setTimeout(function () {
//             window.location.href = "index.html";
//         }, 3000); // Redirect after 3 seconds
//     } catch (error) {
//         console.error("Error registering user or writing document: ", error);
//     }
// }


// document.addEventListener("DOMContentLoaded", function () {
//     // Select the link by its id
//     const signOutLink = document.getElementById("signOutLink");
  
//     // Add a click event listener to the link
//     signOutLink.addEventListener("click", function (e) {
//       e.preventDefault(); // Prevent the default behavior (navigating to a new page)
  
//       // Call the signOut function
//       signOut();
//     });
//   });
  
//   // Define the signOut function
//   function signOut() {
  
//     auth.signOut().then(() => {
//       // Sign-out successful.
//       window.location.href = "index.html";
//       console.log("User has been successfully logged out.");
//     }).catch((error) => {
//       // An error happened.
//       console.error("Error during sign-out: ", error);
//     });
//   }
  
// // async function checkEmailExists(email) {
// //     const collectionRef = collection(db, collectionName);

// //     const querySnapshot = await getDocs(collectionRef);

// //     let emailExists = false;

// //     querySnapshot.forEach((doc) => {
// //         const data = doc.data();
// //         if (data.email === email) {
// //             console.log("Email already exists");
// //             emailExists = true;
// //         }
// //     });

// //     return emailExists;
// // }

// // async function Addrequests() {
// //     const firtsName = document.getElementById("FirstName").value;
// //     const lastName = document.getElementById("LastName").value;
// //     const email = document.getElementById("Email").value;
// //     const stationName = document.getElementById("StationName").value;
// //     const stationLocation = document.getElementById("GoogleMapUrl").value;

// //     const data = {
// //         first_name: firtsName,
// //         last_name: lastName,
// //         email: email,
// //         station_name: stationName,
// //         station_location: stationLocation,
// //         accepted: true,
// //     };

// //     // Define a reference to the Firestore collection
// //     const collectionRef = collection(db, collectionName);

// //     addDoc(collectionRef, data)
// //         .then(() => {
// //             console.log("Document successfully written");
// //             document.getElementById("registrationForm").reset();
// //             alert("Thank you for completing the registration process with 91.com. \nPlease await our approval for access.")
          
// //             // Delay the redirection by a few seconds (adjust the time as needed)
// //             setTimeout(function () {
// //                 window.location.href = "index.html";
// //             }, 600000); // Redirect after 3 seconds

// //         })
// //         .catch((error) => {
// //             console.error("Error writing document: ", error);
// //         });
// // }

// // document.getElementById("registrationForm").addEventListener("submit", async function (event) {
// //     event.preventDefault();

// //     const email = document.getElementById("Email").value;
// //     const emailExists = await checkEmailExists(email);

// //     if (emailExists) {
// //         alert("Email already exists.");
// //     } else {
// //         await Addrequests();
// //     }
// // });


// document.getElementById("registrationForm").addEventListener("submit", async function (event) {
//     event.preventDefault();

//     const email = document.getElementById("Email").value;

//     try {
//         // Check if the email already exists
//         const emailExists = await checkEmailExists(email);

//         if (emailExists) {
//             alert("Email already exists.");
//         } else {
//             // Register the user and add data to Firestore
//             await Addrequests();
//         }
//     } catch (error) {
//         console.error("Error checking email or registering user: ", error);
//     }
// });


import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, getDoc, doc, updateDoc, addDoc, collection } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

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

// Specify the name of the collection you want to read from
const collectionName = "Station_Requests";

//retrieve stationID
const SID = sessionStorage.getItem('branchManagerID');

if (SID) {
    const Sdoc = doc(db, "Branch_Manager", SID); // Update the document reference
    // Use await with getDoc since it returns a Promise
    const docSnap = await getDoc(Sdoc);

    if (docSnap.exists()) {
        const SData = docSnap.data();
        
        // document.getElementById("FirstName").value = SData.first_name;
        // document.getElementById("LastName").value = SData.last_name;
        document.getElementById("FirstName").value = SData.firstName;
        document.getElementById("LastName").value = SData.lastName;
        document.getElementById("Email").value = SData.email;

        document.getElementById("FirstName").style.fontSize = "larger";
        document.getElementById("LastName").style.fontSize = "larger";
        document.getElementById("Email").style.fontSize = "larger";
        document.getElementById("FirstName").style.color = "#30b476";
        document.getElementById("LastName").style.color = "#30b476";
        document.getElementById("Email").style.color = "#30b476";

    }
} else {
    window.location.href = "signup.html";
}

async function Addrequests() {
    const stationName = document.getElementById("StationName").value;
    const stationLocation = document.getElementById("GoogleMapUrl").value;
  
    try {


        // Add to the "Station_Requests" collection
        const stationRequestRef = await addDoc(collection(db, "Station_Requests"), {
            name: stationName,
            Location: stationLocation,
            branch_manager_id: SID, // Store the foreign key
            accepted: true,
        });        

        // Get the ID of the newly created "Branch_Manager" document
        const stationRequestID = stationRequestRef.id;

        // Define a reference to a specific document within the "Branch_Manager" collection
        const branchManagerDocRef = doc(db, "Branch_Manager", SID);

        // Update the document with the new field
        // updateDoc(branchManagerDocRef, {
        //     station_request_id: stationRequestID,
        // });

        // Document updated successfully
        document.getElementById("registrationForm").reset();
        window.location.href = "waitApproval.html";
    } catch (error) {
        console.error("Error updating document:", error);
    }
      
}

document.getElementById("registrationForm").addEventListener("submit", async function (event) {
    event.preventDefault();

        await Addrequests();
});
