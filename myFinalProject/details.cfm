<cfparam name="searchme" default=''/>
<cfparam name="genre" default='' />
<cfparam name="publisher" default='' />
<cfparam name="authorF" default= ''/>
<cfparam name="authorL" default= ''/>


<cftry>
    <!--- Will sets the right query depending on the value of the variables 'searchme' and 'genre' --->
    <cfset bookinfo = makeQuery()>

    <!--- If there is an error(such nothing entered in the search box) catches  it and shows a message --->
    <cfcatch type="any">
        <cfoutput>
           <p> #cfcatch.message#<br> Please, enter a title in the search box.</p>
        </cfoutput>
    </cfcatch>
</cftry>


<!--- Section calling the functions to display the results of the search depending on the number of results --->
<cfoutput>
    <legend>#bookinfo.label#</legend>
    <cfif bookinfo.booksQuery.recordcount eq 0 >
        #noResults()#
    <cfelseif bookinfo.booksQuery.recordcount eq 1>
        #oneResult(bookinfo.booksQuery, bookInfo.authorQuery)#
    <cfelse>
        #manyResults(bookinfo.booksQuery)#
    </cfif>
</cfoutput>


<!--- Function NoResults: displays a message saying there's no results founds form that search --->
<cffunction name="noResults">
    <p>There were no results to be found.</p>
</cffunction>


<!--- Function oneResult: shows a message saying one book was found and displays the information for that book --->
<cffunction name="oneResult">
    <!--- Function accepts two arguments --->
    <cfargument name="bookQ" type="query" required="true">
    <cfargument name="authorQ" type="query" required="true">

    <!--- Message displayed --->
    <p>There is one result. See the details.</p>
    <br>

    <!--- Displays the information of the selected book --->
    <cfoutput>
        <span>
            <cfif bookQ.image[1] neq '' >
                <img src="images/#bookQ.image[1]#" style="float:left; width:250px; height:250px; margin:0 15px 15px 15px" />
            <cfelseif bookQ.image[1] eq '' and session.user.isadmin eq 1>
                <p style="border: 1px solid grey; width:250px"> No image available.
                <a href="./management/index.cfm?tool=addedit&book=#bookQ.isbn13[1]#"> Add an image?</a></p>
            <cfelse>
                <p style="border:1px solid grey; width:250px">No image available.</p>
            </cfif>
        </span>
        <span>Title: #bookQ.title[1]#</span>
        <br>
        <span>Author: <a href="#cgi.script_name#?p=authorbooks&authorF=#authorQ.firstname[1]
            #&authorL=#authorQ.lastname[1]#">#authorQ.firstname[1]# #authorQ.lastname[1]#</a></span>
        <br>
        <span>Language: #bookQ.language[1]#</span>
        <br>
        <span>Pages: #bookQ.pages[1]#</span>
        <br>
        <span>Binding: #bookQ.binding[1]#</span>
        <br>
        <span>Publisher: #bookQ.name[1]#</span>
        <br>
        <span>Year: #bookQ.year[1]#</span>
        <br>
        <span>Description: #bookQ.description[1]#</span>
    </cfoutput>
</cffunction>


<!--- Function manyResults: displays a list of the matching results --->
<cffunction name="manyResults">
    <!--- Function accept an argument--->
    <cfargument name="bookQ" type="query" required="true">

    <!--- Message displayed --->
    <p>There are more than one result. See the list.</p>
    <br>

    <!--- List of coincidental results --->
    <ol class="nav nav-stacked">
        <cfoutput query="arguments.bookQ">
            <li><a href="#cgi.script_name#?p=details&searchme=#trim(isbn13)#">#trim(title)#</a></li>
        </cfoutput>
    </ol>
</cffunction>


<!--- Function makeQuery: --->
<cffunction name="makeQuery">
    <!--- This function returns a structure (bookinfo) that will be passed to either of noResults, oneResult or
    manyResult functions depending on the result of the query --->

    <!--- Sets the structure BookInfo. --->
    <cfset bookInfo={
        booksQuery: QueryNew("title"),
        authorQuery: QueryNew("author"),
        label: ''
    }>

    <!--- Selects what query to use depending on the search input field (genre or searchme)--->
    <!--- If 'genre' is not empty --->
    <cfif genre neq ''>
        <!--- Selects the 'Genre' for the label--->
        <cfquery name="whatGenre" datasource="#application.dsource#">
            select * from genres where genreid='#genre#'
        </cfquery>

        <!--- Query the DB to get all the information from tables: books and publishers, connecting them via join table
        genrestobooks to get the genre corresponding to the variable 'genre'--->
        <cfquery name="booksQuery" datasource="#application.dsource#">
            select * from books
            inner join genrestobooks on books.isbn13=genrestobooks.bookid
            inner join publishers on books.publisher=publishers.id
            where genreid='#genre#'
        </cfquery>

        <!--- Create the label from the Genre search --->
        <cfset bookinfo.label="Genre: #whatGenre.genrename[1]#">

        <!--- Query to get the author of the book stored in var 'searchme'--->
        <cfquery name="author" datasource="#application.dsource#">
            select firstname, lastname from people
            inner join persontorole on people.personid=persontorole.personid
            inner join genrestobooks on persontorole.bookid=genrestobooks.bookid
            where roleid = '1' and genreid = '#genre#'

        </cfquery>

    <cfelseif searchme neq ''>
        <!--- If 'searchme' result is not empty, query selects all the information from the searched book and the
        publisher associated with it --->
        <cfquery name="booksQuery" datasource="#application.dsource#">
            select * from books
            inner join publishers on books.publisher=publishers.id
            where title like '%#trim(searchme)#%' or isbn13 = '#searchme#' or publishers.id='#searchme#'
        </cfquery>
        <!--- Create the label for this search type --->
        <cfset bookinfo.label="Keyword: #searchme#">

        <!--- Query to get the author of the book stored in var 'searchme'--->
        <cfquery name="author" datasource="#application.dsource#">
            select firstname, lastname from people
            inner join persontorole on people.personid=persontorole.personid
            inner join roles on persontorole.roleid=roles.roleid
            inner join books on persontorole.bookid = books.isbn13
            where roletitle='author' and books.title like '%#trim(searchme)#%' or isbn13 = '#searchme#'
        </cfquery>
    </cfif>

    <!--- Sets the value of the structure 'bookInfo.booksQuery' and 'bookInfo.authorQuery' with the value of the selected query result --->
    <cfset bookInfo.booksQuery= booksQuery>
    <cfset bookInfo.authorQuery= author>

    <cfreturn bookInfo>

</cffunction>
