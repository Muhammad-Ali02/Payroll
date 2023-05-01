
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
        `Action` ENUM('Approved','Reject','Pending','Partial Approved') NULL DEFAULT 'Pending',
        `Action_By` VARCHAR(45) NULL,
        `Action_Date` DATETIME NULL,
        `Action_Remarks` VARCHAR(225) NULL,
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

<cftry>
    <cfquery name = "query11">
            CREATE TABLE `payroll`.`leaves_approval` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `leave_id` INT(11) NULL,
            `leave_Date` DATE NULL,
            `action` ENUM('Approved','Rejected') NULL,
            PRIMARY KEY (`id`))
    </cfquery>
<cfcatch type="any">
    query11:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query12">
            ALTER TABLE `payroll`.`leaves_approval` 
            ADD COLUMN `approved_as` FLOAT(6) NULL COMMENT 'leave payment type if value equal 1 means full paid leave , 0.5 means half paid leave and 0 means no paid leave.' AFTER `action`;
    </cfquery>
<cfcatch type="any">
    query12:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query13">
            ALTER TABLE `payroll`.`emp_users` 
            ADD COLUMN `machine_name` VARCHAR(45) NULL DEFAULT NULL AFTER `ip_address`;
    </cfquery>
<cfcatch type="any">
    query13:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query14">
            ALTER TABLE `payroll`.`ip_address_audit` 
            ADD COLUMN `current_machine_name` VARCHAR(45) NOT NULL DEFAULT '' AFTER `current_ip_address`;
    </cfquery>
<cfcatch type="any">
    query14:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query15">
            ALTER TABLE `payroll`.`all_leaves` 
            CHANGE COLUMN `action` `action` ENUM('Pending','Approved','Rejected','Partial Approved') NULL DEFAULT 'Pending' ;
    </cfquery>
<cfcatch type="any">
    query15:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query15">
            CREATE TABLE `payroll`.`attendance_audit` (
            `change_id` INT NOT NULL AUTO_INCREMENT,
            `attendance_id` INT NULL,
            `employee_id` VARCHAR(45) NULL,
            `date` DATE NULL,
            `time_in` TIME NULL,
            `time_out` TIME NULL,
            `short_time` INT NULL,
            `exeed_time` INT NULL,
            `update_at` DATETIME NULL,
            `operation` VARCHAR(15) NULL,
            PRIMARY KEY (`change_id`));
    </cfquery>
<cfcatch type="any">
    query15:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query16">
            CREATE TABLE `payroll`.`employee_audit` (
            `AuditEventId` INT(11) NOT NULL AUTO_INCREMENT,
            `AuditEventTime` DATETIME NOT NULL DEFAULT current_timestamp,
            `AuditEventKey` VARCHAR(1) NOT NULL DEFAULT '',
            `employee_id` VARCHAR(45) NULL,
            `first_name` VARCHAR(45) NULL,
            `middle_name` VARCHAR(45) NULL,
            `last_name` VARCHAR(45) NULL,
            `contact` VARCHAR(45) NULL,
            `cnic` VARCHAR(20) NULL,
            `personal_email` VARCHAR(145) NULL,
            `full_address` VARCHAR(200) NULL,
            `gender` VARCHAR(1) NULL,
            `dob` DATE NULL,
            `marital_status` VARCHAR(10) NULL,
            `joining_date` DATE NULL,
            `department` VARCHAR(11) NULL,
            `designation` VARCHAR(11) NULL,
            `basic_salary` VARCHAR(11) NULL,
            `father_name` VARCHAR(45) NULL,
            `father_cnic` VARCHAR(45) NULL,
            `emergency_contact1` VARCHAR(20) NULL,
            `emergency_contact2` VARCHAR(20) NULL,
            `official_email` VARCHAR(45) NULL,
            `city` VARCHAR(45) NULL,
            `country` VARCHAR(45) NULL,
            `leaving_date` VARCHAR(25) NULL,
            `religion` VARCHAR(11) NULL,
            `blood_group` VARCHAR(3) NULL,
            `covid_vaccination` VARCHAR(10) NULL,
            `workingdays_group` INT(11) NULL,
            `employment_type1` VARCHAR(45) NULL,
            `employment_type2` VARCHAR(45) NULL,
            `payment_mode` VARCHAR(11) NULL,
            `bank_name` VARCHAR(20) NULL,
            `bank_account_no` VARCHAR(20) NULL,
            `created_date` DATETIME NULL,
            `last_update` DATETIME NULL,
            PRIMARY KEY (`AuditEventId`));
    </cfquery>
<cfcatch type="any">
    query16:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query17">
            ALTER TABLE `payroll`.`attendance_audit` 
            CHANGE COLUMN `update_at` `AuditEventTime` DATETIME NULL AFTER `AuditEventId`,
            CHANGE COLUMN `operation` `AuditEventKey` VARCHAR(15) NULL AFTER `AuditEventTime`,
            CHANGE COLUMN `change_id` `AuditEventId` INT(11) NOT NULL AUTO_INCREMENT ;
    </cfquery>
<cfcatch type="any">
    query17:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query18">
            create table users_audit like users;
    </cfquery>
<cfcatch type="any">
    query18:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query19">
            ALTER TABLE `payroll`.`users_audit` 
            CHANGE COLUMN `id` `id` INT(11) NULL ,
            ADD COLUMN `AuditEventId` INT(11) NOT NULL AUTO_INCREMENT FIRST,
            ADD COLUMN `AuditEventTime` DATETIME NULL AFTER `AuditEventId`,
            ADD COLUMN `AuditEventKey` VARCHAR(1) NULL AFTER `AuditEventTime`,
            DROP PRIMARY KEY,
            ADD PRIMARY KEY (`AuditEventId`),
            ADD UNIQUE INDEX `AuditEventId_UNIQUE` (`AuditEventId` ASC);
    </cfquery>
<cfcatch type="any">
    query19:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query20">
            create table all_leaves_audit like all_leaves;
    </cfquery>
<cfcatch type="any">
    query20:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query21">
            ALTER TABLE `payroll`.`all_leaves_audit` 
            CHANGE COLUMN `id` `id` INT(11) NULL ,
            ADD COLUMN `AuditEventId` INT(11) NOT NULL AUTO_INCREMENT FIRST,
            ADD COLUMN `AuditEventTime` DATETIME NULL AFTER `AuditEventId`,
            ADD COLUMN `AuditEventKey` VARCHAR(1) NULL AFTER `AuditEventTime`,
            DROP PRIMARY KEY,
            ADD PRIMARY KEY (`AuditEventId`);
    </cfquery>
<cfcatch type="any">
    query21:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query22">
            create table emp_users_audit like emp_users;
    </cfquery>
<cfcatch type="any">
    query22:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query23">
            ALTER TABLE `payroll`.`emp_users_audit` 
            CHANGE COLUMN `user_name` `user_name` VARCHAR(45) NULL DEFAULT '' ,
            ADD COLUMN `AuditEventId` INT(11) NOT NULL AUTO_INCREMENT FIRST,
            ADD COLUMN `AuditEventTime` DATETIME NULL AFTER `AuditEventId`,
            ADD COLUMN `AuditEventKey` VARCHAR(1) NULL AFTER `AuditEventTime`,
            DROP PRIMARY KEY,
            ADD PRIMARY KEY (`AuditEventId`),
            ADD UNIQUE INDEX `AuditEventId_UNIQUE` (`AuditEventId` ASC);
    </cfquery>
<cfcatch type="any">
    query23:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query24">
            create table current_month_pay_audit like current_month_pay;
    </cfquery>
<cfcatch type="any">
    query24:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query25">
            ALTER TABLE `payroll`.`current_month_pay_audit` 
            ADD COLUMN `AuditEventId` INT(11) NOT NULL AUTO_INCREMENT FIRST,
            ADD COLUMN `AuditEventTime` DATETIME NULL AFTER `AuditEventId`,
            ADD COLUMN `AuditEventKey` VARCHAR(1) NULL AFTER `AuditEventTime`,
            DROP PRIMARY KEY,
            ADD PRIMARY KEY (`AuditEventId`),
            ADD UNIQUE INDEX `AuditEventId_UNIQUE` (`AuditEventId` ASC);
    </cfquery>
<cfcatch type="any">
    query25:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query26">
            create table working_days_audit like working_days;
    </cfquery>
<cfcatch type="any">
    query26:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query27">
            ALTER TABLE `payroll`.`working_days_audit` 
            CHANGE COLUMN `group_id` `group_id` INT(11) NULL ,
            ADD COLUMN `AuditEventId` INT(11) NOT NULL AUTO_INCREMENT FIRST,
            ADD COLUMN `AuditEventTime` DATETIME NULL AFTER `AuditEventId`,
            ADD COLUMN `AuditEventKey` VARCHAR(1) NULL AFTER `AuditEventTime`,
            DROP PRIMARY KEY,
            ADD PRIMARY KEY (`AuditEventId`),
            ADD UNIQUE INDEX `AuditEventId_UNIQUE` (`AuditEventId` ASC);
    </cfquery>
<cfcatch type="any">
    query27:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query28">
        ALTER TABLE `payroll`.`loan` 
        CHANGE COLUMN `Action` `Action` ENUM('Approved','Rejected','Pending', 'Partial Approved') NULL DEFAULT 'Pending' ;
    </cfquery>
<cfcatch type="any">
    query28:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query29">
        ALTER TABLE `payroll`.`emp_users` 
        CHANGE COLUMN `password` `password` VARCHAR(90) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query29:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query30">
        ALTER TABLE `payroll`.`emp_users_audit` 
        CHANGE COLUMN `user_name` `user_name` VARCHAR(45) NULL DEFAULT '' ,
        CHANGE COLUMN `password` `password` VARCHAR(255) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query30:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query31">
        ALTER TABLE `payroll`.`users` 
        CHANGE COLUMN `password` `password` VARCHAR(90) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query31:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query32">
        ALTER TABLE `payroll`.`users_audit` 
        CHANGE COLUMN `password` `password` VARCHAR(90) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query32:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query33">
        CREATE TABLE `payroll`.`uuid_table` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `uuid` VARCHAR(90) NULL,
        `user_name` VARCHAR(45) NULL,
        PRIMARY KEY (`id`),
        UNIQUE INDEX `id_UNIQUE` (`id` ASC));
    </cfquery>
<cfcatch type="any">
    query33:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query34">
        CREATE TABLE `payroll`.`survey` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `title` VARCHAR(255) NULL,
        `description` VARCHAR(955) NULL,
        `question1` VARCHAR(355) NULL DEFAULT NULL,
        `question2` VARCHAR(355) NULL DEFAULT NULL,
        `question3` VARCHAR(355) NULL DEFAULT NULL,
        `question4` VARCHAR(355) NULL DEFAULT NULL,
        `question5` VARCHAR(355) NULL DEFAULT NULL,
        `question6` VARCHAR(355) NULL DEFAULT NULL,
        `question7` VARCHAR(355) NULL DEFAULT NULL,
        `question8` VARCHAR(355) NULL DEFAULT NULL,
        `question9` VARCHAR(355) NULL DEFAULT NULL,
        `question10` VARCHAR(355) NULL DEFAULT NULL,
        PRIMARY KEY (`id`),
        UNIQUE INDEX `id_UNIQUE` (`id` ASC));
    </cfquery>
<cfcatch type="any">
    query34:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name='query35'>
        ALTER TABLE `payroll`.`survey` 
        ADD COLUMN `status` VARCHAR(7) NULL DEFAULT 'open' AFTER `question10`;
    </cfquery>
<cfcatch type="any">
    query35:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query36">
        create table emp_survey_review like survey;
    </cfquery>
<cfcatch type="any">
    query36:<cfdump  var="#cfcatch.cause.message#"><br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query37">
        ALTER TABLE `payroll`.`emp_survey_review` 
        DROP COLUMN `status`,
        ADD COLUMN `survey_id` INT(11) NULL AFTER `id`,
        ADD COLUMN `employee_id` VARCHAR(45) NULL AFTER `survey_id`;
    </cfquery>
<cfcatch type="any">
    query37:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query38">
        ALTER TABLE `payroll`.`emp_survey_review` 
        ADD COLUMN `is_submitted` VARCHAR(3) NULL DEFAULT 'N' AFTER `question10`;
    </cfquery>
<cfcatch type="any">
    query38:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name='query39'>
        ALTER TABLE `payroll`.`emp_survey_review` 
        DROP COLUMN `description`,
        DROP COLUMN `title`;
    </cfquery>
<cfcatch type="any">
    query39:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>
<cftry>
    <cfquery name='query40'>
        ALTER TABLE `payroll`.`employee_allowance` 
        CHANGE COLUMN `allowance_amount` `allowance_amount` FLOAT(11) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query40:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name='query41'>
        ALTER TABLE `payroll`.`employee_deduction` 
        CHANGE COLUMN `deduction_amount` `deduction_amount` FLOAT(11) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query41:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query42">
        ALTER TABLE `payroll`.`department`
        CHANGE COLUMN `description` `description` VARCHAR(1000) NULL DEFAULT NULL;
    </cfquery>
<cfcatch type="any">
    query42:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query43">
        ALTER TABLE `payroll`.`designation`
        CHANGE COLUMN `description` `description` VARCHAR(1000) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query43:<cfdump  var="#cfcatch.cause.message#"> <cr>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query44">
        ALTER TABLE `payroll`.`allowance`
        CHANGE COLUMN `description` `description` VARCHAR(1000) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query44:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query45">       
        ALTER TABLE `payroll`.`loan` 
        CHANGE COLUMN `Apply_Description` `Apply_Description` VARCHAR(1000) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query45:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query46">       
        ALTER TABLE `payroll`.`advance_salary` 
        CHANGE COLUMN `Apply_Description` `Apply_Description` VARCHAR(1000) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query46:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query47">       
        ALTER TABLE `payroll`.`all_leaves` 
        CHANGE COLUMN `reason` `reason` VARCHAR(1000) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query47:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name = "query49">
            create table past_month_pay like current_month_pay;
    </cfquery>
<cfcatch type="any">
    query49:<cfdump  var="#cfcatch.cause.message#">  <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query50">
        ALTER TABLE `payroll`.`past_month_pay` 
        CHANGE COLUMN `basic_salary` `basic_salary` INT(11) NULL DEFAULT '0' ,
        CHANGE COLUMN `month` `month` INT(11) NOT NULL DEFAULT '0' ,
        CHANGE COLUMN `days_worked` `days_worked` FLOAT NULL DEFAULT '0' ,
        DROP PRIMARY KEY,
        ADD PRIMARY KEY (`employee_id`, `month`);
    </cfquery>
<cfcatch type="any">
    query50:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query51">
        ALTER TABLE `payroll`.`past_month_pay` 
            ADD COLUMN `allowance1` VARCHAR(45) NULL DEFAULT '0' AFTER `processed`,
            ADD COLUMN `allowance2` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance1`,
            ADD COLUMN `allowance3` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance2`,
            ADD COLUMN `allowance4` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance3`,
            ADD COLUMN `allowance5` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance4`,
            ADD COLUMN `allowance6` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance5`,
            ADD COLUMN `allowance7` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance6`,
            ADD COLUMN `allowance8` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance7`,
            ADD COLUMN `allowance9` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance8`,
            ADD COLUMN `allowance10` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance9`,
            ADD COLUMN `allowance11` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance10`,
            ADD COLUMN `allowance12` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance11`,
            ADD COLUMN `allowance13` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance12`,
            ADD COLUMN `allowance14` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance13`,
            ADD COLUMN `allowance15` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance14`,
            ADD COLUMN `deduction1` VARCHAR(45) NULL DEFAULT '0' AFTER `allowance15`,
            ADD COLUMN `deduction2` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction1`,
            ADD COLUMN `deduction3` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction2`,
            ADD COLUMN `deduction4` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction3`,
            ADD COLUMN `deduction5` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction4`,
            ADD COLUMN `deduction6` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction5`,
            ADD COLUMN `deduction7` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction6`,
            ADD COLUMN `deduction8` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction7`,
            ADD COLUMN `deduction9` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction8`,
            ADD COLUMN `deduction10` VARCHAR(45) NULL DEFAULT '0' AFTER `deduction9`; 
        </cfquery>
<cfcatch type="any">
    query51:<cfdump  var="#cfcatch#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query52">
        ALTER TABLE `payroll`.`past_month_pay` 
        CHANGE COLUMN `employee_id` `employee_id` VARCHAR(45) NULL DEFAULT '' ,
        CHANGE COLUMN `month` `month` INT(11) NULL DEFAULT '0' ,
        ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
        DROP PRIMARY KEY,
        ADD PRIMARY KEY (`id`);
    </cfquery>
<cfcatch type="any">
    query52:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query53">
        ALTER TABLE `payroll`.`current_month_pay`
        ADD COLUMN `loan_amount` VARCHAR(45) NULL AFTER `processed`;
    </cfquery>
<cfcatch type="any">
    query53:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query54">
        create table advance_salary_installments like loan_installments;
    </cfquery>
<cfcatch type="any">
    query54:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query55">
        ALTER TABLE `payroll`.`advance_salary_installments` 
        CHANGE COLUMN `loan_id` `Advance_Id` INT(11) NULL DEFAULT NULL ;
    </cfquery>
<cfcatch type="any">
    query55:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>

<cftry>
    <cfquery name="query56">
        ALTER TABLE `payroll`.`current_month_pay`
        ADD COLUMN `adv_salary_amount` VARCHAR(45) NULL AFTER `loan_amount`;
    </cfquery>
<cfcatch type="any">
    query56:<cfdump  var="#cfcatch.cause.message#"> <br>
</cfcatch>
</cftry>
</cfoutput>

