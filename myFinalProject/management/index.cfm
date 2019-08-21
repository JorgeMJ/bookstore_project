<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Management</title>
    <link href="../../includes/css/mycss.css" rel="stylesheet" />
    <link href="../../includes/bootstrap/css/bootstrap.css" rel="stylesheet" />
    <script src="/jmart82733/includes/ckeditor/ckeditor.js" type="text/javascript"></script>

    <!--- JS code to handle a non admin user trying to get access to the management section --->
    <script>
        /* Setting the beginning time */
        let timeLeft = 10;

        /* Calls changeCountdown every second */
        function startCountdown(){
            setInterval(changeCountdown, 1000);
        }

        /* Puts the remaining time in the appropriate html tag. Calls the rejectNoAdmin function when timeleft is '0' */
        function changeCountdown() {
            document.getElementById("rejectNoAdminMessage").innerHTML = "<strong>" + timeLeft.toString() + "</strong>";
            if(timeLeft === 0 ){
                rejectNoAdmin();
            }
            timeLeft = timeLeft - 1;
        }

        /* Redirects the user to the main page of the site ./index.cfm */
        function rejectNoAdmin(){
            window.location.href= "../";
        }
    </script>
</head>

    <!--- Sets the 'tool' as addedit by default. What shows by default is the 'addeddit' module --->
    <cfparam name='tool' default='addedit'>

    <!--- If hte user is not logged in as an administrator, it is sent to the website index --->
    <cfif not session.user.isadmin >
        <h4 style="margin-top: 15%; text-align: center">Your are not an administrator user.</h4>
        <h4 style="text-align: center">You will be redirected to the main page in
        <span id="rejectNoAdminMessage"></span>
            seconds.</h4>

        <script>startCountdown()</script>
        <!--- Prevents the rest of the site to be read and displayed --->
        <cfabort>
    </cfif>

<!--- Structure of the management page --->
<body>
    <div id="wrapper" class="container">
        <div id="topHeader" class="row">
            <cfinclude template="../header.cfm" />
        </div>

        <div class="container">
            <cfinclude template= 'managementnavbar.cfm'>
            <cfinclude template= '#tool#.cfm'>
        </div>

        <div id="footer" class="row">
            <cfinclude template="../footer.cfm" />
        </div>
    </div>
</body>
</html>