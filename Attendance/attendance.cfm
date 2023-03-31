<cfoutput>
<cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, "loggedIn")>
        <cfquery name = "get_employees"> <!--- to print All employees list --->
            select concat(employee_id,' | ',first_name,' ', middle_name, ' ', last_name) as name , employee_id
            from employee
        </cfquery>
        <cfif structKeyExists(form, "month")>
            <cfquery name = "attendance_sheet">
                select * 
                from attendance
                where month(date) = "#form.month#" 
                and employee_id = "#form.employee_id#"
            </cfquery>
            <cfquery name="working_group">
                select b.*, a.employee_id
                from payroll.employee a, payroll.working_days b
                where employee_id = "#form.employee_id#" And b.group_id = a.workingdays_group;
            </cfquery>
        </cfif>
<!--- |________________________________\|/_Front End _\|/________________________________|--->
        <div class="employee_box">
            <h3 class="mb-5 box_heading text-center"> ATTENDANCE SHEET </h3>
            <form name="attendance_sheet_form" action = "" onsubmit="return formValidate();" method = "post">
                <cfset current_date = dateFormat(now(), 'yyyy-mm-dd') > 
                <div class = "row m-4">
                    <div class = "col-md-3">
                        Select Month :
                        <select name = "month" id="month" class = "form-select">
                            <cfloop from = "1" to="12" index="i">
                                <option value = "#i#"> #monthAsString(i)# </option>
                            </cfloop>
                        </select>
<!---                         From Date: <input type = "date"  class = "form-control" name = "date" value = "#current_date#"> --->
                    </div>
                    <div class = "col-md-6">
                        Select Employee:
                            <select class = "form-select" name = "Employee_id" id="Employee_id" required="true"> 
                                <option value = ''> -- Select Employee -- </option> 
                                <cfloop query="get_employees">
                                    <option value = "#employee_id#"> #name# </option>
                                </cfloop>
                            </select>
                    </div>
                    <div class = "col-md-3">
                        <input type = "submit" class = "btn btn-outline-dark mt-4" value = "Search">
                    </div>
                </div>    
            </form>
        </div>
        <cfif structKeyExists(form, "employee_id")>
            <cfquery name = "get_employee">
                select *, concat(first_name,' ', middle_name, ' ', last_name) as name 
                from employee
                where employee_id = "#form.employee_id#"
            </cfquery>
            <div class="employee_box">
                <div style="display: flex; justify-content: space-between;">
                    <p style = "font-weight:bold;"> Employee Id: <u> #get_employee.employee_id# </u> </p>
                    <p style = "font-weight:bold;"> Attendance Month: <u>#monthAsString(form.month)#</u> </p>
                </div>
                <p style = "font-weight:bold;"> Employee Name: <u> #get_employee.name# </u> </p>
                <p style = "font-weight:bold;"> CNIC: <u> #get_employee.cnic# </u> </p>
                <div style="overflow-x: auto;">
                    <table class = "table custom_table">
                        <tr>
                            <th> Date </th>
                            <th> Time In </th>
                            <th> Time Out </th>
                            <th> Total Time </th>
                            <th> Required Time </th>
                            <th> Actual Time </th>
                            <th> Short/Exceed Time </th>
                            <th> Status  </th>
                        </tr>
                        <cfloop query="attendance_sheet">
                            <cfset date = dateFormat("#date#","yyyy,mm,dd")>
                            <cfset day = dayOfWeek(date)>
                            <tr>
                                <cfif time_in eq ''>
                                    <cfset var_time_in = 'Not Found'>
                                <cfelse>
                                    <cfset var_time_in = #LSTimeFormat("#time_in#")# >
                                </cfif>
                                <cfif time_out eq ''>
                                    <cfset var_time_out = 'Not Found'>
                                <cfelse>
                                    <cfset var_time_out = #LSTimeFormat("#time_out#")#>
                                </cfif>
                                <td> #dateFormat("#date#", 'dd-mm-yyyy')# </td>
                                <td> #var_time_in#</td>
<!---                                 <cfdump  var="#time_out#"><cfabort> --->
                                <td> #var_time_out#</td>
                                    <!--- Variabls for Calculation --->
                                    <cfif var_time_out eq 'Not Found'>
                                        <cfset total_time = 0>
                                        <cfset total_hours = 0>
                                        <cfset total_Minutes = 'Not Found'>
                                        <cfset required_hours = 0>
                                        <cfset required_Minutes = 'Not Found'>
                                        <cfset actual_hours = 0>
                                        <cfset actual_Minutes = 'Not Fount'>
                                        <cfset extra_hours = 0>
                                        <cfset extra_Minutes = 'Not Fount'>
                                    <cfelse>
                                        <cfset total_time = dateDiff("n", #var_time_in#, #var_time_out#) > 
                                        <cfset total_hours = total_time / 60> 
                                        <cfset total_Minutes = total_time mod 60>
                                        <cfif day eq '6'>
                                            <cfset required_time = dateDiff("n", "#working_group.friday_time_in#" , "#working_group.friday_time_out#")>
                                        <cfelse>
                    <!---              <cfset required_time = 490> <!--- Required time temporary static ---> --->
                                            <cfset required_time = datediff("n", working_group.time_in , working_group.time_out)>
                                        </cfif>
                                        <cfset break_time = "#working_group.break_time#"> <cfset required_hours = required_time / 60> 
                                        <cfset required_Minutes = required_time mod 60>
                                        <cfset extra_time = #total_time# - #required_time#> 
                                        <cfset extra_hours = extra_time / 60> 
                                        <cfset extra_Minutes = extra_time mod 60>
                                            <cfif extra_hours lt 0 and extra_Minutes neq 0> <!--- Condition to check if hours are negative, if only 1 Minutes exist with the negative hour then one our should be ignored--->
                                                <cfset extra_hours = extra_hours + 1 >
                                            </cfif>
                                        <cfset actual_time = #total_time# - #break_time#> 
                                        <cfset actual_hours = actual_time/60> <cfset actual_Minutes = actual_time mod 60>
                                    </cfif>
                                <td> #int(total_hours)# Hours #total_Minutes# Minutes </td>
                                <td> #int(required_hours)# Hours #required_Minutes# Minutes </td>
                                <td> #int(actual_hours)# Hours #actual_Minutes# Minutes </td>
                                <cfif var_time_out eq 'Not Found'>
                                    <td> Not Found</td>
                                <cfelse>
                                    <td <cfif (extra_hours lt 0 or extra_Minutes lt 0) and (extra_hours lt 0 or extra_Minutes lt -15)> style = "color:red;" <cfelse> style = "color:green;"</cfif>> 
                                        #int(extra_hours)# Hours #extra_Minutes# Minutes 
                                        </td>
                                </cfif>
                                <cfif isDefined('extra_time') And extra_time lt 0>
                                    <td>Short Time</td>
                                <cfelse>
                                    <td> Present </td> <!--- will be dynamic --->
                                </cfif>
                            </tr>
                        </cfloop>
                    </table>
                </div>
            </div>
        </cfif>
    </cfif>
</cfoutput>
<script>
    function formValidate(){
        var month = $('#month').val();
        var employee_id = $('#Employee_id').val();
        if(month == '' || employee_id == ''){
            alert("All Fields Must Be Filled Out.");
            return false;
        }else{
            return true;
        }
    }
</script>
<cfinclude  template="..\includes\foot.cfm">