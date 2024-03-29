
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signup</title>
    <link rel="icon" type="image/x-icon" href="../assets/images/icon.jpg">
    <link rel="icon" type="image/x-icon" href="../assets/images/icon.jpg">
    <link rel="stylesheet" type="text/css" href="../bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/local.css" />
    <link rel="stylesheet" type="text/css" href="../css/loader.css"/>

    <script type="text/javascript" src="../js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../bootstrap/js/bootstrap.min.js"></script>
	  <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

    <link rel="stylesheet" type="text/css" href="../css/error.css" />
    <script type="text/javascript" src="../js/config.js"></script>
    <script type="text/javascript" src="../js/validation.js"></script>
    <script type="text/javascript" src="../js/loader.js"></script>

    <script type="text/javascript" src="../js/signup.js"></script>
</head>
<body>
    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12 text-center v-center">
                <p id="msg" style="color: green; font-size: 150%;"></p>
                <h1>Sign Up</h1>
                <p class="lead">Enter your name & email to sign-up</p>
                <br>

                <form class="col-lg-12" id="registrationForm" >

                    <div class="input-group" style="width: 340px; text-align: center; margin: 0 auto;">
                        <!-- <div class="form-group">
                                <label class="userType">Sign up as:</label>
                                <input type="radio" name="userType"  id="student" value="ROLE_ARTIST">ARTIST</input>
                                <input type="radio"  name="userType" id="teacher" value="ROLE_ORGADMIN" >ORGANIZER</input>
                        </div> -->
                        <input class="form-control input-lg" title="Confidential signup."
                            placeholder="Enter your first Name" type="text" id="fname" onclick="hideFnameFunction()">
                        <p id="fnameError"></p>
                        <br>
                        <input class="form-control input-lg" title="Confidential signup."
                            placeholder="Enter your last Name" type="text" id="lname" onclick="hideLnameFunction()">
                        <p id="lnameError"></p>
                        <br>
                        <input class="form-control input-lg" title="Confidential signup."
                          placeholder="Enter your email address" type="text" id="email" onclick="hideEmailFunction()">
                        <p id="emailErrorMsg"></p>
                        <br>
                        <input class="form-control input-lg" title="Confidential signup."
                          placeholder="Enter your password" type="text" id="password" onclick="hidepasswordFunction()">
                           <p id="passwordErrorMsg"></p>
                        <br>
                        <button class="btn btn-lg btn-primary" id="signUp" style="width: 340px"; type="button" >SignUp</button>
                    </div>
					<p id="mainErrMsg">
					</p>
                </form>
                <a href="signin.cfm"> Already have an account.</a>
            </div>
        </div>
        <br>

    </div>

</body>
</html>
