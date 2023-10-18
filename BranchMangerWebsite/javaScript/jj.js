import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, collection, getDocs, addDoc, updateDoc, doc, query, where} from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

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

async function checkEmailExists(email) {
    const branchManagerQuery = query(collection(db, "Branch_Manager"), where("email", "==", email));
    const branchManagerQuerySnapshot = await getDocs(branchManagerQuery);
    const collectionRef = collection(db, "Station_Requests");
    const querySnapshot = await getDocs(collectionRef);
    let loged = false;

    if (branchManagerQuerySnapshot.empty) {
        querySnapshot.forEach(async (Doc) => {
            const data = Doc.data();
            if (data.email === email && data.accepted === true) {
                loged = true;
                const firstName = data.first_name;
                const lastName = data.last_name;
                const stationName = data.station_name;
                const stationLocation = data.station_location;

                // Add a new "Branch_Manager" document
                const branchManagerRef = await addDoc(collection(db, "Branch_Manager"), {
                    first_name: firstName,
                    last_name: lastName,
                    email,
                });

                // Get the ID of the newly created "Branch_Manager" document
                const branchManagerId = branchManagerRef.id;

                // Set a session item
                sessionStorage.setItem('sessionID', branchManagerId);
                //console.log(sessionStorage.getItem('sessionID'));

                // Add to the "Station" collection
                const stationRef = await addDoc(collection(db, "Station"), {
                    name: stationName,
                    Location: stationLocation,
                    branch_manager_id: branchManagerId, // Store the foreign key
                });

                // Get the ID of the newly created "Branch_Manager" document
                const stationId = stationRef.id;

                // Define a reference to a specific document within the "Branch_Manager" collection
                const branchManagerDocRef = doc(db, "Branch_Manager", branchManagerId);

                // Update the document with the new field
                updateDoc(branchManagerDocRef, {
                    station_id: stationId,
                });
                document.getElementById("registrationForm").reset();
                window.location.href = "homepagePM.html";
            }
        });
    } else {
        branchManagerQuerySnapshot.forEach((Doc) => {
            const data = Doc.data();
            if (data.email === email) {
                loged = true;
                const branchManagerId = Doc.id; // Retrieve the ID of the specific document
                // Set a session item
                sessionStorage.setItem('sessionID', branchManagerId);
                document.getElementById("registrationForm").reset();
                //console.log(sessionStorage.getItem('sessionID'));
                window.location.href = "homepagePM.html";
            }
        });
    }

    if (loged === false) {
        alert("Please register first");
    }
}


document.getElementById("registrationForm").addEventListener("submit", async function (event) { //حطي ايدي الفورم
    event.preventDefault();

    const email = document.getElementById("Email").value;//حطي ايدي الانبوت حق الايميل
    await checkEmailExists(email);
});
