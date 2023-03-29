<cfinclude  template="../includes/head.cfm">
<cfoutput>
    <cfquery name = "Leave_list"> <!---With the help of Result, generate a dynamic list of Available Leaves --->
        select L.leave_title, L.leave_id, E.leaves_allowed, ifNull(E.leaves_availed, 0) as leaves_availed, E.leaves_balance
        from leaves L
        inner join employee_leaves E on L.leave_id = E.leave_id
        where E.employee_id = '#session.loggedin.username#' and E.status = 'Y'
    </cfquery>
    <!--- front end --->
    <cfif leave_list.recordcount neq 0>
        <a href = "request_leave.cfm" >
            <button type = "button" class = "btn btn-outline-dark custom_button">
                Request Leave
            </button>
        </a>
        <table class = "table mt-4 custom_table">
            <thead class = "thead-dark">
                <th> Leave Title </th>
                <th> Total Allowed</th>
                <th> Availed </th>
                <th> Balance </th>
            </thead>
            <cfloop query = "leave_list">
                <tr>
                    <td> #leave_title# </td>
                    <td> #leaves_allowed# </td>
                    <td> #leaves_availed# </td>
                    <td> #leaves_balance# </td>
                </tr>
            </cfloop>
        </table>
    <cfelse>
        <!--- query result used to show a message if employee not allowed any leave ---> 
        <cfquery name = "get_employee">
            select concat(first_name,' ',middle_name,' ',last_name) as employee_name from employee
        </cfquery>

        <p>Dear #get_employee.employee_name# You are Not Allowed any Leave. Please Contact HR Department.</p>
    </cfif>
</cfoutput>
<cfinclude  template="../includes/foot.cfm">