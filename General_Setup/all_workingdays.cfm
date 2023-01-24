<cfoutput>
    <cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfquery name = "all_workingdays">
            select * from working_days
        </cfquery>
            <a href = "workingdays.cfm">
                <button type = "button" class = "btn btn-outline-dark mb-3 custom_button">
                    Create New Group
                </button>
            </a>
        <table class = "table custom_table">
            <tr>
                <th> No.</th>
                <th> Group ID </th>
                <th> Group Name </th>
                <th style = "text-align:center"> Action </th>
            </tr>
            <cfset No = 0>
            <cfloop query = "all_workingdays">
                <cfset No = No + 1>
            <tr>
                <td>#No#</td>
                <td> #group_id# </td>
                <td> #group_name# </td>
                <td style = "text-align:center">
                    <a href="workingdays.cfm?edit=#group_id#"> 
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                            <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                            <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                        </svg> 
                    </a>
                </td>
            </tr>
            </cfloop>
        </table>
    </cfif>
</cfoutput>
    <cfinclude  template="..\includes\foot.cfm">