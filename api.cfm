<cfparam name="application.api" default="#structNew()#">
<cfif isDefined("URL.reset") and (reset is 'gooberfish')>
</cfif>
	<cfset application.api = {}>

<cfset path = '#CGI.PATH_INFO#'>
<cfparam name="callback" default="jsonp_callback">

<cfparam name="application.APIlog" default="#arrayNew(1 )#">
<cfset arrayAppend(application.APIlog, path)>

<cfif listLen(path, '/') lt 2>
	{"error":"Malformed API Call"}
	<cfabort>
</cfif>

<cfset component = listFirst(path, '/')>
<cfset path = listDeleteAt(path, 1, '/')>
<cfset method = listFirst(path, '/')>
<cfset path = listDeleteAt(path, 1, '/')>
<cfset args = listToArray(path, '/')>

<cfif not isDefined("application.api.#component#")>
	<cfset application.api[component] = createObject("component", 'service.#component#')>
</cfif>

<cfif isDefined("application.api.#component#.#method#")>
	<cfset fn = application.api[component][method]>
<cfelse>
	{"error":"Invalid API Branch"}
	<cfabort>
</cfif>

<cfset fnInfo = getMetadata(fn)>

<cfif not fnInfo.access is "remote">
	{"error":"Invalid API Call"}
	<cfabort>
</cfif>

<cfif arrayLen(args) gt arrayLen(fnInfo.parameters)>
	{"error":"Invalid Number of Arguments"}
	<cfabort>
</cfif>

<cfset I = 0>
<cfinvoke component="#application.api[component]#" method="#method#" returnvariable="result">
	<cfloop array="#args#" index="arg">
		<cfinvokeargument name="#fnInfo.parameters[++I]['name']#" value="#arg#">
	</cfloop>
</cfinvoke>

<cfif isDefined("result.error")>
	<cfheader statuscode="404" statustext="#result.error#">
<cfelse>
	<cfheader name="Content-Type" value="application/json">
	<cfoutput>#callback#(#serializeJSON(result)#)</cfoutput>
</cfif>