<cfoutput>
    <cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfif structKeyExists(url, 'edited')>
            <h3 style="color:green; text-align:center"> *Employee #url.edited# Updated Successfully </h3>
        </cfif>
        <cfquery name = "all_employees">
            select emp.employee_id as id, concat(emp.first_name," ",emp.middle_name," ",emp.last_name) as name, dep.department_name as department, des.designation_title as designation
            from employee emp, designation des, department dep
            where emp.department = dep.department_id and emp.designation = des.designation_id
        </cfquery>
        <div>
            <a href = "employee.cfm" target = "_self">
                <button type = "button" class = "btn btn-outline-dark create_button mb-3">
                    New Employee
                </button>
            </a>
        </div>
        <table class = "table table-secondary table-striped table-hover">
            <tr>
                <th> No. </th>
                <th> Employee ID </th>
                <th> Employee Name </th>
                <th> Department </th>
                <th> Designation </th>
                <th> Action </th>
            </tr>
            <cfset No = 0>
            <cfloop query = "all_employees">
            <cfset No = No + 1>
            <tr>
                <td> #No# </td>
                <td> #id# </td>
                <td> #name# </td>
                <td> #department# </td>
                <td> #designation# </td>
                <td> <a href="Employee.cfm?edit=#id#">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                            <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                            <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                        </svg> 
                    </a> </td>
            </tr>
            </cfloop>
        </table>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">