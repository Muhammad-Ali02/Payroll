<cfoutput>
    <cfinclude  template="head.cfm">
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
                No Deduction! Please Add Some <a href = "deduction.cfm" > <button class = "btn btn-primary cls_btn"> Add Deduction </button> </a>
            </h1>
        <cfelse>
                <cfif structKeyExists(url, 'deleted')>
                    <h1 class = "text-danger"> Deduction Deleted </h1>
                </cfif>
            <table class = "table table-warning table-striped table-hover">
                <tr>
                    <th> ID </th>
                    <th> Deduction Name </th>
                    <th> Deduction Amount </th>
                    <th> Action </th>
                </tr>
                <cfloop query = "all_Deduction">
                <tr>
                    <cfquery name = employees_deduction> <!--- query will return something if any of employee having this deduction  --->
                        select employee_id from employee_deduction
                        where deduction_id = '#deduction_id#' and status = "Y"
                    </cfquery>
                    <td> #Deduction_id# </td>
                    <td> #Deduction_Name# </td>
                    <td> #Deduction_Amount# </td>
                    <td> <a href="Deduction.cfm?edit=#Deduction_id#"> edit </a> 
                        <cfif employees_deduction.recordcount eq 0> <!--- If any Employee have this deduction then delete not allowed ---> 
                            <button type = "button" onclick = "javascript:confirmDelete(#deduction_id#);"> Delete </button> 
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
<cfinclude  template="foot.cfm">