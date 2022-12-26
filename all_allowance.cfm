<cfoutput>
    <cfinclude  template="head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfquery name = "all_Allowances">
            select * from allowance
            where is_deleted != "Y" or is_deleted is null
        </cfquery>
        <cfif structKeyExists(url, 'delete')>
            <cfquery name = "get_employee">
                select employee_id
                from employee_allowance
                where allowance_id = '#url.delete#'
            </cfquery>
            <cfif get_employee.recordcount eq 0> <!--- if employee not found in this designation then update --->
                <cfquery name = "update_allowance">
                    update allowance
                    set is_deleted = "Y" , deleted_by = '#session.loggedin.username#', deleted_date = now()
                    where allowance_id = '#url.delete#'
                </cfquery>
                <h4> Allowance Deleted </h4>
                <cflocation  url="all_allowance.cfm?deleted=true">
            <cfelse>
                Sorry! Can't Delete This Allowance.
            </cfif>
        </cfif>
        <cfquery name = "all_allowance">
            select * 
            from allowance
            where is_deleted != "Y" or (is_deleted is null or is_deleted = '')
        </cfquery>
        <cfif all_allowance.recordcount eq 0> <!--- If All Allowance Deleted or Not Found Show a message otherwise print table of all designations --->
            <h1> 
                No Allowance! Please Add Some <a href = "allowance.cfm" > <button class = "btn btn-primary cls_btn"> Add Allowance </button> </a>
            </h1>
        <cfelse>
            <cfif structKeyExists(url, 'deleted')>
                <h1 class = "text-danger"> Allowance Deleted </h1>
            </cfif>
            <!--- Front End --->
            <table class = "table table-info table-striped table-hover">
                <tr>
                    <th> ID </th>
                    <th> Allowance Name </th>
                    <th> Allowance Amount </th>
                    <th> Description </th>
                    <th> Action </th>
                </tr>
                <cfloop query = "all_allowances">
                    <cfquery name = employees_allowance> <!--- query will return something if any of employee having this allowance  --->
                        select employee_id from employee_allowance
                        where allowance_id = '#allowance_id#' and status = "Y"
                    </cfquery>
                    <tr>
                        <td> #allowance_id# </td>
                        <td> #allowance_name# </td>
                        <td> #allowance_amount# </td>
                        <td> #description# </td>
                        <td> 
                            <a href="allowance.cfm?edit=#allowance_id#"><button type = "button"> Edit </button> </a> 
                            <cfif employees_allowance.recordcount eq 0> <!--- If any Employee have this Allowance then delete not allowed ---> 
                                <button type = "button" onclick = "javascript:confirmDelete(#allowance_id#);"> Delete </button> 
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
                        window.location.href = "all_allowance.cfm?delete="+id;
                    }
                    else{
                        window.location.href = "all_allowance.cfm";
                    }
                }
            </script>
        </cfif>
    </cfif>
</cfoutput>
<cfinclude  template="foot.cfm">