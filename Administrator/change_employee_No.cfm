<cfoutput>
    <cfinclude  template="\includes\head.cfm">
        <cfif isDefined('form.new_emp_No')>
            <cfquery name="get_table">
                SELECT table_name, COLUMN_NAME
                FROM information_schema.columns
                WHERE column_name = 'employee_id' or COLUMN_NAME = 'user_name' and table_schema = 'payroll';
            </cfquery>
<!---              <cfdump  var="#get_table#">  <cfabort> --->
            <cfloop query="get_table">
                <cfif "#get_table.COLUMN_NAME#" eq "user_name">
                    <cfquery name="update_emp_id" result="updateId">
                        Update #table_name#
                        set user_name = <cfqueryparam value="#form.new_emp_No#">
                        where user_name = <cfqueryparam value="#form.old_Id#">
                    </cfquery>
                <cfelse>
                    <cfquery name="update_emp_id" result="updateId">
                        Update #table_name#
                        set employee_id = <cfqueryparam value="#form.new_emp_No#">
                        where employee_id = <cfqueryparam value="#form.old_Id#">
                    </cfquery>
                </cfif>
            </cfloop>
<!---             <cfdump  var="#updateId#"> --->
<!---             <cfabort> --->
            <script>
                alert("Employee Id update successfully.");
            </script>
        </cfif>
        <cfquery name = "get_employees"> <!--- to print All employees list --->
            select concat(employee_id,' | ',first_name,' ', middle_name, ' ', last_name) as name , employee_id
            from employee
        </cfquery>
    <div class="w-100">
        <div class="employee_box">
            <div class="d-flex justify-content-center">
                <h3 class="mb-4 box_heading"> Change Employee No </h3>
            </div>
            <div class="d-flex">
                <form action="" method="post" name="Change_Employee_Name">
                    <div class="row" style="color: rgb(255, 255, 255,0.7);">
                        <div class="col-md-1"></div>
                        <div class="col-md-5 mb-1">
                            <span class="ml-1"> Select Employee </span>
                            <select class="form-select" name="old_Id" id="select_employee" >
                                <option value=""> -- Select Employee -- </option> 
                                <cfloop query="get_employees">
                                    <option value = "#employee_id#"> #name# </option>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col-md-3 mb-1">
                            <span class="ml-1"> Employee No </span> 
                            <input type="text" name="new_emp_No" id="emp_No" class="form-control">
                        </div>
                        <div class="col-md-3 mt-4">
                            <input type="submit" value="Change" class="btn custom_button" onclick="return formvalidate();">
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
        function formvalidate(){
            let old_id = document.forms["Change_Employee_Name"]["select_employee"].value;
            let new_id = document.forms["Change_Employee_Name"]["new_emp_No"].value;
            if( (old_id == "") || (new_id == "")){
                alert("All field must be filled out!");
                return false;
            }
        }
    </script>
    <cfinclude  template="\includes\foot.cfm">
</cfoutput>