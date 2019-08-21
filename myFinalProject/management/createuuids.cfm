<!--- Create a random list of 20 UUIDs to be used as unique ids in the database --->
<ul>
<cfoutput>
    <cfloop from="1" to="20" index="I">
            <li>#createuuid()#</li>
    </cfloop>
</cfoutput>
</ul>