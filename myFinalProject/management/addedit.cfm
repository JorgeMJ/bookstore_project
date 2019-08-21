<!--- Setting default variable values --->
<cfparam name="book" default="">
<cfparam name="qterm" default="">


<!--- JavaScript code to toggle ISBN13 input field --->
<script>
    function togglenewisbnform(){
        var newISBNArea = document.getElementById('newisbn13area');
        if(newISBNArea.style.display=='none'){
            newISBNArea.style.display='inline';
        }
        else{
            newISBNArea.style.display='none';
        }
    }
</script>


<!--- Try-catch Calling the different functions of the page --->
<cftry>
    <cfset processForms()>

    <div id="main" class="col-lg-9 col-lg-push-3">
    <cfoutput>#mainForm()#</cfoutput>
    </div>

    <div id="leftgutter" class="col-lg-3 col-lg-pull-9">
    <cfoutput>#sideNav()#</cfoutput>
    </div>

    <cfcatch type="any">
        <cfoutput>
            <!--- CFCatch is a structure that has several keys in it.
            One of these is the message. You might want to change this to be <cfdump var="#cfcatch#">
            if you want to get more insight into what is happening --->

            #cfcatch.message#
        </cfoutput>
    </cfcatch>
</cftry>


<!--- Function "mainForm" adding/editing form --->

<cffunction name="mainForm">
    <cfoutput>
        <input type="hidden" name="qterm" value="#qterm#" />
    </cfoutput>
    <cfif book neq ''>

        <!--- Queries --->
        <!--- Selects all genres from the table Genres and order them by name --->
        <cfquery name="allgenres" datasource="#application.dsource#">
            select * from genres order by genrename
        </cfquery>

        <cfquery name="bookgenres" datasource="#application.dsource#">
            select * from GenresToBooks where bookid='#book#'
        </cfquery>

        <!--- Select the book with isbn13 equal to the value of var "book" --->
        <cfquery name="thisbook" datasource="#application.dsource#">
            select * from books where isbn13='#book#'
        </cfquery>

        <!--- Selects all publisher and store in var "allpubs" --->
        <cfif isdefined('url.book')>
            <cfquery name="allpubs" datasource="#application.dsource#">
                select * from publishers order by name
            </cfquery>
        </cfif>


        <!--- Determine whether to show the isbn13 edit or display --->
        <!--- By default show the display --->
        <cfset isbnfield="none">
        <cfset isbndisplay="inline">
        <cfset req=''>

        <!--- If the ISBN13 from the db is blank, show the isbn13 input --->
        <cfif trim(thisbook.isbn13[1]) eq ''>
            <cfset isbnfield='inline'>
            <cfset isbndisplay='none'>
            <cfset req="required">
        </cfif>

        <!--- Form to add a new book or edit an existing one --->
        <cfoutput>
            <!--- By using #cgi.script_name# this form will submit the form data to this same page by reponeing it--->
            <form action="#cgi.script_name#?tool=#tool#&book=#url.book#" method="post" enctype="multipart/form-data"
                                                                            class="form-horizontal">

                <!--- ISBN13 --->
                <div class="form-group">
                    <label for="isbn13" class="col-lg-3 control-label">ISBN13</label>
                    <div class="col-lg-9">
                        <!--- This area will toggle (display/hide) when pressing on Edit ISBN --->
                        <span id="newisbn13area" style="display:#isbnfield#">
                            <input type="text" id="newisbn13" name="newisbn13" class="form-control"  placeholder="New ISBN13"
                                value="#thisbook.isbn13[1]#" #req# pattern=".{13}" title="Please enter 13 characters only. No dashes necessary." />
                        </span>

                        <span style="display:#isbndisplay#">
                        <cfoutput>
                            <!--- Displays the EXISTING ISNB13. Button toggles to show the EDIT ISBN13 --->
                            #thisbook.isbn13[1]# <button type="button" onclick="togglenewisbnform()"
                                                         class="btn btn-warning btn-xs">Edit ISBN</button>
                        </cfoutput>
                                <input type="hidden" class="form-control" id="isbn13" name="isbn13" placeholder="ISBN13"
                                    value="#thisbook.isbn13[1]#"/>
                        </span>
                    </div>
                </div>

                <!--- Title --->
                <div class="form-group">
                    <label for="title" class="col-lg-3 control-label">Book Title</label>
                    <div class="col-lg-9">
                        <input type="text" id="title" name="title" placeholder="Book Title" value="#thisbook.title[1]#"
                            maxlength="45"  class="form-control" required/>
                    </div>
                </div>

                <!--- Language --->
                <div class="form-group">
                    <label for="language" class="col-lg-3 control-label">Language</label>
                    <div class="col-lg-9">
                        <input type="text" id="language" name="language" placeholder="language" value="#thisbook.language[1]#"
                            class="form-control" required/>
                    </div>
                </div>

                <!--- Year --->
                <div class="form-group">
                    <label for="year" class="col-lg-3 control-label">Publication Year</label>
                    <div class="col-lg-9">
                        <input type="text" name="year" class="form-control" id="year" value="#thisbook.year[1]#"
                            placeholder="Publication year" />
                    </div>
                </div>

                <!--- Pages --->
                <div class="form-group">
                    <label for="pages" class="col-lg-3 control-label">Number of Pages</label>
                    <div class="col-lg-9">
                        <input type="text" name="pages" class="form-control" id="pages" value="#thisbook.pages[1]#"
                            placeholder="Number of pages" />
                    </div>
                </div>

                <!--- Binding --->
                <div class="form-group">
                    <label for="pages" class="col-lg-3 control-label">Binding</label>
                    <div class="col-lg-9">
                        <input type="text" name="binding" class="form-control" id="binding" value="#thisbook.binding[1]#"
                               placeholder="Paperback, harcover, ebook..." />
                    </div>
                </div>
                <!--- Weight --->
                <div class="form-group">
                    <label for="weight" class="col-lg-3 control-label">Weight</label>
                    <div class="col-lg-9">
                        <input type="text" name="weight" class="form-control" id="weight" value="#thisbook.weight[1]#"
                            placeholder="Book Weight (lbs)" />
                    </div>
                </div>

                <!--- ISBN --->
                <div class="form-group">
                    <label for="isbn" class="col-lg-3 control-label">ISBN</label>
                    <div class="col-lg-9">
                        <input type="text" name="isbn" class="form-control" id="isbn" value="#thisbook.isbn[1]#"
                            placeholder="isbn" />
                    </div>
                </div>

                <!--- Publisher --->
                <div class="form-group">
                    <label for="publisher" class="col-lg-3 control-label">Publisher</label>
                    <div class="col-lg-9">
                        <select class="form-control" id="publisher" name="publisher">
                            <option value=""></option>
                            <cfloop query="allpubs">
                                <cfset sel=''>
                                <cfif trim(id) eq trim(thisbook.publisher[1])>
                                    <cfset sel='selected="selected"'>
                                </cfif>
                                <option value="#trim(id)#" #sel#>#trim(name)#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>

                <!--- Genre --->
                <div class="form-group">
                    <label class="col-lg-3 control-label" for="genres" >Genres </label>
                    <div class="col-lg-9">
                        <!--- Loops over the genres in the 'allgenres' query and displays them in the form as checkboxes --->
                        <cfloop query="allgenres">
                            <input id="genre#genreid#" type="checkbox" name="genre" value="#genreid#">
                            #genrename#<br/>
                        </cfloop>

                        <!--- For the book we selected, it shows as checked those genres matching its genre --->
                        <cfloop query="bookgenres">
                            <script>document.getElementById('genre#genreid#').checked=true;</script>
                        </cfloop>

                    </div>
                </div>

                <!--- Image --->
                <div class="form-group">
                    <label class="col-lg-3 control-label" for="image" >Cover </label>
                    <div class="col-lg-9">
                        <input type="file" name="uploadimage">
                        <input type="hidden" name="image" value="#trim(thisbook.image[1])#" height="150">
                        <cfif thisbook.image[1] neq ''>
                                <img src="/jmart82733/MyFinalProject/images/#trim(thisbook.image[1])#" />
                        </cfif>
                    </div>
                </div>

                <!--- CKEDITOR: allows user to enter a book description under WYSIWYG philosophy --->
                <div class="form-group">
                    <label class="col-lg-3 control-label" for="bookdesc">Description</label>
                    <div class="col-lg-9">
                        <cfoutput>
                                <textarea id="bookdesc" name="description" >#trim(thisbook.description[1])#</textarea>
                        </cfoutput>
                    </div>
                    <script>
                        CKEDITOR.replace('bookdesc');
                    </script>
                </div>

                <!--- Submit button --->
                <div class="form-group">
                    <label class="col-lg-3 control-label">&nbsp;</label>
                    <div class="col-lg-9">
                        <button type="submit" class="btn btn-primary">Add Book</button>
                    </div>
                </div>
            </form>
        </cfoutput>
    </cfif>
</cffunction>


<!--- Function "Side Navigation" --->

<cffunction name="sideNav">
    <!--- Search from --->
    <cfoutput>
        <form action="#cgi.SCRIPT_NAME#?tool=addedit" method="post" class="form-inline">
            <div class="form-group">
                    <input type="text" class="form-control" id="qterm" name="qterm" value="#qterm#">
                <button type="submit" class="btn btn-xs btn-primary">Search</button>
            </div>
        </form>
    </cfoutput>

    <!--- If the variable that holds the value to be search (qterm) is not empty queries the DB --->
    <cfif qterm neq ''>
        <cfquery name="allbooks" datasource="#application.dsource#">
           select * from books where title like '%#qterm#%' order by title
        </cfquery>
    </cfif>

    <!--- List of results --->
    <cfoutput>
        <!--- Button to add a new book --->
        <li><a href="#cgi.script_name#?tool=addedit&book=new">Add a Book</a></li>
        <hr>

        <!--- List the findings of the search. If result is '0', displays a message--->
        <div>Book List</div>
        <ul class="nav nav-stacked">
            <cfif isdefined("allbooks")>

                <cfloop query="allbooks">
                    <li><a href="#cgi.script_name#?tool=addedit&book=#isbn13#&qterm=#qterm#">#trim(title)#</a></li>
                </cfloop>
            <cfelse>
                No Search Term Entered (Try *Momo*)
            </cfif>
        </ul>
    </cfoutput>
</cffunction>


<!--- Function "processForms" to process the adds and edits into the DB --->

<cffunction name="processForms">

    <cfif isdefined('form.isbn13')>

        <!--- Uploads (saves) teh image in folder 'images' if form.uploadimage is different from '' --->
        <cfif isdefined('form.uploadimage') and trim(form.uploadimage) neq '' >
            <cffile action="upload" filefield="uploadimage" destination="#expandpath('/')#jmart82733/myFinalProject/images/"
                    nameconflict="makeunique">

            <cfset form.image='#cffile.serverfile#'>

        </cfif>


        <!--- Updates the ISBN13 in the database if newisbn13 is defined --->
        <cfif isdefined('form.newisbn13')>
            <cfquery name="updateisbn13" datasource="#application.dsource#">
                update books set isbn13='#form.newisbn13#' where isbn13='#form.isbn13#'
            </cfquery>
            <cfset form.isbn13=form.newisbn13>
        </cfif>

        <!--- Add a new book with all its information only if hte book does not exists in the database --->
        <cfquery name="adddata" datasource="#application.dsource#">
            if not exists(select * from books where isbn13='#form.isbn13#')
                insert into books (isbn13,title) values ('#form.isbn13#','#form.title#');
                update books set
                title='#form.title#',
                weight='#form.weight#',
                language='#form.language#',
                binding='#form.binding#',
                year='#form.year#',
                isbn='#form.isbn#',
                pages='#form.pages#',
                description='#form.description#'

            where isbn13='#form.isbn13#'
        </cfquery>

        <!--- query Updates an already existing book --->
        <cfquery name="putin" datasource="#application.dsource#">
            update books set
                title='#form.title#',
                image='#form.image#',
                publisher='#form.publisher#',
                weight='#form.weight#',
                year='#form.year#',
                isbn='#form.isbn#',
                language='#form.language#',
                binding='#form.binding#',
                pages='#form.pages#'

            where isbn13='#form.isbn13#'
        </cfquery>

        <!--- Query Deletes all genres assigned to a given book  --->
        <cfquery name="deletegenre" datasource="#application.dsource#">
            delete from genrestobooks where bookid='#form.isbn13#'
        </cfquery>

        <cfoutput>
        <!--- Loop over all the submitted genres and insert each into the database --->
            <cfloop list="#form.genre#" index="i">
                <cfquery name="putingenres" datasource="#application.dsource#">
                    insert into genrestobooks (bookid,genreid) values ('#form.isbn13#','#i#')
                </cfquery>
            </cfloop>
        </cfoutput>
    </cfif>
</cffunction>