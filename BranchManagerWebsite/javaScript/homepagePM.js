// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, doc, getDoc, collection } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

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
const collectionName = "Station";

//retrieve stationID
const BMID = sessionStorage.getItem('sessionID');
let stationID;

if (BMID) {
    const BMdoc = doc(db, "Branch_Manager", BMID); // Update the document reference

    // Use await with getDoc since it returns a Promise
    const docSnap = await getDoc(BMdoc);

    if (docSnap.exists()) {
        const BMData = docSnap.data();
        stationID = BMData.station_id;

        if (stationID) {
            // Pass the Firestore instance (db) to the fetchStationData function
            fetchStationData(db, collectionName, stationID);
        }
    }
} else {
    window.location.href = "login.html";
}

async function fetchStationData(db, collectionName, stationID) { // Pass documentPath and collectionRef as arguments
    try {
        // Create a reference to the specific document
        const documentPath = doc(db, collectionName, stationID);

        const docSnap = await getDoc(documentPath);

        if (docSnap.exists()) {
            const stationData = docSnap.data();

            if(stationData.open_hour != null){
                const openHour = convertTimeToAMPM(stationData.open_hour);
                document.getElementById("OpenHour").textContent = openHour;
            }

            if(stationData.close_hour != null){
                const closeHour = convertTimeToAMPM(stationData.close_hour);
                document.getElementById("CloseHour").textContent = closeHour;
            }

            const fuelStatus = stationData.fuel_status;

            // Loop through fuel status elements and set their display and width based on the data
            if (fuelStatus) {
                fuelStatus.forEach((status) => {
                    const [type, state] = status.split(" ");

                    if (type === '91') {
                        document.getElementById("91state").style.display = 'block';

                        if (state === 'Unavailable') {
                            var value = "91";
                            var pElement = document.getElementById("91statewidth");
                            pElement.innerHTML = value + " unavailable";
                        }
                    } else if (type === '95') {
                        document.getElementById("95state").style.display = 'block';

                        if (state === 'Unavailable') {
                            var value = "95";
                            var pElement = document.getElementById("95statewidth");
                            pElement.innerHTML = value + " unavailable";
                        }
                    } else if (type === 'Diesel') {
                        document.getElementById("Dieselstate").style.display = 'block';

                        if (state === 'Unavailable') {
                            var value = "Diesel";
                            var pElement = document.getElementById("Dieselstatewidth");
                            pElement.innerHTML = value + " unavailable";
                        }
                    }
                });

            }
        } else {
            console.log("Document does not exist.");
        }
    } catch (error) {
        console.error("Error accessing Firestore:", error);
    }
}

// set time in AM or PM 
function convertTimeToAMPM(time24) {
    let splitTime = time24.split(':');
    let hours = parseInt(splitTime[0], 10);
    let minutes = splitTime[1];
    let period = hours < 12 ? 'AM' : 'PM';
  
    if (hours === 0) {
      hours = 12; // 0 hours is 12 AM
    } else if (hours > 12) {
      hours -= 12; // Convert to 12-hour format
    }
  
    return `${hours}:${minutes} ${period}`;
  }