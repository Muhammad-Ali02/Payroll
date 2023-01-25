<cfoutput>
    <cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfif structKeyExists(url, 'edit_process_detail')>
            <!--- Query to get Employee for edit --->
            <cfquery name = "get_employee">
                select concat(emp.first_name,' ', emp.middle_name,' ', emp.last_name) as employee_name, emp.employee_id, des.designation_title as designation, emp.basic_salary
                from employee emp, designation des
                where emp.employee_id = "#url.edit_process_detail#" and des.designation_id = emp.designation
            </cfquery>
            <!--- Query to get current month of pay process  --->
            <cfquery name = "setting_info">
                select * from setup
            </cfquery>
            <!--- query to get pay status active or not --->
            <cfquery name = "get_pay_status">
                select pay_status
                from current_month_pay
                where employee_id = "#url.edit_process_detail#"
            </cfquery>
            <!--- get employee bank details --->
            <cfquery name = "get_bank_details">
                select bank_name as name, bank_account_no as account, payment_mode as mode
                from employee
                where employee_id = "#url.edit_process_detail#"
            </cfquery>
            <!--- Query used to get allowed allowances to an employee --->
            <cfquery name = "get_allowance">
                select b.allowance_name as name, a.allowance_amount as amount, b.allowance_id as id
                from pay_allowance a
                left join allowance b on b.allowance_id = a.allowance_id
                where a.employee_id = "#url.edit_process_detail#" and a.status = "Y"
            </cfquery>
            <!--- Query used to get included Deduction to an employee --->
            <cfquery name = "get_deduction">
                select b.deduction_name as name, a.deduction_amount as amount, b.is_percent as percent, b.deduction_id as id
                from pay_deduction a
                left join deduction b on b.deduction_id = a.deduction_id
                where a.employee_id = "#url.edit_process_detail#" and a.status = "Y"
            </cfquery>
            <!--- Query used to get Worked days of an employee --->
            <cfquery name = "day_count">
                select count(employee_id) as worked_days
                from attendance
                where employee_id = "#url.edit_process_detail#"
            </cfquery>
            <!--- Query used to get all Leave Days of an Employee --->
            <cfquery name = "leave_count">
                select count(a.employee_id) as leave_days, a.leave_id as id, b.leave_title as title
                from all_leaves a
                inner join leaves b on a.leave_id = b.leave_id 
                where a.employee_id = "#url.edit_process_detail#" 
                and a.action = "Approved"
                group by b.leave_id
            </cfquery>
            <!--- Query used to get all paid Leave Days of an Employee --->
            <cfquery name = "paid_leave_count">
                select count(a.employee_id) as leave_days
                from all_leaves a
                inner join leaves b on a.leave_id = b.leave_id 
                where a.employee_id = "#url.edit_process_detail#" 
                and a.action = "Approved" 
                and leave_type = "Paid"
            </cfquery>
            <!--- Query used to get all Hlaf Leave Days of an Employee --->
            <cfquery name = "half_paid_leave_count">
                select count(a.employee_id) as leave_days
                from all_leaves a
                inner join leaves b on a.leave_id = b.leave_id 
                where a.employee_id = "#url.edit_process_detail#" 
                and a.action = "Approved" 
                and leave_type = "halfPaid"
            </cfquery>
            <!--- Query used to get all non paid Leave Days of an Employee --->
            <cfquery name = "Non_paid_leave_count">
                select count(a.employee_id) as leave_days
                from all_leaves a
                inner join leaves b on a.leave_id = b.leave_id 
                where a.employee_id = "#url.edit_process_detail#" 
                and a.action = "Approved" 
                and leave_type = "NonPaid"
            </cfquery>
            <!--- Calculating Working Days of Current Month --->
            <cfquery name = "workingdays">
                SELECT a.sunday, a.monday, a.tuesday, a.wednesday, a.thursday, a.friday, a.saturday
                from working_days a
                inner join employee b on b.workingdays_group = a.group_id
                where b.employee_id = "#url.edit_process_detail#"
            </cfquery>
            <cfset firstDay = createDate(#setting_info.current_year#, #setting_info.current_month#, 1)>
            <cfset lastDay = createDate(#setting_info.current_year#, #setting_info.current_month#, daysInMonth(firstDay))> 
            <!--- Loop to check for working days of current month by comparing each date of month with the working days group's days --->
            <cfset working_days = 0>
                <cfloop from = "#day(firstDay)#" to = "#day(lastday)#" index = "i"> 
                    <cfset date = createDate(#setting_info.current_year#, #setting_info.current_month#, #i#)>
                    <cfset day_of_week = dayOfWeek(#date#)>
                        <cfif  evaluate("workingdays.#dayOfWeekAsString('#day_of_week#')#") eq 1.0 >
                            <cfset working_days = working_days + 1>
                        <cfelseif evaluate("workingdays.#dayOfWeekAsString('#day_of_week#')#") eq 0.5>
                            <cfset working_days = working_days + 0.5>
                        </cfif>
                </cfloop>
            <!--- Calculate Basic Rate Per Day using Basic Salary of Employee --->
            <cfset basic_rate = get_employee.basic_salary / working_days>
        <!---________________________________________________________Create/Update Front End _________________________________________________________--->
            <div class = "container mb-3">    
                <div class="row">
                    <div class = "col-8">
                        <p> Employee ID: #get_employee.employee_id# </p> 
                        <p> Employee Name: #get_employee.employee_name# </p> 
                        <p> Designation: #get_employee.designation# </p>
                    </div>
                    <div class = "col-4">
                        <p> Current Month: #monthAsString('#setting_info.current_month#')# </p>
                        <p> Current Year: #setting_info.current_year# </p>
                        <p> Transaction Mode: #get_bank_details.mode#
                    </div>
                </div>
            </div>
            <form action = "process_detail.cfm?updated" method = "post">
                <div class = "container mb-3">
                    <div class = "row container">
                        <div class = "col-2">
                            <label for = "working_days" class = "form-control-label"> Working Days: </label>
                            <input type = "number" name = "working_days" id = "working_days" readonly = "true" value = "#working_days#" class = "form-control">
                        </div>
                        <div class = "col-2">
                            <label for = "basic_rate" class = "form-control-label"> Rate/Day: </label> 
                            <input name = "basic_rate" id = "basic_rate" type = "number" readonly = "true" value = "#numberFormat(basic_rate, '.__')#" step=".01" class = "form-control">  <!--- #DecimalFormat(basic_rate * sqr(2))# NOT Working--->
                        </div>
                        <div class = "col-2">
                            <label for = "days_worked" class = "form-control-label"> Days Worked: </label>
                            <input name = "days_worked" id = "days_worked" type = "number" readonly = "true" value = "#day_count.worked_days#" class = "form-control">
                        </div>
                        <div class = "col-2">
                            <label for = "deduct_days" class = "form-control-label"> Deduct Days: </label> 
                            <input name = "deduct_days" id = "deduct_days" type = "number" min = "0" required = "true" value = "0" class = "form-control">
                        </div>
                        <div class = "col-2">
                            <label for = "add_days" class = "form-control-label"> Add Days: </label> 
                            <input name = "add_days" id = "add_days" type = "number" min = "0" required = "true" value = "0" class = "form-control">
                        </div>
                        <div class = "col-2">
                            <label for = "pay_satus" class = "form-select-label"> Pay Status: </label> 
                            <select name = "pay_status" id = "pay_satus" class = "form-select">
                                <option value = "Y"> Active </option>
                                <option value = "N" <cfif get_pay_status.pay_status neq "Y"> selected </cfif>> Non-Active </option>
                            </select>
                        </div>
                    </div>
                </div>
                <!---  Allowed Allowances --->
                <div class = "employee_box">
                    <div class = "row">
                        <div class = "col-4">
                            <h4 class = "text-light">Allowances:</h4>
                                <cfloop query="get_allowance">
                                    <label for = "allowance_amount#id#" class = "form-control-label"> #name#: </label>
                                    <input type = "hidden" name = "allowance_id#id#" value = "#id#">
                                    <input type = "number"  min = "0" name = "allowance_amount#id#" id = "allowance_amount#id#" value = "#amount#" class = "form-control"> <br>
                                </cfloop>
                        </div>
                        <!--- Deductions --->
                        <div class = "col-4">
                            <h4 class = "text-light"> Deductions: </h4>
                                <cfloop query="get_deduction">
                                    <label for = "deduction_amount#id#" class = "form-control-label"> #name#: </label>
                                    <input type = "hidden" name = "deduction_id#id#" value = "#id#">
                                    <input type = "number"  min = "0" id = "deduction_amount#id#" name = "deduction_amount#id#" value = "#amount#" class = "form-control"> <br>
                                </cfloop>
                        </div>
                        <!--- Leaves --->
                        <div class = "col-4">
                            <h4 class = "text-light"> Leaves: </h4>
                                <cfset total_leaves = 0> <!--- variable used in loop to get total leaves --->
                                <cfloop query="leave_count"> <!--- Loop Will Print all leaves availed by employee --->
                                    <label for = "leave_days#id#" class = "form-control-label"> #title#: </label>
                                    <input type = "number"  min = "0" id = "leave_days#id#" name = "leave_days#id#" value = "#leave_days#" readonly = "true" class = "form-control"> <br>
                                    <cfset total_leaves = total_leaves + leave_days>
                                </cfloop>
                                <label for = "total_leaves" class = "form-control-label">
                                    Total Leaves: 
                                </label>
                                <input type = "number" class = "form-control" id = "total_leaves" name = "total_leaves" value = "#total_leaves#" readonly = "true"><br>
                                <label for = "paid_leaves" class = "form-control-label">
                                    Paid Leaves: 
                                </label>
                                    <input type = "number" class = "form-control" min = "0" name = "paid_leaves" id = "paid_leaves" value = "#paid_leave_count.leave_days#" readonly = "true"> <br>
                                <label for = "half_paid_leaves" class = "form-control-label">
                                    Half Pay Leaves: 
                                </label>
                                    <input type = "number" class = "form-control" min = "0" name = "half_paid_leaves" id = "half_paid_leaves" value = "#half_paid_leave_count.leave_days#" readonly = "true"> <br>
                                <label for = "non_paid_leaves" class = "form-control-label">
                                    Leaves Without Pay: 
                                </label>
                                    <input type = "number"  class = "form-control" min = "0" name = "non_paid_leaves" id = "non_paid_leaves" value = "#Non_paid_leave_count.leave_days#" readonly = "true">
                        </div>
                    </div>
                </div>
                <input name = "employee_id" value = "#get_employee.employee_id#" type = "hidden">
                <input name = "basic_salary" value = "#get_employee.basic_salary#" type = "hidden">
                <input name = "month" value = "#setting_info.current_month#" type = "hidden">
                <input name = "year" value = "#setting_info.current_year#" type = "hidden">
                <input name = "transaction_mode" value = "#get_bank_details.mode#" type = "hidden">
                <input name = "txt_bank_name" value = "#get_bank_details.name#" type = "hidden">
                <input name = "bank_account_no" value = "#get_bank_details.account#" type = "hidden">
                <input type = "submit" value = "Save" class = "btn btn-outline-dark">
            </form>
        <cfelseif structKeyExists(url, 'updated')>
        <!--- _________________________________________ Back End _________________________________________________ --->
            <!--- queries--->
            <!--- check the employee already exsists or not --->
            <cfquery name = "check_duplicate">
                select employee_id 
                from employee
                where employee_id = '#form.employee_id#'
            </cfquery>
            <!--- get allowances to run a query loop --->
            <cfquery name = "get_allowance">
                select b.allowance_name as name, a.allowance_amount as amount, b.allowance_id as id
                from pay_allowance a
                left join allowance b on b.allowance_id = a.allowance_id
                where a.employee_id = "#form.employee_id#" and a.status = "Y"
            </cfquery>
            <!--- get deductions to run a query loop --->
            <cfquery name = "get_deduction">
                select b.deduction_name as name, a.deduction_amount as amount, b.deduction_id as id
                from pay_deduction a
                left join deduction b on b.deduction_id = a.deduction_id
                where a.employee_id = "#form.employee_id#" and a.status = "Y"
            </cfquery>
            <!--- get allowances if already exist --->
            <cfquery name = "pay_allowances"> <!--- query will return records that are not existing already ---> 
                select b.allowance_name as name, a.allowance_amount as amount, b.allowance_id as id
                from pay_allowance a
                left join allowance b on b.allowance_id = a.allowance_id
                where a.employee_id = "#form.employee_id#" and a.status = "Y" and b.allowance_id not in (
                    select allowance_id 
                    from pay_allowance
                    where employee_id = "#form.employee_id#"
                )
            </cfquery>
            <!--- Insert --->
                <!--- loop will run query according to all allowances defined in form ---> 
            <cfif pay_allowances.recordcount eq 0>
                <cfloop query = "pay_allowances">
                    <cfif structKeyExists(form, 'allowance_id#id#')>
                        <cfquery>
                            insert into pay_allowance (employee_id, allowance_id, allowance_amount, status)
                            values ('#form.employee_id#', '#evaluate("allowance_id#id#")#', '#evaluate("allowance_amount#id#")#', 'Y'  )
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
            <cfif check_duplicate.recordcount eq 0>
                <!--- loop will run query according to all Deductions defined in form ---> 
                <cfloop query = "get_deduction">
                    <cfif structKeyExists(form, 'deduction_id#id#')>
                        <cfquery>
                            insert into pay_deduction (employee_id, deduction_id, deduction_amount, status)
                            values ('#form.employee_id#', '#evaluate("deduction_id#id#")#', '#evaluate("deduction_amount#id#")#', 'Y'  )
                        </cfquery>
                    </cfif>
                </cfloop>
                <!--- Update --->
            <cfelse>
                <!--- Update main table of salary "current month"--->
                <cfquery name = "update_pay">
                    update current_month_pay 
                    set basic_salary = '#form.basic_salary#',
                        month = '#form.month#',
                        year = '#form.year#',
                        transaction_mode = '#form.transaction_mode#',
                        bank_name = '#form.txt_bank_name#',
                        bank_account_no = '#form.bank_account_no#',
                        transaction_date = now(),
                        pay_status = '#form.pay_status#',
                        days_worked = '#form.days_worked#',
                        working_days = '#form.working_days#',
                        additional_days = '#form.add_days#',
                        deducted_days = '#form.deduct_days#',
                        basic_rate = '#form.basic_rate#',
                        paid_leaves = '#form.paid_leaves#',
                        half_paid_leaves = '#form.half_paid_leaves#',
                        leaves_without_pay = '#form.non_paid_leaves#',
                        processed = 'N'
                    where employee_id = '#form.employee_id#'
                </cfquery>
                <!--- Update pay allowances if existing already --->
                <cfloop query = "get_allowance">
                    <cfif structKeyExists(form, 'allowance_id#id#')>
                        <cfquery>
                            update pay_allowance
                            set allowance_amount = '#evaluate("allowance_amount#id#")#', status = 'Y'
                            where employee_id = '#form.employee_id#' 
                            and allowance_id = '#evaluate("allowance_id#id#")#'
                        </cfquery>
                    </cfif>
                </cfloop>
                <!--- Update pay deduction it existing already ---> 
                <cfloop query = "get_deduction">
                    <cfif structKeyExists(form, 'deduction_id#id#')>
                        <cfquery>
                            update pay_deduction 
                            set deduction_amount = '#evaluate("deduction_amount#id#")#', status = "Y"
                            where employee_id = '#form.employee_id#' 
                            and deduction_id = '#evaluate("deduction_id#id#")#'
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
        <!--- _________________________________________ Front End _________________________________________________ --->

            <h3 id = "message" class = "text-success" style = "text-align:center;"> Information Saved </h3>
            <!--- javascript used to set information updated message timeout = 3.5 seconds --->
            <script>
                var message = document.getElementById("message");
                setTimeout(function(){
                    message.style.display = "none";
                }, 3500);
            </script>
        <cfelse>
        <!--- below part will show employee list on front end --->
            <cfquery name = "all_employees">
                select emp.employee_id as id, concat(emp.first_name,' ', emp.middle_name,' ', emp.last_name) as name, des.designation_title as designation, emp.basic_salary as basic_salary
                from employee emp, designation des
                where emp.designation = des.designation_id
            </cfquery>
            <table class = "table custom_table">
                <tr>
                    <th> Employee ID </th>
                    <th> Employee Name </th>
                    <th> Designation </th>
                    <th> Action </th>
                </tr>
                <cfloop query = "all_employees">
                <tr>
                    <td> #id# </td>
                    <td> #name# </td>
                    <td> #designation# </td>
                    <td> <a href="process_detail.cfm?edit_process_detail=#id#"> 
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                            </svg>  
                         </a> 
                    </td>
                </tr>
                </cfloop>
            </table>
        </cfif>
        <!--- Javascript --->   
        <script>
        // Now not using this function
        // this function calculating working days static.... A dynamic calculation is performing in cf code.... no using javascript 
        /*    function getDates () {
                const dates = []
                var from_date = new Date(document.getElementById("fromDate").value);    
                var to_date = new Date(document.getElementById("toDate").value);
                let currentDate = from_date
                const addDays = function (days) {
                    const date = new Date(this.valueOf())
                    date.setDate(date.getDate() + days)
                    return date
                }
                while (currentDate <= to_date ) {
                    if(currentDate.getDay() != 0 && currentDate.getDay() != 6)
                    dates.push(currentDate)
                    currentDate = addDays.call(currentDate, 1)
                }
                document.getElementById("total_days").value = dates.length;
                return dates //dates[0].getDay();
                }
            */
        </script>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">