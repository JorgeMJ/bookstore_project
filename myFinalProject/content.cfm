<!--- Sets the var contentid with a default value. Contentid will hold the value of the contentid parameter from the query --->
<cfparam name="contentid" default="">

<!--- Query --->
<!--- Selects all parameters of the chosen 'content' --->
<cfquery name="whatContent" datasource="#application.dsource#">
    select * from content where contentid='#contentid#'
</cfquery>


<!--- If the content exists (is different from an empty string) and the query gets a result of more than 0, it displays the content --->
<cfif contentid neq '' and whatContent.recordcount gt 0>
    <cfoutput>
        <legend>#whatContent.title[1]#</legend>
    <div>#whatContent.description[1]#</div>
    </cfoutput>
<!--- If there is no content for the selected query, it displays the following message --->
<cfelse>
    Content not found. Please Try again.
</cfif>