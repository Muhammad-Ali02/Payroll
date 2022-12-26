<cfoutput>
    <cfinclude  template="head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- ___________________________________________________ Back end ________________________________________________ --->
        <!--- Query to print dynamic drop dwon list of all employees --->
        <cfquery name = "get_employee_list">
            select concat(a.employee_id, " | ", a.first_name," ",a.middle_name," ",a.last_name) as name, a.employee_id as id
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
                            employee_id = "#form.employee_id#"
                        <cfelse>
                            processed is not null or processed != ''
                        </cfif>

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
                    <cfset var_gross_allowances = allowance_amount + (basic_rate * (paid_leaves + additional_days + (half_paid_leaves/2)))>
                    <cfset var_gross_deductions = deduction_amount + (basic_rate * (leaves_without_pay + deducted_days)) >
                    <cfset var_gross_salary = ((basic_rate * (days_worked + additional_days))) + var_gross_allowances>
                    <cfset var_net_salary = var_gross_salary - var_gross_deductions>
                    <cfquery name = "update_pay"> <!--- Query Will update all requirements --->
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
                    </cfquery>
                </cfloop>
                <h1> Pay Process Run Successfully </h1>
            <cfelse>
                <h1> No Employees Selected </h1>
            </cfif>
        </cfif>
        <!--- ___________________________________________________ Front End _________________________________________________ --->
        <form action = "pay_process.cfm?run_pay_process=true" method = 'post'>
            <select name = "employee_id" required> 
                <option disabled> Select Employee </option>
                <option value = "All"> All </option>
                    <cfloop query="get_employee_list">
                        <option value = "#ID#"> #name# </option>
                    </cfloop>
            </select>
            <input type = "submit" name = "run_process" value = "Run Pay Process">
        </form>
    </cfif>
</cfoutput>
<cfinclude  template="foot.cfm">
