<!--- Displays the name of the author whose books are going to be listed --->
<cfoutput>
    <legend>#authorF# #authorL#</legend>
</cfoutput>

<!--- Query to get the books of the selected author--->
<cfquery name="authorbooks" datasource="#application.dsource#">
    select books.title from books
    inner join persontorole on books.isbn13 = persontorole.bookid
    inner join people on persontorole.personid = people.personid
    inner join roles on persontorole.roleid=roles.roleid
    where firstname = '#authorF#' and lastname = '#authorL#'
    order by books.title
</cfquery>

<cfoutput>
    <p>All of the titles in store by #authorF# #authorL#</p>
</cfoutput>

<!--- Display the list of books by the selected author --->
<cfloop query="authorbooks" >
    <cfoutput>
        <ul>
            <li><a href="#cgi.script_name#?p=details&searchme=#title#">#title#</a></li>
        </ul>
    </cfoutput>
</cfloop>



