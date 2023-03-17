<cfinclude  template="/includes/head.cfm">
<cfoutput>
<cftry>
<cfquery name = "query1">
    create table ip_address_audit like emp_users
</cfquery>
<cfcatch type="any">
    query1: <cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query2">
        ALTER TABLE `payroll`.`ip_address_audit` 
        ADD COLUMN `attempt_time` DATETIME NULL AFTER `level`,
        ADD COLUMN `current_ip_address` VARCHAR(45) NULL AFTER `attempt_time`
    </cfquery>
<cfcatch type="any">
    query2: <cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query3">
        ALTER TABLE `payroll`.`emp_users` 
        ADD COLUMN `ip_address` VARCHAR(45) NULL AFTER `level`;
    </cfquery>
<cfcatch type="any">
    query3:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query4">
    ALTER TABLE `payroll`.`file_names` 
        CHANGE COLUMN `employee_no` `employee_id` VARCHAR(10) NOT NULL 
    </cfquery>
<cfcatch type="any">
    query4:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query5">
        ALTER TABLE `payroll`.`all_leaves` 
        CHANGE COLUMN `action_remarks` `action_remarks` VARCHAR(200) NULL DEFAULT NULL 
    </cfquery>
<cfcatch type="any">
    query5:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query6">
        ALTER TABLE `payroll`.`loan` 
        ADD COLUMN `term_condition` VARCHAR(45) NULL AFTER `Action_Remarks`,
        ADD COLUMN `InstallmentAmount` INT(11) NULL AFTER `term_condition`
    </cfquery>
<cfcatch type="any">
    query6:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query7">
    CREATE TABLE `payroll`.`advance_salary` (
        `Advance_Id` INT NOT NULL AUTO_INCREMENT,
        `employee_Id` VARCHAR(10) NULL,
        `Total_Amount` INT(11) NULL,
        `Returned_Amount` INT(11) NULL,
        `Remaining_balance` INT(11) NULL,
        `Applied_Amount` INT(11) NULL,
        `Apply_Description` VARCHAR(45) NULL,
        `Apply_Date` DATETIME NULL,
        `Apply_By` VARCHAR(45) NULL,
        `Status` ENUM('Y','N') NULL,
        `Advance_End_Date` DATE NULL,
        `Action` ENUM('Approved','Reject') NULL,
        `Action_By` VARCHAR(45) NULL,
        `Action_Date` DATETIME NULL,
        `Action_Remark` VARCHAR(225) NULL,
        `term_condition` VARCHAR(10) NULL,
        `InstallmentAmount` INT(11) NULL,
        PRIMARY KEY (`Advance_Id`))
    </cfquery>
<cfcatch type="any">
    query7:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query8">
            ALTER TABLE `payroll`.`ip_address_audit` 
            DROP PRIMARY KEY,
            ADD PRIMARY KEY (`user_name`, `attempt_time`, `current_ip_address`)
    </cfquery>
<cfcatch type="any">
    query8:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="get_table">
        SELECT table_name, COLUMN_NAME
        FROM information_schema.columns
        WHERE column_name = 'employee_id' or COLUMN_NAME = 'user_name' and table_schema = 'payroll';
    </cfquery>

    <cfset i = 0>

    <cftry>
        <cfloop query="get_table">
            <cfquery name="updateSchema" datasource="payroll">
                ALTER TABLE #table_name#
                CHANGE COLUMN #COLUMN_NAME# #COLUMN_NAME# VARCHAR(45) NULL DEFAULT NULL
            </cfquery>
        </cfloop>
        <cfset i += 1>
    <cfcatch type="any">
        query10.#i#:<cfdump  var="#cfcatch.cause.message#">  <br>
    </cfcatch>
    </cftry>
<cfcatch type="any">
    query9:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

</cfoutput>
<cfinclude  template="/includes/foot.cfm">