<cfoutput>
     
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- Back End --->
        <cfquery name = "all_Deduction"> <!--- get all deductions to display on front end --->
            select * from Deduction
            where is_deleted != 'Y'
        </cfquery>
        <cfif structKeyExists(url, 'delete')>
            <cfquery name = "get_employee">
                select employee_id
                from employee_deduction
                where deduction_id = '#url.delete#'
            </cfquery>
            <cfif get_employee.recordcount eq 0> <!--- if employee not found in this designation then update --->
                <cfquery name = "update_deduction">
                    update deduction
                    set is_deleted = "Y" , deleted_by = '#session.loggedin.username#', deleted_date = now()
                    where deduction_id = '#url.delete#'
                </cfquery>
                <h4> Deduction Deleted </h4>
                <cflocation  url="all_deduction.cfm?deleted=true">
            <cfelse>
                Sorry! Can't Delete This Deduction.
            </cfif>
        </cfif>
        <cfquery name = "all_deduction">
            select * 
            from deduction
            where is_deleted != "Y" or is_deleted = "N" or (is_deleted is null or is_deleted = '')
        </cfquery>
        <cfif all_deduction.recordcount eq 0> <!--- If All deductions Deleted or Not Found Show a message otherwise print table of all designations --->
            <h1> 
                No Deduction! Please Add Some <a href = "deduction.cfm" > <button class = "btn btn-outline-dark custom_button"> Add Deduction </button> </a>
            </h1>
        <cfelse>
            <!--- _______________________ Front End __________________________  --->
            <cfif structKeyExists(url, 'deleted')>
                <h1 class = "text-danger"> Deduction Deleted </h1>
            </cfif>
            <cfif structKeyExists(url, 'updated')>
                <p class = "text-success" style = "text-align:center; font-weight:bold;"> *Deduction Updated Successfuly <p>
            <cfelseif structKeyExists(url, 'created')>
                <p class = "text-success" style = "text-align:center; font-weight:bold;"> *New Deduction Created Successfuly <p>
            </cfif>
            <div class="text-center mb-5">
                <h3 class="box_heading">Manage Deductions</h3>
            </div>
            <a href = "deduction.cfm">
                <button type = "button" class = "btn btn-outline-dark mb-3 custom_button">
                    Create New Deduction
                </button>
            </a>
            <table class = "table custom_table">
                <tr>
                    <th> No. </th>
                    <th> ID </th>
                    <th> Deduction Name </th>
                    <th> Deduction Amount </th>
                    <th> Action </th>
                </tr>
                <cfset No = 0 >
                <cfloop query = "all_Deduction">
                <cfset No = No + 1>
                <cfquery name = employees_deduction> <!--- query will return something if any of employee having this deduction  --->
                    select employee_id from employee_deduction
                    where deduction_id = '#deduction_id#' and status = "Y"
                </cfquery>
                <tr>
                    <td> #No# </td>
                    <td> #Deduction_id# </td>
                    <td> #Deduction_Name# </td>
                    <td> #Deduction_Amount# </td>
                    <td><a href="Deduction.cfm?edit=#Deduction_id#">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                            </svg>
                        </a> 
                        <cfif employees_deduction.recordcount eq 0> <!--- If any Employee have this deduction then delete not allowed ---> 
                            <a href = "##" class = "delete_button" onclick = "javascript:confirmDelete(#deduction_id#);">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
                                    <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5ZM11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H2.506a.58.58 0 0 0-.01 0H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1h-.995a.59.59 0 0 0-.01 0H11Zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5h9.916Zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47ZM8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5Z"/>
                                </svg>
                            </a> 
                        </cfif>
                    </td>
                </tr>
                </cfloop>
            </table>
            <script>
                    <!--- This Function will generate Confirm Alert when delete Button Clicked --->
                    function confirmDelete(id){
                            var confirmMessage = confirm("Delete Permanentaly?");
                        if (confirmMessage == true){
                            window.location.href = "all_deduction.cfm?delete="+id;
                        }
                        else{
                            window.location.href = "all_deduction.cfm";
                        }
                    }
            </script>
        </cfif>
    </cfif>
</cfoutput>
 