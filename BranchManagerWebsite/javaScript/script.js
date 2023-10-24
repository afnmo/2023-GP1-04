function youcanlogin() {
    alert("You can log in ");
    console.log("YES");
  }
  
  function navigateToLogin() {
    // // const otpver = document.getElementsByClassName("otpverify")[0];
    // const createPasswordBtn = document.getElementsByClassName("password")[0];
    // const passwordInput = document.getElementsByClassName("password-input")[0];
    // const login_btn = document.getElementsByClassName("login_btn")[0];
    // // otpver.style.display = "none";
    // createPasswordBtn.style.display = "none";
    // passwordInput.style.display = "block";
    // login_btn.style.display = "block";
    window.location.href = "login.html";
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
  
  //////////////////////////////////
  