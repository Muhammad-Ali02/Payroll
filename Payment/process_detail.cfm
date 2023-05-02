<cfoutput>
     
    <cfif structKeyExists(session, 'loggedIn')>
        <cfif structKeyExists(url, 'edit_process_detail')>
            <!--- Query to get Employee for edit --->
            <cfquery name = "get_employee">
                select concat(emp.first_name,' ', emp.middle_name,' ', emp.last_name) as employee_name, emp.employee_id, des.designation_title as designation, emp.basic_salary , cmp.gross_allowances
                from employee emp, designation des, current_month_pay cmp
                where emp.employee_id = "#url.edit_process_detail#" and des.designation_id = emp.designation
            </cfquery>
            <!--- Query to get current month of pay process  --->
            <cfquery name = "setting_info">
                select * from setup
            </cfquery>
            <!--- query to get pay status active or not --->
            <cfquery name = "get_pay_status">
                select pay_status,loan_amount,adv_salary_amount
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
                and month(date) = "#setting_info.current_month#" 
                and year(date) = "#setting_info.current_year#"
            </cfquery>
            <!--- query for getting current month from setup table --->
            <cfquery name="get_month">
                select * from setup;
            </cfquery>
            <!--- Get the start date of the month --->
            <cfset startDate = CreateDate(#get_month.current_year#, #get_month.current_month#, 1)>
            <!--- Get the end date of the month --->
            <cfset endDate = DateAdd("d", -1, DateAdd("m", 1, startDate))>
            <!--- Query used to get all Leave Days of an Employee --->
            <cfquery name = "leave_count">
                select count(b.leave_Date)as leave_days, a.leave_id as id, c.leave_title as title
                from all_leaves a, leaves_approval b, leaves c
                where a.id = b.leave_id
                And a.leave_id = c.leave_id
                And a.employee_id = '#url.edit_process_detail#'
                And b.action = 'Approved'
                And b.leave_Date >='#DateFormat(startDate, "yyyy-mm-dd")#' 
                And b.leave_Date <='#DateFormat(endDate, "yyyy-mm-dd")#'
                group by b.leave_id
                <!--- select count(a.employee_id) as leave_days, a.leave_id as id, b.leave_title as title
                -- from all_leaves a
                -- inner join leaves b on a.leave_id = b.leave_id 
                -- where a.employee_id = "#url.edit_process_detail#" 
                -- and a.action = "Approved"
                -- group by b.leave_id--->
            </cfquery>
            <!--- Query used to get all paid Leave Days of an Employee --->
            <cfquery name = "paid_leave_count">
                select count(b.leave_Date)as leave_days, a.leave_id as id, c.leave_title as title
                from all_leaves a, leaves_approval b, leaves c
                where a.id = b.leave_id
                And a.leave_id = c.leave_id
                And a.employee_id = '#url.edit_process_detail#'
                And b.action = 'Approved'
                And b.approved_as = '1'
                And b.leave_Date >='#DateFormat(startDate, "yyyy-mm-dd")#' 
                And b.leave_Date <='#DateFormat(endDate, "yyyy-mm-dd")#'
                group by b.leave_id
                <!---select count(a.employee_id) as leave_days
                from all_leaves a
                inner join leaves b on a.leave_id = b.leave_id 
                where a.employee_id = "#url.edit_process_detail#" 
                and a.action = "Approved" 
                and leave_type = "Paid"--->
            </cfquery>
            <!--- Query used to get all Hlaf Leave Days of an Employee --->
            <cfquery name = "half_paid_leave_count">
                select count(b.leave_Date)as leave_days, a.leave_id as id, c.leave_title as title
                from all_leaves a, leaves_approval b, leaves c
                where a.id = b.leave_id
                And a.leave_id = c.leave_id
                And a.employee_id = '#url.edit_process_detail#'
                And b.action = 'Approved'
                And b.approved_as = '0.5'
                And b.leave_Date >='#DateFormat(startDate, "yyyy-mm-dd")#' 
                And b.leave_Date <='#DateFormat(endDate, "yyyy-mm-dd")#'
                group by b.leave_id
                <!---select count(a.employee_id) as leave_days
                from all_leaves a
                inner join leaves b on a.leave_id = b.leave_id 
                where a.employee_id = "#url.edit_process_detail#" 
                and a.action = "Approved" 
                and leave_type = "halfPaid"--->
            </cfquery>
            <!--- Query used to get all non paid Leave Days of an Employee --->
            <cfquery name = "rejected_leaves">
                select b.*
                from all_leaves a, leaves_approval b 
                where a.id = b.leave_id
                And a.employee_id = '#url.edit_process_detail#'
                And b.action = 'rejected'
                And b.approved_as = '0'
                And b.leave_Date >='#DateFormat(startDate, "yyyy-mm-dd")#' 
                And b.leave_Date <='#DateFormat(endDate, "yyyy-mm-dd")#'
                <!---select count(a.employee_id) as leave_days
                from all_leaves a
                inner join leaves b on a.leave_id = b.leave_id 
                where a.employee_id = "#url.edit_process_detail#" 
                and a.action = "Approved" 
                and leave_type = "NonPaid"--->
            </cfquery>
            <!---Query for get loan amount by Kamal--->
            <cfquery  name="get_loan_amt">
                select * from loan where employee_Id = '#get_employee.employee_id#' and status = 'Y'
            </cfquery>
            <!---Query for get advance_salary amount by Kamal--->
            <cfquery  name="get_advance_salary_amt">
                select * from advance_salary where employee_Id = '#get_employee.employee_id#' and status = 'Y'
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
            <cfset working_days = day(lastday)>
                <!---<cfloop from = "#day(firstDay)#" to = "#day(lastday)#" index = "i"> 
                    <cfset date = createDate(#setting_info.current_year#, #setting_info.current_month#, #i#)>
                    <cfset day_of_week = dayOfWeek(#date#)>
                    
                    <cfset working_days = i>
                        <!---
                        <cfif  evaluate("workingdays.#dayOfWeekAsString('#day_of_week#')#") eq 1.0 >
                            <cfset working_days = working_days + 1>
                        <cfelseif evaluate("workingdays.#dayOfWeekAsString('#day_of_week#')#") eq 0.5>
                            <cfset working_days = working_days + 0.5>
                        </cfif>
                        --->
                </cfloop>--->
            <!--- Calculate Basic Rate Per Day using Basic Salary of Employee --->
            <cfset basic_rate = get_employee.basic_salary / working_days>

        <!---________________________________________________________Create/Update Front End _________________________________________________________--->
        <div class="employee_box"> 
            <div class="text-center mb-5">
                <h3 class="box_heading">Pay Slip Detail</h3>
            </div>   
            <div class="row mb-3">
                <div class = "col-md-8">
                    <p> Employee ID: #get_employee.employee_id# </p> 
                    <p> Employee Name: #get_employee.employee_name# </p> 
                    <p> Designation: #get_employee.designation# </p>
                </div>
                <div class = "col-md-4">
                    <p> Current Month: #monthAsString('#setting_info.current_month#')# </p>
                    <p> Current Year: #setting_info.current_year# </p>
                    <p> Transaction Mode: #get_bank_details.mode#
                </div>
            </div>
             <cfif get_advance_salary_amt.remaining_balance eq ''>
                <cfset remaining_adv_balance = 0>
            <cfelse>
                <cfset remaining_adv_balance = get_advance_salary_amt.remaining_balance>
            </cfif>
            <cfif get_loan_amt.remaining_balance eq ''>
                <cfset remaining_loan_balance = 0>
            <cfelse>
                <cfset remaining_loan_balance = get_loan_amt.remaining_balance>
            </cfif>
            <cfset remaining_adv_balance = get_advance_salary_amt.remaining_balance>
            <cfset remaining_loan_balance = get_loan_amt.remaining_balance>
            <form onsubmit="return formvalidate(#remaining_adv_balance#,#remaining_loan_balance#);" action = "process_detail.cfm?updated=true" method = "post">
                <div class = "row container mb-3">
                    <div class = "col-md-4 mb-2">
                        <label for = "working_days" class = "form-control-label"> Working Days: </label>
                        <input type = "number" name = "working_days" id = "working_days" readonly = "true" value = "#working_days#" class = "form-control">
                    </div>
                    <div class = "col-md-4 mb-2">
                        <label for = "basic_rate" class = "form-control-label"> Rate/Day: </label> 
                        <input name = "basic_rate" id = "basic_rate" type = "number" readonly = "true" value = "#numberFormat(basic_rate, '.__')#" step=".01" class = "form-control">  <!--- #DecimalFormat(basic_rate * sqr(2))# NOT Working--->
                    </div>
                    <div class = "col-md-4 mb-2">
                        <label for = "days_worked" class = "form-control-label"> Days Worked: </label>
                        <input name = "days_worked" id = "days_worked" type = "number" readonly = "true" value = "#day_count.worked_days#" class = "form-control">
                    </div>
                </div>
                <div class="row container mb-5">
                    <div class = "col-md-4 mb-2">
                        <label for = "deduct_days" class = "form-control-label"> Deduct Days: </label> 
                        <input name = "deduct_days" id = "deduct_days" type = "number" min = "0" required = "true" value = "0" class = "form-control">
                    </div>
                    <div class = "col-md-4 mb-2">
                        <label for = "add_days" class = "form-control-label"> Add Days: </label> 
                        <input name = "add_days" id = "add_days" type = "number" min = "0" required = "true" value = "0" class = "form-control">
                    </div>
                    <div class = "col-md-4 mb-2">
                        <label for = "pay_satus" class = "form-select-label"> Pay Status: </label> 
                        <select name = "pay_status" id = "pay_satus" class = "form-select">
                            <option value = "Y"> Active </option>
                            <option value = "N" <cfif get_pay_status.pay_status neq "Y"> selected </cfif>> Non-Active </option>
                        </select>
                    </div>
                </div>
                <!---  Allowed Allowances --->
                <div class = "row">
                    <div class = "col-md-4">
                        <h4 class = "text-light">Allowances:</h4>
                            <cfloop query="get_allowance">
                                <label for = "allowance_amount#id#" class = "form-control-label"> #name#: </label>
                                <input type = "hidden" name = "allowance_id#id#" value = "#id#">
                                <input type = "number"  min = "0" name = "allowance_amount#id#" id = "allowance_amount#id#" value = "#amount#" class = "form-control"> <br>
                            </cfloop>
                    </div>
                    <!--- Deductions --->
                    <div class = "col-md-4">
                        <h4 class = "text-light"> Deductions: </h4>
                            <cfloop query="get_deduction">
                                <label for = "deduction_amount#id#" class = "form-control-label"> #name#: </label>
                                <input type = "hidden" name = "deduction_id#id#" value = "#id#">
                                <input type = "number"  min = "0" id = "deduction_amount#id#" name = "deduction_amount#id#" value = "#amount#" class = "form-control"> <br>   
                            </cfloop>
                            <!---input of loan amount by Kamal--->
                            <cfif get_loan_amt.RecordCount gt 0>
                                <label for = "loan_amt" class = "form-control-label"> Loan Installment: </label>
                                <input type = "number"  min = "0" id = "loan_amt" name = "loan_amt" <cfif #get_pay_status.loan_amount# eq ""> value = "#get_loan_amt.installmentAmount#"<cfelse> value = "#get_pay_status.loan_amount#" </cfif> class = "form-control">
                                <label for = "loan_amt" class = "form-control-label" style="font-size:14px"> Remaining Loan Balance: <cfif isNull(get_loan_amt.remaining_balance) or get_loan_amt.remaining_balance eq ""> #get_loan_amt.total_amount# <cfelse> #remaining_loan_balance# </cfif></label> <br>
                            </cfif>
                            <!---input of advance salary amount by Kamal--->
                            <cfif get_advance_salary_amt.RecordCount gt 0>
                                <label for = "advance_salary_amt" class = "form-control-label"> Advance Salary Installment: </label>
                                <input type = "number"  min = "0" id = "advance_salary_amt" name = "advance_salary_amt" <cfif #get_pay_status.adv_salary_amount# eq ""> value = "#get_advance_salary_amt.installmentAmount#"<cfelse> value = "#get_pay_status.adv_salary_amount#" </cfif> class = "form-control">
                                <label for = "advance_salary_amt" class = "form-control-label" style="font-size:14px"> Remaining Advance : <cfif isNull(get_advance_salary_amt.remaining_balance) or get_advance_salary_amt.remaining_balance eq ""> #get_advance_salary_amt.total_amount# <cfelse> #remaining_adv_balance# </cfif></label> <br>
                            </cfif>
                    </div>
                    <!--- Leaves --->
                    <div class = "col-md-4">
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
                            <cfset non_leaves = 0>
                            <cfloop query="rejected_leaves">
                                <cfquery name="count_non_paid_leaves">
                                    select date 
                                    from attendance a
                                    where a.date = '#dateFormat(leave_Date,'yyyy-mm-dd')#'
                                    And a.employee_id = "#url.edit_process_detail#"
                                </cfquery>
                                <cfif count_non_paid_leaves.recordcount eq '1'>
                                    <cfset non_leaves += 1>
                                </cfif>
                            </cfloop>
                                <input type = "number"  class = "form-control" min = "0" name = "non_paid_leaves" id = "non_paid_leaves" value = "#rejected_leaves.recordcount - non_leaves#" readonly = "true">
                    </div>
                </div>
                <input name = "employee_id" value = "#get_employee.employee_id#" type = "hidden">
                <input name = "basic_salary" value = "#get_employee.basic_salary#" type = "hidden">
                <input name = "month" value = "#setting_info.current_month#" type = "hidden">
                <input name = "year" value = "#setting_info.current_year#" type = "hidden">
                <input name = "transaction_mode" value = "#get_bank_details.mode#" type = "hidden">
                <input name = "txt_bank_name" value = "#get_bank_details.name#" type = "hidden">
                <input name = "bank_account_no" value = "#get_bank_details.account#" type = "hidden">
                <div class="text-right mt-4">
                    <input type = "submit" value = "Save" class = "btn btn-outline-dark">
                </div>
            </form>
        </div>
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
                <cfquery  name="get_loan_amt">
                    select * from loan where employee_Id = '#form.employee_id#' and status = 'Y'
                </cfquery>
                <!---Query for get advance_salary amount by Kamal--->
                <cfquery  name="get_advance_salary_amt">
                    select * from advance_salary where employee_Id = '#form.employee_id#' and status = 'Y'
                </cfquery>
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
                        <cfif get_loan_amt.RecordCount gt 0>
                            ,loan_amount = <cfqueryparam value='#form.loan_amt#'>
                        </cfif>
                        <cfif get_advance_salary_amt.RecordCount gt 0>
                            ,adv_salary_amount = <cfqueryparam value='#form.advance_salary_amt#'>
                        </cfif>

                    where employee_id = '#form.employee_id#'
                </cfquery>
                <!---query for update installment by Kamal
                <cfif month(#loan_check.installment_date#) eq month(now())>
                    <cfquery name="update_loan_installment">
                        update loan_installments,
                        (select loan_id as id from loan where employee_id = "#form.employee_id#") as get_loan_id
                        set installment_amount = "#form.loan_amt#"
                        where loan_id = get_loan_id.id
                    </cfquery>
                </cfif> --->   
                <!----and (#get_data_chk.installment_date# eq "" or isNull(#get_data_chk.installment_date#) or month(#get_data_chk.installment_date#) neq Month(Now()))---->
                
                <cfquery name="get_loan_amount"><!---Query for get loan records by Kamal--->
                    select * from loan 
                    where employee_id = "#form.employee_id#"
                    and status ='Y'
                </cfquery>
                <cfquery name = "setting_info">
                    select * from setup
                </cfquery>
                <cfquery name="loan_check">
                    select * from loan a
                    join loan_installments b
                    where a.loan_id = b.loan_id
                    and a.employee_id = "#form.employee_id#"
                    and month(installment_date) = '#setting_info.current_month#'
                </cfquery>
                
                <!--- Process of loan updation by Kamal--->
                <cfset installment_date = createDate(#setting_info.current_year#, #setting_info.current_month#, 1)>
                <cfset installment_date = DateFormat(installment_date, "yyyy-mm-dd") & " " & TimeFormat(now(), "hh:mm:ss")>
                
                <cfif get_loan_amt.RecordCount gt 0>
                    <cfif loan_check.RecordCount gt 0>
                        <cfif month(#loan_check.installment_date#) neq #setting_info.current_month#>
                            <cfquery name="insert_loan_installment">
                                insert into loan_installments
                                (loan_id,installment_amount,installment_date)
                                values(
                                    <cfqueryparam value = '#get_loan_amount.loan_id#'>,
                                    <cfqueryparam value = '#form.loan_amt#'>,
                                    <cfqueryparam value = '#installment_date#'>
                                    )
                            </cfquery>
                        <cfelse>
                            <!---query for update installment by Kamal--->
                            <cfquery name="update_loan_installment">
                                update loan_installments,
                                (select loan_id as id from loan where employee_id = "#form.employee_id#") as get_loan_id
                                set installment_amount = "#form.loan_amt#"
                                where loan_id = get_loan_id.id
                                and month(installment_date) = '#setting_info.current_month#'
                            </cfquery>
                        </cfif>    
                    <cfelse>
                        <cfquery name="insert_loan_installment">
                            insert into loan_installments
                            (loan_id,installment_amount,installment_date)
                            values(
                                <cfqueryparam value = '#get_loan_amount.loan_id#'>,
                                <cfqueryparam value = '#form.loan_amt#'>,
                                <cfqueryparam value = '#installment_date#'>
                                )
                        </cfquery>
                    </cfif>
                </cfif>

                <cfquery name="get_adv_salary_amount"><!---Query for get advance salary records by Kamal--->
                    select * from advance_salary 
                    where employee_id = "#form.employee_id#"
                    and status ='Y'
                </cfquery>
                <cfquery name = "setting_info">
                    select * from setup
                </cfquery>
                <cfquery name="advance_salary_check">
                    select * from advance_salary a
                    join advance_salary_installments b
                    where a.advance_id = b.advance_id
                    and a.employee_id = "#form.employee_id#"
                    and month(installment_date) = '#setting_info.current_month#'
                </cfquery>
                
                <!--- Process of loan updation by Kamal--->
                <cfset adv_salary_installment_date = createDate(#setting_info.current_year#, #setting_info.current_month#, 1)>
                <cfset adv_salary_installment_date = DateFormat(adv_salary_installment_date, "yyyy-mm-dd") & " " & TimeFormat(now(), "hh:mm:ss")>
                
                <cfif get_advance_salary_amt.RecordCount gt 0>
                    <cfif advance_salary_check.RecordCount gt 0>
                        <cfif month(#advance_salary_check.installment_date#) neq #setting_info.current_month#>
                            <cfquery name="insert_advance_salary_installment">
                                insert into advance_salary_installments
                                (advance_id,installment_amount,installment_date)
                                values(
                                    <cfqueryparam value = '#get_adv_salary_amount.advance_id#'>,
                                    <cfqueryparam value = '#form.advance_salary_amt#'>,
                                    <cfqueryparam value = '#adv_salary_installment_date#'>
                                    )
                            </cfquery>
                        <cfelse>
                            <!---query for update installment by Kamal--->
                            <cfquery name="insert_advance_salary_installment">
                                update advance_salary_installments,
                                (select advance_id as id from advance_salary where employee_id = "#form.employee_id#" and status = 'Y') as get_adv_salary_id
                                set installment_amount = "#form.advance_salary_amt#"
                                where advance_id = get_adv_salary_id.id
                                and month(installment_date) = '#setting_info.current_month#'
                            </cfquery>
                        </cfif>    
                    <cfelse>
                        <cfquery name="insert_advance_salary_installment">
                            insert into advance_salary_installments
                            (advance_id,installment_amount,installment_date)
                            values(
                                <cfqueryparam value = '#get_adv_salary_amount.advance_id#'>,
                                <cfqueryparam value = '#form.advance_salary_amt#'>,
                                <cfqueryparam value = '#adv_salary_installment_date#'>
                                )
                        </cfquery>
                    </cfif>
                </cfif>

                <cfquery name="get_data_chk">
                    select * from loan_installments where loan_id = '#get_loan_amount.loan_id#'
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
            <!---
            <h3 id = "message" class = "text-success" style = "text-align:center;"> Information Saved </h3>
            <!--- javascript used to set information updated message timeout = 3.5 seconds --->
            <script>
                var message = document.getElementById("message");
                setTimeout(function(){
                    message.style.display = "none";
                }, 3500);
            </script>
            --->
            <script>
                alert('Salary Information Saved successfully!');
                window.location.href = "process_detail.cfm";
            </script>
        <cfelse>
            <div class="text-center mb-5">
                <h3 class="box_heading">
                    Edit Pay
                </h3>
            </div>
            <a href="pay.cfm" class="btn btn-outline-danger custom_button mb-3">Go Back</a>
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
    </cfif>    
    <!--- Javascript --->   
    <script>
        function formvalidate(rem_adv_bal,rem_loan_bal){
            debugger;
            let remaining_adv_balance = rem_adv_bal;
            let advance_salary_amt = $('##advance_salary_amt').val();
            let remaining_loan_balance=rem_loan_bal;
            let loan_amt = $('##loan_amt').val();
            if(parseInt(remaining_loan_balance) < loan_amt){
                alert('Laon Installment Amount cannot greater than Remaining Loan Amount');
                return false;
            }
            if(parseInt(remaining_adv_balance) < advance_salary_amt){
                alert('Advance Salary Installment Amount cannot greater than Remaining Advance Amount');
                return false;
            }
        }
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
    
</cfoutput>