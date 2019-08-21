
<!--- The wrapper for the navigation bar --->
<nav class="navbar navbar-default">

    <!--- THe inner wrapper which is needed according to bootstrap --->
    <div class="container-fluid">
        <!--- The first section of the bar --->
        <div class="navbar-header">

            <!--- The menu toggle which only appears on small screens --->
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#readDeseNav">
                <!--- The sr-only class indicates that it is only seen by screen readers and therefore read outloud to identify what this is --->
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>

            <!--- RDB Graphic: Link to main page (index.cfm) --->
            <a class="navbar-brand" href="../index.cfm">
                <img src="/CodeBase/includes/classimages/rdb.png"/>
            </a>
        </div>

        <!--- The Main buttons of the Nav Bar. These collapse when the screen size is small --->
        <div class="collapse navbar-collapse" id="readDeseNav">
            <ul class="nav navbar-nav">
                <cfoutput>
                    <li class="active"><a href="#cgi.script_name#?tool=addedit">Add/Edit</a></li>
                    <li><a href="#cgi.script_name#?tool=createuuids">Create UUIDs</a></li>
                    <li><a href="#cgi.script_name#?tool=content">Content</a></li>
                </cfoutput>

                <!--- The search box takes to the ./index.cfm (not the management/index.cfm) showing the result of the search --->
                 <li>
                     <cfoutput>
                        <form action="../index.cfm?p=details" class="navbar-form navbar-left" role="search" method="post" >
                            <div class="form-group">
                                <input type="text" name="searchme" class="form-control" placeholder="Search">
                            </div>
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                     </cfoutput>
                </li>
            </ul>

            <!--- Session loggedin: if true, sets the session as login, else as logoff  --->
            <ul class="nav navbar-nav navbar-right">
            <cfoutput>
                <cfif session.isloggedin>
                        <li><a>Welcome #session.user.firstname#</a></li>
                        <!--- If the user is also Administrator allow access to "Management" --->
                        <li><a href="../index.cfm?p=logoff ">Logout</a></li>
                </cfif>
            </cfoutput>
            </ul>
        </div>
    </div>
</nav>
