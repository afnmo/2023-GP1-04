import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
import { doc, getDoc, collection, query, where, getDocs, deleteDoc, setDoc, updateDoc , onSnapshot, getCountFromServer} from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
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


function checkForEmptyState(pendingCount, acceptedCount, declinedCount) {

    const noPendingMessage = document.getElementById('no-pending-message');
    const noAcceptedMessage = document.getElementById('no-accepted-message');
    const noDeclinedMessage = document.getElementById('no-declined-message');
    console.log("noPendingMessage: " + noPendingMessage);
    console.log("pendingCount == 0: " + (pendingCount == 0));
    console.log("pendingCount: " + pendingCount);
    console.log("acceptedCount: " + acceptedCount);
    console.log("declinedCount: " + declinedCount);
    // Check each container's child element count and adjust message visibility
    if (pendingCount == 0) {
        console.log("pendingCount == 0: " + (pendingCount == 0));
        console.log("oPendingMessage.style.display: " + noPendingMessage.style.display);
        noPendingMessage.style.display = 'block';
        console.log("oPendingMessage.style.display: " + noPendingMessage.style.display);
    } else {
        noPendingMessage.style.display = 'none';
        console.log("oPendingMessage.style.display: " + noPendingMessage.style.display);
    }

    if (acceptedCount == 0) {
        noAcceptedMessage.style.display = 'block';
    } else {
        noAcceptedMessage.style.display = 'none';
    }

    if (declinedCount == 0) {
        noDeclinedMessage.style.display = 'block';
    } else {
        noDeclinedMessage.style.display = 'none';
    }
}
// Function to remove request card elements from a container
function removeRequestCards(container) {
    const requestCards = container.querySelectorAll('.request-card');
    requestCards.forEach((card) => {
        container.removeChild(card);
    });
}


function fetchStationRequests() {
    // Define the containers for each tab
    const pendingRequestsContainer = document.getElementById('pending-requests');
    const acceptedRequestsContainer = document.getElementById('accepted-requests');
    const declinedRequestsContainer = document.getElementById('declined-requests');

    // Initialize counters for each request status
    let pendingCount = 0;
    let acceptedCount = 0;
    let declinedCount = 0;


    // Query Firestore for all requests
    const q = query(collection(db, "Station_Requests"));

    // Listen for changes in the requests collection
    onSnapshot(q, (querySnapshot) => {
        // // Clear existing content in each tab's container
        removeRequestCards(pendingRequestsContainer);
        removeRequestCards(acceptedRequestsContainer);
        removeRequestCards(declinedRequestsContainer);

        // Iterate through each request and distribute them based on their status
        querySnapshot.forEach((doc) => {
            const request = doc.data();
            request.id = doc.id;

            if (request.accepted === 'pending') {
                displayRequest(request, request.id, 'pending');
                pendingCount++; // Increment pending count
            } else if (request.accepted === 'accepted') {
                displayRequest(request, request.id, 'accepted');
                acceptedCount++; // Increment accepted count
            } else if (request.accepted === 'declined') {
                displayRequest(request, request.id, 'declined');
                declinedCount++; // Increment declined count
            }
        });

        // Update the accepted stations count in the UI
        const acceptedStationsElement = document.getElementById('acceptedStations');
        acceptedStationsElement.textContent = acceptedCount;

        // Optionally, you can use the counts for other purposes, such as displaying them in the UI.
        // For example:
        // document.getElementById('pending-count').textContent = pendingCount;
        // document.getElementById('accepted-count').textContent = acceptedCount;
        // document.getElementById('declined-count').textContent = declinedCount;

        // Call checkForEmptyState() to handle empty state messages
        checkForEmptyState(pendingCount, acceptedCount, declinedCount);
    });
}


// Function to display a request in the appropriate tab container
async function displayRequest(request, requestId, status) {
    // Get manager information
    const managerInfo = await getBranchManagerInfo(request.branch_manager_id);

    // Create a new request card element
    const requestElement = document.createElement('div');
    requestElement.className = 'col request-card';
    requestElement.setAttribute('data-request-id', requestId);

    // Set the innerHTML of the request card
    requestElement.innerHTML = `
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0">${request.name}</h5>
                <span class="status-span badge ${status === 'pending' ? 'bg-secondary' : (status === 'accepted' ? 'bg-success' : 'bg-danger')}">
                    ${status.charAt(0).toUpperCase() + status.slice(1)}
                </span>
            </div>
            <div class="card-body">
                <p class="card-text">
                    <ion-icon name="location-outline"></ion-icon>
                    Location: <a href="${request.location}" target="_blank">View on map</a>
                </p>
                <p class="card-text">
                    <ion-icon name="person-outline"></ion-icon> Name: ${managerInfo.name}
                </p>
                <p class="card-text">
                    <ion-icon name="mail-outline"></ion-icon>
                    Email: ${managerInfo.email}
                </p>
            </div>
            ${status === 'pending' ? `
                <div class="card-footer">
                    <button type="button" class="btn btn-outline-success">
                        <ion-icon name="checkmark-circle-outline"></ion-icon> Accept
                    </button>
                    <button type="button" class="btn btn-outline-danger">
                        <ion-icon name="close-circle-outline"></ion-icon> Decline
                    </button>
                </div>
            ` : ''}
        </div>
    `;

    // Attach confirmation handlers if request is pending
    if (status === 'pending') {
        attachConfirmationHandlers(requestElement, requestId);
    }

    // Append the request card to the appropriate tab container
    const requestsContainer = document.getElementById(`${status}-requests`);
    requestsContainer.appendChild(requestElement);
}

// Attach event handlers for confirmation modal
function attachConfirmationHandlers(element, requestId) {
    const acceptBtn = element.querySelector('.btn-outline-success');
    const declineBtn = element.querySelector('.btn-outline-danger');

    acceptBtn.addEventListener('click', () => showConfirmationModal(requestId, true));
    declineBtn.addEventListener('click', () => showConfirmationModal(requestId, false));
}

// Show confirmation modal and handle confirmation
function showConfirmationModal(requestId, accepted) {
    const confirmationModalElement = document.getElementById('confirmationModal');
    const confirmationModal = new bootstrap.Modal(confirmationModalElement, {
        keyboard: false
    });

    // Update modal body with the confirmation message
    const modalBody = confirmationModalElement.querySelector('.modal-body');
    const actionText = accepted ? "accept" : "decline";
    modalBody.textContent = `Are you sure you want to ${actionText} this request?`;

    // Add event listener to the confirmation button
    const confirmBtn = document.getElementById('confirmBtn');
    confirmBtn.onclick = async function() {
        await updateRequestStatus(requestId, accepted);
        confirmationModal.hide();
    };

    confirmationModal.show();
}

// // Update the status of a request in Firestore and update the UI
// async function updateRequestStatus(requestId, accepted) {
//     const requestRef = doc(db, "Station_Requests", requestId);

//     try {
//         // Update the status in Firestore
//         await updateDoc(requestRef, {
//             accepted: accepted ? 'accepted' : 'declined'
//         });

//         console.log(`Request ${accepted ? 'accepted' : 'declined'}.`);

//         // Refresh the requests list to reflect changes
//         fetchStationRequests();

//     } catch (error) {
//         console.error("Error updating request: ", error);
//     }
// }

// Fetch and display branch manager info
async function getBranchManagerInfo(managerId) {
    const docRef = doc(db, "Branch_Manager", managerId);
    const docSnap = await getDoc(docRef);
    if (docSnap.exists()) {
        const managerData = docSnap.data();
        return {
            name: `${managerData.firstName} ${managerData.lastName}`,
            email: managerData.email
        };
    } else {
        return { name: "Unknown", email: "N/A" };
    }
}
function showToast(message) {
    // Create a toast element
    const toastElement = document.createElement('div');
    toastElement.className = 'toast d-flex align-items-center text-white bg-primary border-0 justify-content-between';
    toastElement.role = 'alert';
    toastElement.setAttribute('aria-live', 'assertive');
    toastElement.setAttribute('aria-atomic', 'true');

    // Create the toast body
    const toastBody = document.createElement('div');
    toastBody.className = 'toast-body';
    toastBody.textContent = message;

    // Create a close button
    const closeButton = document.createElement('button');
    closeButton.type = 'button';
    closeButton.className = 'btn-close';
    closeButton.setAttribute('data-bs-dismiss', 'toast');
    closeButton.setAttribute('aria-label', 'Close');

    // Append the close button and body to the toast
    toastElement.appendChild(toastBody);
    toastElement.appendChild(closeButton);

    // Append the toast to the toast container
    const toastContainer = document.getElementById('toast-container');
    toastContainer.appendChild(toastElement);

    // Create a Bootstrap Toast instance and show it
    const toast = new bootstrap.Toast(toastElement);
    toast.show();
}


async function updateRequestStatus(requestId, accepted) {
    const requestRef = doc(db, "Station_Requests", requestId);

    try {
        // Update the status in Firestore
        await updateDoc(requestRef, {
            accepted: accepted ? 'accepted' : 'declined'
        });

        // Provide feedback to the user
        const message = accepted
            ? 'Request accepted and moved to the "Accepted" tab.'
            : 'Request declined and moved to the "Declined" tab.';

        // Show a toast notification to the user
        showToast(message);

        console.log(`Request ${accepted ? 'accepted' : 'declined'}.`);

        // Refresh the requests list to reflect changes
        fetchStationRequests();

    } catch (error) {
        console.error("Error updating request: ", error);
    }
}


async function countUsers() {
    const usersCollection = collection(db, 'Users');
    const snapshot = await getCountFromServer(usersCollection);
    const userCount = snapshot.data().count;

    // Now that you have the user count, you can update your HTML element
    const numUsersElement = document.getElementById('numUsers');
    numUsersElement.textContent = userCount;
}

// Call the function to count users and update the page
countUsers();

// ---------------




// Wait for the DOM to fully load before calling fetchStationRequests()
window.addEventListener('DOMContentLoaded', async function(event) {


            // Create an object to store the count of requested stations for each date
            const requestedStationsCount = {};

            // Query the Station_Requests collection in Firestore
            const stationRequestsCollection = collection(db, 'Station_Requests');
            const stationRequestsSnapshot = await getDocs(stationRequestsCollection);
    
            // Iterate through each station request and count requests for each date
            stationRequestsSnapshot.forEach(doc => {
                const requestData = doc.data();
                const requestDate = requestData.requestDate;
    
                // Increment the count for the requestDate
                if (requestDate) {
                    if (requestedStationsCount[requestDate]) {
                        requestedStationsCount[requestDate] += 1;
                    } else {
                        requestedStationsCount[requestDate] = 1;
                    }
                }
            });
    
            // Function to convert date to day short name
            function getDayShortName(dateString) {
                const date = new Date(dateString);
                const daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                return daysOfWeek[date.getDay()];
            }
    
            // Prepare the data for the daily requested stations bar chart
            const requestedStationsData = {
                // Convert dates to short day names in the same order
                labels: Object.keys(requestedStationsCount).map(getDayShortName),
                datasets: [{
                    label: 'Requested Stations',
                    data: Object.values(requestedStationsCount),
                    backgroundColor: 'rgba(54, 162, 235, 0.5)', // Bootstrap primary color
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            };
    
            // Initialize daily requested stations bar chart
            const ctx = document.getElementById('stationsRequestedChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: requestedStationsData,
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            stepSize: 1, // Set step size to 1 to ensure only integers are displayed
                            precision: 0 
                        }
                    }
                }
            });
    
            console.log('Requested stations data loaded successfully.');
    
// Create an array to store the last 7 days' dates in the format d/m/yyyy
const last7Days = [];
const today = new Date();
for (let i = 6; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(today.getDate() - i);
    const day = date.getDate();
    const month = date.getMonth() + 1; // Months are zero-based in JavaScript
    const year = date.getFullYear();
    last7Days.push(`${day}/${month}/${year}`);
}

// Create an object to count logins for each date in `last7Days`
const loginsCount = last7Days.reduce((acc, date) => {
    acc[date] = 0; // Initialize the count for each date to 0
    return acc;
}, {});

// Query the Users collection in Firestore
const usersCollection = collection(db, 'Users');
const usersSnapshot = await getDocs(usersCollection);

// Iterate through each user and count logins
usersSnapshot.forEach(doc => {
    const userData = doc.data();
    const lastLoggedIn = userData.lastLoggedIn;

    // Check if the lastLoggedIn date is within the last 7 days
    if (last7Days.includes(lastLoggedIn)) {
        // Increment the count for the date
        loginsCount[lastLoggedIn] += 1;
    }
});

// Function to convert date to day short name
function getDayShortName(dateString) {
    const [day, month, year] = dateString.split('/');
    const date = new Date(`${year}-${month}-${day}`);
    const daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return daysOfWeek[date.getDay()];
}

// Prepare the data for the daily logged-in users bar chart
const loggedInUsersData = {
    // Convert `last7Days` to short day names in the same order
    labels: last7Days.map(getDayShortName),
    datasets: [{
        label: 'Logged-in Users',
        data: last7Days.map(date => loginsCount[date] || 0), // Map counts based on last7Days
        backgroundColor: 'rgba(40, 167, 69, 0.5)', // Bootstrap success color
        borderColor: 'rgba(40, 167, 69, 1)',
        borderWidth: 1
    }]
};

// Initialize daily logged-in users bar chart
const ctx2 = document.getElementById('loggedInUsersChart').getContext('2d');
new Chart(ctx2, {
    type: 'bar',
    data: loggedInUsersData,
    options: {
        scales: {
            y: {
                beginAtZero: true,
                stepSize: 1, // Set step size to 1 to ensure only integers are displayed
                precision: 0 
            }
        }
    }
});


    try {
        // Initialize the requests on page load
        console.log('DOM fully loaded, initializing requests...');        
        const noPendingMessage = document.getElementById('no-pending-message');
        const noAcceptedMessage = document.getElementById('no-accepted-message');
        const noDeclinedMessage = document.getElementById('no-declined-message');

        fetchStationRequests();
        console.log('fetchStationRequests() executed successfully.');
    } catch (error) {
        console.error('Error initializing requests:', error);
    }
});
