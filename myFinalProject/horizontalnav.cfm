<!--- Default value for variable contentid --->
<cfparam name="contentid" default="">


<!--- Horizontal NavBar --->
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#readDeseNav">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="index.cfm">
                <img src="/../includes/classimages/rdb.png"/>
            </a>
        </div>
        <div class="collapse navbar-collapse" id="readDeseNav">
            <ul class="nav navbar-nav">
                <cfoutput>
                    <li class="active"><a href="index.cfm">Home</a></li>
                    <li><a href="#cgi.script_name#?p=content&contentid=709496AD-F8CE-6BAC-69D802ED5A897252" >Store Information</a></li>
                    <li><a href="#cgi.script_name#?p=content&contentid=6FC51FB9-F49F-FF02-B7B073F8262126B1" >Highlighted Favorites</a></li>
                    <li><a href="#cgi.script_name#?p=content&contentid=70846395-F17F-AD63-1B0E24064FD5E8BC" >Events</a></li>
                    <li>
                        <form action="#cgi.SCRIPT_NAME#?p=details" method="post" class="navbar-form navbar-left" role="search" >
                            <div class="form-group">
                                <input type="text" name="searchme" class="form-control" placeholder="Search"  >
                            </div>
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                    </li>
                </cfoutput>

            </ul>

            <!--- Session loggedin: if true, sets the session as login, else as logoff  --->
            <ul class="nav navbar-nav navbar-right">
                <cfoutput>
                    <cfif session.isloggedin>
                        <li><a>Welcome #session.user.firstname#</a></li>

                        <!--- If the user is also Administrator allow access to "Management" --->
                        <cfif session.user.isadmin>
                                <li><a href="management">Management</a></li>
                        </cfif>

                        <li><a href="#cgi.SCRIPT_NAME#?p=logoff ">Logout</a></li>
                    <cfelse>
                        <li><a href="#cgi.script_name#?p=login">Login</a></li>
                    </cfif>
                </cfoutput>
            </ul>
        </div>
    </div>
</nav>