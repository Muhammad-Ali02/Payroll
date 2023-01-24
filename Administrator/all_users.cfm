<cfinclude  template="..\includes\head.cfm">
    <cfoutput>
        <cfif structKeyExists(session, 'loggedIn')>
            <script>
                <cfif structKeyExists(url, 'created')>
                    alert("User Created Succesfully");
                    window.location.href = "all_users.cfm";
                <cfelseif structKeyExists(url, 'updated')>
                    alert("User Data Updated Succesfully");
                    window.location.href = "all_users.cfm";
                </cfif>
            </script>
            <cfquery name = "all_users">
                select * from users
            </cfquery>
            <div>
                <a href = "create_user.cfm" target = "_self">
                    <button type = "button" class = "btn btn-outline-dark create_button mb-3 custom_button">
                        Create User with Role 
                    </button>
                </a>
            </div>
            <table class = "table custom_table">
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
                    <td> 
                        <cfquery name = "get_employee_user">
                            select employee_id from employee where employee_id = "#user_name#"
                        </cfquery>
                        <cfif get_employee_user.recordcount eq 0>
                            <a href="create_user.cfm?edit=#id#&new_user=true">
                        <cfelse>
                            <a href="create_user.cfm?edit=#id#&employee_as_admin=true"> 
                        </cfif>
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