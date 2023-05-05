<style type="text/css">
    #loader-wrapper {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    background-color: rgba(255, 255, 255, 0.7);
    display: none;
    }
    #loader {
    border: 16px solid #f3f3f3;
    border-top: 16px solid #024069e9;
    border-radius: 50%;
    width: 120px;
    height: 120px;
    animation: spin 1s linear infinite;
    position: absolute;
    top: 32%;
    left: 50%;
    transform: translate(-50%, -50%);
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    #progress_bar{
        width: auto;
        position: absolute;
        margin-top: 10px;
        top: 50%;
        margin-top: 5px;
        left: 47%;
        font-size: medium;
        font-weight: 500;
    }
</style>
<cfoutput>
            <!---       Front End           --->
    <div id="loader-wrapper">
        <div id="loader" style="display:none;"></div>
        <div id="progress_bar" class="mt-10" style="color: black;">Loading....... Please Wait!</div> 
    </div> 
    <div class="employee_box">
        <div class="text-center mb-5">
            <h3 class="box_heading">
                Month End Process
            </h3>
        </div>
        <cfquery name="check_current_month_data">
            select * from current_month_pay
            where basic_salary <> '' or basic_salary is not null
        </cfquery>
        <cfif check_current_month_data.recordcount neq 0>
            <div class="text-center">
                <form id="month_end_form" onsubmit="return confirmation();" name="month_end" action="" method="post">
                    <input type="submit" class="btn btn-outline-dark" name="month_end_process" value="Month End">
                </form>
            </div>
        <cfelse>
            <p>No Record found for month end process.</p>
        </cfif>
        <cfif structKeyExists(form, 'month_end_process')>
            <cftransaction>

                <!---process of update status by Kamal--->
                <cfquery name="get_current_employees">
                    select employee_id from current_month_pay
                </cfquery>
                
                <cfloop query="get_current_employees">
                    <!---update advance salary status by Kamal--->
                    <cfquery name="get_adv_salary_record">
                        select * from advance_salary
                        where employee_id = '#get_current_employees.employee_id#'
                        and status = 'Y'
                    </cfquery>

                    <cfif get_adv_salary_record.RecordCount gt 0>
                        <cfif #get_adv_salary_record.total_amount# eq #get_adv_salary_record.returned_amount#>
                            <cfquery name="update_adv_salary_status">
                                update advance_salary
                                set status = 'N',
                                    advance_End_Date = now()
                                where advance_id = '#get_adv_salary_record.advance_id#'  
                            </cfquery>
                        </cfif>
                    </cfif>
                    <!---update loan status by Kamal--->
                    <cfquery name="get_loan_record">
                        select * from loan
                        where employee_id = '#get_current_employees.employee_id#'
                        and status = 'Y'
                    </cfquery>

                    <cfif get_loan_record.RecordCount gt 0>
                        <cfif #get_loan_record.Returned_Amount# eq #get_loan_record.total_amount#>
                            <cfquery name="update_loan_status">
                                update loan
                                set status = 'N',
                                    Loan_End_Date = now()
                                where loan_id = '#get_loan_record.loan_id#' 
                            </cfquery>
                        </cfif>
                    </cfif>
                </cfloop>

                <cfquery name="get_setup">
                    select * from setup
                </cfquery>
                <cfquery name="previous_employees">
                    select employee_id from employee 
                    where leaving_date <> ''
                </cfquery>
                
                <cfquery name="send_current_month_data_past_month">
                    insert into past_month_pay (employee_id,basic_salary,month,year,transaction_mode,bank_name,bank_account_no,transaction_date,pay_status,days_worked,working_days,additional_days
                                    ,deducted_days,basic_rate,paid_leaves,half_paid_leaves,leaves_without_pay,gross_salary,net_salary,gross_allowances,gross_deductions,processed,loan_amount,adv_salary_amount)

                    select employee_id,basic_salary,month,year,transaction_mode,bank_name,bank_account_no,transaction_date,pay_status,days_worked,working_days,additional_days
                                    ,deducted_days,basic_rate,paid_leaves,half_paid_leaves,leaves_without_pay,gross_salary,net_salary,gross_allowances,gross_deductions,processed,loan_amount,adv_salary_amount
                    from current_month_pay
                </cfquery>

                <cfquery name = 'get_column'>
                    select column_name from information_schema.columns 
                    where table_name = "current_month_pay" 
                    And column_name <> "employee_id" 
                    And column_name <> "pay_status"
                </cfquery>
                <cfloop query="get_column">
                    <cfif get_column.column_name eq 'month'>
                        <cfquery name="update_data">
                            UPDATE current_month_pay
                            SET
                            <cfif get_setup.current_month eq 12>
                                `#column_name#` = <cfqueryparam value="1">
                            <cfelse>
                                <cfset month = get_setup.current_month + 1>
                                `#column_name#` = <cfqueryparam value="#month#">
                            </cfif>
                        </cfquery>
                    <cfelse>
                        <cfquery name="update_data">
                            UPDATE current_month_pay
                            SET
                            `#column_name#` = Null 
                        </cfquery>
                    </cfif>
                </cfloop>

                <cfquery name="t_employee">
                    select employee_id from current_month_pay
                </cfquery>
                <!---           This query delete the record of left employees after month end process   --->
                <cfif previous_employees.recordcount gt 0>
                    <cfloop query="previous_employees">
                        <cfquery name="delete_previous_employee">
                            delete from current_month_pay
                            where employee_id = <cfqueryparam value="#previous_employees.employee_id#">
                        </cfquery>
                    </cfloop>
                </cfif>

                <!---        This query select column names          --->
                <cfquery name="columns_name">
                    select column_name as col from information_schema.columns 
                    where table_name = "Past_month_pay";
                </cfquery>
                <cfloop query="t_employee">
                <!---         following query get allownce and deduction record  against each employee          --->
                    <cfquery name="allowance">
                        select p.* from pay_allowance p , current_month_pay c
                        where status = 'y' And p.employee_Id = c.employee_id And c.employee_id="#employee_id#"
                    </cfquery>
                    <cfquery name="deduction">
                        select p.* from pay_deduction p , current_month_pay c
                        where status = 'y' And p.employee_Id = c.employee_id And c.employee_id="#employee_id#"
                    </cfquery>
                    <cfif allowance.recordcount neq 0>
                    <!---          this query update data from past_mounth_pay in allowance cols          --->
                        <cfquery name="insert_allownces">
                            update past_month_pay
                            set 
                            <cfset counter = 0>
                            <cfloop query = "allowance">
                                <cfloop query="columns_name">
                                    <cfif columns_name.col neq "allowance#allowance.allowance_id#">
                                        <cfset flag1 = true>
                                    <cfelse>
                                        <cfset flag1 = false>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
                                <cfif flag1 eq true>
                                    
                                    <cfquery name="add_new_column">
                                        ALTER TABLE `payroll`.`past_month_pay`
                                        ADD COLUMN `allowance#allowance_id#` VARCHAR(45) NULL DEFAULT '0'; 
                                    </cfquery>
                                </cfif>
                                <cfset counter += 1>
                                <cfif allowance.recordcount eq counter>
                                    allowance#allowance_id# = "#allowance.allowance_amount#"
                                <cfelse>
                                    allowance#allowance_id# = "#allowance.allowance_amount#",
                                </cfif>
                            </cfloop>
                            where employee_id = "#allowance.employee_id#"
                            And month = "#get_setup.current_month#"
                            And year = "#get_setup.current_year#"
                        </cfquery>
                    </cfif>
                    <cfif deduction.recordcount neq 0>
                        <!---          this query update data from past_mounth_pay in deduction columns          --->
                        <cfquery name="insert_deductions">
                            update past_month_pay
                            set 
                            <cfset counter = 0>
                            <cfloop query = "deduction">
                                <cfloop query="columns_name">
                                    <cfif columns_name.col neq "deduction#deduction.deduction_id#">
                                        <cfset flag = true>
                                    <cfelse>
                                        <cfset flag = false>
                                        <cfbreak>
                                    </cfif>
                                </cfloop>
                                <cfif flag eq true>
                                    <cfquery name="add_new_column">
                                        ALTER TABLE `payroll`.`past_month_pay`
                                        ADD COLUMN `deduction#deduction_id#` VARCHAR(45) NULL DEFAULT '0'; 
                                    </cfquery>
                                </cfif>
                                <cfset counter += 1>
                                <cfif deduction.recordcount eq counter>
                                    deduction#deduction_id# = "#deduction.deduction_amount#"
                                <cfelse>
                                    deduction#deduction_id# = "#deduction.deduction_amount#",
                                </cfif>
                            </cfloop>
                            where employee_id = "#deduction.employee_id# "
                            And month = "#get_setup.current_month#"
                            And year = "#get_setup.current_year#"
                        </cfquery>
                    </cfif>
                </cfloop>
                <cfquery name = "update_setting">
                    update setup
                    set 
                    <cfif get_setup.current_month eq 12>
                        <cfset new_month = 1>
                        <cfset new_year = get_setup.current_year + 1>
                        current_month = '#new_month#', current_year = '#new_year#'
                    <cfelse>
                        <cfset new_month = get_setup.current_month + 1>
                        current_month = '#new_month#'
                    </cfif>
                </cfquery>
            </cftransaction>
            <cfquery name="check">
                select basic_salary from current_month_pay
            </cfquery>
            <cfset is_successful = false>
            <cfloop query="check">
                <cfif check.basic_salary eq ''>
                    <cfset is_successful = true>
                <cfelse>
                    <cfset is_successful = false>
                    <cfbreak>
                </cfif>
            </cfloop>
            <cfif is_successful eq true>
                <script>
                    alert("Month End Process Run Successfully!");
                </script>
                <p class="text-success text-center mt-3">*Month End Process Runs Successfully!</p>
            <cfelse>
                <script>
                    alert("Month End Process Not Successful Try Again.");
                </script>
                <p class="text-danger text-center mt-3">*Month End Process Not Successful Try Again!</p>
            </cfif>
        </cfif>
    </div>
    <!---       Back End          --->
</cfoutput>
<script>
    function confirmation(){
        var con = confirm("Are you sure to run month End process?");
        return con;
    }
    
        $(document).ready(function() {
        // On form submit
            if(con == true){
                $("#month_end_form").submit(function() {
                    // Show the loader
                    $('#loader-wrapper').fadeIn('fast');
                    $("#loader").show();
                });
            }
        });
</script>