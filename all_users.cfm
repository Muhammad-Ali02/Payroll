<cfoutput>
    <cfinclude  template="head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfquery name = "all_users">
            select * from users
        </cfquery>
        <div>
            <a href = "create_user.cfm" target = "_self">
                <button type = "button" class = "btn btn-outline-dark create_button">
                    Create User with Role 
                </button>
            </a>
        </div>
        <table class = "table table-warning table-striped table-hover">
            <tr>
                <th> ID </th>
                <th> User Name </th>
                <th> Password </th>
                <th> Level </th>
                <th> Action </th>
            </tr>
            <cfloop query = "all_users">
            <tr>
                <td> #id# </td>
                <td> #user_name# </td>
                <td> #password# </td>
                <td> #level# </td>
                <td> <a href="create_user.cfm?edit=#id#"> edit </a> </td>
            </tr>
            </cfloop>
        </table>
    </cfif>
</cfoutput>
    <cfinclude  template="foot.cfm">