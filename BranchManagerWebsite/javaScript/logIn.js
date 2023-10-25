import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, collection, getDocs, query, where, addDoc, doc, updateDoc } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js";


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
    // const branchManagerRef = collection(db, "branchManager");
    const branchManagerRef = collection(db, "Branch_Manager");
    // console.log("branchManagerRef: " + branchManagerRef);
    const branchManagerQuery = query(branchManagerRef, where("email", "==", email));
    // console.log("branchManagerQuery: " + branchManagerQuery.email);
    const branchManagerQuerySnapshot = await getDocs(branchManagerQuery);
    // console.log("branchManagerQuerySnapshot" + branchManagerQuerySnapshot);

    let docID = null; // Initialize the docID variable

    // Iterate through the documents in the snapshot
    branchManagerQuerySnapshot.forEach((doc) => {
        // Check if the email in the document matches the desired email
        if (doc.data().email === email) {
            // If it does, store the document ID and break out of the loop
            docID = doc.id;
            return;
        }
    });
    console.log("Entered check requests");
    console.log("branchManagerQuerySnapshot.empty: " + branchManagerQuerySnapshot.empty);

    if (!branchManagerQuerySnapshot.empty) {
        // The email exists in the "branchManager" collection
        console.log("branchManagerQuerySnapshot not empty");

        // retireve the branch manager id to check if he has a station request
        //const branchManagerId11 = branchManagerQuerySnapshot.data.id;
        console.log("docID: " + docID);


        signInWithEmailAndPassword(auth, email, password)
            .then(async (userCredential) => {

                // User is signed in.
                console.log("signInWithEmailAndPassword");
                const user = userCredential.user;
                console.log(user);
                // Check if the email exists in the "Station_Requests" collection
                const stationRequestsRef = collection(db, "Station_Requests");
                // const stationRequestsQuery = query(stationRequestsRef, where("email", "==", email));
                //console.log("branchManagerId11 inside then: " + docID);
                const stationRequestsQuery = query(stationRequestsRef, where("branch_manager_id", "==", docID));
                const stationRequestsQuerySnapshot = await getDocs(stationRequestsQuery);
                console.log("stationRequestsQuerySnapshot");
                console.log("stationRequestsQuerySnapshot.empty: " + stationRequestsQuerySnapshot.empty);

                stationRequestsQuerySnapshot.forEach((doc) => {
                    const data = doc.data();
                    console.log(data);
                });

                if (!stationRequestsQuerySnapshot.empty) {
                    // The email exists in the "Station_Requests" collection
                    // the branch manager has a request
                    console.log("stationRequestsQuerySnapshot");

                    // Check if the request is accepted
                    const data = stationRequestsQuerySnapshot.docs[0].data(); // Assuming there's only one matching document
                    console.log("data.accepted: " + data.accepted);

                    if (data.accepted === true) {

                        const stationName = data.name;
                        console.log("Station name: " + stationName);
                        const stationLocation = data.Location;
                        console.log("Station Location: " + stationLocation);

                        // Get the ID of the logined "Branch_Manager" document
                        // const branchManagerId = branchManagerRef.id;

                        sessionStorage.setItem('sessionID', docID);

                        const stationRef1 = collection(db, "Station");
                        const stationQuery = query(stationRef1, where("branch_manager_id", "==", docID));
                        const stationQuerySnapshot = await getDocs(stationQuery);
                        if (!stationQuerySnapshot.empty) {
                            // Redirect to the homepage
                            window.location.href = "homepagePM.html";
                        }
                        else{
                            // Add to the "Station" collection
                        const stationRef = await addDoc(collection(db, "Station"), {
                            name: stationName,
                            Location: stationLocation,
                            branch_manager_id: docID, // Store the foreign key
                        });

                        const stationId = stationRef.id;

                        // Define a reference to a specific document within the "Branch_Manager" collection
                        const branchManagerDocRef = doc(db, "Branch_Manager", docID);

                        // Update the document with the new field
                        updateDoc(branchManagerDocRef, {
                            station_id: stationId,
                        });
                        // Redirect to the homepage
                        window.location.href = "homepagePM.html";
                        }

                    } else {
                        // Redirect to the waiting for approval page
                        window.location.href = "waitApproval.html";
                    }
                    // if pending
                } else {
                    console.log("ELSE if (!branchManagerQuerySnapshot.empty)");
                    // Email doesn't exist in "Station_Requests" collection
                    // alert("you have not applied yet");
                    window.location.href = "registerFormPM.html";
                }
            })
            .catch((error) => {
                // Handle errors, such as incorrect password or non-existent user.
                //alert(error);
                console.log(error);
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

