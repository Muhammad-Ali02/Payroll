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
        <div class="text-center">
            <form id="month_end_form" onsubmit="return confirmation();" name="month_end" action="" method="post">
                <input type="submit" class="btn btn-outline-dark" name="month_end_process" value="Month End">
            </form>
        </div>
        <cfif structKeyExists(form, 'month_end_process')>
            <cftransaction>
                <cfquery name="get_setup">
                    select * from setup
                </cfquery>
                <cfquery name="left_employees">
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
                    where table_name = "current_month_pay" And column_name <> "employee_id"
                </cfquery>
                <cfloop query="get_column">
                    <cfif get_column.column_name eq 'month'>
                        <cfquery name="update_data">
                            UPDATE current_month_pay
                            SET
                            `#column_name#` = <cfqueryparam value="#get_setup.current_month#">
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
                <cfif left_employees.recordcount gt 0>
                    <cfloop query="left_employees">
                        <cfquery name="delete_left_employee">
                            delete from current_month_pay
                            where employee_id = <cfqueryparam value="#left_employees.employee_id#">
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