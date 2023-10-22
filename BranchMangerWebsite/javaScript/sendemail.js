function sendOTP() {
    const email = document.getElementById('email');
    const otpverify = document.getElementsByClassName('otpverify')[0];

    // Check if an OTP has already been sent to this email
    const hasOTPSent = sessionStorage.getItem(email.value);

    if (hasOTPSent) {
        alert("OTP has already been sent to this email.");
        return; // Exit the function
    }

    let otp_val = Math.floor(Math.random() * 10000);

    let emailbody = `
        <h1>Please Subscribe to 91 </h1> <br>
        <h2>Your OTP is </h2>${otp_val}
    `;

    Email.send({
        SecureToken: "57e69e22-01b8-44cf-9b23-f0672c96a21a",
        To: email.value,
        From: "Shaaahd1441@gmail.com",
        Subject: "This is from 91, Please Subscribe",
        Body: emailbody
    }).then(message => {
        if (message === "OK") {
            // Mark this email as having received an OTP
            sessionStorage.setItem(email.value, "sent");

            alert("OTP sent to your email " + email.value);
            otpverify.style.display = "block";
            const otp_inp = document.getElementById('otp_inp');
            const otp_btn = document.getElementById('otp_btn');

            otp_btn.addEventListener('click', () => {
                if (otp_inp.value == otp_val) {
                    alert("Email address verified...");
                } else {
                    alert("Invalid OTP");
                }
            });
        }
    });
}
























































// //OTP code

// function sendOTP() {
//     const email = document.getElementById('email');
//     const otpverify = document.getElementsByClassName('otpverify')[0];
//     let otp_val = Math.floor(Math.random() * 10000);

//     let emailbody = `
//         <h1>Please Subscribe to 91 </h1> <br>
//         <h2>Your OTP is </h2>${otp_val}
//     `;

  

//     Email.send({
//         SecureToken: "57e69e22-01b8-44cf-9b23-f0672c96a21a",
//         To: email.value,
//         From: "Shaaahd1441@gmail.com",
//         Subject: "This is the from 91, Please Subscribe",
//         Body: emailbody
//     }).then(
//         //if success it returns "OK";
//         message => {
//             if (message === "OK") {
//                 alert("OTP sent to your email " + email.value);
//                 // now making otp input visible
//                 otpverify.style.display = "block";
//                 const otp_inp = document.getElementById('otp_inp');
//                 const otp_btn = document.getElementById('otp_btn');

//                 otp_btn.addEventListener('click', () => {
//                     // now check whether sent email is valid
//                     if (otp_inp.value == otp_val) {
//                         alert("Email address verified...");
                        
//                     }
//                     else {
//                         alert("Invalid OTP");
//                     }
//                 })
//             }
//         }
//     ).then(
//         message => {
//         if (message === "OK") {
//             alert("You can log in ")
//             login_btn.style.display = "block";

//         }} );

// }
