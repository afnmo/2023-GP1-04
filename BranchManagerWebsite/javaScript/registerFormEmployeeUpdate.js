// Firebase configuration...
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
const employeeCollectionName = "Station_Employee";

document.addEventListener("DOMContentLoaded", async function () {
    const pleaseWaitMessage = document.getElementById('pleaseWaitMessage');
    const successMessage = document.getElementById('successMessage');
    const errorMessage = document.getElementById('errorMessage');

    // Retrieve query parameters from the URL
    const urlParams = new URLSearchParams(window.location.search);

    // Get values from query parameters
    const firstName = urlParams.get("FirstName");
    const lastName = urlParams.get("LastName");
    const email = urlParams.get("email");
    const phone= urlParams.get("phone");
    const years_experience= urlParams.get("years_experience");
    const employeeId = urlParams.get("employeeId"); // Add this line to get the employeeId

    // Set values to form fields
    document.getElementById("FirstName").value = firstName;
    document.getElementById("LastName").value = lastName;
    document.getElementById("Email").value = email;
    document.getElementById("phone").value = phone;
    document.getElementById("years_experience").value = years_experience;
    document.getElementById("cancel").addEventListener("click", function () {
        // Construct the URL with query parameters for the bill details page
        const url = `myemployee.html`;
    
        // Redirect to the bill details page with query parameters
        window.location.href = url;
    });

    document.getElementById("registrationForm").addEventListener("submit", async function (event) {
        event.preventDefault(); // Prevent the default form submission behavior

        // Reset all error messages
        resetErrorMessages();

        // Validate and get the phone number
        const phoneInput = document.getElementById("phone");
        const phone = phoneInput.value.trim(); // Trim leading and trailing whitespaces

        if (!isValidPhone(phone)) {
            displayErrorMessage('Phone number must have exactly ten digits');
            return;
        }

        // Validate and get the email
        const emailInput = document.getElementById("Email");
        const email = emailInput.value.trim(); // Trim leading and trailing whitespaces

        if (!isValidEmail(email)) {
            displayErrorMessage('Incorrect Email');
            return;
        }

        // Check if the provided email is already in use by another user
        const currentEmail = await getCurrentEmail(employeeId);
        if (currentEmail !== email) {
            const isEmailUsed = await isEmailAlreadyUsed(email, employeeId);
            if (isEmailUsed) {
                displayErrorMessage('Email is already in use');
                return;
            }
        }

        // Display "please wait" message only if there are no error messages
        if (!errorMessage.textContent) {
            pleaseWaitMessage.style.display = 'block';
        }

        // Update the document in the Firestore collection using the employeeId
        const updatedData = {
            firstName: document.getElementById("FirstName").value,
            lastName: document.getElementById("LastName").value,
            email: document.getElementById("Email").value,
            phone: document.getElementById("phone").value,
            years_experience: document.getElementById("years_experience").value,
        };

        const employeeDocRef = doc(db, employeeCollectionName, employeeId);
        updateDoc(employeeDocRef, updatedData)
            .then(() => {
                // Display success message
                successMessage.style.display = 'block';

                // Redirect to myEmployee.html after 1.5 seconds
                setTimeout(() => {
                    window.location.href = "myEmployee.html";
                }, 1500);
            })
            .catch((error) => {
                console.error("Error updating document: ", error);
            })
            .finally(() => {
                // Hide "please wait" message
                pleaseWaitMessage.style.display = 'none';
            });
    });
});




//--------Method For Validation And error massege ---------


const resetErrorMessages = () => {
    // Reset error messages for previous password
    const passwordError1 = document.getElementById("passwordError1");
    resetErrorMessage(passwordError1);

    // Reset error messages for new password
    const passwordError2 = document.getElementById("passwordError2");
    resetErrorMessage(passwordError2);

    // Reset error messages for confirm password
    const passwordError3 = document.getElementById("passwordError3");
    resetErrorMessage(passwordError3);

      // Reset error messages for confirm password
      const EmailError4 = document.getElementById("EmailError4");
      resetErrorMessage(EmailError4);
      // Reset error messages for confirm password
      const EmailError5 = document.getElementById("EmailError5");
      resetErrorMessage(EmailError5);
        // Reset error messages for confirm password
        const phoneError6 = document.getElementById("PhoneError6");
        resetErrorMessage(phoneError6);
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





function isValidEmail(email) {
    // Use a regular expression to validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Function to check if the provided email is already in use by another user
async function isEmailAlreadyUsed(email, currentEmployeeId) {
    // Create a query to check if the email is already used by another user
    const employeeQuery = query(collection(db, employeeCollectionName), where("email", "==", email));

    const querySnapshot = await getDocs(employeeQuery);

    // Check if there are any documents other than the current user with the same email
    return querySnapshot.docs.some(doc => doc.id !== currentEmployeeId);
}

// Function to get the current email of the employee
async function getCurrentEmail(employeeId) {
    const employeeDocRef = doc(db, employeeCollectionName, employeeId);
    const employeeDoc = await getDoc(employeeDocRef);
    return employeeDoc.data().email;
}
    function isValidPhone(phone) {
        // Phone number must contain exactly ten digits
        const phoneRegex = /^\d{10}$/;
        return phoneRegex.test(phone);
    }
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

