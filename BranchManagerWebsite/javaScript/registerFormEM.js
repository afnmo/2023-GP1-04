// Your existing code for Firebase initialization
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, addDoc, collection, query, where, getDocs } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
import { getAuth, createUserWithEmailAndPassword } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-auth.js';



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

// Retrieve stationID
const BMID = sessionStorage.getItem('sessionID');

if (!BMID) {
    window.location.href = "login.html";
}

document.addEventListener('DOMContentLoaded', function () {
     // Reset form fields when the page loads
     resetForm();
    const employeeRegistrationForm = document.getElementById('registrationForm2');
    const errorMessageElement = document.getElementById('errorMessage');
    const successMessageElement = document.getElementById('successMessage');
    const passwordInput = document.getElementById('d');
    const showPasswordCheckbox = document.getElementById('showPassword');

    // Set the initial state of the password input
    passwordInput.type = 'password';
    // Reset form fields when the page loads
    resetForm();

    employeeRegistrationForm.addEventListener('submit', function (event) {
        event.preventDefault(); // Prevent default form submission
        Add();
    });

    async function Add() {
        try {
            const firstName = document.getElementById("FirstName").value;
            const lastName = document.getElementById("LastName").value;
            const email = document.getElementById("l").value;
            const password = document.getElementById("d").value;

            // Validate password
            if (!isValidPassword(password)) {
                errorMessageElement.textContent = "Password must length 8 and contain at least one digit, one special character, one uppercase letter, and one lowercase letter.";
                successMessageElement.style.display = "none";
                return;
            }
            // Validate email format
            if (!isValidEmail(email)) {
                errorMessageElement.textContent = "Please enter a valid email address.";
                successMessageElement.style.display = "none";
                return;
            }
// Hash the password
const hashedPassword = await hashPassword(password);
            // Check if the email is already in use
            if (await isEmailInUse(email)) {
                errorMessageElement.textContent = "Email address is already in use. Please use a different email.";
                successMessageElement.style.display = "none";
                return;
            }
            // Create user in Firebase Authentication
           // const auth = getAuth();
           // const userCredential = await createUserWithEmailAndPassword(auth, email, password);
           // const user = userCredential.user;

            // Add to the "Station_Employee" collection
            const stationRequestRef = await addDoc(collection(db, "Station_Employee"), {
                firstName: firstName,
                lastName: lastName,
                email: email,
                branch_manager_id: BMID, // Store the foreign key//here
                password: hashedPassword,
            });
        

            // Document updated successfully
            errorMessageElement.textContent = ""; // Clear any previous error message
            successMessageElement.style.display = "block";
            document.getElementById("registrationForm2").reset();
            // You may want to add a delay or handle the redirection in a way that fits your application
            setTimeout(() => {
                window.location.href = "my_employee.html";
            }, 2000); // Redirect after 2 seconds
        } catch (error) {
            console.error("An error occurred during form submission:", error);
            errorMessageElement.textContent = "An error occurred. Please try again later.";
            successMessageElement.style.display = "none";
        }
    }

    // Function to toggle password visibility
    const togglePasswordVisibility = () => {
        console.log('Toggle password visibility function called');
        if (showPasswordCheckbox.checked) {
            passwordInput.type = 'text';
        } else {
            passwordInput.type = 'password';
        }
    };

    // Add an event listener to the showPasswordCheckbox
    showPasswordCheckbox.addEventListener('change', togglePasswordVisibility);

    async function isEmailInUse(email) {
        // Query Firestore to check if the email is already in use
        const querySnapshot = await getDocs(query(collection(db, "Station_Employee"), where("email", "==", email)));
        return !querySnapshot.empty;
    }

    function isValidEmail(email) {
        // Use a regular expression to validate email format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
});
    // Function to validate the password
    const isValidPassword = (password) => {
        // Password must contain at least one digit, one special character, one uppercase letter, and one lowercase letter
        const passwordRegex = /^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{8,}$/;
        return passwordRegex.test(password);
    };

    // Function to hash the password
    const hashPassword = async (password) => {
        const encoder = new TextEncoder();
        const data = encoder.encode(password);
        const hashBuffer = await crypto.subtle.digest('SHA-256', data);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        const hashHex = hashArray.map(byte => byte.toString(16).padStart(2, '0')).join('');
        return hashHex.toString();
        // You can store 'hashHex' in your database
    };
    async function resetForm() {
        // Reset all form fields
        document.getElementById('FirstName').value = '';
        document.getElementById('LastName').value = '';
        document.getElementById('l').value = '';
        document.getElementById('d').value = '';
        // Additional fields can be reset similarly
    }