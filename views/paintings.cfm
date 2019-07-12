
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paintings</title>

    <link rel="stylesheet" type="text/css" href="../bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/local.css" />
    <link rel="stylesheet" type="text/css" href="../css/loader.css">
    <link rel="stylesheet" type="text/css" href="../css/error.css">


    <script type="text/javascript" src="../js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../bootstrap/js/bootstrap.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>


    <script type="text/javascript" src="../js/config.js"></script>
    <script type="text/javascript" src="../js/showCurretUser.js"></script>
    <script type="text/javascript" src="../js/paintings.js"></script>
    <script type="text/javascript" src="../js/logout.js"></script>
    <script type="text/javascript" src="../js/loader.js"></script>
    <script type="text/javascript" src="../js/jquery.twbsPagination.js"></script>
    <script type="text/javascript" src="../js/jquery.twbsPagination.min.js"></script>
    <!-- <script type="text/javascript" src="../js/Gruntfile.js"></script> -->

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
                <a class="navbar-brand" style="color: royalblue" href="">ArtistPortfolio</a>
            </div>
            <div class="collapse navbar-collapse navbar-ex1-collapse">
                <ul class="nav navbar-nav side-nav">
                    <li><a href="index.cfm"><i class="fa fa-bullseye"></i> Dashboard</a></li>
                    <li class="selected"><a href="profile.cfm"><i class="fa fa-tasks"></i> Profile</a></li>

                </ul>
                <ul class="nav navbar-nav navbar-right navbar-user">

                    <li class="dropdown user-dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-user"></i> <span id="fullName"> </span><b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            <!-- <li><a href="profile.cfm"><i class="fa fa-user"></i> Profile</a></li> -->
                            <!-- <li><a href="#"><i class="fa fa-gear"></i> Settings</a></li> -->
                            <li class="divider"></li>
                            <li><a href="javascript:void(0)" id="logout"><i class="fa fa-power-off"></i> Log Out</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>

        <hr/>

        <div class="container" id="paintingsDiv">
            <div class="row">

                <div>
                    <label for="uploadimage" class="col-md-2">
                        Upload Painting here
                    </label>
                </div>
                <form enctype="multipart/form-data" id="uploadimage" >
                    <div class="col-md-10">
                        <input type="file" name="fileUpload" id="file" onchange="ValidateSingleInput(this);" />
                        <p class="help-block">
                            Allowed formats: jpeg, jpg, png
                        </p>
                    </div>
                </form>
                <div class="col-sm-2">
                        <button class="btn btn-success" id="saveImage">Upload</button>
                </div>
                <div class="col-sm-10">
                    <p id="imageUploadError"></p>
                </div>
                <div class="text-center col-md-8">
                    <h1>ALBUMS</h1>
                </div>
            </div>
        </div>
        <div id="wrapper" class="container">
                <div id="imgDiv">
                    <!-- <div class='row'></div> -->
                </div>
                <!-- <button id="loadMore" type="button"
                class="btn btn-warning btn-lg center-block"style="display:none; ">Load More</button> -->
                <ul id="pagination-demo" class="pagination-sm flex-wrap mt-50 mb-70 justify-content-center"></ul>
        </div>
        <div class="container" style="display: none" id="msgDiv">
            <div class="row">
                <div class="col-md-12">
                    <p style="color: red"> 
                        Please create artist account then proceed with uploading painting.
                    </p>
                </div>
            </div>

        </div>

        <ul id="pagination-demo" class="pagination-sm  justify-content-center"></ul>
    </div>

</body>
</html>
