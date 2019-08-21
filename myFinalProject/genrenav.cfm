<!--- Selects the genres --->
<cfquery name="allmygenres" datasource="#application.dsource#">
    select distinct genres.genreid, genres.genrename from genrestobooks
    inner join genres on genres.genreid = genrestobooks.genreid
    order by genrename
</cfquery>

<!--- Displays a list of the different genres taken from the 'allgenres' query --->
<cfoutput>
    <ul class="nav nav-stacked">
        <cfloop query="allmygenres">
            <li><a href="#cgi.SCRIPT_NAME#?p=details&genre=#allmygenres.genreid#">#allmygenres.genrename#</a></li>
        </cfloop>
    </ul>
</cfoutput>