// Import necessary Firebase modules
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore, addDoc, collection, query, where, getDocs } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';

// Firebase configuration
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

// Retrieve branch manager ID from session storage
const BMID = sessionStorage.getItem('sessionID');

// Redirect to login page if branch manager ID is not available
if (!BMID) {
    window.location.href = "login.html";
}

document.addEventListener('DOMContentLoaded', function () {
    // Reset form fields when the page loads
    resetForm();

    const employeeRegistrationForm = document.getElementById('registrationForm2');
    const errorMessageElement = document.getElementById('errorMessage');
    const successMessageElement = document.getElementById('successMessage');
    const passwordInput = document.getElementById('password');
    const showPasswordCheckbox = document.getElementById('showPassword');

    // Set the initial state of the password input
    passwordInput.type = 'password';

    employeeRegistrationForm.addEventListener('submit', function (event) {
        event.preventDefault(); // Prevent default form submission
        Add();
    });

    async function Add() {
        try {
            // Extract form data
            const firstName = document.getElementById("FirstName").value;
            const lastName = document.getElementById("LastName").value;
            const email = document.getElementById("email").value;
            const password = document.getElementById("password").value;
            const phone = document.getElementById("phone").value;
            const yearsExperience = document.getElementById("years_experience").value;

            // Validate password
            if (!isValidPassword(password)) {
                displayErrorMessage("Password must have at least 8 characters, one digit, one special character, one uppercase, and one lowercase letter.");
                return;
            }

            // Validate email format
            if (!isValidEmail(email)) {
                displayErrorMessage("Please enter a valid email address.");
                return;
            }

            // Validate phone number
            if (!isValidPhoneNumber(document.getElementById("phone"))) {
                displayErrorMessage("Phone number must contain exactly ten digits.");
                return;
            }

            // Hash the password
            const hashedPassword = await hashPassword(password);

            // Check if the email is already in use
            if (await isEmailInUse(email)) {
                displayErrorMessage("Email address is already in use. Please use a different email.");
                return;
            }

            // Add employee to the Firestore collection
            const stationRequestRef = await addDoc(collection(db, "Station_Employee"), {
                firstName: firstName,
                lastName: lastName,
                email: email,
                branch_manager_id: BMID,
                password: hashedPassword,
                phone: phone,
                years_experience: yearsExperience,
                terminated: false,
            });

            // Display success message and reset form
            displaySuccessMessage();
            resetForm();

            // Redirect after 2 seconds
            setTimeout(() => {
                window.location.href = "myEmployee.html";
            }, 2000);
        } catch (error) {
            console.error("An error occurred during form submission:", error);
            displayErrorMessage("An error occurred. Please try again later.");
        }
    }

    // Function to toggle password visibility
    const togglePasswordVisibility = () => {
        passwordInput.type = showPasswordCheckbox.checked ? 'text' : 'password';
    };

    // Add an event listener to the showPasswordCheckbox
    showPasswordCheckbox.addEventListener('change', togglePasswordVisibility);

    // Other utility functions

    function displayErrorMessage(message) {
        errorMessageElement.textContent = message;
        successMessageElement.style.display = "none";
    }

    function displaySuccessMessage() {
        errorMessageElement.textContent = "";
        successMessageElement.style.display = "block";
    }

    async function isEmailInUse(email) {
        const querySnapshot = await getDocs(query(collection(db, "Station_Employee"), where("email", "==", email)));
        return !querySnapshot.empty;
    }

    function isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    function isValidPhoneNumber(phoneInput) {
        const phoneNumber = phoneInput.value;
        return /^\d{10}$/.test(phoneNumber);
    }

    const isValidPassword = (password) => /^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{8,}$/.test(password);

    const hashPassword = async (password) => {
        const encoder = new TextEncoder();
        const data = encoder.encode(password);
        const hashBuffer = await crypto.subtle.digest('SHA-256', data);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        return hashArray.map(byte => byte.toString(16).padStart(2, '0')).join('');
    };

    function resetForm() {
        // Reset all form fields
        document.getElementById('FirstName').value = '';
        document.getElementById('LastName').value = '';
        document.getElementById('email').value = '';
        document.getElementById('password').value = '';
        document.getElementById('phone').value = '';
        document.getElementById('years_experience').value = '';
    }
});
