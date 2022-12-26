<cfoutput>
    <cfinclude  template="head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfquery name = "all_designation">
            select * from designation
        </cfquery>
        <cfif structKeyExists(url, 'delete')>
            <cfquery name = "get_employee">
                select designation
                from employee
                where designation = '#url.delete#'
            </cfquery>
            <cfif get_employee.recordcount eq 0> <!--- if employee not found in this designation then update --->
                <cfquery>
                    update designation
                    set is_deleted = "Y" , deleted_by = '#session.loggedin.username#', deleted_date = now()
                    where designation_id = '#url.delete#'
                </cfquery>
                <h4> Designation Deleted </h4>
                <cflocation  url="all_designation.cfm?deleted=true">
            <cfelse>
                Sorry! Can't Delete This Designation.
            </cfif>
        </cfif>
        <cfquery name = "all_designation">
            select * 
            from designation
            where is_deleted != "Y" or (is_deleted is null or is_deleted = '')
        </cfquery>
        <cfif all_designation.recordcount eq 0> <!--- If All Designation Deleted or Not Found Show a message otherwise print table of all designations --->
            <h1> 
                No Designation! Please Add Some <a href = "designation.cfm" > <button class = "btn btn-primary cls_btn"> Add Designation </button> </a>
            </h1>
        <cfelse>
            <!--- Front End --->
            <table class = "table table-info table-striped table-hover">
                <tr>
                    <th> ID </th>
                    <th> Designation Title </th>
                    <th> Short Word </th>
                    <th> Basic Salary </th>
                    <th> Action </th>
                </tr>
                <cfloop query = "all_designation">
                    <cfquery name = employees_designation> <!--- Query Will return data of employee that have this Designation --->
                        select designation from employee
                        where designation = '#designation_id#'
                    </cfquery>
                    <tr>
                        <td> #designation_id# </td>
                        <td> #designation_title# </td>
                        <td> #short_word# </td>
                        <td> #basic_salary# </td>
                        <td> 
                                <a href="designation.cfm?edit=#designation_id#"><button type = "button"> Edit </button> </a> 
                            <cfif employees_designation.recordcount eq 0> <!--- If any Employee have this Designation then delete not allowed ---> 
                                <button type = "button" onclick = "javascript:confirmDelete(#designation_id#);"> Delete </button> 
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
                        window.location.href = "all_designation.cfm?delete="+id;
                    }
                    else{
                        window.location.href = "all_designation.cfm";
                    }
                }
            </script>
        </cfif>
    </cfif>
</cfoutput>
<cfinclude  template="foot.cfm">