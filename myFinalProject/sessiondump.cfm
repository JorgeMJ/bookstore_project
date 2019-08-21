<!--- THIS FILE IS JUST FOR CODE TESTING PURPOSES --------------------------------------------------------------------->
<!--------------------------------------------------------------------------------------------------------------------->

<!---<cfparam name="genre" default="0AAFF13B-D7E0-97B5-50DF2DBD2C549D51">

<cfquery name="author2" datasource="#application.dsource#">
    select * from people
    inner join persontorole on people.personid=persontorole.personid
    inner join genrestobooks on persontorole.bookid=genrestobooks.bookid
<!---inner join genres on genrestobooks.genreid = genres.genreid--->
<!---selecciona el nombre de PEOPLE para el que el GENERO es genero-input donde el role sea autor --->
</cfquery>


<cfdump var="#author2#">

<cfquery name="author" datasource="#application.dsource#">
    select firstname, lastname from people
    inner join persontorole on people.personid=persontorole.personid
    inner join genrestobooks on persontorole.bookid=genrestobooks.bookid
<!---inner join genres on genrestobooks.genreid = genres.genreid--->
    where roleid = '1' and genreid = '#genre#'
<!---selecciona el nombre de PEOPLE para el que el GENERO es genero-input donde el role sea autor --->
</cfquery>

<cfdump var="#author#">--->

<cfquery name="author" datasource="#application.dsource#">
    select firstname, lastname from people
    inner join persontorole on people.personid=persontorole.personid
    inner join genrestobooks on persontorole.bookid=genrestobooks.bookid
    where roleid = '1' and genreid = 'D90D6A22-E62C-08F5-921805BCFF83DF66'

</cfquery>

<cfdump var="#author#">
<!---
<cfloop query="author" >
    <cfoutput>
        <ul>
        <li><a href="#cgi.script_name#?p=details&searchme=#title#">#title#</a></li>
    </ul>
    </cfoutput>
</cfloop>
--->