<!---<cfif structKeyExists(url, 'delete')> onLoad="noBack();" onpageshow="if (event.persisted) noBack();" onUnload="" </cfif>--->
<cfinclude  template="head.cfm">
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
            where is_deleted != "Y"
        </cfquery>
        <cfif all_departments.recordcount eq 0>
            <h1> 
                No Departments! Please Create Some <a href = "department.cfm" > <button class = "btn btn-primary cls_btn"> Create department </button> </a>
            </h1>
        <cfelse>
            <!--- Front End --->
            <table class = "table table-info table-striped table-hover">
                <tr>
                    <th> ID </th>
                    <th> Department Name </th>
                    <th> Description</th>
                    <th> Action </th>
                </tr>
                <cfloop query = "all_departments">
                    <cfquery name = employees_department> <!--- Query Will return data of employee that have this department --->
                        select department from employee
                        where department = '#department_id#'
                    </cfquery>
                    <tr>
                        <td> #department_id# </td>
                        <td> #department_name# </td>
                        <td> #description# </td>
                        <td> 
                            <cfif employees_department.recordcount eq 0> <!--- If any Employee have this Department then delete not allowed ---> 
                                <a href="department.cfm?edit=#department_id#"><button type = "button"> edit </button> </a> 
                                <button type = "button" onclick = "javascript:confirmDelete(#department_id#);"> delete </button> 
                            <cfelse>
                                None
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
            </table>
        </cfif>
    </cfif>
</cfoutput>
<cfinclude  template="foot.cfm">
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
