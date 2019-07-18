<cfif NOT StructKeyExists(session,"stLoggedInuser")>
         	<cflocation url="signin.cfm">
<cfelse>

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>

    <link rel="stylesheet" type="text/css" href="../bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/local.css" />
    <link rel="stylesheet" type="text/css" href="../css/dropdownPaintingType.css" />
    <link rel="stylesheet" type="text/css" href="../css/error.css" />

    <link rel="stylesheet" type="text/css" href="../css/loader.css" />

    <script type="text/javascript" src="../js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/config.js"></script>

    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>
<body>

    <div id="wrapper">
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <p class="navbar-brand" style="color: royalblue">ArtistPortfolio</p>

            </div>
            <div class="collapse navbar-collapse navbar-ex1-collapse">
                <ul class="nav navbar-nav side-nav">
                    <li><a href="index.cfm"><i class="fa fa-bullseye"></i> Dashboard</a></li>
                    <!-- <li><a href="portfolio.cfm"><i class="fa fa-tasks"></i> Portfolio</a></li> -->
                    <li id="myPaintingNav"><a href="paintings.cfm" id="paintingHref"><i class="fa fa-list-ol"></i>My Paintings</a></li>
                    <!-- <li><a href="register.cfm"><i class="fa fa-font"></i> Register</a></li> -->
                </ul>
                <ul class="nav navbar-nav navbar-right navbar-user">
                    <li class="dropdown messages-dropdown">
                      <div class="col-md-7 col-4 align-self-center">
                          <a href="" class="btn waves-effect waves-light btn-success pull-right hidden-sm-down"
                           onclick="redirectArtistPublicProfile()" id="previewProfile">
                              Preview profile</a>
                      </div>

                      <ul class="dropdown-menu">
                            <li class="dropdown-header">2 New Messages</li>
                            <li class="message-preview">
                                <a href="#">
                                    <span class="avatar"><i class="fa fa-bell"></i></span>
                                    <span class="message">Security alert</span>
                                </a>
                            </li>
                            <li class="divider"></li>
                            <li class="message-preview">
                                <a href="#">
                                    <span class="avatar"><i class="fa fa-bell"></i></span>
                                    <span class="message">Security alert</span>
                                </a>
                            </li>
                            <li class="divider"></li>
                            <li><a href="#">Go to Inbox <span class="badge">2</span></a></li>
                        </ul>
                    </li>
                     <li class="dropdown user-dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-user"></i><span id="fullName"> </span><b class="caret"></b>
                        </a>
                        <ul class="dropdown-menu">
                            <!-- <li><a href="#"><i class="fa fa-user"></i> Profile</a></li>
                            <li><a href="#"><i class="fa fa-gear"></i> Settings</a></li> -->
                            <li class="divider"></li>
                            <li><a href="" id="logout"><i class="fa fa-power-off"></i> Log Out</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>
        <div class="row">
            <!-- Column -->
            <div class="col-lg-4 col-xlg-3 col-md-5">
                <div class="card">
                    <div class="card-block mainContainer">
                        <center class="m-t-30">
                            <div class="mainContainer">
                                <div id="profilePicDiv"  class="profile-img-container">
                                    <img src="../assets/images/default-profile-pic.png" height="200px" width="200px" class="img-circle" width="160" id="profileImage"
                                        alt="upload image here"/>
                                    <div class="profile-img-i-container middle">
                                        <button type="submit" class="commentButton" id="myBtn" >
                                            <i class="fa fa-edit" style="font-size:24px;color:green"></i>
                                        <br>
                                        <button type="submit" class="likeButton" id="deleteImage">
                                            <i class="fa fa-remove" style="font-size:24px;color:red"></i></i></button>
                                    </div>
                                </div>
                            </div>
                            <h4 class="card-title m-t-10" id="name"></h4>
                            <div id="paintingType">
                                <!-- <h6 class="card-subtitle" >Oil painting</h6> -->
                            </div>

                            <!-- The Modal -->
                            <div id="profilePicModal" class="modal" >

                                <!-- Modal content -->
                                <div class="modal-content">
                                    <span class="close">&times;</span>
                                    <p>Upload Your profile picture here</p>

                                    <div class="container">
                                        <div class="row">
                                            <div class="col-md-5">
                                                <form enctype="multipart/form-data" id="uploadimage" name="profilePicForm">
                                                    <div class="col-md-10">
                                                        <input type="file" name="fileUpload" id="file"  onchange="hideProfileErr()"/>
                                                        <input type="hidden" name="imageName" id="imageName" />
                                                        <p class="help-block">
                                                            Allowed formats: jpeg, jpg, png
                                                        </p>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="col-md-2">
                                                <button class="btn" id="editUpdateBtn" style="background-color: #00ff90b5;color: black;">
                                                    Upload Image
                                                </button>
                                            </div>
                                             <div class="col-sm-12">
                                                <p id="profilePicShowError"></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                        </center>
                    </div>
                </div>
            </div>

            <!-- Column -->
            <div class="col-lg-8 col-xlg-9 col-md-7" id="formInput">
                <div class="card">
                    <div class="card-block">
                        <div class="form-horizontal form-material">

                          <label for="example-email" class="col-md-12">Email</label>
                          <div class="col-md-12">
                              <p name="example-email" id="email" style="color:blue"></p>
                          </div>
                          <div id="pName" style='display:none;'>
                                <label for="profile-name" class="col-md-12">Profile-Name</label>
                                <div class="col-md-12">
                                    <p name="profileName" id="profileN" style="color:blue"></p>
                                </div>
                          </div>
                          
                          <br>
                            <label class="col-md-12">First Name*</label>
                            <div class="col-md-12">
                                <input type="text" id="firstName" name = "firstName" class="form-control form-control-line">
                                <p id="fnameError"></p>
                            </div>

                            <label class="col-md-12">Last Name</label>
                            <div class="col-md-12">
                                <input type="text" id="lastName" name="lastName"  class="form-control form-control-line">
                            </div>

                            <label class="col-md-12">Profile Name*</label>
                            <div class="col-md-12">
                                <input type="text" id="profileName"  onclick="hideError()"
                                class="form-control form-control-line">
                                <p id="profilenameerror"></p>
                            </div>

                            <label class="col-md-12">Facebook url</label>
                            <div class="col-md-12">
                                <input type="text" id="fbUrl" name="facebookUrl" class="form-control form-control-line" onclick="hidefberror()">
                                <p id="fberror"></p>
                            </div>
                            <br>
                            <label class="col-md-12">Twitter url</label>
                            <div class="col-md-12">
                                <input type="text" id="twitterUrl" name="twitterUrl" class="form-control form-control-line" onclick="hideterror()">
                                <p id="terror"></p>
                            </div>
                            <br>
                            <label class="col-md-12">LinkedIn url</label>
                            <div class="col-md-12">
                                <input type="text" id="linkedInUrl" name="linkedInUrl" class="form-control form-control-line" onclick="hideLError()">
                                <p id="lerror"></p>
                            </div>

                            <label class="col-md-12">Background colour*</label>
                            <div class="col-md-12">
                                <select type="text" id="bgcol" name="colorName" class="form-control form-control-line" onclick="hidecolorerror()">
                                    <option>Select</option>
                                    <!-- <option>red</option>
                                    <option>yellow</option> -->
                                </select>
                                <p id="colorerror"></p>
                            </div>

                            <br>
                            <label class="col-md-12">Type of painting</label>
                            <div class="col-md-12">

                                <form>
                                    <div class="multiselect">
                                        <div class="selectBox" onclick="showCheckboxes()">
                                            <select class="form-control form-control-line">
                                                <option id="optionPaintingType">Select an option</option>
                                            </select>
                                            <div class="overSelect"></div>
                                        </div>
                                        <div id="checkboxes" style='max-height: 150px; overflow-y: auto'>
                                            <!--<label for="one">-->
                                                <!--<input type="checkbox" id="one" />First checkbox</label>-->
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <label class="col-md-12">About Me</label>
                            <div class="col-md-12">
                                <textarea rows="5" id="aboutMe" placeholder="max 255 chars" onclick="hideMainError()"
                                class="form-control form-control-line"></textarea>
                                <p id="aboutmeerr"></p>
                            </div>

                            <!-- <div class="col-sm-4">
                                <button class="btn btn-success" id="save">Save Profile</button>
                            </div> -->
                            <div class="col-sm-8">
                                <p id="msg"></p>
                            </div>
                            <div class="col-sm-4">
                                    <button class="btn btn-success" id="update" style="float: right;">Update Profile</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <script type="text/javascript" src="../js/showCurretUser.js"></script>
    <script type="text/javascript" src="../js/artistProfile.js"></script>
    <script type="text/javascript" src="../js/displayColors.js"></script>
    <script type="text/javascript" src="../js/displayTypeOfPainting.js"></script>
    <script type="text/javascript" src="../js/logout.js"></script>
    <script type="text/javascript" src="../js/loader.js"></script>

    <script>
            // Get the modal
            var modal = document.getElementById("profilePicModal");

            // Get the button that opens the modal
            var btn = document.getElementById("myBtn");

            // Get the <span> element that closes the modal
            var span = document.getElementsByClassName("close")[0];

            // When the user clicks the button, open the modal
            btn.onclick = function() {
              modal.style.display = "block";
            }

            // When the user clicks on <span> (x), close the modal
            span.onclick = function() {
              modal.style.display = "none";
            }

            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function(event) {
              if (event.target == modal) {
                modal.style.display = "none";
              }
            }
            </script>

</body>
</html>
</cfif>