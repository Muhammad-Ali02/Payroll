<cfoutput>
<cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, "loggedIn")>
        <cfquery name = "get_employees"> <!--- to print All employees list --->
            select concat(employee_id,' | ',first_name,' ', middle_name, ' ', last_name) as name , employee_id
            from employee
        </cfquery>
        <cfif structKeyExists(form, "date")>
            <cfquery name = "attendance_sheet">
                select * 
                from attendance 
                where attendance.date >= "#form.date#" 
                and employee_id = "#form.employee_id#"
            </cfquery>
        </cfif>
<!--- |________________________________\|/_Front End _\|/________________________________|--->
        <h1 style = "text-align: center; color: blue;"> ATTENDANCE SHEET </h1>
        <form action = "attendance.cfm" method = "post">
            <cfset current_date = dateFormat(now(), 'yyyy-mm-dd') > 
            <div class = "row mb-4">
                <div class = "col-md-3">
                    From Date: <input type = "date"  class = "form-control" name = "date" value = "#current_date#">
                </div>
                <div class = "col-md-4">
                    Select Employee:
                        <select class = "form-select" name = "Employee_id" required="true"> 
                            <option disabled> Select Employee </option> 
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
        <cfif structKeyExists(form, "employee_id")>
            <cfquery name = "get_employee">
                select *, concat(first_name,' ', middle_name, ' ', last_name) as name 
                from employee
                where employee_id = "#form.employee_id#"
            </cfquery>
            <p style = "color: green; font-weight:bold;"> Employee Id: <u> #get_employee.employee_id# </u> </p>
            <p style = "color: green; font-weight:bold;"> Employee Name: <u> #get_employee.name# </u> </p>
            <p style = "color: green; font-weight:bold;"> CNIC: <u> #get_employee.cnic# </u> </p>
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
                    <tr>
                        <td> #dateFormat("#date#", 'dd-mm-yyyy')# </td>
                        <td> #LSTimeFormat("#time_in#")#</td>
                        <td> #LSTimeFormat("#time_out#")# </td>
                            <!--- Variabls for Calculation --->
                            <cfset total_time = dateDiff("n", #time_in#, #time_out#) > <cfset total_hours = total_time / 60> <cfset total_Minutes = total_time mod 60>
                            <cfset required_time = 490> <!--- Required time temporary static --->
                            <cfset break_time = 50> <cfset required_hours = required_time / 60> <cfset required_Minutes = required_time mod 60>
                            <cfset extra_time = #total_time# - #required_time# - #break_time# >  <cfset extra_hours = extra_time / 60> <cfset extra_Minutes = extra_time mod 60>
                                <cfif extra_hours lt 0 and extra_Minutes neq 0> <!--- Condition to check if hours are negative, if only 1 Minutes exist with the negative hour then one our should be ignored--->
                                    <cfset extra_hours = extra_hours + 1 >
                                </cfif>
                            <cfset actual_time = #total_time# - #break_time#> <cfset actual_hours = actual_time/60> <cfset actual_Minutes = actual_time mod 60>
                        <td> #int(total_hours)# Hours #total_Minutes# Minutes </td>
                        <td> #int(required_hours)# Hours #required_Minutes# Minutes </td>
                        <td> #int(actual_hours)# Hours #actual_Minutes# Minutes </td>
                        <td <cfif (extra_hours lt 0 or extra_Minutes lt 0) and (extra_hours lt 0 or extra_Minutes lt -15)> style = "color:red;" <cfelse> style = "color:green;"</cfif>> 
                        #int(extra_hours)# Hours #extra_Minutes# Minutes 
                        </td>
                        <td> Present </td> <!--- will be dynamic --->
                    </tr>
                </cfloop>
            </table>
        </cfif>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">