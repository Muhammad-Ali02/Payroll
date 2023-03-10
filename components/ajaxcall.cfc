<cfcomponent output = "false">
    <cffunction  name="getdbdata" returntype = "string" returnformat = "plain">
        <cfargument  name="employee_id" type = "string" required = "true">
        <cfquery name = "getDataDb">
            select * from employee
            where employee_id = '#argument.employee_id#'
        </cfquery>
    </cffunction>
</cfcomponent>