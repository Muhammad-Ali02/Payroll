<cfoutput>
    <cfinclude  template="header.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <table> 
            <tr>
                <td>    <a href = "all_employees.cfm"> <button class = "btn btn-info cls_btn" > View All Employees </button> </a>  </td>
                <td>    <a href = "employee.cfm" > <button class = "btn btn-outline-info cls_btn" > Create employee </button> </a> </td>
            </tr>
            <tr>
                <td>    <a href = "department.cfm" > <button class = "btn btn-primary cls_btn"> Create department </button> </a> </td>
                <td>    <a href = "all_departments.cfm"><button class = "btn btn-outline-primary cls_btn"> View All Departments </button> </a> </td>
            </tr>
            <tr>
                <td>    <a href = "designation.cfm"> <button class = "btn btn-warning cls_btn"> Add New Designation </button> </a> </td>
                <td>    <a href = "all_designation.cfm"> <button class = "btn btn-outline-warning cls_btn"> View Designation </button> </a> </td>
            </tr>
            <tr>
                <td>    <a href = "create_user.cfm"> <button class = "btn btn-secondary cls_btn"> Create User </button> </a> </td>
                <td>    <a href = "all_users.cfm"> <button class = "btn btn-outline-secondary cls_btn"> View All User </button> </a> </td>
            <tr>
                <td>    <a href = "allowance.cfm"> <button class = "btn btn-dark cls_btn"> Add New Allowance </button> </a> </td>
                <td>    <a href = "all_allowance.cfm"> <button class = "btn btn-outline-dark cls_btn"> View Allowances </button> </a> </td>
            </tr>
            <tr>
                <td>    <a href = "Deduction.cfm"> <button class = "btn btn-danger cls_btn"> Add New Deduction </button> </a> </td>
                <td>    <a href = "all_deduction.cfm"> <button class = "btn btn-outline-danger cls_btn"> View Deductions </button> </a> </td>
            </tr>
            <tr>    
                <td>    <a href = "attendance.cfm"> <button class = "btn btn-success cls_btn"> Attendance Sheet </button> </a> </td>
                <td>    <a href = "add_attendance.cfm"> <button class = "btn btn-outline-success cls_btn"> Manual Attendance </button> </a> </td>
            </tr>
            <tr>    
                <td>    <a href = "leaves.cfm"> <button class = "btn btn-info cls_btn"> New Leave </button> </a> </td>
                <td>    <a href = "all_leaves.cfm"> <button class = "btn btn-outline-info cls_btn"> View All Leaves </button> </a> </td>
            </tr>
            <tr>    
                <td>    <a href = "request_leave.cfm"> <button class = "btn btn-primary cls_btn"> Leave Request </button> </a> </td>
                <td>    <a href = "all_leaves.cfm"> <button class = "btn btn-outline-primary cls_btn"> Pending Approval </button> </a> </td>
            </tr>
            <tr>    
                <td>    <a href = "workingdays.cfm"> <button class = "btn btn-primary cls_btn"> Working Days Groups</button> </a> </td>
                <td>    <a href = "all_workingdays.cfm"> <button class = "btn btn-outline-primary cls_btn"> View Groups </button> </a> </td>
            </tr>
            <tr>    
                <td>    <a href = "setting.cfm"> <button class = "btn btn-info cls_btn"> Setting </button> </a> </td>
                <td>    <a href = "pay.cfm"> <button class = "btn btn-outline-info cls_btn"> Pay </button> </a> </td>
            </tr>
        </table>
    </cfif>
</cfoutput>