<cfcomponent output = "false"> 
    <cfset this.name = 'payroll'>
    <cfset this.applicationTimeOut = createTimespan(0, 1, 30, 0) >
<!--- By defining datasource in this file, no need to use datasource attribute explicitly in each query   --->
    <cfset this.datasource = 'payroll'>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimespan(0, 0, 50, 0)>
</cfcomponent>