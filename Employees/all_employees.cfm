<cfoutput>
     
    <cfif structKeyExists(session, 'loggedIn')>
        <script>
            <cfif structKeyExists(url, 'edited')>
                alert("Employee Information Updated Successfully");
            <cfelseif structKeyExists(url, 'created')>
                alert("Employee Created Successfully")
            </cfif>
        </script>
        <cfquery name = "all_employees">
            select emp.employee_id as id, concat(emp.first_name," ",emp.middle_name," ",emp.last_name) as name, dep.department_name as department, des.designation_title as designation
            from employee emp, designation des, department dep
            where emp.department = dep.department_id and emp.designation = des.designation_id and emp.leaving_date = ""
        </cfquery>
        <cfquery name = "left_employees">
            select emp.employee_id as id, concat(emp.first_name," ",emp.middle_name," ",emp.last_name) as name, dep.department_name as department, des.designation_title as designation, emp.leaving_date as leaving_date
            from employee emp, designation des, department dep
            where emp.department = dep.department_id and emp.designation = des.designation_id and emp.leaving_date <> ""
        </cfquery>
        <div>
            <a href = "employee.cfm" target = "_self">
                <button type = "button" class = "btn btn-outline-dark create_button mb-3 custom_button">
                    New Employee
                </button>
            </a>
            <a target = "_self" id='left' style="display: inline;">
                <button type = "button" onclick="displayLeftEmployees();" class = "btn btn-outline-dark create_button mb-3 custom_button">
                    Former Employees
                </button>
            </a>
            <a target = "_self" id='present' style="display: none;">
                <button type = "button" onclick="displayEmployees();" class = "btn btn-outline-dark create_button mb-3 custom_button">
                    Active Employees
                </button>
            </a>
        </div>
        <div id="present_employees" style="display: inline;">
            <div style="overflow-x: auto; margin-bottom: 20px;">
                <table class = "table custom_table">
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
                                </a> 
                            </td>
                        </tr>
                    </cfloop>
                </table>
            </div>
        </div>
        <div id="left_employees" style="display: none;">
            <div style="overflow-x: auto;">
                <table class = "table custom_table">
                    <tr>
                        <th> No. </th>
                        <th> Employee ID </th>
                        <th> Employee Name </th>
                        <th> Department </th>
                        <th> Designation </th>
                        <th> Leaving Date </th>
                        <th> Action </th>
                    </tr>
                    <cfset No = 0>
                    <cfloop query = "left_employees">
                        <cfset No = No + 1>
                        <tr>
                            <td> #No# </td>
                            <td> #id# </td>
                            <td> #name# </td>
                            <td> #department# </td>
                            <td> #designation# </td>
                            <td> #leaving_date# </td>
                            <td> <a href="Employee.cfm?edit=#id#">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                                        <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                        <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                                    </svg> 
                                </a> 
                            </td>
                        </tr>
                    </cfloop>
                </table>
            </div>
        </div>
    </cfif>
</cfoutput>
<script>
    function displayLeftEmployees(){
        document.getElementById('left_employees').style.display='inline';
        document.getElementById('present_employees').style.display='none';
        document.getElementById('left').style.display='none';
        document.getElementById('present').style.display='inline';
    }
    function displayEmployees(){
        document.getElementById('left_employees').style.display='none';
        document.getElementById('present_employees').style.display='inline';
        document.getElementById('present').style.display='none';
        document.getElementById('left').style.display='inline';
    }
</script>
 