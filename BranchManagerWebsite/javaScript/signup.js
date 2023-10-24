import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, collection, getDocs, addDoc } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

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

async function checkEmailExists(email) {
    const collectionRef = collection(db, collectionName);

    const querySnapshot = await getDocs(collectionRef);

    let emailExists = false;

    querySnapshot.forEach((doc) => {
        const data = doc.data();
        if (data.email === email) {
            console.log("Email already exists");
            emailExists = true;
        }
    });

    return emailExists;
}

async function Addrequests() {
    const firtsName = document.getElementById("FirstName").value;
    const lastName = document.getElementById("LastName").value;
    const email = document.getElementById("Email").value;
    const pass = document.getElementById("StationName").value;
    const conpass = document.getElementById("GoogleMapUrl").value;

    if(pass != conpass){
        alert("Yuor pasword not mach con pass");
        return;
    }

    // Add a new "Branch_Manager" document
    const userID = await addDoc(collection(db, collectionName), {
        first_name: firtsName,
        last_name: lastName,
        email: email,
        password: pass,
        accepted: true,
    });

    // Set a session item
    // Get the ID of the newly created "Branch_Manager" document
    const branchManagerId = userID.id;
    sessionStorage.setItem('userID', branchManagerId);
    console.log(sessionStorage.getItem('userID'));
    document.getElementById("registrationForm").reset();
    window.location.href = "registerFormBM.html";
}

document.getElementById("registrationForm").addEventListener("submit", async function (event) {
    event.preventDefault();

    const email = document.getElementById("Email").value;
    const emailExists = await checkEmailExists(email);

    if (emailExists) {
        alert("Email already exists");
    } else {
        await Addrequests();
    }
});
