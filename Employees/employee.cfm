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
<!---             <cfif employee_number eq ''> 
                <cfset employee_number = "0001">
            <cfelse>
                <cfset employee_number = int(employee_number) + 1>
                <cfset employee_number = numberFormat(#int('#employee_number#')#, '0000')>
            </cfif>--->
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
            from allowance where is_deleted is null or is_deleted = 'N'
        </cfquery>
        <cfquery name = "get_deduction"> <!--- get all saved Deductions / result used to print dynamic list with check boxes --->
            select deduction_name as name, deduction_amount as amount, deduction_id as id
            from deduction where is_deleted is null or is_deleted = 'N'
        </cfquery>
        <cfquery name = "get_leaves"> <!--- get all saved leaves / result used to print dynamic list with check boxes --->
            select leave_id as id, leave_title as title, allowed_per_year as balance
            from leaves where is_deleted is null or is_deleted = 'N'
        </cfquery>
        <!--- \|/_____________________________\|/_Back End_\|/__________________________________\|/ --->
        <cfparam  name="duplicate" default = "false">
        <!--- \|/_____________________________\|/_Create_\|/__________________________________\|/ --->  
        <cfif structKeyExists(form, 'create')>
            <cfquery name = "get_data">  <!--- query will get the last employee number --->
                select cnic as cnic, official_email as email
                from employee
                where cnic = '#form.cnic#' or official_email = '#form.official_email#'
            </cfquery>
            <cfif get_data.cnic eq #form.cnic#> <!--- Comparing Result to show error if cnic already exist --->
                <script>
                    alert('Employee cnic already Exists.');
                </script>
                <h3 style="color:red; text-align:center;" id = "error_massage1" > *Employee CNIC already Exists </h3>
                    <style> <!--- if error occor style will apply to input --->
                        .cnic{
                            border-color: red;
                            color: red;
                        }
                    </style>
                    
                <cfset duplicate = "true"> <!--- will be used to restore form information --->
            <cfelseif get_data.email eq '#form.official_email#'> <!--- Comparing Result to show error if email already exist --->
                <script>
                    alert('Employee official Email already Exists.');
                </script>
                <h3 style="color:red; text-align:center;" id = "error_massage2"> *Official Email already Exists </h3>
                    <style> <!--- if error occor style will apply to input --->
                        .email{
                            border-color: red;
                            color: red;
                        }
                    </style>
                <cfset duplicate = "true"> <!--- will be used to restore form information --->
            <cfelse>
                <cftransaction>
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
                        values(
                        <!--- concat('#get_designation.short_word#','#form.txt_employee_number#'), --->
                        <cfqueryparam value = '#form.txt_employee_number#'>,
                        <cfqueryparam value = '#form.txt_first_name#'>,
                        <cfqueryparam value = '#form.txt_middle_name#'>,
                        <cfqueryparam value = '#form.txt_last_name#'>,
                        <cfqueryparam value = '#form.txt_father_name#'>,
                        <cfqueryparam value = '#form.txt_father_cnic#'>, 
                        <cfqueryparam value = '#form.contact#'>,
                        <cfqueryparam value = '#form.emergency_contact1#'>,
                        <cfqueryparam value = '#form.emergency_contact2#'>, 
                        <cfqueryparam value = '#form.cnic#'>, 
                        <cfqueryparam value = '#form.personal_email#'>,
                        <cfqueryparam value = '#form.official_email#'>,
                        <cfqueryparam value = '#form.txt_city#'>,
                        <cfqueryparam value = '#form.txt_country#'>, 
                        <cfqueryparam value = '#form.txt_full_address#'>,
                        <cfqueryparam value = '#form.gender#'>,
                        <cfqueryparam value = '#form.dob#'>, 
                        <cfqueryparam value = '#form.marital_status#'>,
                        <cfqueryparam value = '#form.blood_group#'>,
                        <cfqueryparam value = '#form.religion#'>,
                        <cfqueryparam value = '#form.designation#'>, 
                        <cfqueryparam value = '#form.joining_date#'>,
                        <cfqueryparam value = '#form.leaving_date#'>,
                        <cfqueryparam value = '#form.covid_vaccination#'>,
                        <cfqueryparam value = '#form.department#'>, 
                        <cfqueryparam value = '#form.employment_type1#'>, 
                        <cfqueryparam value = '#form.employment_type2#'>,
                        <cfqueryparam value = '#form.workingdays_group#'>,
                        <cfqueryparam value = '#form.payment_mode#'>,
                        <cfqueryparam value = '#form.txt_bank_name#'>,
                        <cfqueryparam value = '#form.bank_account_no#'>,
                        now(),
                        <cfqueryparam value = '#get_designation.basic_salary#'>
                        )
                    </cfquery>
                    <!---    Password encryption     --->

                    <!--- Generate hashed password --->
                <!---    Insert uuid in uuid table accross the user name     --->
                    <cfquery name="insert_uuid">
                        insert into uuid_table (uuid , user_name)
                        values (<cfqueryparam value="#CreateUUID()#">, <cfqueryparam value="#form.txt_employee_number#">)
                    </cfquery>
                <!---      Get uuid of newly created user from uuid table and then hash the password and insert into user table  --->
                    <cfquery name="get_uuid">
                        select * from uuid_table
                        where user_name = "#form.txt_employee_number#"
                    </cfquery>
                    <cfset salt = "#get_uuid.uuid#">
                    <cfset password = "#form.cnic#">
                    <cfset hashed_Password = hash(password & salt, "SHA-256")>

                    <cfquery name = "insert_emp_user">
                        insert into emp_users
                        (
                            user_name, password, level
                        )
                        values
                        (   
                            <cfqueryparam value = '#form.txt_employee_number#'>,
                            <cfqueryparam value = '#hashed_Password#'>,
                            <cfqueryparam value = 'employee'>
                        )
                    </cfquery>
                    <cfquery name = "get_employee"> <!--- this query will return id of a recently created Employee --->
                        select employee_id as id
                        from employee
                        order by created_date desc
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
                                    (
                                        <cfqueryparam value = '#get_employee.id#'>,
                                        <cfqueryparam value = '#evaluate('form.chk_allowance#id#')#'>,
                                        '#evaluate('form.allowance_amount#id#')#',
                                        now(),
                                        <cfqueryparam value = 'Y'>
                                    )
                            </cfquery>
                            <!--- Insert Allowance items in to pay_allowance --->
                            <cfquery name = "insert_pay_allowance">
                                insert into pay_allowance 
                                    (employee_id,
                                    allowance_id,
                                    allowance_amount,
                                    status)
                                values
                                    (
                                        <cfqueryparam value = '#get_employee.id#'>,
                                        <cfqueryparam value = '#evaluate('form.chk_allowance#id#')#'>,
                                        <cfqueryparam value = '#evaluate('form.allowance_amount#id#')#'>,
                                        <cfqueryparam value = 'Y'>
                                    )
                            </cfquery>
                        </cfif>
                    </cfloop>
                    <!--- Insert Deductions ---> 
                    <cfloop query = "get_deduction">
                    <!--- <cfloop index="d" from="1" to="#count_deduction.counter#"> --->
                        <cfif isDefined("form.chk_deduction#id#")>
                            <cfquery name = "insert_deduction">
                                insert into employee_deduction (employee_id, deduction_id, deduction_amount, added_date, status)
                                values (
                                    <cfqueryparam value = '#get_employee.id#'>, 
                                    <cfqueryparam value = '#evaluate('form.chk_deduction#id#')#'>, 
                                    <cfqueryparam value = '#evaluate('form.deduction_amount#id#')#'>, 
                                    now(), 
                                    <cfqueryparam value = "Y">)
                            </cfquery>
                        </cfif>
                        <cfif isDefined("form.chk_deduction#id#")>
                            <cfquery name = "insert_pay_deduction">
                                insert into pay_deduction (employee_id, deduction_id, deduction_amount, status)
                                values (
                                    <cfqueryparam value = '#get_employee.id#'>, 
                                    <cfqueryparam value = '#evaluate('form.chk_deduction#id#')#'>, 
                                    <cfqueryparam value = '#evaluate('form.deduction_amount#id#')#'>, 
                                    <cfqueryparam value = "Y">)
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
                            <!---  change by M Usama add leave_balance column into insert query --->
                            <cfquery name = "insert_leaves"> 
                                insert into employee_leaves (employee_id, leave_id, leaves_allowed, leaves_balance, status)
                                values (
                                    <cfqueryparam value = '#get_employee.id#'>, 
                                    <cfqueryparam value = '#evaluate('form.chk_leaves#id#')#'>, 
                                    <cfqueryparam value = '#net_balance#'> , 
                                    <cfqueryparam value = '#net_balance#'> ,
                                    <cfqueryparam value = 'Y'>)
                            </cfquery>
                            <!---  change by M Usama add leave_balance column into insert query --->
                        </cfif>
                    </cfloop>
                    <cfquery name = "pay_employee"> <!--- Query will insert just employee_id as primary key and other coloums as null into current_month_pay table, data will be updated from another page --->
                        insert into current_month_pay (employee_id, pay_status)
                        values (<cfqueryparam value = '#get_employee.id#'>, <cfqueryparam value = 'Y'>)    
                    </cfquery>
                    <!--- upload file process --->
                    <cfquery name = "get_file_names">
                        select employee_id from file_names where employee_id = "#get_employee.id#"
                    </cfquery>
                    <cfif get_file_names.recordcount eq 0> <!--- if employee not exist already insert employee in table file_names  ---> 
                        <cfquery name = "insert_file_names">
                            insert into file_names (employee_id)
                            values (<cfqueryparam value = '#get_employee.id#'>)
                        </cfquery>
                    </cfif>
                    <cfset document_path = expandPath("/employees/documents/#get_employee.id#")>
                    <cfif directoryExists('#document_path#') eq false>
                        <cfset directoryCreate('#document_path#')>
                    </cfif>
                    <cfloop index="file_no" from="1" to="14">
                        <cfset currentFile = "file_" & file_no>
                        <cfif structKeyExists(form, "file_#file_no#") and evaluate("file_#file_no#") neq ''>
                            <cffile  
                                action="upload"
                                destination = "#document_path#"
                                fileField = "#currentFile#"
                                nameconflict = "MakeUnique"
                                result = "uploaded_file"
                            >
                            <cfset sourcePath = document_path & "\" & uploaded_file.clientFile>
                            <cfset finded = find(".", uploaded_file.clientFile)>
                            <cfset count = Len(uploaded_file.clientFile) - finded + 1>
                            <cfset file_type = right(uploaded_file.clientFile, count)>
                            <cfset destinationPath = document_path & "\" & currentFile & file_type>
                            <cffile  action="rename"
                                source = "#sourcePath#"
                                destination = "#destinationPath#"
                                attributes="normal"
                            >
                            <cfset file_name = currentFile & file_type>
                            <cfquery name = "update_file_names">
                                update file_names set #currentFile# = <cfqueryparam value = "#file_name#"> 
                                where employee_id = "#get_employee.id#"
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cftransaction>
                <cflocation  url="all_employees.cfm?created=true">
            </cfif>
        </cfif>
        <!--- \|/_____________________________\|/_Update_\|/__________________________________\|/ --->
        <cfif structKeyExists(url, 'edit')>
            <cfquery name = "get_employee"> <!--- result will be used to show in the form when updating employee information --->
                select * from employee
                where employee_id = "#url.edit#"
            </cfquery>
            <cfquery name = "get_employee_allowance"> 
                select allowance_id, status,allowance_amount
                from employee_allowance
                where employee_id = "#url.edit#" and status = "Y"
            </cfquery>
            <cfquery name = "get_employee_deduction"> 
                select deduction_id,deduction_amount
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
            <cftransaction>
                <cfquery name  = "update_employee"> <!--- update data in  employee table ---> 
                    update employee
                    set
                        first_name = <cfqueryparam value = '#form.txt_first_name#'>,  
                        middle_name = <cfqueryparam value = '#form.txt_middle_name#'>, 
                        last_name = <cfqueryparam value = '#form.txt_last_name#'>, 
                        father_name = <cfqueryparam value = '#form.txt_father_name#'>, 
                        father_cnic = <cfqueryparam value = '#form.txt_father_cnic#'>, 
                        contact = <cfqueryparam value = '#form.contact#'>, 
                        emergency_contact1 = <cfqueryparam value = '#form.emergency_contact1#'>, 
                        emergency_contact2 = <cfqueryparam value = '#form.emergency_contact2#'>, 
                        cnic = <cfqueryparam value = '#form.cnic#'>, 
                        personal_email = <cfqueryparam value = '#form.personal_email#'>, 
                        official_email = <cfqueryparam value = '#form.official_email#'>, 
                        city = <cfqueryparam value = '#form.txt_city#'>, 
                        country = <cfqueryparam value = '#form.txt_country#'>, 
                        full_address = <cfqueryparam value = '#form.txt_full_address#'>, 
                        gender = <cfqueryparam value = '#form.gender#'>, 
                        dob = <cfqueryparam value = '#form.dob#'>, 
                        marital_status = <cfqueryparam value = '#form.marital_status#'>, 
                        blood_group = <cfqueryparam value = '#form.blood_group#'>, 
                        Religion = <cfqueryparam value = '#form.religion#'>, 
                        designation = <cfqueryparam value = '#form.designation#'>,  
                        joining_date = <cfqueryparam value = '#form.joining_date#'>, 
                        leaving_date = <cfqueryparam value = '#form.leaving_date#'>, 
                        covid_vaccination = <cfqueryparam value = '#form.covid_vaccination#'>, 
                        department = <cfqueryparam value = '#form.department#'>,
                        employment_type1 = <cfqueryparam value = '#form.employment_type1#'>,
                        employment_type2 = <cfqueryparam value = '#form.employment_type2#'>,
                        workingdays_group = <cfqueryparam value = '#form.workingdays_group#'>,
                        payment_mode = <cfqueryparam value = '#form.payment_mode#'>,
                        bank_name = <cfqueryparam value = '#form.txt_bank_name#'>,
                        bank_account_no = <cfqueryparam value = '#form.bank_account_no#'>,
                        last_update = now(),
                        basic_salary = <cfqueryparam value = '#form.basic_salary#'>                
                    where employee_id = '#form.txt_employee_id#'
                </cfquery>
                <cfquery name = "get_employee_allowance">  <!---Reminder: a function can make code reuse --->
                    select allowance_id, status
                    from employee_allowance
                    where employee_id = "#form.txt_employee_id#"
                </cfquery>
                <!--- Queries for Updating Employee Allowances --->
                <cfif structKeyExists(form, 'chk_allowances')>
                    <cfloop query = "get_allowance">
                        <cfif isDefined('form.chk_allowance#id#')>  <!--- condition to verify the checkbox is checked or not --->
                                <cfquery name = "get_allowances">
                                    select * from employee_allowance
                                    where employee_id = '#form.txt_employee_id#' and allowance_id = '#evaluate('form.chk_allowance#id#')#'
                                </cfquery>
                                <cfif get_allowances.recordCount eq 0> 
                                    <cfquery name = "insert_newly_selected"> <!--- update employee allowance --->
                                        insert into employee_allowance (employee_id, allowance_id,allowance_amount, added_date , status)
                                        values (
                                            <cfqueryparam value = '#form.txt_employee_id#'>, 
                                            <cfqueryparam value = '#evaluate('form.chk_allowance#id#')#'>, 
                                            <cfqueryparam value = '#evaluate('form.allowance_amount#id#')#'>, 
                                            now(), 
                                            <cfqueryparam value = "Y">)
                                    </cfquery>
                                    <cfquery name = "insert_newly_selected_pay"> <!--- update pay allowance --->
                                        insert into pay_allowance (employee_id, allowance_id, allowance_amount, status)
                                        values (
                                            <cfqueryparam value = '#form.txt_employee_id#'>, 
                                            <cfqueryparam value = '#evaluate('form.chk_allowance#id#')#'>, 
                                            <cfqueryparam value = '#evaluate('form.allowance_amount#id#')#'>, 
                                            <cfqueryparam value = 'Y'>)
                                    </cfquery>
                                <cfelse>
                                    <cfquery name = "update_existing"> <!--- update employee allowance --->
                                        update employee_allowance
                                        set allowance_amount = <cfqueryparam value = '#evaluate('form.allowance_amount#id#')#'>, status = <cfqueryparam value = "Y">
                                        where allowance_id = '#evaluate('form.chk_allowance#id#')#' and employee_id = '#form.txt_employee_id#'
                                    </cfquery>
                                    <cfquery name = "update_existing_pay"> <!--- update pay allowance --->
                                        update pay_allowance
                                        set allowance_amount = <cfqueryparam value = '#evaluate('form.allowance_amount#id#')#'>, status = <cfqueryparam value = "Y">
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
                                set status = <cfqueryparam value = "N">, disabled_date = now(), disabled_by = <cfqueryparam value = '#session.loggedin.username#'>
                                where employee_id  = '#form.txt_employee_id#' and a.allowance_id = b.allowance_id
                            </cfquery>
                            <!--- If check box not checked update pay allowance's status as "N" --->
                            <cfquery name = "disable_existing_pay"> <!--- in case of unchecked checkboxes --->  
                                update pay_allowance a, (select allowance_id from pay_allowance
                                    where allowance_id in (
                                        select allowance_id
                                        from pay_allowance
                                        where employee_id = '#form.txt_employee_id#' and allowance_id = '#id#'
                                    )) as b
                                set status = <cfqueryparam value = "N">
                                where employee_id  = '#form.txt_employee_id#' 
                                and a.allowance_id = b.allowance_id
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
                <!--- Queries for Updating Employee Deductions --->
                <cfif structKeyExists(form, 'chk_deductions')>
                    <cfloop query = "get_deduction">
                        <cfif isDefined('form.chk_deduction#id#')> 
                            <cfquery name = "get_deductions">
                                select * from employee_deduction
                                where employee_id = '#form.txt_employee_id#' and deduction_id = '#evaluate('form.chk_deduction#id#')#'
                            </cfquery>
                            <cfif get_deductions.recordCount eq 0> 
                                <cfquery name = "insert_newly_selected_deduction">
                                    insert into employee_deduction (employee_id, deduction_id,deduction_amount, added_date , status)
                                    values (
                                        <cfqueryparam value = '#form.txt_employee_id#'>, 
                                        <cfqueryparam value = '#evaluate('form.chk_deduction#id#')#'>, 
                                        <cfqueryparam value = '#evaluate('form.deduction_amount#id#')#'>, 
                                        now(), 
                                        <cfqueryparam value = 'Y'>)
                                </cfquery>
                                <!--- pay deduction --->
                                <cfquery name = "insert_newly_selected_pay_deduction">
                                    insert into pay_deduction (employee_id, deduction_id, deduction_amount, status)
                                    values (
                                        <cfqueryparam value = '#form.txt_employee_id#'>, 
                                        <cfqueryparam value = '#evaluate('form.chk_deduction#id#')#'>, 
                                        <cfqueryparam value = '#evaluate('form.deduction_amount#id#')#'>, 
                                        <cfqueryparam value = 'Y'>)
                                </cfquery>
                            <cfelse>
                                <cfquery name = "update_existing_deduction">
                                    update employee_deduction
                                    set deduction_amount = <cfqueryparam value = '#evaluate('form.deduction_amount#id#')#'>, status = <cfqueryparam value = 'Y'>, disabled_date = now(), disabled_by = <cfqueryparam value = '#session.loggedin.username#'>
                                    where deduction_id = '#evaluate('form.chk_deduction#id#')#' and employee_id = '#form.txt_employee_id#'
                                </cfquery>
                                <!--- pay deduction --->
                                <cfquery name = "update_existing_pay_deduction">
                                    update pay_deduction
                                    set deduction_amount = <cfqueryparam value = '#evaluate('form.deduction_amount#id#')#'>, status = <cfqueryparam value = 'Y'>
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
                                    set status = <cfqueryparam value = "N">
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
                                    set status = <cfqueryparam value = "N">
                                    where employee_id  = '#form.txt_employee_id#' and a.deduction_id = b.deduction_id
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
                <!--- Queries for Updating Employee Leaves --->
                <cfif structKeyExists(form, 'chk_leaves')>
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
                                    <cfif structKeyExists(form, 'chk_leave_calculation')>
                                        <cfset remaining_months = 12>
                                    <cfelse>
                                        <cfset remaining_months = 12 - month(#form.joining_date#) + currentMonth> <!--- currentMonth = 1 for current month if currentMonth = 0 employee will not awarded by the leaves of joining month--->
                                    </cfif>
                                    <cfset net_balance = balance_per_month * remaining_months>
                                    <cfquery name = "insert_leaves"> <!--- Insert Leaves ---> 
                                        insert into employee_leaves (employee_id, leave_id, leaves_allowed, status)
                                        values (
                                            <cfqueryparam value = '#form.txt_employee_id#'>, 
                                            <cfqueryparam value = '#evaluate('form.chk_leaves#id#')#'>, 
                                            <cfqueryparam value = '#net_balance#'>, 
                                            <cfqueryparam value = 'Y'>)
                                    </cfquery>
                                <cfelse>
                                    <cfquery name = "update_existing_leaves">
                                        update employee_leaves
                                        set status = <cfqueryparam value = 'Y'>
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
                                set status = <cfqueryparam value = "N">, disabled_date = now(), disabled_by = <cfqueryparam value = '#session.loggedin.username#'>
                                where employee_id  = '#form.txt_employee_id#' and a.leave_id = b.leave_id
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>
                <!--- upload files process --->
                <cfquery name = "get_file_names">
                    select employee_id from file_names where employee_id = "#form.txt_employee_id#"
                </cfquery>
                <cfif get_file_names.recordcount eq 0> <!--- if employee not exist already insert employee in table file_names  ---> 
                    <cfquery name = "insert_file_names">
                        insert into file_names (employee_id)
                        values (<cfqueryparam value = '#form.txt_employee_id#'>)
                    </cfquery>
                </cfif>
                <cfset document_path = expandPath("/employees/documents/#form.txt_employee_id#")>
                    <cfif directoryExists('#document_path#') eq false>
                        <cfset directoryCreate('#document_path#')>
                    </cfif>
                <cfloop index="file_no" from="1" to="14">
                    <cfset currentFile = "file_" & file_no>
                    <cfif structKeyExists(form, "file_#file_no#") and evaluate("file_#file_no#") neq ''>
                        <cffile  
                            action="upload"
                            destination = "#document_path#"
                            fileField = "#currentFile#"
                            nameconflict = "MakeUnique"
                            result = "uploaded_file"
                        >
                        <cfset sourcePath = document_path & "\" & uploaded_file.clientFile>
                        <cfset finded = find(".", uploaded_file.clientFile)>
                        <cfset count = Len(uploaded_file.clientFile) - finded + 1>
                        <cfset file_type = right(uploaded_file.clientFile, count)>
                        <cfset destinationPath = document_path & "\" & currentFile & file_type>
                        <cffile  action="rename"
                            source = "#sourcePath#"
                            destination = "#destinationPath#"
                            attributes="normal"
                        >
                        <cfset file_name = currentFile & file_type>
                        <cfquery name = "update_file_names">
                            update file_names set #currentFile# = <cfqueryparam value = "#file_name#"> 
                            where employee_id = "#form.txt_employee_id#"
                        </cfquery>
                    </cfif>
                </cfloop>
            </cftransaction>
            <cflocation  url="all_employees.cfm?edited=#form.txt_employee_id#"> 
        </cfif>
        <!--- \|/_____________________________\|/_Front End_\|/__________________________________\|/ --->
<nav>
  <div class="nav nav-tabs" id="nav-tab" role="tablist">
    <button class="nav-link active" id="nav-personal-tab" data-bs-toggle="tab" data-bs-target="##nav-personal" type="button" role="tab" aria-controls="nav-personal" aria-selected="true">Personal Details</button>
    <button class="nav-link" id="nav-contact-tab" data-bs-toggle="tab" data-bs-target="##nav-contact" type="button" role="tab" aria-controls="nav-contact" aria-selected="true">Contact</button>
    <button class="nav-link" id="nav-allowances-tab" data-bs-toggle="tab" data-bs-target="##nav-allowances" type="button" role="tab" aria-controls="nav-allowances" aria-selected="false">Allowances</button>
    <button class="nav-link" id="nav-deductions-tab" data-bs-toggle="tab" data-bs-target="##nav-deductions" type="button" role="tab" aria-controls="nav-deductions" aria-selected="false">Deductions</button>
    <button class="nav-link" id="nav-leaves-tab" data-bs-toggle="tab" data-bs-target="##nav-leaves" type="button" role="tab" aria-controls="nav-leaves" aria-selected="false">Leaves</button>
    <button class="nav-link" id="nav-payment-tab" data-bs-toggle="tab" data-bs-target="##nav-payment" type="button" role="tab" aria-controls="nav-payment" aria-selected="false">Payment</button>
    <button class="nav-link" id="nav-files-tab" data-bs-toggle="tab" data-bs-target="##nav-files" type="button" role="tab" aria-controls="nav-files" aria-selected="false">Files</button>
    <button class="nav-link" id="nav-action-tab" data-bs-toggle="tab" data-bs-target="##nav-action" type="button" role="tab" aria-controls="nav-action" aria-selected="false" onclick = "validation1();">Action</button>
  </div>
</nav>
<form action = "employee.cfm" onsubmit="return formValidate();" method = "post" enctype="multipart/form-data">
    <div class="tab-content" id="nav-tabContent">
        <div class="tab-pane fade show active" id="nav-personal" role="tabpanel" aria-labelledby="nav-home-tab">
        <!---   Personal Detail --->
                <div class = "employee_box">
                        <div class = "row">
                            <div class = "col-md-2">
                                <label  class="form-control-label" for = "employee_id"> Employee Number<span class="required"> * </span> </label> 

                                <input required type = "text" name = "txt_employee_number" id = "employee_id" class = "form-control inpt" <cfif structKeyExists(url, 'edit')>value = "#url.edit#" readonly<cfelse> value = "#employee_number#" </cfif>>

                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "first_name">First Name<span class="required"> * </span></label>
                                <input type="text" name = "txt_first_name" id = "first_name" class = "form-control" placeholder = "First Name"  <cfif duplicate eq "true"> value = "#form.txt_first_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.first_name#" </cfif>>
                            </div>
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "middle_name"> Middle Name </label>
                                <input type="text" name = "txt_middle_name" placeholder = "Middle Name" id = "middle_name" class = "form-control" <cfif duplicate eq "true"> value = "#form.txt_middle_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.middle_name#" </cfif>>
                            </div>
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "last_name"> Last Name<span class="required"> * </span> </label> 
                                <input type="text" name = "txt_last_name" placeholder = "Last Name" id = "last_name" class = "form-control"  <cfif duplicate eq "true"> value = "#form.txt_last_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.last_name#" </cfif>>
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "father_name"> Father/Husband Name<span class="required"> * </span> </label>
                                <input type="text" name = "txt_father_name" id = "father_name" placeholder = "Father/Husband Name" class = "form-control"  <cfif duplicate eq "true"> value = "#form.txt_father_name#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.father_name#" </cfif>>
                            </div>
                            <div class = "col-md-4">
                                <label  class="form-control-label" for = "cnic"> Employee's CNIC No.<span class="required"> * </span> </label>
                                <input type = "number" id = "cnic" name = "cnic" placeholder = "13 Digits CNIC No. Without Dashes" class = "form-control"  <cfif duplicate eq "true"> value = "#form.cnic#" class = "cnic" id = "cnic" </cfif>  <cfif structKeyExists(url, 'edit')> value = "#get_employee.cnic#" </cfif>>
                            </div>
                            <div class = "col-md-4">
                                <label for = "txt_father_cnic" class = "form-control-label">Father/Husband CNIC No.<span class="required"> * </span> </label> 
                                <input type="number" name = "txt_father_cnic" id = "txt_father_cnic" placeholder = "13 Digits CNIC No. Without Dashes" class = "form-control"  <cfif duplicate eq "true"> value = "#form.txt_father_cnic#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.father_cnic#" </cfif>>   
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-2">
                                <label for = "txt_city" class = "form-control-label">City<span class="required"> * </span></label> 
                                <input type = "text" id = "txt_city" name = "txt_city"  class = "form-control" placeholder = "City Name"<cfif duplicate eq "true"> value = "#form.txt_city#"</cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.city#" </cfif>>
                            </div>
                            <div class = "col-md-2">
                                <label for = "txt_country" class = "form-control-label"> Country<span class="required"> * </span> </label> 
                                <input type = "text" name = "txt_country" id = "txt_country" class = "form-control" placeholder = "Country Name"  <cfif duplicate eq "true"> value = "#form.txt_country#"</cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.country#" </cfif>>
                            </div>
                            <div class = "col-md-8">
                                <label for = "txt_full_address" class = "form-control-label">Full Address<span class="required"> * </span> </label> 
                                <input type = "text" name = "txt_full_address" id = "txt_full_address" class = "form-control" placeholder = "Enter Full Address, Included Street, House etc"  <cfif duplicate eq "true"> value = "#form.txt_full_address#"</cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.full_address#" </cfif>>
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-4">
                                <label for = "designation" class = "form-select-label">Designation<span class="required"> * </span></label>
                                <cfquery name = "designation_list"> <!---With the help of Result, generate a dynamic list of designations --->
                                    select designation_title as title, designation_id as id
                                    from designation
                                </cfquery>
                                <select  name = "designation" id = "designation" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                    <option disabled> Select Designation </option>  
                                    <cfloop query = "designation_list"> <!--- printing dynamic list --->
                                        <option value = "#ID#"<cfif structKeyExists(url, 'edit')> <cfif get_employee.designation eq ID> selected  </cfif> </cfif>> #title# </option>
                                    </cfloop>
                                </select>
                            </div>
                            <div class = "col-md-2">
                                <label for = "dob" class = "form-control-label">DOB<span class="required"> * </span></label> 
                                <input type = "date" placeholder="YYYY-MM-DD"   name = "dob" id = "dob" class = "form-control"<cfif duplicate eq "true"> value = "#form.dob#"</cfif> <cfif structKeyExists(url, 'edit')> value = "#dateFormat(get_employee.dob, 'yyyy-mm-dd')#" </cfif>>  </td>
                            </div>
                            <div class = "col-md-6">
                                <div class = "row">
                                    <div class = "col-md-4">
                                        <label for = "marital_status" class = "form-control-label"> Marital Status:</label> 
                                        <select name = "marital_status" id = "marital_status" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                            <option value = "S"> Single </option>
                                            <option value = "M" <cfif structKeyExists(form,'marital_status')> <cfif form.marital_status eq "married">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.marital_status eq "m"> selected </cfif> </cfif> >  Married </option>
                                            <option value = "W" <cfif structKeyExists(form,'marital_status')> <cfif form.marital_status eq "widow">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.marital_status eq "w"> selected </cfif> </cfif>> Widow </option>
                                        </select>
                                    </div>
                                    <div class = "col-md-4">
                                        <label for = "blood_group" class = "form-select-label"> Blood Group:</label> 
                                        <select name = "blood_group" id = "blood_group" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
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
                                    <div class = "col-md-4">
                                        <label for = "religion" class = "form-select-label">Religion:</label> 
                                        <select name = "religion" id = "religion" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                            <option value = "M" > Muslim </option>
                                            <option value = "N" <cfif structKeyExists(form,'religion')> <cfif form.religion eq "N">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.religion eq "N"> selected </cfif> </cfif> >  Non-Muslim </option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-md-4">
                                    <label class = "form-check-label">Gender:</label>
                                    <input type = "radio" name = "gender" value = "M" checked = "true" id = "chk_male" class = "form-check-inline form-check-input ml-1"> 
                                    <label class="form-input-label ml-4" for = "chk_male">Male</label>
                                    <input type = "radio" name = "gender" value = "F" id = "chk_femail" class = "form-check-inline form-check-input ml-1" <cfif structKeyExists(form,'gender')> <cfif form.gender eq "F"> checked </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.gender eq "F"> checked </cfif> </cfif>>
                                    <label class="form-input-label ml-4" for = "chk_femail">Female</label>
                            </div>
                            <div class = "col-md-4">
                                <select name = "employment_type1" class="form-select form-select-md mb-3" aria-label=".form-select-md example" >
                                    <option value = "Fulltime" > Full Time </option>
                                    <option value = "Parttime" <cfif structKeyExists(form,'employment_type1')> <cfif form.employment_type1 eq "Parttime">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.employment_type1 eq "Parttime"> selected </cfif> </cfif> >  Part Time </option>
                                </select>
                            </div>
                            <div class = "col-md-4">
                                <select name = "employment_type2" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                    <option value = "Permanent" > Permanent </option>
                                        <option value = "Temporary" <cfif structKeyExists(form,'employment_type2')> <cfif form.employment_type2 eq "Temporary">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.employment_type2 eq "Temporary"> selected </cfif> </cfif> >  Temporary </option> 
                                </select>
                            </div>
                            
                        </div>
                    <div class = "row">
                        <div class = "col-md-4">
                            <label for = "covid_vaccination" class = "form-select-label">Covid Vaccine:</label>
                            <select name = "covid_vaccination" id = "covid_vaccination" class="form-select form-select-md mb-3" aria-label=".form-select-md example">
                                <option value = "Yes" > Yes </option>
                                <option value = "No" <cfif structKeyExists(form,'covid_vaccination')> <cfif form.covid_vaccination eq "No">selected </cfif> </cfif> <cfif structKeyExists(url, 'edit')> <cfif get_employee.covid_vaccination eq "No"> selected </cfif> </cfif> >  No </option>
                            </select>
                        </div>
                        <div class = "col-md-4">
                            <label for = "joining_date" class = "form-control-label"> Date of Joining<span class="required"> * </span> </label> 
                            <input type = "date" name = "joining_date" id = "joining_date"  class = "form-control" <cfif duplicate eq "true"> value = "#form.joining_date#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#dateFormat(get_employee.joining_date, 'yyyy-mm-dd')#" </cfif> > </td> 
                        </div>
                        <div class = "col-md-4">
                            <label for = "leaving_date" class = "form-control-label"> Date of Leaving: </label>
                            <input type = "date" name = "leaving_date" id = "leaving_date" class = "form-control"<cfif duplicate eq "true"> value = "#form.leaving_date#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#dateFormat(get_employee.leaving_date, 'yyyy-mm-dd')#" </cfif> > </td> 
                        </div>
                    </div>
                    <div class = "row">
                        <div class = "col-md-4">
                            <label for = "department" class = "form-control-label"> Department<span class="required"> * </span> </label>
                            <select  name = "department" id = "department" class = "form-select">
                                <cfloop query = "department_list"> <!--- printing dynamic list --->
                                    <option value = "#id#" <cfif structKeyExists(url, 'edit')> <cfif get_employee.department eq #ID# > selected </cfif> </cfif> > #name# </option>
                                </cfloop>
                            </select>
                        </div>
                        <div class = "col-md-4">
                            <label for = "workingdays_group" class = "form-control-label"> Working Days Group<span class="required"> * </span> </label>
                            <select  name = "workingdays_group" id = "workingdays_group" class = "form-select">
                                <cfloop query = "get_workingdays_groups"> <!--- printing dynamic list --->
                                    <option value = "#id#" <cfif structKeyExists(url, 'edit')> <cfif get_employee.workingdays_group eq #id# > selected </cfif> </cfif> > #group_name# </option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                </div> <!--- end personal detail --->
        </div>
        <!--- Contact Information --->
        <div class="tab-pane fade" id="nav-contact" role="tabpanel" aria-labelledby="nav-contact-tab">
            <div class = "employee_box">    
                <div class = "row">
                    <div class = "col-6">
                        <label for = "personal_email" class = "form-control-label"> Personal Email<span class="required"> * </span> </label> 
                        <input type = "text" id = "personal_email" name = "personal_email" class = "form-control" placeholder = "example@gamil.com"  <cfif duplicate eq "true"> value = "#form.personal_email#" class = "email" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.personal_email#" </cfif> >
                    </div>
                    <div class = "col-6">
                        <label for = "official_email"> Official Email<span class="required"> * </span> </label> 
                        <input type = "text" id = "official_email" name = "official_email" class = "form-control" placeholder = "example@bjs.com"  <cfif duplicate eq "true"> value = "#form.official_email#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.official_email#" </cfif> > </td>
                    </div>
                </div>
                <div class = "row">
                    <div class = "col-md-4">
                        <label for = "contact" class = "form-control-label"> Contact No.<span class="required"> * </span></label> 
                        <input type = "number" name = "contact" id = "contact" placeholder = "Minimum 11 Digits" class = "form-control"  <cfif duplicate eq "true"> value = "#form.contact#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.contact#" </cfif> >
                    </div>
                    <div class = "col-md-4">
                        <label for = "emergency_contact1" class = "form-control-label"> Emergency Contact No.1<span class="required"> * </span> </label>
                        <input type = "number" placeholder = "Minimum 11 Digits"  class = "form-control" name = "emergency_contact1" id = "emergency_contact1" <cfif duplicate eq "true"> value = "#form.emergency_contact1#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.emergency_contact1#" </cfif> >
                    </div>
                    <div class = "col-md-4">
                        <label for = "emergency_contact2" class = "form-control-label"> Emergency Contact No.2:</label>
                        <input type = "number" placeholder = "Minimum 11 Digits"  class = "form-control" id="emergency_contact2" name = "emergency_contact2" <cfif duplicate eq "true"> value = "#form.emergency_contact2#" </cfif> <cfif structKeyExists(url, 'edit')> value = "#get_employee.emergency_contact2#" </cfif> > </td>
                    </div>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="nav-allowances" role="tabpanel" aria-labelledby="nav-allowances-tab">
        <!---   Allowances --->
            <div class = "employee_box">
                <div class = "row">
                    <cfloop query="get_allowance">
                        <div class = "col-5">    
                            <input class = "form-check-input ml-3" name = "chk_allowance#id#" id="chk_allowance#id#" onclick="javascript:allowance_deduction('allowance');" value = "#id#" type = "checkbox" <cfif structKeyExists(url, 'edit')> <cfloop query = "get_employee_allowance"> <cfif allowance_id eq get_allowance.id > checked </cfif> </cfloop> </cfif> > 
                            <label for = "chk_allowance#id#" class = "form-check-label ml-5">#name#</lable> 
                        </div>
                        <div class = "col-7">
                            <input class = "form-control" type = "number" step="0.00001" min = "0" name = "allowance_amount#id#" id = "allowance_amount#id#" style = "visibility:hidden;" <cfif structKeyExists(url, 'edit')> <cfloop query = "get_employee_allowance"> <cfif allowance_id eq get_allowance.id > value = "#allowance_amount#" </cfif></cfloop> </cfif> value = "#amount#" > <br>
                        </div>
                    </cfloop>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="nav-deductions" role="tabpanel" aria-labelledby="nav-deductions-tab">
        <!---   Deductions --->
            <div class = "employee_box">
                <div class = "row">
                    <cfloop query="get_deduction">
                        <div class = "col-5">
                            <input class = "form-check-input ml-3" name = "chk_deduction#id#" value = "#id#" id = "chk_deduction#id#" onclick="javascript:allowance_deduction('deduction');" type = "checkbox" <cfif structKeyExists(url, 'edit')> <cfloop query = "get_employee_deduction"> <cfif deduction_id eq get_deduction.id > checked  </cfif> </cfloop> </cfif>> 
                            <label for = "chk_deduction#id#" class = "form-check-label ml-5" >#name#</label> 
                        </div>
                        <div class = "col-7">
                            <input type = "number"  min = "0" step="0.00001" class = "form-control" id = "deduction_amount#id#" name = "deduction_amount#id#" style="visibility:hidden;" <cfif structKeyExists(url, 'edit')> <cfloop query = "get_employee_deduction"> <cfif deduction_id eq get_deduction.id > value = "#deduction_amount#" </cfif></cfloop></cfif> value = "#amount#" > <br>
                        </div>
                    </cfloop>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="nav-leaves" role="tabpanel" aria-labelledby="nav-leaves-tab">
        <!---   Leaves --->
            <div class = "employee_box">
                <cfloop query="get_leaves"> <!--- Dynamic List of Leaves --->

                    <div class = "row align-items-center">
                        <input name = "chk_leaves#id#" class = "form-check-input ml-3"  id="chk_leaves#id#" value = "#id#" type = "checkbox" <cfif structKeyExists(url, 'edit')> <cfloop query = "get_employee_leaves"> <cfif leave_id eq get_leaves.id and get_employee_leaves.status eq "Y" > checked </cfif> </cfloop> </cfif> >
                        <label for = "chk_leaves#id#" class = "form-check-label ml-5" > #title# </label>
                    </div>
                </cfloop>
                <div class = "form-group">
                    <input name = "chk_leave_calculation" id = "chk_leave_calculation" class = "form-check-input ml-3" value = "1" type = "checkbox" <cfif not structKeyExists(url, 'edit')>checked = "true"</cfif>>
                    <label for = "chk_leave_calculation" class = "form-check-label ml-5" > Calculate Leave Balance According to Date of Joining </label>
                </div>
            </div> <!--- Ending Leaves --->
        </div>
        <!---   Payment Detail--->
        <div class="tab-pane fade" id="nav-payment" role="tabpanel" aria-labelledby="nav-payment-tab">
            <div class = "employee_box">
                <div class="row">
                    <div class = "col-md-4">
                        <cfif structKeyExists(url, 'edit')> 
                            <label for = "basic_salary" class = "form-control-label"> Basic Salary: </label>
                            <input id = "basic_salary" class = "form-control" value = "#get_employee.basic_salary#" name = "basic_salary">
                        </cfif>
                    </div>
                </div>
                <div class = "row">
                    <div class = "col-md-4">
                        <label for = "payment_mode" class = "form-select-label">Payment Method</label>
                        <select name = "payment_mode" id = "payment_mode" onchange = "javascript:bank('cash');" class = "form-select">
                            <option value = "cash" id = "cash"> Cash </option>
                            <option value = "cheque" id = "cheque" <cfif structKeyExists(url, 'edit')> <cfif get_employee.payment_mode eq "cheque" > selected </cfif> </cfif>> Cheque </option>
                            <option value = "transfer" id = "transfer" <cfif structKeyExists(url, 'edit')> <cfif get_employee.payment_mode eq "transfer" > selected </cfif> </cfif> > Bank Transfer </option>
                        </select>
                    </div>
                    <div class = "col-md-4">
                        <label for = "bank_name" class = "form-select-label" id = "bank_label">Bank Name:</label>
                        <input class = "form-control" type = "text" id = "bank_name" name = "txt_bank_name" placeholder = "Enter Bank Name"  style="display:none;" <cfif structKeyExists(url, 'edit')> value = "#get_employee.bank_name#" </cfif> > <br>                      
                    </div>
                    <div class = "col-md-4">
                        <label for = "bank_account_no" class = "form-select-label" id = "account_label">Bank Account No.:</label>
                        <input class = "form-control" type = "number" id = "bank_account_no" name = "bank_account_no" placeholder = "Enter Bank Account No." style="display:none;" <cfif structKeyExists(url, 'edit')> value = "#get_employee.bank_account_no#" </cfif>> <br>                      
                    </div>
                </div>
            </div>
        </div><!--- Ending payment detail --->
        <!--- Files --->
        <div class="tab-pane fade" id="nav-files" role="tabpanel" aria-labelledby="nav-files-tab">
            <div class = "employee_box">
                <cfset files_array = arrayNew(1)>
                <cfset files_array = [   
                                        "ID Card Front (Only .jpg or .png)", 
                                        "ID Card Back (Only .jpg or .png)" ,
                                        "Profile Photo (Only .jpg or .png)",
                                        "Passport Size Photo (Only .jpg or .png)",
                                        "Formal Photograph (Only .jpg or .png)",
                                        "CV (Only .DOCX or .pdf)",
                                        "Experience Letter (Only .docx or .pdf)", 
                                        "Offer Letter (Only .pdf)",
                                        "Agreement (Only .pdf)",
                                        "Covid19 Vaccination (Only .jpg or .png or .pdf)",
                                        "Most Recent Degree (Only .pdf or .jpg or .png)",
                                        "Other Certificate 1 (Only .jpg or .png or .pdf)",
                                        "Other Certificate 2 (Only .jpg or .png or .pdf)",
                                        "Other Documents (Only .jpg or .png or .pdf)"
                                        ]>
                <cfset i = 0>
                <cfloop array="#files_array#" index="file_no">
                    <cfset i = i + 1>
                    <div class = "row mb-3">
                        <div class = "col-md-6">
                            <label for = "file_#i#" class = "form-control-label">#file_no#</label>
                        </div>
                        <div class = "col-md-4">
                            <input type = "file" id = "file_#i#" onchange="filevalidation('#i#', '#file_no#');" name = "file_#i#" class = "form-control">
                        </div>
                        <cfif structKeyExists(url, 'edit')>
                            <cfquery name = "get_employee_files">
                                select * from file_names where employee_id = "#url.edit#"
                            </cfquery>
                            <cfif evaluate('get_employee_files.file_#i#') neq ''>
                                <cfset file_name = evaluate('get_employee_files.file_#i#')>
                                <cfset file_path = expandpath('/employees/documents/#url.edit#/#file_name#')>
                                <cfif fileExists(file_path) eq true>
                                    <div class = "col-md-2">
                                        <a href = "/employees/documents/#url.edit#/#file_name#" target = "blank" download>
                                            <input type = "button" id = "file_#i#_btn" name = "file_#i#_btn" value = "Download" class = "form-control">
                                        </a>
                                    </div>
                                </cfif> 
                            </cfif>
                        </cfif>
                    </div>
                </cfloop>
                <cfset i = 0>
            </div>
        </div>
        <!--- End Files --->
        <!--- Action --->
        <div class="tab-pane fade" id="nav-action" role="tabpanel" aria-labelledby="nav-action-tab">
            <div class = "employee_box">
                <cfif structKeyExists(url, 'edit')>
                <div class = "row container">
                    <div class = "col-md-4">
                        <input type = "checkbox" name = "chk_allowances" id = "Allowances" class = "form-check-input">
                        <label for = "Allowances"  class = "form-check-label">Update Allowances</label>
                    </div>
                    <div class = "col-md-4">
                        <input type = "checkbox" name = "chk_deductions" id = "Deductions" class = "form-check-input">
                        <label for = "Deductions" class = "form-check-label">Update Deductions</label>
                    </div>
                    <div class = "col-md-4">
                        <input type = "checkbox" name = "chk_leaves" id = "leaves" class = "form-check-input">
                        <label for = "leaves" class = "form-check-label">Update Leaves</label>
                    </div>
                </div>
                </cfif>
                <ol id = "validation1" class = "text-danger">
                </ol>
                    <div style = "text-align:center;">
                        <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "update" <cfelse> "create" </cfif>>
                        <cfif structKeyExists(url, 'edit')> <input type = "hidden" name = "txt_employee_id" value = "#url.edit#"> </cfif>
                        <input type = "submit"  id "submit" class = "btn btn-outline-dark" value = <cfif structKeyExists(url, 'edit')> "Update Employee" <cfelse> "Create Employee" </cfif>>
                    </div>
                </form>
            </div>
        </div><!--- Ending Action --->
    </div><!--- Ending Tabs --->
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
                document.getElementById("bank_label").style.visibility = "hidden";
                document.getElementById("account_label").style.visibility = "hidden";
                document.getElementById("bank_name").required = false;
                document.getElementById("bank_account_no").required = false;
                } 
                else {
                document.getElementById("bank_name").style.display = 'inline';
                document.getElementById("bank_account_no").style.display = 'inline';
                document.getElementById("bank_label").style.visibility = "visible";
                document.getElementById("account_label").style.visibility = "visible";
                document.getElementById("bank_name").required = true;
                document.getElementById("bank_account_no").required = true;
                }
            }
            function filevalidation(i, name){
                let file_name = $('#file_'+i).val();
                let extension = file_name.split(".")[1].toUpperCase()
                if(i <=5){
                    if(extension != "PNG" && extension != "JPG" && extension != "JPEG"){
                        alert("File : "+name+"\nFile with ." + file_name.split(".")[1] + " extension is invalid. Upload a valid file with PNG, JPG or JPEG extensions.")
                        $('#file_'+i).val('');
                        $('#file_'+i).focus();
                        return false;
                    }
                }else if( i>5 && i<=7){
                    if(extension != "DOC" && extension != "DOCX" && extension != "PDF"){
                        alert("File : "+name+"\nFile with ." + file_name.split(".")[1] + " extension is invalid. Upload a valid file with DOC, DOCX or PDF extensions.")
                        $('#file_'+i).val('');
                        $('#file_'+i).focus();
                        return false;
                    }
                }else if(i>7 && i<=9){
                    if(extension != "PDF"){
                        alert("File : "+name+"\nFile with ." + file_name.split(".")[1] + " extension is invalid. Upload a valid file with .PDF extensions.")
                        $('#file_'+i).val('');
                        $('#file_'+i).focus();
                        return false;
                    }
                }else if(i>9){
                    if(extension != "PNG" && extension != "JPG" && extension != "JPEG" && extension != "PDF"){
                        alert("File : "+name+"\nFile with ." + file_name.split(".")[1] + " extension is invalid. Upload a valid file with PNG, JPG, JPEG or PDF extensions.")
                        $('#file_'+i).val('');
                        $('#file_'+i).focus();
                        return false;
                    }
                }
            }
            function IsEmail(email) {
                var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if(!regex.test(email)) {
                    return false;
                }else{
                    return true;
                }
            }
            function containsNonNumeric(str) {
                return /\D/.test(str);
            }
            function formValidate(){
                const array_of_id = ["employee_id","first_name","last_name","father_name","cnic","txt_father_cnic","txt_city","txt_country","txt_full_address","designation","dob","joining_date","department","workingdays_group","personal_email","official_email","contact","emergency_contact1"];
                const array_of_names = ["txt_employee_number","txt_first_name","txt_last_name","txt_father_name","cnic","txt_father_cnic","txt_city","txt_country","txt_full_address","designation","dob","joining_date","department","workingdays_group","personal_email","official_email","contact","emergency_contact1"];
                var error_message = "";
                array_of_id.forEach(myFunction);
                function myFunction(item, index){
                    if(document.getElementById(item).value == ''){
                        error_message = error_message + array_of_names[index] + " is must required\n";
                    } 
                }
                if(error_message != ''){
                    alert(error_message);
                    return false;
                }
                var personal_email = $('#personal_email').val();
                var official_email = $('#official_email').val();
                var cnic =$('#cnic').val();
                var father_cnic = $('#txt_father_cnic').val();
                var contact = $('#contact').val();
                var emergency_contact1 = $('#emergency_contact1').val();
                var emergency_contact2 = $('#emergency_contact2').val();
                if(IsEmail(personal_email) == false){
                    alert('Personal Email is inValid.');
                    return false;
                }
                if(IsEmail(official_email) == false){
                    alert('official Email is inValid.');
                    return false;
                }
                if((containsNonNumeric(cnic)== true) || (cnic.length != 13)){
                    alert('Cnic Number contain non numaric character or length not equal to 13 digit.')
                    return false;
                }
                if((containsNonNumeric(father_cnic) == true) || (father_cnic.length != 13)){
                    alert('Father cnic Number contain non numaric character or length not equal to 13 digit.')
                    return false;
                }
                if(((containsNonNumeric(contact) == true) || (containsNonNumeric(emergency_contact1) == true) || (containsNonNumeric(emergency_contact2) == true)) || (contact.length != 11 || emergency_contact1.length != 11 || emergency_contact2.length != 11)){
                    alert("Contacts with non numeric characters or length not equal to 11 are not allowed.");
                    return false;
                } 
                return true; 
            }
             function validation1(){
                var error = document.querySelector('#validation1');
                var validationFlag = 0;
                error.innerHTML = "";
                if(document.getElementById('first_name').value == ''){
                    error.innerHTML += "<li>" + "First name is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('last_name').value == ''){
                    error.innerHTML += "<li>" + "Last name is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('father_name').value == ''){
                    error.innerHTML += "<li>" + "Father/Husband name is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('cnic').value == ''){
                    error.innerHTML += "<li>" + "Employee CNIC is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('txt_city').value == ''){
                    error.innerHTML += "<li>" + "City Name is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('txt_country').value == ''){
                    error.innerHTML += "<li>" + "Country Name is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('txt_full_address').value == ''){
                    error.innerHTML += "<li>" + "Full Address is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('designation').value == ''){
                    error.innerHTML += "<li>" + "Designation is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('department').value == ''){
                    error.innerHTML += "<li>" + "Department is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('dob').value == ''){
                    error.innerHTML += "<li>" + "Date of Birth (DOB) is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('joining_date').value == ''){
                    error.innerHTML += "<li>" + "Date of Joining is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('workingdays_group').value == ''){
                    error.innerHTML += "<li>" + "Working Days Group is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('personal_email').value == ''){
                    error.innerHTML += "<li>" + "Personal Email is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('official_email').value == ''){
                    error.innerHTML += "<li>" + "Official Email is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('contact').value == ''){
                    error.innerHTML += "<li>" + "Contact No. is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(document.getElementById('emergency_contact1').value == ''){
                    error.innerHTML += "<li>" + "Emergency Contact No.1 is required" + "</li>";
                    validationFlag = validationFlag + 1;
                }
                if(validationFlag >= 1 ){
                    document.getElementById("submit").disabled = true;
                }
            }
            allowance_deduction('allowance');
            allowance_deduction('deduction');
            bank('cash');
        </script>
<cfinclude  template="..\includes\foot.cfm">

