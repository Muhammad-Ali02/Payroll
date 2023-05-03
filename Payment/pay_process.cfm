<cfoutput>
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- ___________________________________________________ Back end ________________________________________________ --->
        <!--- Query to print dynamic drop dwon list of all employees --->
        <cfquery name = "get_employee_list">
            select concat(a.employee_id, " | ", a.first_name," ",a.middle_name," ",a.last_name) as name, a.employee_id as id, a.leaving_date 
            from employee a
            inner join current_month_pay b on a.employee_id = b.employee_id
            where b.pay_status = "Y" 
            and b.processed is not null
        </cfquery>
        <cfif structKeyExists(url, 'run_pay_process') and structKeyExists(form, 'run_process')>
            <cfquery name = "get_pay_data">
                select * 
                from current_month_pay
                where
                    <cfif form.employee_id neq "All">
                        employee_id = "#form.employee_id#" and
                    </cfif>
                    (processed is not null or processed <> '')
            </cfquery>
            <cfif get_pay_data.recordcount neq 0>
                <cfloop query="get_pay_data">
                    <!--- Query used to get all allowances of an employee --->
                    <cfquery name = "get_allowances">
                        select sum(a.allowance_amount) as amount
                        from pay_allowance a
                        where 
                        <cfif form.employee_id neq "All">
                            a.employee_id = "#form.employee_id#" 
                        <cfelse>
                            a.employee_id = "#employee_id#"
                        </cfif>
                            and a.status = "Y"
                    </cfquery>
                    <!--- Query used to get all Deduction of an employee --->
                    <!---             This query get percentage for deduction            --->
                    <cfquery name="deduction_percentage">
                        select sum(deduction.deduction_amount) as percentage
                        from deduction , pay_deduction
                        where pay_deduction.deduction_id = deduction.deduction_id
                        And <cfif form.employee_id neq "all">
                                pay_deduction.employee_id = "#form.employee_id#" 
                            <cfelse>
                                pay_deduction.employee_id = "#employee_id#"
                            </cfif> 
                        And deduction.is_percent='y'
                        And deduction.is_deleted = 'N';
                    </cfquery>
                    <!---             update query and get tax according to requirement              --->
                     <cfquery name="deduction_of_Tax">
                        select sum(deduction.deduction_amount) as tax_amount
                        from deduction , pay_deduction
                        where pay_deduction.deduction_id = deduction.deduction_id
                        And <cfif form.employee_id neq "all">
                                pay_deduction.employee_id = "#form.employee_id#" 
                            <cfelse>
                                pay_deduction.employee_id = "#employee_id#"
                            </cfif> 
                        And deduction.is_percent='N'
                        And deduction.is_deleted = 'N';
                    </cfquery>
                    <cfquery name = "get_deductions">
                        select sum(a.deduction_amount) as amount
                        from pay_deduction a
                        where 
                        <cfif form.employee_id neq "all">
                            a.employee_id = "#form.employee_id#" 
                        <cfelse>
                            a.employee_id = "#employee_id#"
                        </cfif>
                        and a.status = "Y"
                    </cfquery>
                    <!--- Varibales for calculation --->
                    <cfif get_allowances.amount eq ''> <!--- condition to handle if an employee don't have allowances : convert emplty string to 0 ---> 
                        <cfset allowance_amount = 0>
                    <cfelse>
                        <cfset allowance_amount = get_allowances.amount>
                    </cfif>
                    <cfif get_deductions.amount eq ''> <!--- condition to handle if an employee don't have deductions : convert emplty string to 0 ---> 
                        <cfset deduction_amount = 0>
                    <cfelse>
                        <cfset deduction_amount = get_deductions.amount>
                    </cfif>


                    <cfif deduction_of_Tax.tax_amount eq ''> <!--- condition to handle if an employee don't have deductions : convert emplty string to 0 ---> 
                        <cfset deduction_tax_amount = 0>
                    <cfelse>
                        <cfset deduction_tax_amount = deduction_of_Tax.tax_amount>
                    </cfif>
                    <cfif deduction_percentage.percentage eq ''> <!--- condition to handle if an employee don't have deductions : convert emplty string to 0 ---> 
                        <cfset deduction_percent = 0>
                    <cfelse>
                        <cfset deduction_percent = deduction_percentage.percentage>
                    </cfif>

                <cfquery name = "setting_info">
                    select * from setup
                </cfquery>
                <cfquery name="previous_employee"><!---query for employees that exit--->
                    select * from employee where leaving_date <> '' and 
                    <cfif form.employee_id neq "all">
                            employee_id = "#form.employee_id#" 
                        <cfelse>
                            employee_id = "#employee_id#"
                        </cfif>
                </cfquery>

                <cfif previous_employee.RecordCount gt 0>
                    <cfif year(previous_employee.joining_date) neq year(now()) or month(previous_employee.joining_date) neq month(now())>
                        <cfset startMonth = CreateDate(Year(now()), Month(now()), 1)>
                    <cfelse>
                        <cfset startMonth = #previous_employee.joining_date#>
                    </cfif>    
                    <cfset endMonth = #previous_employee.leaving_date#>
                    <cfset workingDays = 0>
                    <cfloop from="#startMonth#" to="#endMonth#" index="day">
                        <cfif DayOfWeek(day) neq 1 and DayOfWeek(day) neq 7>
                            <cfset workingDays = workingDays + 1>
                        </cfif>
                    </cfloop>
                    <cfset total_work_days = #workingDays#>
                <cfelse>    
                    <cfset year = #setting_info.current_year#> 
                    <cfset month = #setting_info.current_month#> 
                    <cfset daysInMonth = DateDiff("d", "#month#/1/#year#", DateAdd("m", 1, "#month#/1/#year#"))>
                    <cfset workdaysInMonth = 0>
                    <cfloop from="1" to="#daysInMonth#" index="day">
                        <cfif DayOfWeek("#month#/#day#/#year#") neq 1 and DayOfWeek("#month#/#day#/#year#") neq 7>
                            <cfset workdaysInMonth = workdaysInMonth + 1>
                        </cfif>
                    </cfloop>
                    <cfset total_work_days = #workdaysInMonth#>
                </cfif>

                <cfquery name="get_loan_amount"><!---Query for get loan records by Kamal--->
                    select * from loan where 
                        <cfif form.employee_id neq "all">
                            employee_id = "#form.employee_id#" 
                        <cfelse>
                            employee_id = "#employee_id#"
                        </cfif> 
                        and status = 'Y'
                </cfquery>
                <cfquery name="get_advance_salary_amount"><!---Query for get advance salary records by Kamal--->
                    select * from advance_salary where 
                        <cfif form.employee_id neq "all">
                            employee_id = "#form.employee_id#" 
                        <cfelse>
                            employee_id = "#employee_id#"
                        </cfif> 
                        and status = 'Y'
                </cfquery>
                
                <!---process of installments by Kamal--->
                <cfif get_loan_amount.RecordCount neq 0>
                    <cfquery name="installments">
                        select * from loan a , loan_installments b
                        where a.loan_id = b.loan_id and a.Status = 'y' 
                        and 
                        <cfif form.employee_id neq "all">
                            a.employee_id = "#form.employee_id#" 
                        <cfelse>
                            a.employee_id = "#employee_id#"
                        </cfif> 
                        order by installment_date desc
                    </cfquery>
                    <!--- process of add installments by Kamal--->
                    <cfset var_returned_amount = 0>
                    <cfif installments.RecordCount neq 0>
                        <cfloop query="installments">
                            <cfset var_returned_amount = var_returned_amount + installment_amount>
                        </cfloop>
                    </cfif>
                    <!---query for loan return by Kamal--->
                    <!---<cfquery name="get_loan_employees">
                        select *, sum(b.installment_amount) as returned_amt from loan a
                        join loan_installments b
                        where a.loan_id = b.loan_id
                        and 
                        <cfif form.employee_id neq "all">
                            a.employee_id = "#form.employee_id#" 
                        <cfelse>
                            a.employee_id = "#employee_id#"
                        </cfif> 
                        and status = 'Y'
                        and 
                    </cfquery>--->
                    
                    <!--- this code update remaining balance from loan by Kamal--->
                    <cfif installments.RecordCount neq 0>    
                        <cfset var_total_amount = #installments.total_amount#>
                        <cfset var_installment_amount = #installments.installment_amount#>
                        <cfset var_remaining_amount = var_total_amount - var_returned_amount>
                    </cfif>  
                </cfif> 
                <!---process of advance salary installments by Kamal--->
                <cfif get_advance_salary_amount.RecordCount neq 0>
                    <cfquery name="adv_salary_installments">
                        select * from advance_salary a , advance_salary_installments b
                        where a.advance_id = b.advance_id and a.Status = 'Y' 
                        and 
                        <cfif form.employee_id neq "all">
                            a.employee_id = "#form.employee_id#" 
                        <cfelse>
                            a.employee_id = "#employee_id#"
                        </cfif> 
                        order by installment_date desc
                    </cfquery>
                    <!--- process of add installments by Kamal--->
                    <cfset var_adv_salary_returned_amount = 0>
                    <cfif adv_salary_installments.RecordCount neq 0>
                        <cfloop query="adv_salary_installments">
                            <cfset var_adv_salary_returned_amount = var_adv_salary_returned_amount + installment_amount>
                        </cfloop>
                    </cfif>
                    
                    <!--- this code update remaining balance from advance_salary by Kamal--->
                    <cfif adv_salary_installments.RecordCount neq 0>    
                        <cfset var_adv_salary_total_amount = #adv_salary_installments.total_amount#>
                        <cfset var_adv_salary_installment_amount = #adv_salary_installments.installment_amount#>
                        <cfset var_adv_salary_remaining_amount = var_adv_salary_total_amount - var_adv_salary_returned_amount>
                    </cfif>  
                </cfif> 
                    <cfset absent_days = (total_work_days - days_worked) - paid_leaves - (half_paid_leaves/2) - leaves_without_pay>
                    <cfset worked_days = working_days - absent_days>
                    <cfset var_gross_allowances = allowance_amount>
                    <!---<cfset var_gross_allowances = allowance_amount + (basic_rate * (paid_leaves + additional_days + (half_paid_leaves/2)))>--->
                    <cfset var_gross_salary = (basic_rate * (worked_days + additional_days)) + var_gross_allowances>
                    <cfset amount_of_percentage_tax = (var_gross_salary/100) * deduction_percent >
                    <cfset total_deduction = deduction_tax_amount + amount_of_percentage_tax>
                    <cfset var_gross_deductions = total_deduction + (basic_rate * (leaves_without_pay + deducted_days))>
                    <cfif get_loan_amount.RecordCount neq 0>
                        <cfif installments.RecordCount neq 0>
                            <cfset var_net_salary = (var_gross_salary - var_gross_deductions) - var_installment_amount>
                            <cfset var_gross_deductions += var_installment_amount>
                    <!---process of loan instalment deduction from salary by Kamal--->
                        <cfelse>
                            <cfset var_net_salary = (var_gross_salary - var_gross_deductions)>
                        </cfif>
                    <cfelse>
                        <cfset var_net_salary = (var_gross_salary - var_gross_deductions)>
                    </cfif>  
                    <!---process of advance salary instalment deduction from salary by Kamal--->
                    <cfif get_advance_salary_amount.RecordCount neq 0>
                        <cfif adv_salary_installments.RecordCount neq 0>
                            <cfset var_net_salary = var_net_salary - var_adv_salary_installment_amount>
                            <cfset var_gross_deductions += var_adv_salary_installment_amount>
                        <cfelse>
                            <cfset var_net_salary = (var_gross_salary - var_gross_deductions)>
                        </cfif>
                    <cfelse>
                        <cfset var_net_salary = (var_gross_salary - var_gross_deductions)>
                    </cfif>   

                    <cfquery name = "update_pay"> <!--- Query Will update all requirements --->
                    
                    <cfoutput>
                        update current_month_pay
                        set 
                            gross_salary = '#var_gross_salary#',
                            net_salary = '#var_net_salary#',
                            gross_allowances = '#var_gross_allowances#',
                            gross_deductions = '#var_gross_deductions#',
                            processed = 'Y'
                        where
                            <cfif form.employee_id neq "All">
                                employee_id = '#form.employee_id#'
                            <cfelse>
                                employee_id = '#employee_id#'
                            </cfif> 
                    </cfoutput> 
                   
                   </cfquery> 
                    
                    <!---process of updation of loan table on the basis of deduction by Kamal--->
                    <cfif get_loan_amount.RecordCount gt 0>
                        <cfif installments.RecordCount neq 0>
                            <cfquery name="update_loan">
                                update loan
                                set Remaining_balance = <cfqueryparam value = '#var_remaining_amount#'>,
                                Returned_Amount = <cfqueryparam value = '#var_returned_amount#'>
                                <cfif var_returned_amount eq installments.total_amount>
                                    ,status = 'N',
                                    Loan_End_Date = now()
                                </cfif>
                                where
                                <cfif form.employee_id neq "All">
                                    employee_id = '#form.employee_id#'
                                <cfelse>
                                    employee_id = '#employee_id#'
                                </cfif> 
                                and status = 'Y'
                            </cfquery>
                        </cfif>
                    </cfif>
                    <!---process of updation of advance salary table on the basis of deduction by Kamal--->
                    <cfif get_advance_salary_amount.RecordCount gt 0>
                        <cfif adv_salary_installments.RecordCount neq 0>
                            <cfquery name="update_adv_salary">
                                update advance_salary
                                set Remaining_balance = <cfqueryparam value = '#var_adv_salary_remaining_amount#'>,
                                Returned_Amount = <cfqueryparam value = '#var_adv_salary_returned_amount#'>
                                <cfif var_adv_salary_returned_amount eq adv_salary_installments.total_amount>
                                    ,status = 'N',
                                    advance_End_Date = now()
                                </cfif>
                                where
                                <cfif form.employee_id neq "All">
                                    employee_id = '#form.employee_id#'
                                <cfelse>
                                    employee_id = '#employee_id#'
                                </cfif>
                                and status = 'Y' 
                            </cfquery>
                        </cfif>
                    </cfif>
                </cfloop>
                <script>
                    alert("Pay Process Run Successfully!");
                    window.location.assign('pay.cfm');
                </script>
            <cfelse>
                <h1 class="text-center"> No Employees Selected </h1>
            </cfif>
        </cfif>
        <!--- ___________________________________________________ Front End _________________________________________________ --->
        <form action = "pay_process.cfm?run_pay_process=true" method = 'post'>
        <div class="employee_box">
            <div class="mb-5 text-center">
                <h3 class="box_heading">Run Pay Process</h3>
            </div>
            <div class = "row">
                <div class="col-md-2"></div>
                <div class = "col-md-5 mb-2">    
                    <select name = "employee_id" required class = "form-select"> 
                        <option value=""> -- Select Employee -- </option>
                        <option value = "All"> All </option>
                            <cfloop query="get_employee_list">
                                <option value = "#ID#"> #name# </option>
                            </cfloop>
                    </select>
                </div>
                <div class = "col-md-3">
                    <input type = "submit" name = "run_process" value = "Run Pay Process" class = "btn btn-outline-dark">
                </div>
                <div class="col-md-2"></div>
            </div>
        </div>
        </form>
    </cfif>
</cfoutput>

