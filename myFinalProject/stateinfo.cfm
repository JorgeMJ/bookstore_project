
<!--- Running this function at the beginning of the session, sets the isloggedin var as false and user as empty
(with the  parameter 'isadmin' pre-set as '0') --->
<cfif not isdefined('session.user') or not structKeyExists(session,"isloggedin")>
    <cfset makeCleanUser()>
</cfif>


<!--- Handles logoff state. If the url.p is set to logoff --->
<cfif isdefined('url.p') and url.p eq 'logoff'>
    <cfset StructClear(session)>
    <cfset session.isloggedin=false>
    <cfset makeCleanUser()>
    <cfset p="carousel">
</cfif>


<!--- Handling login information--->
<cfif isdefined('form.loginemail')>
    <!--- Selects the record from table People whose password and and Id matches the login information (loginemail and password)--->
    <cfquery name="access" datasource="#application.dsource#">
        select * from people
        inner join passwords on people.personid=passwords.personid
        where email='#form.loginemail#' and password='#hash(form.loginpass,"SHA-256")#'
    </cfquery>

    <!--- If the query "access" gets any number of results greater than 0, it sets user session, isloggedin=true and shows them the carousel --->
    <cfif access.recordcount gt 0>
        <cfset session.user.firstname=access.firstname[1]>
        <cfset session.user.lastname=access.lastname[1]>
        <cfset session.user.email=access.email[1]>
        <cfset session.user.acctnumber=access.personid[1]>

        <cfset session.isloggedin=true>
        <cfset p="carousel">

        <!--- If the user is also an admin, makes sure that is in the session --->
        <cfif access.isadmin[1] neq ''>
            <cfset session.user.isadmin=access.isadmin[1]>
        </cfif>
    <cfelse>
        <cfset loginmessage="Sorry, that login doesn't match" />
    </cfif>
</cfif>



<!--- Function makeCleanUser sets all the values of login to empty --->
<cffunction name="makeCleanUser">
    <!--- Sets the isloogedin var as false --->
    <cfset session.isloggedin=false>
    <!--- Sets the user parameters as empty --->
    <cfset session.user={
        firstname:'',
        lastname:'',
        acctnumber:'',
        email:'',
        isadmin:0
    }>
</cffunction>