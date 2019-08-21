<!--- Setting default value of variables --->
<!--- Stores any message concerning "new account" --->
<cfparam name="AccountMessage" default="" />
<!--- Store any message concerning "login"--->
<cfparam name="loginmessage" default= "" />

<!--- Javascript code: --->
<script type="text/javascript">
    <!--- Function validateNewAccount() checks if password and passwordconfirm are alike --->
    function validateNewAccount() {
        var originalPassword=document.getElementById('newAccountPassword').value;
        var confirmPassword=document.getElementById('newAccountPasswordConfirm').value;

        if(originalPassword === confirmPassword && originalPassword !== '' && confirmPassword !== ''){
            document.getElementById('submitNewAccountForm').click();
            document.getElementById('newAccountMessage').innerHTML="";
        }
        else{
            document.getElementById('newAccountMessage').innerHTML="The two passwords do not match";
        }
    }
</script>


<!--- Calling preprocess function --->
<cfset preProcess()>

<!--- Form: New User account --->

<div class="col-lg-6">
    <legend>New user account: </legend>
    <cfoutput>
        <!--- Shows messages if there is a problem--->
        <div id="newAccountMessage">#AccountMessage#</div>

        <form action="#cgi.script_name#?p=login" class="form-horizontal" method="post" >

            <!--- New Person ID (hidden). Flags the preprocess function to handle the newaccount submission --->
            <input type="hidden" name="newpersonid"  value=""/>

            <!--- Firstname --->
            <div class="form-group">
                <label class="col-lg-3 control-label">First Name*</label>
                <div class="col-lg-9">
                    <input type="text" class="form-control" name="firstname" required />
                </div>
            </div>

            <!--- Lastname --->
            <div class="form-group">
                <label class="col-lg-3 control-label">Last Name*</label>
                <div class="col-lg-9">
                    <input type="text" class="form-control" name="lastname" required />
                </div>
            </div>

            <!--- Email --->
            <div class="form-group">
                <label class="col-lg-3 control-label">Email*</label>
                <div class="col-lg-9">
                    <input type="email" class="form-control" name="email" required />
                </div>
            </div>

            <!--- Password --->
            <div class="form-group">
                <label class="col-lg-3 control-label">Password*</label>
                <div class="col-lg-9">
                    <input type="password" class="form-control" name="password" id="newAccountPassword" required />
                </div>
            </div>

            <!--- Password confirm --->
            <div class="form-group">
                <label class="col-lg-3 control-label">Confirm Password*</label>
                <div class="col-lg-9">
                    <input type="password" class="form-control" id="newAccountPasswordConfirm" required />
                </div>
            </div>

            <!--- Submit Button --->
            <div class="form-group">
                <label class="col-lg-3 control-label">&nbsp;</label>
                <div class="col-lg-9">
                    <button id="newaccountbutton" class="btn btn-warning" type="button"
                            onclick="validateNewAccount()"> Make Account </button>
                    <input type="submit" id="submitNewAccountForm" style="display:none" />
                </div>
            </div>

        </form>
    </cfoutput>
</div>

<!--- Form: Login --->

<div class="col-lg-6">
    <legend>User login: </legend>
    <cfoutput>
        <!--- Display message if there is a problem during the login--->
        <div id="loginmessage">#loginmessage#</div>

        <form action="#cgi.script_name#?p=login" class="form-horizontal" method="post">

            <!--- Login Email--->
            <div class="form-group">
                <label class="col-lg-3 control-label">Email*</label>
                <div class="col-lg-9">
                    <input name="loginemail" required/>
                </div>
            </div>

            <!--- Login Pass --->
            <div class="form-group">
                <label class="col-lg-3 control-label">Password*</label>
                <div class="col-lg-9">
                    <input type="password" name="loginpass" required/>
                </div>
            </div>

            <div class="form-group">
                <label class="col-lg-3 control-label">&nbsp;</label>
                <div class="col-lg-9">
                    <button class="btn btn-primary" type="submit">Login</button>

                    <a href="#cgi.script_name#?p=forgotpassword">Forgot Password</a>
                </div>
            </div>
        </form>
    </cfoutput>
</div>


<!--- Function preprocess: handles the new account --->

<cffunction name="preProcess">

    <cfif isdefined('form.newpersonid')>

        <!---Creates a new UUID. It will be used in he quesries "putin" and "passw" --->
        <cfset newpersonid=createuuid()>

        <!--- Selects the emails from database that are equal to the input one in the login form --->
        <cfquery name="getemail" datasource="#application.dsource#">
            select * from people where email='#form.email#'
        </cfquery>

        <!--- If email is not in our database create a new user inserting all fields from the form--->
        <cfif getemail.recordcount eq 0>
            <!--- Insert the field forms in the People table --->
            <cfquery name="putin" datasource="#application.dsource#">
                insert into people (personid,firstname,lastname,email,isadmin) values ('#newpersonid#','#form.firstname#','#form.lastname#','#form.email#','0')
            </cfquery>

            <!--- Insert the person's id and hashed password into the passwords table --->
            <cfquery name="passw" datasource="#application.dsource#">
                insert into passwords (personid,password) values ('#newpersonid#','#hash(form.password,"SHA-256")#')
            </cfquery>

        <cfelse>

            <cfset AccountMessage="That Email Account is Already in our system. Please login.">

        </cfif>

    </cfif>
</cffunction>