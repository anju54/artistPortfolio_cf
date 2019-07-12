
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SignIn</title>

    <link rel="stylesheet" type="text/css" href="../bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/local.css" />
    <link rel="stylesheet" type="text/css" href="../css/loader.css"/>


    <script type="text/javascript" src="../js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../bootstrap/js/bootstrap.min.js"></script>

    <link rel="stylesheet" type="text/css" href="../css/error.css" />
    <script type="text/javascript" src="../js/config.js"></script>
    <script type="text/javascript" src="../js/signinValidation.js"></script>
    <script type="text/javascript" src="../js/loader.js"></script>

    <script src="../js/login.js"> </script>

</head>
<body>

      <div id="page-wrapper">
          <div class="row">
              <div class="col-lg-12 text-center v-center">
                  <h1>Sign In</h1>
                  <p class="lead">Enter your email & password to SignIn</p>

                  <!-- <form class="col-lg-12"> -->
                      <div class="input-group" style="width: 340px; text-align: center; margin: 0 auto;">
                          <input class="form-control input-lg" id="email"
                              placeholder="Enter your email address" type="text" id="email" onclick="hideEmail()">
                          <p id="emailError"></p>
                          <input type="password" class="form-control input-lg" id="password"
                              placeholder="Enter your password" type="text" id="password" onclick="hidePassword()">
                           <p id="passwordError"></p>
                          <button class="btn btn-lg btn-primary" id="loginBtn" style="width: 340px"; type="su">SignIn</button>
                      </div>
                  <!-- </form> -->
                    <a href="signup.cfm"> SignUp</a>
                    <p id="error"></p>
              </div>
          </div>
          <br>
          <br>
          <br>
          <!-- <div class="text-center">
              <h1>Follow us</h1>
          </div>
          <div class="row">
              <div class="col-lg-12 text-center v-center" style="font-size: 39pt;">
                  <a href="#"><span class="avatar"><i class="fa fa-google-plus"></i></span></a>
                  <a href="#"><span class="avatar"><i class="fa fa-linkedin"></i></span></a>
                  <a href="#"><span class="avatar"><i class="fa fa-facebook"></i></span></a>
                  <!-- <a href="#"><span class="avatar"><i class="fa fa-github"></i></span></a> -->
              </div>
          </div>
      </div>

</body>
</html>
