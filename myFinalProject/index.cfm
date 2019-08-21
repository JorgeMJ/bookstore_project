<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Untitled Document</title>
    <link href="../includes/bootstrap/css/bootstrap.css" rel="stylesheet" />
    <link href="../includes/css/mycss.css" rel="stylesheet" />
    <script src="../includes/js/jQuery/jquery-1.11.3.min.js" type="text/javascript"></script>
    <script src="../includes/bootstrap/js/bootstrap.js" type="text/javascript"></script>
</head>

<!--- By default the index.cfm page shows the carousel in main content section--->
<cfparam name="p" default="carousel" />
<!--- Sets the stateinfo first thing on the page to avoid potential issues in other sections, such missmatched loggin info --->
<cfinclude template="stateinfo.cfm" />


<!--- Structure of the page --->
<body>
    <div id="wrapper" class="container">
        <div id="topHeader" class="row">
            <cfinclude template="header.cfm" />
        </div>
        <div id="horizontalnav" class="row">
           <cfinclude template="horizontalnav.cfm" />
        </div>
        <div id="maincontent" class="row">
            <div id="center" class="col-sm-7 col-lg-7 col-md-7 col-sm-push-3">
                <cfinclude template="#p#.cfm" />
            </div>
            <div id="leftgutter" class="col-sm-3 col-lg-3 col-md-3 col-sm-pull-7">
                <cfinclude template="genrenav.cfm" />
            </div>
            <div id="rightside" class="col-sm-2 col-lg-2"></div>
        </div>
        <div id="footer" class="row">
            <cfinclude template="footer.cfm" />
        </div>
    </div>
</body>
</html>

