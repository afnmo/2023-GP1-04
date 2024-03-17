// Import Firebase modules
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, doc, updateDoc, query, where, getDoc, getDocs, collection } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

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

// Specify the correct name of the collection for employees
const billCollectionName = "Bills";

// Retrieve branch manager ID from session storage
const BMID = sessionStorage.getItem('sessionID');

document.addEventListener("DOMContentLoaded", async function () {

    // Retrieve query parameters from the URL
    const urlParams = new URLSearchParams(window.location.search);

    // Get values from query parameters
    const carId = urlParams.get("car_id");
    const amount= urlParams.get("amount");
    const date= urlParams.get("date");
    const employeeName = urlParams.get("employeename");
    const fuelType = urlParams.get("fuel_type");
    const billId = urlParams.get("billId"); 
    const day = urlParams.get("day");
    const month = urlParams.get("month");
    const year = urlParams.get("year");

    const spaceIndex = employeeName.indexOf(' ');
    const firstName = employeeName.substring(0, spaceIndex);
    // Extract the last name from employeeName after the first space
    const lastName = employeeName.substring(spaceIndex + 1) ;
    
    // Set values to form fields
    document.getElementById("employeeName").value = employeeName;
    document.getElementById("carId").value = carId;
    document.getElementById("fuelType").value = fuelType;
    document.getElementById("amount").value = amount;
    document.getElementById("date").value = `${year}-${month}-${day}`;

console.log(`${year}-${month}-${day}`);


document.getElementById("registrationForm").addEventListener("submit", async function (event) {
    event.preventDefault(); // Prevent the default form submission behavior
    
    // Display wait message
    displayPleaseWaitMessage();
    
    // Reset all error messages
    resetErrorMessages();
    
    // Retrieve employee name from the form
    const employeeNameInput = document.getElementById("employeeName");
    const employeeName = employeeNameInput.value.trim(); // Trim whitespace
    
    // Check if employee name is empty
    if (employeeName === '') {
        // Display error message for empty employee name
        const nameError6 = document.getElementById("nameError6");
        if (nameError6) {
            nameError6.innerText = "Employee name cannot be empty";
            nameError6.style.color = "red";
            nameError6.style.fontSize = "12px";
        }
        
        // Hide wait message when displaying an error
        hidePleaseWaitMessage();
        return;
    }

    // Extract the first name and last name from the employee name
    const spaceIndex = employeeName.indexOf(' ');
    const firstName = employeeName.substring(0, spaceIndex);
    const lastName = employeeName.substring(spaceIndex + 1);
    
    // Check if employeeName exists in Station_Employee collection with branch_manager_id matching the branch ID
    const employeeRef = collection(db, "Station_Employee");
    const querySnapshot = await getDocs(query(employeeRef, where("branch_manager_id", "==", BMID), where("firstName", "==", firstName), where("lastName", "==", lastName)));

    if (querySnapshot.empty) {
        // Employee name doesn't exist in Station_Employee collection with the specified branch_manager_id
        const nameError6 = document.getElementById("nameError6");
        if (nameError6) {
            nameError6.innerText = "Employee Name not include in your station employee";
            nameError6.style.color = "red";
            nameError6.style.fontSize = "12px";
        }
        
        // Hide wait message when displaying an error
        hidePleaseWaitMessage();
        return;
    }
   // Retrieve the updated date value
   const updatedDateInput = document.getElementById("date");
   const updatedDateValue = updatedDateInput.value;
   
   // Extract day, month, and year from the updated date value
   const updatedDay = updatedDateValue.substring(8, 10); // Day part
   const updatedMonth = updatedDateValue.substring(5, 7); // Month part
   const updatedYear = updatedDateValue.substring(0, 4); // Year part
    // Update the document in the Firestore collection
    const billDocRef = doc(db, billCollectionName, billId);
    const updatedData = {
        employeeName: employeeName,
        carId: document.getElementById("carId").value,
        fuelType: document.getElementById("fuelType").value,
        amount: document.getElementById("amount").value,
        date:  updatedDateValue,
        day:updatedDay,
        month:updatedMonth,
        year:updatedYear,
    };

    // Use updateDoc from Firestore SDK to update the document
    updateDoc(billDocRef, updatedData)
    .then(() => {
        // Hide wait message
        hidePleaseWaitMessage();
        // Display success message at the end of the form
        const successMessage = document.getElementById("successMessage");
        if (successMessage) {
            successMessage.style.display = "block";
            // Wait for 1.5 seconds
            setTimeout(() => {
                 // Construct the URL with query parameters for the update page
        const url = `billdetails.html?car_id=${updatedData.carId}&date=${updatedData.date}&amount=${updatedData.amount}&employeename=${updatedData.employeeName}&fuel_type=${updatedData.fuelType}&billId=${billId}`;

        // Redirect to the bill update page with query parameters
        window.location.href = url;
            }, 1500);
        }
    })
    .catch((error) => {
        hidePleaseWaitMessage();
        console.error("Error updating document: ", error);
    });
});

});

// Method For Validation And error message
const resetErrorMessages = () => {
    const nameError6 = document.getElementById("nameError6");
    resetErrorMessage(nameError6);
    const fuelError6 = document.getElementById("fuelError6");
    resetErrorMessage(fuelError6);
};

const resetErrorMessage = (element) => {
    if (element) {
        element.innerText = '';
        element.style.color = '';
        element.style.fontSize = '';
        // Reset the parent element's classes
        const inputControl = element.parentElement;
        if (inputControl) {
            inputControl.classList.remove('error');
            inputControl.classList.remove('success');
        }
    }
};

const displayPleaseWaitMessage = () => {
    const pleaseWaitMessage = document.getElementById("pleaseWaitMessage");
    if (pleaseWaitMessage) {
        pleaseWaitMessage.style.display = "block";
        pleaseWaitMessage.innerText = 'Please wait, checking input...';
    }
};

const hidePleaseWaitMessage = () => {
    const pleaseWaitMessage = document.getElementById("pleaseWaitMessage");
    if (pleaseWaitMessage) {
        pleaseWaitMessage.style.display = "none";
        pleaseWaitMessage.innerText = '';
    }
};
const setSuccess = element => {
    const inputControl = element.parentElement;
    if (inputControl) {
        const errorDisplay = inputControl.querySelector('.error');
        if (errorDisplay) {
            errorDisplay.innerText = '';
            errorDisplay.style.color = '';  // Reset color
            errorDisplay.style.fontSize = '';  // Reset font size
            inputControl.classList.add('success');
            inputControl.classList.remove('error');
        }
    }
};
