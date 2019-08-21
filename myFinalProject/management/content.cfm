<!--- Default value for variable contentid --->
<cfparam name="contentid" default="">

<!--- Calls process form --->
<cfset processForms()>

<!--- Structure of the page --->
<cfoutput>
    <div class="col-lg-12">
        <div class="col-lg-9 col-lg-push-3">
            #contentForm()#
        </div>

        <div class="col-lg-3 col-lg-pull-9">
            #contentNav()#
        </div>
    </div>
</cfoutput>


<!--- Function processForm: Creates a new record or updates it if it already exists --->
<cffunction name="processForms">

    <cfif isdefined('form.contentid')>

        <!--- If variable 'contentid' is equal to empty string, we create a new uuid for it --->
        <cfif form.contentid eq ''>
            <cfset form.contentid=createuuid()>
        </cfif>

        <!--- Query that adds a new content if it isn't already in the DB, else updates it  --->
        <cfquery name="putin" datasource="#application.dsource#">
            if not exists(select * from content where contentid='#form.contentid#')
                insert into content (contentid, title) values ('#form.contentid#','#form.title#');

            update content set title='#form.title#', description='#description#' where contentid='#form.contentid#'
        </cfquery>
    </cfif>
</cffunction>


<!--- Function contentForm: Queries and displays the selected content --->
<cffunction name="contentForm">

    <!--- If something different from empty string has been submitted to contentid, query the DB looking for that content --->
    <cfif contentid neq ''>
        <!--- Query --->
        <cfquery name="editContent" datasource="#application.dsource#">
            select * from content where contentid='#contentid#'
        </cfquery>

        <!--- From that shows the content of the content query to be edited--->
        <cfoutput>
            <form action="#cgi.script_name#?tool=content" method="post" class="form-horizontal">
                <!--- ContentID --->
                <input type="hidden" name="contentid" value="#editContent.contentid[1]#">

                <!---Code --->
                <div class="form-group">
                    <label class="col-lg-3 content-label">Code  </label>
                    <div class="col-lg-9">#editContent.contentid[1]#</div>
                </div>

                <!--- Title --->
                <div class="form-group">
                    <label class="col-lg-3 content-label">Title</label>
                    <div class="col-lg-9">
                        <input type="text" name="title" value="#editContent.title[1]#" />
                    </div>
                </div>

                <!--- Description --->
                <div class="form-group">
                    <label class="col-lg-12 content-label" style="text-align: left">Description</label>
                    <div class="col-lg-9">
                        <textarea name="description">#editContent.description[1]#</textarea>
                        <script>CKEDITOR.replace('description')</script>
                    </div>
                </div>

                <!--- Submit button --->
                <div class="form-group">
                    <label class="col-lg-3 content-label">&nbsp;</label>
                    <div class="col-lg-9">
                        <input type="submit" value="Save" />
                    </div>
                </div>
            </form>
        </cfoutput>
    </cfif>
</cffunction>


<!--- Function ContentNav: Displays all the different contents in the left side of the page --->
<cffunction name="contentNav">
    <!--- Query --->
    <cfquery name="allcontent" datasource="#application.dsource#">
        select * from content order by title
    </cfquery>

    <cfoutput>
        <ul>
            <!--- Link to Add a new content --->
            <li><a href="#cgi.script_name#?tool=content&contentid=new">Add Content</a></li>
            <hr>

            <!--- Displays all the content titles as links to show the information it contains --->
            <cfloop query="allcontent">
                <li><a href="#cgi.script_name#?tool=content&contentid=#contentid#">#title#</a></li>
            </cfloop>
        </ul>
    </cfoutput>
</cffunction>