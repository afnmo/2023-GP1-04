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

// Create a reference to the collection
const collectionRef = collection(db, collectionName);

// Retrieve a specific document by ID ("s1") must tack id from BM fk ************************
const documentPath = doc(collectionRef, "gnrYQk0cGN4G28DTEhJm");

async function fetchStationData() {
    try {
        const docSnap = await getDoc(documentPath);
        if (docSnap.exists()) {
            const stationData = docSnap.data();

            if (stationData.open_hour != null)
                document.getElementById("OpenHour").textContent = stationData.open_hour;

            if (stationData.close_hour != null)
                document.getElementById("CloseHour").textContent = stationData.close_hour;

   
            const fuelTypes = stationData.fuel_type;
            const fuelStatus = stationData.fuel_status;

            // Loop through fuel status elements and set their display and width based on the data
            fuelStatus.forEach((status) => {
                const [type, state] = status.split(" ");
            
                if (type === '91') {
                    document.getElementById("91state").style.display = 'block';
            
                    if (state === 'Available') {
                        document.getElementById("91statewidth").style.width = '100%';
                    }
                } else if (type === '95') {
                    document.getElementById("95state").style.display = 'block';
            
                    if (state === 'Available') {
                        document.getElementById("95statewidth").style.width = '100%';
                    }
                } else if (type === 'Diesel') {
                    document.getElementById("Dieselstate").style.display = 'block';
            
                    if (state === 'Available') {
                        document.getElementById("Dieselstatewidth").style.width = '100%';
                    }
                }
            });            

        } else {
            console.log("Document does not exist.");
        }
    } catch (error) {
        console.error("Error accessing Firestore:", error);
    }
}

document.addEventListener('DOMContentLoaded', function () {
    fetchStationData();
});




