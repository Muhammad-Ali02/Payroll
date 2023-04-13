<cfcomponent output = "false"> 
    <cfset this.name = 'payroll'>
    <cfset this.applicationTimeOut = createTimespan(0, 1, 30, 0) >
<!--- By defining datasource in this file, no need to use datasource attribute explicitly in each query   --->
    <cfset this.datasource = 'payroll'>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimespan(0, 0, 50, 0)>
    <cfif StructKeyExists(CGI, "HTTP_X_FORWARDED_FOR")>
        <cfset this.ipAddress = ListFirst(CGI.HTTP_X_FORWARDED_FOR, ", ")>
    <cfelse>
        <cfset this.ipAddress = CGI.REMOTE_ADDR>
    </cfif>
    <cfset obj = createObject("java","java.net.InetAddress")>
    <cfset machine_name = obj.getLocalHost().getHostName()>
    <!--- Initialize application --->
  <cffunction name="onApplicationStart" returnType="boolean" output="false">
    <cfset Application.startTime = Now()>
    <cfreturn true>
  </cffunction>

  <!--- Pre-request processing --->
  <cffunction name="onRequestStart" returnType="void" output="false">

    <!--- Perform any necessary pre-request processing here --->
    <cfset stringurl = CGI.SCRIPT_NAME>
    <cfset searchString = 'Employee_Portal'> 
    <cfif structKeyExists(session, 'loggedIn')> 
        <cfif structKeyExists(url, 'logout')>
            <cfset createObject("component", '\components.user_authentication').user_logout() />
            <cflocation  url="/login/user_login.cfm">
        </cfif>
        <cfif session.loggedin.role eq "employee" and findNoCase(searchString, stringurl) eq 0>
            <cflocation  url="/employee_portal/index.cfm">
        </cfif>
        <cfif session.loggedin.role neq "employee" and findNoCase(searchString, stringurl) gt 0>
            <cflocation  url="/index.cfm?">
        </cfif>
    </cfif>
  </cffunction>

  <!--- Process the request --->
  <cffunction name="onRequest" returnType="void" output="true">
    <!--- Global Variables here --->
    <cferror type="exception" template="/error.cfm">
    <cferror type="request" template="/error.cfm">
    <cferror type="validation" template="/error.cfm">  
    <cfset current_ipAddress = this.ipAddress>
    <cfif not structKeyExists(session, 'loggedIn') and CGI.SCRIPT_NAME neq '/login/user_login.cfm'>
            <cflocation  url="\login\user_login.cfm">
    </cfif>
<!---     <cftransaction>      --->
        <cfif structKeyExists(session, 'loggedIn')>
          <cfinclude  template="\includes\head.cfm">
        </cfif>
        <cfinclude template="#CGI.SCRIPT_NAME#">
        <cfif structKeyExists(session, 'loggedIn')>
          <cfinclude  template="\includes\foot.cfm">
        </cfif>
<!---     </cftransaction> --->
  </cffunction>

  <!--- Post-request processing --->
  <cffunction name="onRequestEnd" returnType="void" output="false">
    <!--- Perform any necessary post-request processing here --->
  </cffunction>

  <!--- Cleanup and finalization --->
  <cffunction name="onApplicationEnd" returnType="void" output="false">
    <!--- Perform any necessary cleanup or finalization tasks here --->
  </cffunction>
  
</cfcomponent>