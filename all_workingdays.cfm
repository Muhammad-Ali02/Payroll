<cfoutput>
    <cfinclude  template="head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfquery name = "all_workingdays">
            select * from working_days
        </cfquery>
        <table class = "table table-info table-striped table-hover">
            <tr>
                <th> ID </th>
                <th> Group Name </th>
                <th> Action </th>
            </tr>
            <cfloop query = "all_workingdays">
            <tr>
                <td> #group_id# </td>
                <td> #group_name# </td>
                <td> <a href="workingdays.cfm?edit=#group_id#"> edit </a> </td>
            </tr>
            </cfloop>
        </table>
    </cfif>
</cfoutput>
    <cfinclude  template="foot.cfm">