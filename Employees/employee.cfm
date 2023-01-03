<cfoutput>
    <cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfquery name = "last_employee"> <!--- get last employee to generate auto employee number of new employee ---> 
                select employee_id
                from employee
                order by created_date desc
                limit 1
            </cfquery>
            <cfset employee_number = right('#last_employee.employee_id#', 4) >
            <cfif employee_number eq ''>
                <cfset employee_number = "0001">
            <cfelse>
                <cfset employee_number = int(employee_number) + 1>
                <cfset employee_number = numberFormat(#int('#employee_number#')#, '0000')>
            </cfif>
        <h3 style="color:red; text-align:center; display:none;" id = "error_massage1" > *CNIC already Exists </h3>
        <cfquery name = "department_list"> <!---With the help of Result, generate a dynamic list of Departments --->
            select department_name as name, department_id as id
            from department
            where is_deleted is null or is_deleted = 'N'
        </cfquery>
        <cfquery name = "get_workingdays_groups"> <!--- get all saved workingdays / result used to print dynamic list with check boxes --->
            select group_name, group_id as id 
            from working_days
        </cfquery>
        <cfquery name = "get_allowance"> <!--- get all saved allowance / result used to print dynamic list with check boxes --->
            select allowance_name as name, allowance_amount as amount, allowance_id as id
            from allowance
        </cfquery>
        <cfquery name = "get_deduction"> <!--- get all saved Deductions / result used to print dynamic list with check boxes --->
            select deduction_name as name, deduction_amount as amount, deduction_id as id
            from deduction
        </cfquery>
        <cfquery name = "get_leaves"> <!--- get all saved leaves / result used to print dynamic list with check boxes --->
            select leave_id as id, leave_title as title, allowed_per_year as balance
            from leaves 
        </cfquery>
        <!--- \|/_____________________________\|/_Back End_\|/__________________________________\|/ --->
        <cfparam  name="duplicate" default = "false">
        <!--- \|/_____________________________\|/_Create_\|/__________________________________\|/ --->    
        <cfif structKeyExists(form, 'create')> <!--- query will get the last employee number --->
            <!--- Query will return a cnic if already exist --->
            <cfquery name = "get_data">
                select cnic as cnic, official_email as email
                from employee
                where cnic = '#form.cnic#' or official_email = '#form.official_email#'
            </cfquery>
            <cfif get_data.cnic eq #form.cnic#> <!--- Comparing Result to show error if cnic already exist --->
                <h3 style="color:red; text-align:center; display:none;" id = "error_massage1" > *CNIC already Exists </h3>
                    <style> <!--- if error occor style will apply to input --->
                        .cnic {
                            border-color: red;
                            color: red;
                        }
                    </style>
                <cfset duplicate = "true"> <!--- will be used to restore form information --->
            <cfelseif get_data.email eq '#form.official_email#'> <!--- Comparing Result to show error if email already exist --->
                <h3 style="color:red; text-align:center" id = "error_massage2"> *Email already Exists </h3>
                    <style> <!--- if error occor style will apply to input --->
                        .email {
                            border-color: red;
                            color: red;
                        }
                    </style>
                <cfset duplicate = "true"> <!--- will be used to restore form information --->
            <cfelse>
                <cfquery name = "get_designation"> <!--- query result will be use to set value of salary dynamically in employee table --->
                    select * 
                    from designation 
                    where designation_id = "#form.designation#"
                </cfquery>
                <!--- Query will insert data into Employee table --->
                <cfquery name = "insert_employee">
                    insert into employee (employee_id,
                    first_name, 
                    middle_name, 
                    last_name, 
                    father_name, 
                    father_cnic, 
                    contact, 
                    emergency_contact1, 
                    emergency_contact2, 
                    cnic, 
                    personal_email, 
                    official_email, 
                    city, 
                    country, 
                    full_address, 
                    gender, 
                    dob, 
                    marital_status, 
                    blood_group, 
                    Religion, 
                    designation,  
                    joining_date, 
                    leaving_date, 
                    covid_vaccination, 
                    department,
                    employment_type1,
                    employment_type2,
                    workingdays_group,
                    payment_mode,
                    bank_name,
                    bank_account_no, 
                    created_date,
                    basic_salary)
                    values(concat('#get_designation.short_word#','#form.txt_employee_number#'),
                    '#form.txt_first_name#',
                    '#form.txt_middle_name#',
                    '#form.txt_last_name#',
                    '#form.txt_father_name#',
                    '#form.txt_father_cnic#', 
                    '#form.contact#',
                    '#form.emergency_contact1#',
                    '#form.emergency_contact2#', 
                    '#form.cnic#', 
                    '#form.personal_email#',
                    '#form.official_email#',
                    '#form.txt_city#',
                    '#form.txt_country#', 
                    '#form.txt_full_address#',
                    '#form.gender#',
                    '#form.dob#', 
                    '#form.marital_status#',
                    '#form.blood_group#',
                    '#form.religion#',
                    '#form.designation#', 
                    '#form.joining_date#',
                    '#form.leaving_date#',
                    '#form.covid_vaccination#',
                    '#form.department#', 
                    '#form.employment_type1#', 
                    '#form.employment_type2#',
                    '#form.workingdays_group#',
                    '#form.payment_mode#',
                    '#form.txt_bank_name#',
                    '#form.bank_account_no#',
                    now(),
                    '#get_designation.basic_salary#'
                    )
                </cfquery>
                <cfquery name = "get_employee"> <!--- this query will return id of a recently created Employee --->
                    select employee_id as id
                    from employee
                    order by employee_id desc
                    limit 1
                </cfquery>
                <cfloop query = "get_allowance">
                    <!--- Insert Allowance items in to Employee_allowance --->
                    <cfif isDefined("form.chk_allowance#id#")>
                        <cfquery name = "insert_allowance">
                            insert into employee_allowance 
                                (employee_id,
                                allowance_id,
                                allowance_amount,
                                added_date,
                                status)
                            values 
                                ('#get_employee.id#',
                                '#evaluate('form.chk_allowance#id#')#',
                                '#evaluate('form.allowance_amount#id#')#',
                                now(),
                                'Y')
                        </cfquery>
                        <!--- Insert Allowance items in to pay_allowance --->
                        <cfquery name = "insert_pay_allowance">
                            insert into pay_allowance 
                                (employee_id,
                                allowance_id,
                                allowance_amount,
                                status)
                            values
                                ('#get_employee.id#',
                                '#evaluate('form.chk_allowance#id#')#',
                                '#evaluate('form.allowance_amount#id#')#',
                                'Y')
                        </cfquery>
                    </cfif>
                </cfloop>
                <!--- Insert Deductions ---> 
                <cfloop query = "get_deduction">
                <!--- <cfloop index="d" from="1" to="#count_deduction.counter#"> --->
                    <cfif isDefined("form.chk_deduction#id#")>
                        <cfquery name = "insert_deduction">
                            insert into employee_deduction (employee_id, deduction_id, deduction_amount, added_date, status)
                            values ('#get_employee.id#', '#evaluate('form.chk_deduction#id#')#', '#evaluate('form.deduction_amount#id#')#', now(), "Y")
                        </cfquery>
                    </cfif>
                    <cfif isDefined("form.chk_deduction#id#")>
                        <cfquery name = "insert_pay_deduction">
                            insert into pay_deduction (employee_id, deduction_id, deduction_amount, status)
                            values ('#get_employee.id#', '#evaluate('form.chk_deduction#id#')#', '#evaluate('form.deduction_amount#id#')#', "Y")
                        </cfquery>
                    </cfif>
                </cfloop>
                <cfloop query = "get_leaves">
                    <cfif isDefined("form.chk_leaves#id#")>
                        <cfquery name = "get_leave_balance"> <!--- result will use to calculate leave balance according to date of joining --->
                            select allowed_per_year as leave_balance
                            from leaves
                            where leave_id = '#evaluate("form.chk_leaves#id#")#'
                        </cfquery>
                        <!--- variables for calculation of leave balance --->
                        <cfset balance_per_month = get_leave_balance.leave_balance / 12 >
                        <cfset remaining_months = 12 - month(#form.joining_date#) + 1> <!--- +1 for current month --->
                        <cfset net_balance = balance_per_month * remaining_months>
                        <cfquery name = "insert_leaves"> 
                            insert into employee_leaves (employee_id, leave_id, leaves_allowed, status)
                            values ('#get_employee.id#', '#evaluate('form.chk_leaves#id#')#', '#net_balance#' , 'Y')
                        </cfquery>
                    </cfif>
                </cfloop>
                <cfquery name = "pay_employee"> <!--- Query will insert just employee_id as primary key and other coloums as null into current_month_pay table, data will be updated from another page --->
                    insert into current_month_pay (employee_id, pay_status)
                    values ('#get_employee.id#', 'Y')    
                </cfquery>
                <cflocation url="employee.cfm?created=true">               
            </cfif>
        </cfif>
        <!--- \|/_____________________________\|/_Update_\|/__________________________________\|/ --->
        <cfif structKeyExists(url, 'edit')>
            <cfquery name = "get_employee"> <!--- result will be used to show in the form when updating employee information --->
                select * from employee
                where employee_id = "#url.edit#"
            </cfquery>
            <cfquery name = "get_employee_allowance"> 
                select allowance_id, status
                from employee_allowance
                where employee_id = "#url.edit#" and status = "Y"
            </cfquery>
            <cfquery name = "get_employee_deduction"> 
                select deduction_id
                from employee_deduction
                where employee_id = "#url.edit#" and status = "Y"
            </cfquery>
            <cfquery name = "get_employee_leaves"> <!--- get all leaves allowed to an employee --->
                select * 
                from employee_leaves
                where employee_id = "#url.edit#"
            </cfquery>
        </cfif>
        <cfif structKeyExists(form, 'update')>
            <cfquery name  = "update_employee"> <!--- update data in  employee table ---> 
                update employee
                set
                    first_name = '#form.txt_first_name#',  
                    middle_name = '#form.txt_middle_name#', 
                    last_name = '#form.txt_last_name#', 
                    father_name = '#form.txt_father_name#', 
                    father_cnic = '#form.txt_father_cnic#', 
                    contact = '#form.contact#', 
                    emergency_contact1 = '#form.emergency_contact1#', 
                    emergency_contact2 = '#form.emergency_contact2#', 
                    cnic = '#form.cnic#', 
                    personal_email = '#form.personal_email#', 
                    official_email = '#form.official_email#', 
                    city = '#form.txt_city#', 
                    country ='#form.txt_country#', 
                    full_address = '#form.txt_full_address#', 
                    gender = '#form.gender#', 
                    dob = '#form.dob#', 
                    marital_status = '#form.marital_status#', 
                    blood_group = '#form.blood_group#', 
                    Religion = '#form.religion#', 
                    designation = '#form.designation#',  
                    joining_date = '#form.joining_date#', 
                    leaving_date = '#form.leaving_date#', 
                    covid_vaccination = '#form.covid_vaccination#', 
                    department = '#form.department#',
                    employment_type1 = '#form.employment_type1#',
                    employment_type2 = '#form.employment_type2#',
                    workingdays_group = '#form.workingdays_group#',
                    payment_mode = '#form.payment_mode#',
                    bank_name = '#form.txt_bank_name#',
                    bank_account_no = '#form.bank_account_no#',
                    last_update = now(),
                    basic_salary = '#form.basic_salary#'                
                where employee_id = '#form.txt_employee_id#'
            </cfquery>
            <cfquery name = "get_employee_allowance">  <!---Reminder: a function can make code reuse --->
                select allowance_id, status
                from employee_allowance
                where employee_id = "#form.txt_employee_id#"
            </cfquery>
            <!--- Queries for Updating Employee Allowances --->
            <cfloop query = "get_allowance">
                <cfif isDefined('form.chk_allowance#id#')>  <!--- condition to verify the checkbox is checked or not --->
                        <cfquery name = "get_allowances">
                            select * from employee_allowance
                            where employee_id = '#form.txt_employee_id#' and allowance_id = '#evaluate('form.chk_allowance#id#')#'
                        </cfquery>
                        <cfif get_allowances.recordCount eq 0> 
                            <cfquery name = "insert_newly_selected">
                                insert into employee_allowance (employee_id, allowance_id,allowance_amount, added_date , status)
                                values ('#form.txt_employee_id#', '#evaluate('form.chk_allowance#id#')#', '#evaluate('form.allowance_amount#id#')#', now(), "Y")
                            </cfquery>
                            <cfquery name = "insert_newly_selected_pay">
                                insert into pay_allowance (employee_id, allowance_id, allowance_amount, status)
                                values ('#form.txt_employee_id#', '#evaluate('form.chk_allowance#id#')#', '#evaluate('form.allowance_amount#id#')#', 'Y')
                            </cfquery>
                        <cfelse>
                            <cfquery name = "update_existing">
                                update employee_allowance
                                set allowance_amount = '#evaluate('form.allowance_amount#id#')#', status = "Y"
                                where allowance_id = '#evaluate('form.chk_allowance#id#')#' and employee_id = '#form.txt_employee_id#'
                            </cfquery>
                            <cfquery name = "update_existing_pay">
                                update pay_allowance
                                set allowance_amount = '#evaluate('form.allowance_amount#id#')#', status = "Y"
                                where allowance_id = '#evaluate('form.chk_allowance#id#')#' and employee_id = '#form.txt_employee_id#'
                            </cfquery>
                        </cfif>
                <cfelse> 
                    <cfquery name = "disable_existing"> <!--- in case of unchecked checkboxes --->  
                        update employee_allowance a, (select allowance_id from employee_allowance
                            where allowance_id in (
                                select allowance_id
                                from employee_allowance
                                where employee_id = '#form.txt_employee_id#' and allowance_id = '#id#'
                            )) as b
                        set status = "N", disabled_date = now(), disabled_by = '#session.loggedin.username#'
                        where employee_id  = '#form.txt_employee_id#' and a.allowance_id = b.allowance_id
                    </cfquery>
                    <!--- If check box not checked update pay deduction's status as "N" --->
                    <cfquery name = "disable_existing_pay"> <!--- in case of unchecked checkboxes --->  
                        update pay_allowance a, (select allowance_id from pay_allowance
                            where allowance_id in (
                                select allowance_id
                                from pay_allowance
                                where employee_id = '#form.txt_employee_id#' and allowance_id = '#id#'
                            )) as b
                        set status = "N"
                        where employee_id  = '#form.txt_employee_id#' 
                        and a.allowance_id = b.allowance_id
                    </cfquery>
                </cfif>
            </cfloop>
            <!--- Queries for Updating Employee Deductions --->
            <cfloop query = "get_deduction">
                <cfif isDefined('form.chk_deduction#id#')> 
                    <cfquery name = "get_deductions">
                        select * from employee_deduction
                        where employee_id = '#form.txt_employee_id#' and deduction_id = '#evaluate('form.chk_deduction#id#')#'
                    </cfquery>
                    <cfif get_deductions.recordCount eq 0> 
                        <cfquery name = "insert_newly_selected_deduction">
                            insert into employee_deduction (employee_id, deduction_id,deduction_amount, added_date , status)
                            values ('#form.txt_employee_id#', '#evaluate('form.chk_deduction#id#')#', '#evaluate('form.deduction_amount#id#')#', now(), 'Y')
                        </cfquery>
                        <!--- pay deduction --->
                        <cfquery name = "insert_newly_selected_pay_deduction">
                            insert into pay_deduction (employee_id, deduction_id, deduction_amount, status)
                            values ('#form.txt_employee_id#', '#evaluate('form.chk_deduction#id#')#', '#evaluate('form.deduction_amount#id#')#', 'Y')
                        </cfquery>
                    <cfelse>
                        <cfquery name = "update_existing_deduction">
                            update employee_deduction
                            set deduction_amount = '#evaluate('form.deduction_amount#id#')#', status = 'Y', disabled_date = now(), disabled_by = '#session.loggedin.username#'
                            where deduction_id = '#evaluate('form.chk_deduction#id#')#' and employee_id = '#form.txt_employee_id#'
                        </cfquery>
                        <!--- pay deduction --->
                        <cfquery name = "update_existing_pay_deduction">
                            update pay_deduction
                            set deduction_amount = '#evaluate('form.deduction_amount#id#')#', status = 'Y'
                            where deduction_id = '#evaluate('form.chk_deduction#id#')#' and employee_id = '#form.txt_employee_id#'
                        </cfquery>
                    </cfif>
                <cfelse> 
                    <cfquery name = "disable_existing_deduction"> <!--- in case of unchecked --->  
                            update employee_deduction a, (select deduction_id from employee_deduction
                                where deduction_id in (
                                    select deduction_id
                                    from employee_deduction
                                    where employee_id = '#form.txt_employee_id#' and deduction_id = '#id#'
                                )) as b
                            set status = "N"
                            where employee_id  = '#form.txt_employee_id#' and a.deduction_id = b.deduction_id
                    </cfquery>
                    <!--- pay deduction --->
                    <cfquery name = "disable_existing_pay_deduction"> <!--- in case of unchecked --->  
                            update pay_deduction a, (select deduction_id from pay_deduction
                                where deduction_id in (
                                    select deduction_id
                                    from pay_deduction
                                    where employee_id = '#form.txt_employee_id#' and deduction_id = '#id#'
                                )) as b
                            set status = "N"
                            where employee_id  = '#form.txt_employee_id#' and a.deduction_id = b.deduction_id
                    </cfquery>
                </cfif>
            </cfloop>
            <!--- Queries for Updating Employee Leaves --->
            <cfloop query = "get_leaves">
                <cfif isDefined('form.chk_leaves#id#')>  <!--- condition to verify the checkbox is checked or not --->
                        <cfquery name = "get_existing_leaves">
                            select * from employee_leaves
                            where employee_id = '#form.txt_employee_id#' and leave_id = '#evaluate('form.chk_leaves#id#')#'
                        </cfquery>
                        <cfif get_existing_leaves.recordCount eq 0>
                            <cfquery name = "get_leave_balance"> <!--- result will use to calculate leave balance according to date of joining --->
                                select allowed_per_year as leave_balance
                                from leaves
                                where leave_id = '#evaluate("form.chk_leaves#id#")#'
                            </cfquery>
                            <!--- variables for calculation of leave balance --->
                            <cfset balance_per_month = get_leave_balance.leave_balance / 12 >
                            <cfset currentDate = dateFormat(now(),'dd-mm-yyyy')>
                            <cfif day(currentDate) gt 22 >
                                <cfset currentMonth = 0>
                            <cfelse>
                                <cfset currentMonth = 1>
                            </cfif>
                            <cfset remaining_months = 12 - month(#form.joining_date#) + currentMonth> <!--- currentMonth = 1 for current month if currentMonth = 0 employee will not awarded by the leaves of joining month--->
                            <cfset net_balance = balance_per_month * remaining_months>
                            <cfquery name = "insert_leaves"> <!--- Insert Leaves ---> 
                                insert into employee_leaves (employee_id, leave_id, leaves_allowed, status)
                                values ('#form.txt_employee_id#', '#evaluate('form.chk_leaves#id#')#', '#net_balance#', 'Y')
                            </cfquery>
                        <cfelse>
                            <cfquery name = "update_existing_leaves">
                                update employee_leaves
                                set status = 'Y'
                                where leave_id = '#evaluate('form.chk_leaves#id#')#' and employee_id = '#form.txt_employee_id#'
                            </cfquery>
                        </cfif>
                <cfelse>
                    <cfquery name = "disable_existing_leaves"> <!--- in case of unchecked checkboxes --->  
                        update employee_leaves a, (select leave_id from employee_leaves
                            where leave_id in (
                                select leave_id
                                from employee_leaves
                                where employee_id = '#form.txt_employee_id#' and leave_id = '#id#'
                            )) as b
                        set status = "N", disabled_date = now(), disabled_by = '#session.loggedin.username#'
                        where employee_id  = '#form.txt_employee_id#' and a.leave_id = b.leave_id
                    </cfquery>
                </cfif>
            </cfloop>
            <cflocation  url="all_employees.cfm?edited=#form.txt_employee_id#">
        </cfif>
        <!--- \|/_____________________________\|/_Front End_\|/__________________________________\|/ --->
        <cfif structKeyExists(url, 'created')>
            <h3 style="color:green; text-align:center"> Employee Created Successfully </h3>
        </cfif>
<nav>
  <div class="nav nav-tabs" id="nav-tab" role="tablist">
    <button class="nav-link active" id="nav-personal-tab" data-bs-toggle="tab" data-bs-target="##nav-personal" type="button" role="tab" aria-controls="nav-personal" aria-selected="true">Personal Details</button>
    <button class="nav-link" id="nav-contact-tab" data-bs-toggle="tab" data-bs-target="##nav-contact" type="button" role="tab" aria-controls="nav-contact" aria-selected="true">Contact</button>
    <button class="nav-link" id="nav-allowances-tab" data-bs-toggle="tab" data-bs-target="##nav-allowances" type="button" role="tab" aria-controls="nav-allowances" aria-selected="false">Allowances</button>
    <button class="nav-link" id="nav-deductions-tab" data-bs-toggle="tab" data-bs-target="##nav-deductions" type="button" role="tab" aria-controls="nav-deductions" aria-selected="false">Deductions</button>
    <button class="nav-link" id="nav-leaves-tab" data-bs-toggle="tab" data-bs-target="##nav-leaves" type="button" role="tab" aria-controls="nav-leaves" aria-selected="false">Leaves</button>
    <button class="nav-link" id="nav-payment-tab" data-bs-toggle="tab" data-bs-target="##nav-payment" type="button" role="tab" aria-controls="nav-payment" aria-selected="false">Payment</button>
  </div>
</nav>
<form action = "employee.cfm" method = "post">
    <div class="tab-content" id="nav-tabContent">
        <div class="tab-pane fade show active" id="nav-personal" role="tabpanel" aria-labelledby="nav-home-tab">
        <!---   Personal Detail --->
                <div class = "container">
                        <div class = "row">
                            <div class = "col-md-2">
                                <label  class="form-control-label" for = "employee_no"> Employee Number: </label> 
                                <input type = "text" name = "txt_employee_number" id = "employee_no" class = "form-control inpt" <cfif structKeyExists(url, 'edit')>value = "#url.edit#" <cfelse> value = "#employee_number#" </cfif> readonly>
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-4">
                                <label  class="form-check-label" for = "first_name"> First Name*</label>
                                <input name = "txt_first_name" id = "first_name" class = "form-control" placeholder = "First Name" required <cfif duplicate eq "true"> value = "#form.txt_first_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.first_name#" </cfif>>
                            </div>
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "middle_name"> Middle Name </label>
                                <input name = "txt_middle_name" placeholder = "Middle Name" id = "middle_name" class = "form-control" <cfif duplicate eq "true"> value = "#form.txt_middle_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.middle_name#" </cfif>>
                            </div>
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "last_name"> Last Name* </label> 
                                <input name = "txt_last_name" placeholder = "Last Name" id = "last_name" class = "form-control" required <cfif duplicate eq "true"> value = "#form.txt_last_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.last_name#" </cfif>>
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "father_name"> Father/Husband Name* </label>
                                <input name = "txt_father_name" id = "father_name" placeholder = "Father/Husband Name" class = "form-control" required <cfif duplicate eq "true"> value = "#form.txt_father_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.father_name#" </cfif>>
                            </div>
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "cnic"> Employee's CNIC No. </label>
                                <input type = "number"  minlength = "13" maxlength = "13"  name = "cnic" placeholder = "13 Digits CNIC No. Without Dashes" class = "form-control" required <cfif duplicate eq "true"> value = "#form.cnic#" class = "cnic" id = "cnic" </cfif>  <cfif structKeyExists(url, 'edit')> value = "#get_employee.cnic#" </cfif>> </td> 
                            </div>
                            <div class = "col-md-4">
                                Father/Husband CNIC No.: <input name = "txt_father_cnic" minlength = "13" maxlength = "13" placeholder = "13 Digits CNIC No. Without Dashes" class = "form-control" required <cfif duplicate eq "true"> value = "#form.txt_first_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.father_cnic#" </cfif>>   
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-2">
                                City*: <input type = "text" name = "txt_city" required class = "form-control" placeholder = "City Name"<cfif duplicate eq "true"> value = "#form.txt_city#"</cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.city#" </cfif>> </td>
                            </div>
                            <div class = "col-md-2">
                                Country*: <input type = "text" name = "txt_country" class = "form-control" placeholder = "Country Name" required <cfif duplicate eq "true"> value = "#form.txt_country#"</cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.country#" </cfif>> </td>
                            </div>
                            <div class = "col-md-8">
                                Full Address*: <input type = "text" name = "txt_full_address" class = "form-control" placeholder = "Enter Full Address, Included Street, House etc" maxlength = "200" required <cfif duplicate eq "true"> value = "#form.txt_full_address#"</cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.full_address#" </cfif>> </td>
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-4">
                                Designation: 
                                <cfquery name = "designation_list"> <!---With the help of Result, generate a dynamic list of designations --->
                                    select designation_title as title, designation_id as id
                                    from designation
                                </cfquery>
                                <select name = "designation" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                    <option disabled> Select Designation </option>  
                                    <cfloop query = "designation_list"> <!--- printing dynamic list --->
                                        <option value = "#ID#"<cfif structKeyExists(url, 'edit')> <cfif get_employee.designation eq ID> selected  </cfif> </cfif>> #title# </option>
                                    </cfloop>
                                </select>
                            </div>
                            <div class = "col-md-2">
                                DOB: <input type = "date" placeholder="YYYY-MM-DD" required  name = "dob" required class = "form-control"<cfif duplicate eq "true"> value = "#form.dob#"</cfif> <cfif structKeyExists(url, 'edit')> value = "#dateFormat(get_employee.dob, 'yyyy-mm-dd')#" </cfif>>  </td>
                            </div>
                            <div class = "col-md-6">
                                <div class = "row">
                                    <div class = "col-md-3">
                                        Marital Status: 
                                        <select name = "marital_status" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                            <option value = "S"> Single </option>
                                            <option value = "M" <cfif structKeyExists(form,'marital_status')> <cfif form.marital_status eq "married">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.marital_status eq "m"> selected </cfif> </cfif> >  Married </option>
                                            <option value = "W" <cfif structKeyExists(form,'marital_status')> <cfif form.marital_status eq "widow">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.marital_status eq "w"> selected </cfif> </cfif>> Widow </option>
                                        </select>
                                    </div>
                                    <div class = "col-md-3">
                                        Blood Group: 
                                        <select name = "blood_group" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                            <option value = "A+" > A+ </option>
                                            <option value = "A-" <cfif structKeyExists(form,'blood_group')> <cfif form.blood_group eq "A-">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.blood_group eq "A-"> selected </cfif> </cfif> >  A- </option>
                                            <option value = "B+" <cfif structKeyExists(form,'blood_group')> <cfif form.blood_group eq "B+">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.blood_group eq "B+"> selected </cfif> </cfif> >  B+ </option>
                                            <option value = "B-" <cfif structKeyExists(form,'blood_group')> <cfif form.blood_group eq "B-">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.blood_group eq "B-"> selected </cfif> </cfif> >  B- </option>
                                            <option value = "O+" <cfif structKeyExists(form,'blood_group')> <cfif form.blood_group eq "O+-">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.blood_group eq "O+"> selected </cfif> </cfif> >  O+ </option>
                                            <option value = "O-" <cfif structKeyExists(form,'blood_group')> <cfif form.blood_group eq "O-">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.blood_group eq "O-"> selected </cfif> </cfif> >  O- </option>
                                            <option value = "AB+" <cfif structKeyExists(form,'blood_group')> <cfif form.blood_group eq "AB+">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.blood_group eq "AB+"> selected </cfif> </cfif> >  AB+ </option>
                                            <option value = "AB-" <cfif structKeyExists(form,'blood_group')> <cfif form.blood_group eq "AB-">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.blood_group eq "AB-"> selected </cfif> </cfif> >  AB- </option>
                                        </select>
                                    </div>
                                    <div class = "col-md-3">
                                        Religion: 
                                        <select name = "religion" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                            <option value = "M" > Muslim </option>
                                            <option value = "N" <cfif structKeyExists(form,'religion')> <cfif form.religion eq "N">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.religion eq "N"> selected </cfif> </cfif> >  Non-Muslim </option>
                                        </select>
                                    </div>
                                    <div class = "col-md-3">
                                        Covid Vaccine: 
                                        <select name = "covid_vaccination" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                            <option value = "Yes" > Yes </option>
                                            <option value = "No" <cfif structKeyExists(form,'covid_vaccination')> <cfif form.covid_vaccination eq "No">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.covid_vaccination eq "No"> selected </cfif> </cfif> >  No </option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class = "align-items-center  row">
                            <div class = "col-md-2">
                                        Gender:<br>
                                        <label class="form-check-label" for = "chk_male"> Male:</label> 
                                        <input type = "radio" name = "gender" value = "M" checked = "true" id = "chk_male" class = "form-check-inline"> 
                                        <label class="form-check-label" for = "chk_femail"> Female:</label>
                                        <input type = "radio" name = "gender" value = "F" id = "chk_femail" class = "form-check-inline" <cfif structKeyExists(form,'gender')> <cfif form.gender eq "F"> checked </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.gender eq "F"> checked </cfif> </cfif>>
                            </div>
                            <div class = "col-md-6 align-items-center">
                                <div class = "align-items-center row">
                                    <div class = "col-md-4">
                                        Employment Type: 
                                    </div>
                                    <div class = "col-md-3 align-items-center">
                                        <select name = "employment_type1" class="form-select form-select-md mb-3" aria-label=".form-select-md example" >
                                            <option value = "Fulltime" > Full Time </option>
                                            <option value = "Parttime" <cfif structKeyExists(form,'employment_type1')> <cfif form.employment_type1 eq "Parttime">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.employment_type1 eq "Parttime"> selected </cfif> </cfif> >  Part Time </option>
                                        </select>
                                    </div>
                                    <div class = "col-md-4 align-items-center">
                                        <select name = "employment_type2" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                            <option value = "Permanent" > Permanent </option>
                                                <option value = "Temporary" <cfif structKeyExists(form,'employment_type2')> <cfif form.employment_type2 eq "Temporary">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.employment_type2 eq "Temporary"> selected </cfif> </cfif> >  Temporary </option> 
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class = "col-md-2">
                                Date of Joining: <input type = "date" name = "joining_date" required class = "form-control" <cfif duplicate eq "true"> value = "#form.joining_date#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#dateFormat(get_employee.joining_date, 'yyyy-mm-dd')#" </cfif> > </td> 
                            </div>
                            <div class = "col-md-2">
                                Date of Leaving: <input type = "date" name = "leaving_date" class = "form-control"<cfif duplicate eq "true"> value = "#form.leaving_date#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#dateFormat(get_employee.leaving_date, 'yyyy-mm-dd')#" </cfif> > </td> 
                            </div>
                        </div>
                    <div class = "row">
                        <div class = "col-md-5">
                            Department:
                            <select name = "department" class = "form-select">
                                <cfloop query = "department_list"> <!--- printing dynamic list --->
                                    <option value = "#id#" <cfif structKeyExists(url, 'edit')> <cfif get_employee.department eq #ID# > selected </cfif> </cfif> > #name# </option>
                                </cfloop>
                            </select>
                        </div>
                        <div class = "col-md-5">
                            Working Days Group:
                            <select name = "workingdays_group" class = "form-select">
                                <cfloop query = "get_workingdays_groups"> <!--- printing dynamic list --->
                                    <option value = "#id#" <cfif structKeyExists(url, 'edit')> <cfif get_employee.workingdays_group eq #id# > selected </cfif> </cfif> > #group_name# </option>
                                </cfloop>
                            </select>
                        </div>
                        <div class = "col-md-2">
                            <cfif structKeyExists(url, 'edit')> 
                                <label for = "basic_salary" > Basic Salary: </label>
                                <input id = "basic_salary" class = "form-control" value = "#get_employee.basic_salary#" name = "basic_salary">
                            </cfif>
                        </div>
                    </div>
                </div> <!--- end personal detail --->
        </div>
        <div class="tab-pane fade" id="nav-contact" role="tabpanel" aria-labelledby="nav-contact-tab">
            <h4>Contact Information</h4>
            <div class = "row">
                <div class = "col-6">
                    Personal Email*: <input type = "email" name = "personal_email" class = "form-control" placeholder = "example@gamil.com" required <cfif duplicate eq "true"> value = "#form.personal_email#" class = "email" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.personal_email#" </cfif> >
                </div>
                <div class = "col-6">
                    Official Email*: <input type = "email" name = "official_email" class = "form-control" placeholder = "example@bjs.com" required <cfif duplicate eq "true"> value = "#form.official_email#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.official_email#" </cfif> > </td>
                </div>
            </div>
            <div class = "row">
                <div class = "col-md-4">
                    Contact No.* <input type = "number" minlength = "11" maxlength = "11" name = "contact" placeholder = "Minimum 11 Digits" class = "form-control" required <cfif duplicate eq "true"> value = "#form.contact#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.contact#" </cfif> >
                </div>
                <div class = "col-md-4">
                    Emergency Contact No.1*: <input type = "number" minlength = "11" maxlength = "11" placeholder = "Minimum 11 Digits" required class = "form-control" name = "emergency_contact1" <cfif duplicate eq "true"> value = "#form.emergency_contact1#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.emergency_contact1#" </cfif> >
                </div>
                <div class = "col-md-4">
                    Emergency Contact No.2:<input type = "number" minlength = "11" maxlength = "11" placeholder = "Minimum 11 Digits" required class = "form-control" name = "emergency_contact2" <cfif duplicate eq "true"> value = "#form.emergency_contact2#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.emergency_contact2#" </cfif> > </td>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="nav-allowances" role="tabpanel" aria-labelledby="nav-allowances-tab">
        <!---   Allowances --->
            <div class = "container">
                <h4>Allowances</h4>
                <div class = "row">
                    <cfloop query="get_allowance">
                        <div class = "col-5">    
                            <label for = "chk_allowance#id#"> #name# </lable> 
                            <input class = "form-check-inline" name = "chk_allowance#id#" id="chk_allowance#id#" onclick="javascript:allowance_deduction('allowance');" value = "#id#" type = "checkbox" <cfif structKeyExists(url, 'edit')> <cfloop query = "get_employee_allowance"> <cfif allowance_id eq get_allowance.id > checked </cfif> </cfloop> </cfif> > 
                        </div>
                        <div class = "col-7">
                            <input class = "form-control" type = "number"  min = "0"name = "allowance_amount#id#" id = "allowance_amount#id#" style = "visibility:hidden;" value = "#amount#"><br>
                        </div>
                    </cfloop>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="nav-deductions" role="tabpanel" aria-labelledby="nav-deductions-tab">
        <!---   Deductions --->
            <div class = "container">
                <div class ="row">
                    <h4>Deductions</h4>
                </div>
                <div class = "row">
                    <cfloop query="get_deduction">
                            <div class = "col-5">
                                <label>#name#</label> <input class = "form-check-inline" name = "chk_deduction#id#" value = "#id#" id = "chk_deduction#id#" onclick="javascript:allowance_deduction('deduction');" type = "checkbox" <cfif structKeyExists(url, 'edit')> <cfloop query = "get_employee_deduction"> <cfif deduction_id eq get_deduction.id > checked  </cfif> </cfloop> </cfif>> 
                            </div>
                            <div class = "col-7">
                                <input type = "number"  min = "0" class = "form-control" id = "deduction_amount#id#" name = "deduction_amount#id#" value = "#amount#" style="visibility:hidden;"> <br>
                            </div>
                    </cfloop>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="nav-leaves" role="tabpanel" aria-labelledby="nav-leaves-tab">
        <!---   Leaves --->
            <div class = "container">
                <h4> Leaves: </h4>
                <cfloop query="get_leaves"> <!--- Dynamic List of Leaves --->
                    <div class = "row align-items-center">
                            <label for = "chk_leaves#id#"> #title# </label>
                            <input name = "chk_leaves#id#" id="chk_leaves#id#" value = "#id#" type = "checkbox" <cfif structKeyExists(url, 'edit')> <cfloop query = "get_employee_leaves"> <cfif leave_id eq get_leaves.id and get_employee_leaves.status eq "Y" > checked </cfif> </cfloop> </cfif> >
                    </div>
                </cfloop>
            </div> <!--- Ending Leaves --->
        </div>
        <div class="tab-pane fade" id="nav-payment" role="tabpanel" aria-labelledby="nav-payment-tab">
        <!---   Payment --->
            <div class = "container">
                    <h4> Payment Detail: </h4> <br>    
                        <select name = "payment_mode" onchange = "javascript:bank('cash');" class = "form-select">
                            <option value = "cash" id = "cash"> Cash </option>
                            <option value = "cheque" id = "cheque" <cfif structKeyExists(url, 'edit')> <cfif get_employee.payment_mode eq "cheque" > selected </cfif> </cfif>> Cheque </option>
                            <option value = "transfer" id = "transfer" <cfif structKeyExists(url, 'edit')> <cfif get_employee.payment_mode eq "transfer" > selected </cfif> </cfif> > Bank Transfer </option>
                        </select>
                        <input class = "form-control" type = "text" id = "bank_name" name = "txt_bank_name" placeholder = "Enter Bank Name"  style="display:none;" <cfif structKeyExists(url, 'edit')> value = "#get_employee.bank_name#" </cfif> > <br>                      
                        <input class = "form-control" type = "number" id = "bank_account_no" name = "bank_account_no" placeholder = "Enter Bank Account No." style="display:none;" <cfif structKeyExists(url, 'edit')> value = "#get_employee.bank_account_no#" </cfif>> <br>                      
            </div>
        </div><!--- Ending payment detail --->
    </div><!--- Ending Tabs --->
<input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "update" <cfelse> "create" </cfif>>
    <cfif structKeyExists(url, 'edit')> <input type = "hidden" name = "txt_employee_id" value = "#url.edit#"> </cfif>
    <br>
    <input type = "submit"  class = "btn btn-outline-info" value = <cfif structKeyExists(url, 'edit')> "Update Employee" <cfelse> "Create Employee" </cfif>>
</form>
</cfif>
</cfoutput>
        <!--- Javascript functions --->
        <script type="text/javascript">
            // Arrays to store query result (IDs of Allowances and Deductions)
            const allowance_id = [];
            const deduction_id = [];
            <cfloop query="get_allowance">
                    <cfoutput>
                        var #toScript(id, "jsid")#;
                    </cfoutput>
                        allowance_id.push(jsid);
                </cfloop>
            <cfloop query="get_deduction">
                <cfoutput>
                    var #toScript(id, "jsid")#;
                </cfoutput>
                    deduction_id.push(jsid);
            </cfloop>
            // Function to show hide input of amount of allowances and deductions
            function allowance_deduction(name1){
                if (name1 == 'allowance'){
                    var total_ids = allowance_id.length;
                    var name = 'chk_allowance';
                    var amount = 'allowance_amount';
                }
                else if (name1 == 'deduction'){
                    var total_ids = deduction_id.length;
                    var name = 'chk_deduction';
                    var amount = 'deduction_amount';
                }
                for(let i = 0; i < total_ids; i++){
                    if (name1 == 'allowance'){
                        var id = allowance_id[i];
                    }
                    else if (name1 == 'deduction'){
                        var id = deduction_id[i];
                    }
                    if (document.getElementById(name+id).checked == true) {
                    document.getElementById(amount+id).style.visibility = 'visible';
                    } 
                    else {
                    document.getElementById(amount+id).style.visibility = 'hidden';
                    }
                }
            }
            //function to show hide bank detail in payment detail section
            function bank(id) {
                if (document.getElementById(id).selected == true) {
                document.getElementById("bank_name").style.display = 'none';
                document.getElementById("bank_account_no").style.display = 'none';
                document.getElementById("bank_name").required = false;
                document.getElementById("bank_account_no").required = false;
                } 
                else {
                document.getElementById("bank_name").style.display = 'inline';
                document.getElementById("bank_account_no").style.display = 'inline';
                document.getElementById("bank_name").required = true;
                document.getElementById("bank_account_no").required = true;
                }
            }
            allowance_deduction('allowance');
            allowance_deduction('deduction');
            bank('cash');
        </script>
<cfinclude  template="..\includes\foot.cfm">

