<cfcomponent>
	<cfset this.name='jmart82733'>
	<cfset this.dsource='jmart82733'>
    <cfset this.sessionmanagement="true">

	<cffunction name="onApplicationStart">
    	<cfset application.dsource="jmart82733">
    </cffunction>

	<cffunction name="onRequestStart">
		<cfif not isdefined('session.firstname')>
			<cfset session.firstname="">
		</cfif>
		<cfif not isdefined('session.lastname')>
			<cfset session.lastname="">
		</cfif>
	</cffunction>
</cfcomponent>

