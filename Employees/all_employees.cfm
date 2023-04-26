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
            where emp.department = dep.department_id and emp.designation = des.designation_id and (emp.leaving_date IS NULL or emp.leaving_date = "")
        </cfquery>
        <cfquery name = "previous_employees">
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
                <button type = "button" onclick="displayPreviousEmployees();" class = "btn btn-outline-dark create_button mb-3 custom_button">
                    Previous Employees
                </button>
            </a>
            <a target = "_self" id='present' style="display: none;">
                <button type = "button" onclick="displayEmployees();" class = "btn btn-outline-dark create_button mb-3 custom_button">
                    Active Employees
                </button>
            </a>
        </div>
        <div id="present_employees" style="display: inline;">
            <div class="text-center mb-5">
                <h3 class="box_heading">Active Employees</h3>
            </div>
            <cfparam name="pageNum" default="1">
            <cfset maxRows = 5>
            <cfset startRow = min( ( pageNum-1 ) * maxRows+1, max( all_employees.recordCount,1 ) )>
            <cfset endRow = min( startRow + maxRows-1, all_employees.recordCount )>
            <cfset totalPages = ceiling( all_employees.recordCount/maxRows )>
            <cfset loopercount = ceiling( all_employees.recordCount/maxRows )>
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
                    <cfloop query = "all_employees" startrow="#startRow#" endrow="#endRow#">
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
            <!---        Pageination code start      --->
            <div class="d-flex justify-content-end">
                <cfif structKeyExists(url, "pageNum")>
                    <cfif "#url.pageNum#" lte looperCount>
                        <cfif "#url.pageNum#" lt looperCount>
                            <a href="?pageNum=#url.pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #url.pageNum#</span>
                        <cfif "#url.pageNum#" gt 1>
                            <a href="?pageNum=#url.pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                    </cfif>
                <cfelse>
                    <cfset pageNum = 1>
                    <cfif "#pageNum#" lt looperCount>
                        <cfif "#pageNum#" lte looperCount>
                            <a href="?pageNum=#pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #pageNum#</span>
                        <cfif "#pageNum#" gt 1>
                            <a href="?pageNum=#pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                    </cfif>
                </cfif>
            </div>
        <!---      Pagination End        --->
        </div>
        <div id="previous_employees" style="display: none;">
            <div class="text-center mb-5">
                <h3 class="box_heading">Previous Employees</h3>
            </div>
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
                    <cfloop query = "previous_employees">
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
    function displayPreviousEmployees(){
        document.getElementById('previous_employees').style.display='inline';
        document.getElementById('present_employees').style.display='none';
        document.getElementById('left').style.display='none';
        document.getElementById('present').style.display='inline';
    }
    function displayEmployees(){
        document.getElementById('previous_employees').style.display='none';
        document.getElementById('present_employees').style.display='inline';
        document.getElementById('present').style.display='none';
        document.getElementById('left').style.display='inline';
    }
</script>
 