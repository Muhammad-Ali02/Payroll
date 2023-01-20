<!---<cfif structKeyExists(url, 'delete')> onLoad="noBack();" onpageshow="if (event.persisted) noBack();" onUnload="" </cfif>--->
<cfinclude  template="..\includes\head.cfm">
<cfoutput>
    <cfif structKeyExists(session, 'loggedIn')>
        <cfif structKeyExists(url, 'delete')>
            <cfquery name = "get_employee">
                select department
                from employee
                where department = '#url.delete#'
            </cfquery>
            <cfif get_employee.recordcount eq 0>
                <cfquery>
                    update department
                    set is_deleted = "Y" , deleted_by = '#session.loggedin.username#', deleted_date = now()
                    where department_id = '#url.delete#'
                </cfquery>
                <h4> Department Deleted </h4>
                <!---                  
                <script type="text/javascript"> <!--- if work... Browser Back button Not allowed ....but still not working --->
                    window.history.forward();
                    function noBack()
                    {
                        window.history.forward();
                    }
                </script> --->
                <cflocation  url="all_departments.cfm?deleted=true">
            <cfelse>
                Sorry! Can't Delete This Department.
            </cfif>
        </cfif>
        <cfquery name = "all_departments">
            select * from department
            where is_deleted <> "Y" or is_deleted is null 
        </cfquery>
        <cfif all_departments.recordcount eq 0>
            <h1>
                No Departments! Please Create Some <a href = "department.cfm" > <button class = "btn btn-primary cls_btn"> Create department </button> </a>
            </h1>
        <cfelse>
            <!--- Front End --->
            <cfif structKeyExists(url, 'updated')>
                <p class = "text-success" style = "text-align:center; font-weight:bold;"> *Department Updated Successfuly <p>
            <cfelseif structKeyExists(url, 'created')>
                <p class = "text-success" style = "text-align:center; font-weight:bold;"> *New Department Created Successfuly <p>
            </cfif>
            <a href = "department.cfm">
                <button type = "button" class = "btn btn-outline-dark mb-3 custom_button">
                    Create New Department
                </button>
            </a>
            <table class = "table table-secondary table-striped table-hover">
                <tr>
                    <th> No. </th>
                    <th> ID </th>
                    <th> Department Name </th>
                    <th> Description</th>
                    <th> Action </th>
                </tr>
                <cfset No = 0>
                <cfloop query = "all_departments">
                    <cfset No = No + 1>
                    <cfquery name = employees_department> <!--- Query Will return data of employee that have this department --->
                        select department from employee
                        where department = '#department_id#'
                    </cfquery>
                    <tr>
                        <td> #No# </td>
                        <td> #department_id# </td>
                        <td> #department_name# </td>
                        <td> #description# </td>
                        <td>
                                <a href="department.cfm?edit=#department_id#">
                                    <button type = "button" class = "btn btn-outline-secondary"> 
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                                            <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                            <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                                        </svg>
                                    </button> 
                                </a> 
                            <cfif employees_department.recordcount eq 0> <!--- If any Employee have this Department then delete not allowed ---> 
                                <button class = "btn btn-outline-danger" type = "button" onclick = "javascript:confirmDelete(#department_id#);">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
                                        <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5ZM11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H2.506a.58.58 0 0 0-.01 0H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1h-.995a.59.59 0 0 0-.01 0H11Zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5h9.916Zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47ZM8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5Z"/>
                                    </svg> 
                                </button>
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
            </table>
        </cfif>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">
         <script>
            <!--- This Function will generate Confirm Alert when delete Button Clicked --->
            function confirmDelete(id){
                    var confirmMessage = confirm("Delete Permanentaly?");
                if (confirmMessage == true){
                    window.location.href = "all_departments.cfm?delete="+id;
                }
                else{
                    window.location.href = "all_departments.cfm";
                }
            }
        </script>
