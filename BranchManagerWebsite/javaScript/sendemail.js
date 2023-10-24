function sendOTP() {
    const email = document.getElementById("email");
    const otpverify = document.getElementsByClassName("otpverify")[0];
    const passwordBtn = document.getElementById("pass1");
    const send_otp = document.getElementById("send_otp");
  
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
      Body: emailbody,
    }).then((message) => {
      if (message === "OK") {
        sessionStorage.setItem(email.value, "sent");
        localStorage.setItem("email_login", email.value);
  
        alert("OTP sent to your email " + email.value);
        otpverify.style.display = "block";
        const otp_inp = document.getElementById("otp_inp");
        const otp_btn = document.getElementById("otp_btn");
  
        otp_btn.addEventListener("click", () => {
          if (otp_inp.value == otp_val) {
            alert("Email address verified...");
            passwordBtn.style.display = "block";
            otpverify.style.display = "none";
            send_otp.style.display = "none";
          } else {
            alert("Invalid OTP");
          }
        });
      }
    });
  }
  
  /////////////////////////////////////////////////////////////////////////////////
  
  function youcanlogin() {
    alert("You can log in ");
    console.log("YES");
  }
  
  function navigateToLogin() {
    window.location.href = "loginafterpassword.html";
  }
  
  function checkPassword() {
    let password = document.getElementById("password").value;
  
    let cnfrmPassword = document.getElementById("cnfrm-password").value;
    const submitbtn = document.getElementsByClassName("login")[0];
  
    console.log(" Password:", password, "\n", "Confirm Password:", cnfrmPassword);
    let message = document.getElementById("message");
    console.log("dfsdfsdf");
  
    if (password.length != 0) {
      if (password == cnfrmPassword) {
        message.textContent = "Passwords match";
        message.style.backgroundColor = "#1dcd59";
        alert("you are created password!");
        submitbtn.style.display = "block";
        localStorage.setItem("login_password", password);
        console.log(localStorage.getItem("login_password"));
        youcanlogin();
      } else {
        message.textContent = "Password don't match";
        message.style.backgroundColor = "#ff4d4d";
      }
    } else {
      alert("Password can't be empty!");
      message.textContent = "";
    }
  }
  
  const storedPassword = localStorage.getItem("login_password");
  
  // Select the password input field by its ID
  const passwordInput = document.getElementById("pass");
  
  // Set the value from local storage, if available
  if (
    storedPassword &&
    window.location.pathname.endsWith("loginafterpassword.html")
  ) {
    passwordInput.value = storedPassword;
  }
  
  const storedEmail = localStorage.getItem("email_login");
  if (
    storedEmail &&
    window.location.pathname.endsWith("loginafterpassword.html")
  ) {
    email.value = storedEmail;
  }
  