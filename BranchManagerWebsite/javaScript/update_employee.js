import { initializeApp } from "https://www.gstatic.com/firebasejs/10.4.0/firebase-app.js";
import { getFirestore } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
import { doc, getDoc, collection, query, where, getDocs, deleteDoc, setDoc } from 'https://www.gstatic.com/firebasejs/10.4.0/firebase-firestore.js';
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

// Specify the correct name of the collection for employees deleted:
const deletedEmployeeCollectionName = "Station_Employee_Deleted";
const deletedEmployeeCollectionRef = collection(db, deletedEmployeeCollectionName);


// Retrieve branch manager ID
const BMID = sessionStorage.getItem('sessionID');

// Wait for the DOM content to be fully loaded
document.addEventListener("DOMContentLoaded", async () => {
    // Call the fetchEmployeeList function with the necessary parameters
    await fetchEmployeeList(db, employeeCollectionName, BMID);
});

// Function to fetch and display the list of employees
async function fetchEmployeeList(db, employeeCollectionName, BMID) {
    try {
        // Create a reference to the employee collection
        const employeeCollectionRef = collection(db, employeeCollectionName);

        // Query the employees with the specific branch manager ID
        const employeeQuery = query(employeeCollectionRef, where("branch_manager_id", "==", BMID));
        const employeeQuerySnapshot = await getDocs(employeeQuery);

        // Clear existing employee list
        const employeeList = document.getElementById("EmployeeList");
        employeeList.innerHTML = '';
        if (employeeQuerySnapshot.empty) {
            // If the employee list is empty, display a bold statement with a margin
     const emptyListItem = document.createElement("p");
     emptyListItem.textContent = "You Don't Have Any Employee";
     //emptyListItem.style.fontWeight = "bold"; // Make the text bold
     emptyListItem.style.marginRight = "50px"; // Add margin to the top
     emptyListItem.style.marginLeft = "50px"; // Add margin to the top
     emptyListItem.style.marginTop = "100px"; 
     employeeList.appendChild(emptyListItem);
             }else{
        // Populate the employee list
        employeeQuerySnapshot.forEach((employeeDoc) => {
            const employeeData = employeeDoc.data();
            const listItem = document.createElement("li");

            // Create a container for the delete icon and employee name
            const containerDiv = document.createElement("div");
            containerDiv.style.display = "flex";
            containerDiv.style.justifyContent = "space-between"; // Align items to the right

            // Create a span for the employee name
            const employeeNameSpan = document.createElement("span");
            employeeNameSpan.textContent = ` ${employeeData.firstName} ${employeeData.lastName}`;

   

            // Create the delete icon
            const deleteIcon = document.createElement("img");
            deleteIcon.src = "../images/delete.png";
            deleteIcon.alt = "Delete Icon";
            deleteIcon.width = 35;
            deleteIcon.height = 35;
            deleteIcon.style.cursor = "pointer";

            deleteIcon.addEventListener("click", async () => {
                // Display a custom confirmation dialog
                var name=` ${employeeData.firstName} ${employeeData.lastName}`;
                
                showAlert_Critical(`Are you sure you want to delete ${name}?`);
            
                // Add event listener for the Yes, I'm Sure button in your custom alert
                const confirmButton = document.querySelector('#customAlertConfirmButton');
                const cancelButton = document.querySelector('#customAlertCancelButton');
            
                const confirmHandler = async () => {
                    try {
                        // Create a reference to the deleted employee collection
                        const deletedEmployeeDocRef = doc(db, `${deletedEmployeeCollectionName}/${employeeDoc.id}`);
            
                        // Add employee data to the deleted employee collection
                        await setDoc(deletedEmployeeDocRef, {
                            email: employeeData.email,
                            password: employeeData.password,
                            // Add other fields as needed
                        });
            
                        // Delete the employee from the Firestore collection
                        const employeeDocRef = doc(db, `${employeeCollectionName}/${employeeDoc.id}`);
                        await deleteDoc(employeeDocRef);

                                  // Check if there are any remaining employees
            const remainingEmployeesQuerySnapshot = await getDocs(employeeQuery);
            if (remainingEmployeesQuerySnapshot.empty) {
                // If no remaining employees, display the statement
                const employeeList = document.getElementById("EmployeeList");
                employeeList.innerHTML = '';
                const emptyListItem = document.createElement("p");
                emptyListItem.textContent = "You Don't Have Any Employee";
                emptyListItem.style.marginRight = "50px"; // Add margin to the top
                emptyListItem.style.marginLeft = "50px"; // Add margin to the top
                emptyListItem.style.marginTop = "100px";
                employeeList.appendChild(emptyListItem);
            }
            
                        // Remove the corresponding list item from the UI
                        listItem.remove();
            
                        // Remove the custom alert overlay
                        const overlay = document.querySelector('#customAlertOverlay');
                        document.body.removeChild(overlay);
                    } catch (error) {
                        console.error("Error deleting document: ", error);
                    }
            
                    // Remove the event listener to avoid multiple executions
                    confirmButton.removeEventListener('click', confirmHandler);
                    cancelButton.removeEventListener('click', cancelHandler);
                };
            
                const cancelHandler = () => {
                    // Remove the custom alert overlay
                    const overlay = document.querySelector('#customAlertOverlay');
                    document.body.removeChild(overlay);
            
                    // Remove the event listener to avoid multiple executions
                    confirmButton.removeEventListener('click', confirmHandler);
                    cancelButton.removeEventListener('click', cancelHandler);
                };
            
                confirmButton.addEventListener('click', confirmHandler);
                cancelButton.addEventListener('click', cancelHandler);
            });

            // Create the additional icon
            const additionalIcon = document.createElement("img");
            additionalIcon.src = "../images/editIcon.png"; // Replace with the correct path
            additionalIcon.alt = "Additional Icon";
            additionalIcon.width = 20; // Adjust the width and height accordingly
            additionalIcon.height = 20;
            additionalIcon.style.cursor = "pointer";
            additionalIcon.addEventListener("click", () => {
                // Get the employee data
                const employeeFirstName = employeeData.firstName;
                const employeeLastName = employeeData.lastName;
                const employeeEmail = employeeData.email;
                //const employeePassword = employeeData.password; // Assuming password is a property of employeeData
                const employeePhone= employeeData.phone;
                const employeeYearExperines= employeeData.years_experience;
                const employeeId = employeeDoc.id; // Access id directly from employeeDoc
            
                // Log the employeeId to the console for debugging
                console.log("Employee ID:", employeeId);
            
                // Construct the URL with query parameters
                const url = `registerFormEPUpdate.html?FirstName=${employeeFirstName}&LastName=${employeeLastName}&email=${employeeEmail}&phone=${employeePhone}&years_experience=${employeeYearExperines}&employeeId=${employeeId}`;
            
                // Redirect to the registerFormEPUpdate page with query parameters
                window.location.href = url;
            });
            
            
            
             // Create a horizontal line
    const horizontalLine = document.createElement("hr");



            // Create a div to wrap the icons and control their spacing
            const iconsWrapper = document.createElement("div");
            iconsWrapper.style.display = "flex";
            iconsWrapper.style.alignItems = "center";

            // Apply margin to the delete icon
            deleteIcon.style.marginRight = "5px"; // Adjust the value as needed

            // Append the delete icon and additional icon to the wrapper
            iconsWrapper.appendChild(deleteIcon);
            iconsWrapper.appendChild(additionalIcon);

            // Append the icons wrapper and employee name to the container
            containerDiv.appendChild(employeeNameSpan);
            
            containerDiv.appendChild(iconsWrapper);

            // Add the container to the list item
            listItem.appendChild(containerDiv);
            listItem.appendChild(horizontalLine);

            // Add the list item to the employee list
            employeeList.appendChild(listItem);
            
        });};
    } catch (error) {
        console.error("Error accessing Firestore for employees:", error);
    }
}

//alert for critical massage:
function showAlert_Critical(message) {
    var overlay = document.createElement('div');
    overlay.style.position = 'fixed';
    overlay.style.top = '0';
    overlay.style.left = '0';
    overlay.style.width = '100%';
    overlay.style.height = '100%';
    overlay.style.backgroundColor = 'rgba(255, 0, 0, 0.2)'; // Red background color
    overlay.style.display = 'flex';
    overlay.style.alignItems = 'center';
    overlay.style.justifyContent = 'center';
    overlay.style.zIndex = '9999';

    var customAlert = document.createElement('div');
    customAlert.style.backgroundColor = '#fff';
    customAlert.style.padding = '20px';
    customAlert.style.border = '1px solid #ccc';
    customAlert.style.boxShadow = '0 0 10px rgba(0, 0, 0, 0.2)';
    customAlert.style.textAlign = 'center';
    customAlert.style.display = 'flex';
    customAlert.style.flexDirection = 'column'; // Align items in a column

    var header = document.createElement('div');
    header.style.display = 'flex';
    header.style.alignItems = 'center';
    header.style.marginBottom = '10px'; // Spacing between header and message

    var imgElement = document.createElement('img');
    imgElement.src = '../images/logo_no_bkg.png'; // Add your image path here
    imgElement.style.width = '50px';
    imgElement.style.marginRight = '10px'; // Space between image and text

    var headerText = document.createElement('span');
    headerText.textContent = '91 Website'; // Your header text
    headerText.style.color = '#000';

    var messageElement = document.createElement('span');
    messageElement.textContent = message;
    messageElement.style.color = '#000';

    var confirmButton = document.createElement('button');
    confirmButton.textContent = "Yes, I'm Sure";
    confirmButton.style.padding = '3px 8px'; // Adjust button size
    confirmButton.style.cursor = 'pointer';
    confirmButton.style.border = 'none';
    confirmButton.style.backgroundColor = 'rgba(255, 0, 0, 0.8)'; // Red color
    confirmButton.style.color = '#fff';
    confirmButton.style.marginTop = '10px';
    confirmButton.style.marginRight = '5px';

    var cancelButton = document.createElement('button');
    cancelButton.textContent = 'Cancel';
    cancelButton.style.padding = '3px 8px'; // Adjust button size
    cancelButton.style.cursor = 'pointer';
    cancelButton.style.border = 'none';
    cancelButton.style.backgroundColor = '#ccc';
    cancelButton.style.color = '#000';
    cancelButton.style.marginTop = '10px';
    cancelButton.style.marginLeft = '5px';

    confirmButton.id = 'customAlertConfirmButton'; // Add an ID to your confirm button
    cancelButton.id = 'customAlertCancelButton'; // Add an ID to your cancel button
    overlay.id = 'customAlertOverlay'; // Add an ID to your overlay

    confirmButton.addEventListener('click', function () {
        document.body.removeChild(overlay);
        // Place the logic for "Yes, I'm Sure" action here
    });

    cancelButton.addEventListener('click', function () {
        document.body.removeChild(overlay);
        // Place the logic for "Cancel" action here
    });

    header.appendChild(imgElement);
    header.appendChild(headerText);
    customAlert.appendChild(header);
    customAlert.appendChild(messageElement);
    customAlert.appendChild(confirmButton);
    customAlert.appendChild(cancelButton);
    overlay.appendChild(customAlert);
    document.body.appendChild(overlay);


}