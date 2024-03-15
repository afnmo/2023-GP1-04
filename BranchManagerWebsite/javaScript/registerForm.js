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

const urlInput = document.getElementById("GoogleMapUrl");
const urlError = document.getElementById("urlError");

async function Addrequests() {
    const stationName = document.getElementById("StationName").value;
    const stationLocation = document.getElementById("GoogleMapUrl").value;
  
    
        const isValidURL = validateURL(stationLocation);

        if (!isValidURL || stationLocation.trim() === '') {
            urlError.textContent = "Location must be in Google Maps URL format";
            urlInput.classList.add('error');
            return; // Stop further execution
        }
 
    
    try {


        // Add to the "Station_Requests" collection
        const stationRequestRef = await addDoc(collection(db, "Station_Requests"), {
            name: stationName,
            location: stationLocation,
            branch_manager_id: SID, 
            accepted: true, //'pending',
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
        window.location.href = "login.html";
    } catch (error) {
        console.error("Error updating document:", error);
    }
      
}

document.getElementById("registrationForm").addEventListener("submit", async function (event) {
    event.preventDefault();

        await Addrequests();
});

function validateURL(url) {
    const urlPattern = /^https:\/\/maps\.app\.goo\.gl\/.*$/;

    const isValidURL = urlPattern.test(url);

    if (!isValidURL) {
        urlError.textContent = "Location must be in the format 'https://maps.app.goo.gl/'";
        urlInput.classList.add('error');
    } else {
        urlError.textContent = "";
        urlInput.classList.remove('error');
    }

    return isValidURL;
}