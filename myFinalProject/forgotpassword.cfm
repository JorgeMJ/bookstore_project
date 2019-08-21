<!--- formToShow holds a value determining what form will show --->
<cfparam name="formToShow" default="authenticationForm" />
<!--- Displays, if any, messages concerning both the authentication and newpassword forms --->
<cfparam name="authenticationMessage" default="" />
<cfparam name="personid" default="" />


<!--- Sets the value of formToShow as processForms to choose what form will be displayed--->
<cfset formToShow=processForms()>

<!--- JS code: Function validateNewPassword}() checks if newpassword and newpasswordconfirm are alike --->
<script  type="text/javascript">
    function validateNewPassword() {
        var newPassword=document.getElementById('newPassword').value;
        var confirmNewPassword=document.getElementById('confirmNewPassword').value;

        if(newPassword === confirmNewPassword && newPassword !== '' && confirmNewPassword !== ''){
            document.getElementById('submitNewPasswordForm').click();
            document.getElementById('newPasswordMessage').innerHTML="";
        }
        else{
            document.getElementById('newPasswordMessage').innerHTML="The two passwords do not match";
        }
    }
</script>

<!--- This section outputs what will be seen in the page --->
<cfoutput>
    <!--- Show any message concerning the authnetication process --->
    <div id="authenticationMessage">#authenticationMessage#</div>

    <!--- Determines what form will appear on screen (authentication form or change password form) depending on its value --->
    <cfif formToShow eq "authenticationForm">
        #authenticationForm()#
    <cfelse>
        #changePasswordForm()#
    </cfif>
</cfoutput>


<!--- Function processForms: --->
<cffunction name="processForms">

    <!--- If the parameter 'lastname' is defined in 'authenticationForm', it will query the DB looking for matching
     records with the form parameters--->
    <cfif isdefined('form.lastname')>

        <cfquery name="recoverpassw" datasource="#application.dsource#">
            select * from people where lastname='#form.lastname#' and email='#form.email#'
        </cfquery>

        <!--- If the result from the query 'recoverpassw' is different from '0' sets formToshow variable as 'changePasswordFrom' --->
        <cfif recoverpassw.recordcount neq 0 >
            <cfset personid=#recoverpassw.personid[1]#>

            <cfreturn "changePasswordFrom">

        <!--- If the result of the query is '0', it shows a message --->
        <cfelse>
            <cfset authenticationMessage = "There is no account matching that information." />
        </cfif>
    </cfif>

    <!--- If the newpassword variable is define in the 'changePasswordForm' it queries the DB to update it with the new password --->
    <cfif isdefined('form.newpassword')>
        <cfquery name="updatepassword" datasource="#application.dsource#">
            update passwords
            set password='#hash(form.newpassword,"SHA-256")#'
            where personid='#personid#'
        </cfquery>
        <!--- After changing the password, send the user to the login page as a courtesy --->
        <cflocation url="index.cfm?p=login" />
    </cfif>

    <!--- By default, show the authentication form --->
    <cfreturn "authenticationForm">

</cffunction>



<!--- Function authenticationForm: Shows the authentication form --->
<cffunction name="authenticationForm">
    <cfoutput>
        <form action="#cgi.script_name#?p=forgotpassword" class="form-horizontal" method="post">

            <legend>Authentication</legend>

            <!--- Authentication: Last Name--->
            <div class="form-group">
                <label class="col-lg-3 control-label">Last Name*</label>
                <div class="col-lg-9">
                    <input type="text" class="form-control" name="lastname" required/>
                </div>
            </div>

            <!--- Authentication: Email address--->
            <div class="form-group">
                <label class="col-lg-3 control-label">Email Address*</label>
                <div class="col-lg-9">
                    <input type="email" class="form-control" name="email" required/>
                </div>
            </div>

            <!--- Submit button--->
            <div class="form-group">
                <label class="col-lg-3 control-label">&nbsp;</label>
                <div class="col-lg-9">
                    <input class="btn btn-primary" type="submit" value="Submit" />
                </div>
            </div>
        </form>
    </cfoutput>
</cffunction>



<!--- Function changePasswordForm: Shows the change password form --->
<cffunction name="changePasswordForm">
    <cfoutput>
        <form action="#cgi.script_name#?p=forgotpassword" class="form-horizontal" method="post">


            <legend>Change Password</legend>
            <input type="text" name="personid" value='#personid#' />


            <!--- Change Password: New Password--->
            <div class="form-group">
                <label class="col-lg-3 control-label">New Password*</label>
                <div class="col-lg-9">
                    <input type="text" class="form-control" name="newpassword" id="newPassword" required/>
                </div>
            </div>

            <!--- Change Password: Confirm New Password--->
            <div class="form-group">
                <label class="col-lg-3 control-label">Confirm New Password*</label>
                <div class="col-lg-9">
                    <input type="text" class="form-control" name="confirmnewpassword" id="confirmNewPassword" required/>
                </div>
            </div>

            <!--- Submit button--->
            <div class="form-group">
                <label class="col-lg-3 control-label">&nbsp;</label>
                <div class="col-lg-9">
                    <button id="newpasswordbutton" class="btn btn-warning" type="button"
                            onclick="validateNewPassword()"> Change Password </button>
                    <input type="submit" id="submitNewPasswordForm" style="display:none" />
                </div>
            </div>
        </form>
    </cfoutput>
</cffunction>

