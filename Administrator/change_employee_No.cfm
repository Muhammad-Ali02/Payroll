<cfoutput>
     
        <cfif isDefined('form.new_emp_No')>
            <cfquery name="get_employee_id">
                SELECT employee_id FROM payroll.employee
                where employee_id = <cfqueryparam value="#form.new_emp_No#">;
            </cfquery>
            <cfif get_employee_id.recordcount eq 0>
                <cfquery name="get_table">
                    SELECT table_name, COLUMN_NAME
                    FROM information_schema.columns
                    WHERE (column_name = 'employee_id' or COLUMN_NAME = 'user_name') and table_schema = 'payroll' and table_name not like '%_audit';
                </cfquery>
                <cfset is_exception = false>
                <cftransaction>
                    <cfloop query="get_table">
                        <cftry>
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
                        <cfcatch type="any">
                            <cfset is_exception = true>
                            <cfdump  var="#get_table.table_name# :#cfcatch.cause.message# ">
                             <br>
                        </cfcatch>
                        </cftry>
                    </cfloop>
                    <cfif is_exception eq false>
                        <script>
                            alert("Employee Id update successfully.");
                        </script>
                    </cfif>
                </cftransaction>
    <!---             <cfdump  var="#updateId#"> --->
    <!---             <cfabort> --->
            <cfelse>
                <script>
                    alert("Employee Id already exist. Please try again with an unique Employee Id.");
                </script>
            </cfif>
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
            <div class="d-flex flex-wrap">
                <form action="" method="post" name="Change_Employee_Name">
                    <div class="row" style="color: rgb(255, 255, 255,0.7);">
                        <div class="col-lg-1"></div>
                        <div class="col-lg-5 mb-1">
                            <span class="ml-1"> Select Employee </span>
                            <select class="form-select" onfocus='this.size=5;' onblur='this.size=1;' onchange='this.size=1; this.blur();' name="old_Id" id="select_employee" >
                                <option value=""> -- Select Employee -- </option> 
                                <cfloop query="get_employees">
                                    <option value = "#employee_id#"> #name# </option>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col-lg-3 mb-1">
                            <span class="ml-1"> Employee No </span> 
                            <input onkeyup="empolyee_id_validate();" type="text" name="new_emp_No" id="new_emp_No" class="form-control">
                        </div>
                        <div class="col-lg-3 mt-4">
                            <input type="submit" value="Change" class="btn custom_button" onclick="return formvalidate();">
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
        function empolyee_id_validate(){
                let new_emp_No = $('##new_emp_No').val();
                const regex = /^[a-zA-Z0-9_/()@\-|]+$/;
                if(regex.test(new_emp_No) == false){
                    alert('You can enter only folowing special characters @ , / , | , ( , ) , - , _  And Spaces are not allowed');
                    $('##new_emp_No').focus();
                    return false;
                }
            }
        function formvalidate(){
            let old_id = document.forms["Change_Employee_Name"]["select_employee"].value;
            let new_id = document.forms["Change_Employee_Name"]["new_emp_No"].value;
            let new_emp_No = $('##new_emp_No').val();
            const regex = /^[a-zA-Z0-9_/()@\-|]+$/;
            if( (old_id == "") || (new_id == "")){
                alert("All field must be filled out!");
                return false;
            }
            if(regex.test(new_emp_No) == false){
                alert('You can enter only folowing special characters @ , / , | , ( , ) , - , _  And Spaces are not allowed');
                return false;
            }
        }
    </script>
     
</cfoutput>