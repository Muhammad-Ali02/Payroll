<cfoutput>
    <cfinclude  template="head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfquery name = "all_Leave">
            select * from Leaves
        </cfquery>
        <table class = "table table-warning table-striped table-hover">
            <tr>
                <th> ID </th>
                <th> Leave Name </th>
                <th> Leave Type </th>
                <th> Leaves Allowed/Year </th>
                <th> Action </th>
            </tr>
            <cfloop query = "all_Leave">
            <tr>
                <td> #Leave_id# </td>
                <td> #Leave_Title# </td>
                <td> <cfif Leave_Type eq "P">Paid Leave<cfelse> Leave Without Pay </cfif> </td>
                <td> #Allowed_per_year# </td>
                <td> <a href="Leaves.cfm?edit=#Leave_id#"> edit </a> </td>
            </tr>
            </cfloop>
        </table>
    </cfif>
</cfoutput>
    <cfinclude  template="foot.cfm">