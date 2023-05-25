<cfinclude template="POIUtility.cfc">
<cfset 	objPOI = CreateObject("component","POIUtility").Init("XSSF") />
<!--- <cfset arrSheets = objPOI.ReadExcel(FilePath = "#Expandpath('leave_balance.xls')#", HasHeaderRow = true) /> --->
<cfset arrSheets = objPOI.ReadExcel(FilePath = expandPath("/BJS.xls"), HasHeaderRow = true) />
<cfparam  name="time_in" default = ''>
<cfparam  name="time_out" default = ''>
<cfloop index="intSheet" from="1" to="#ArrayLen( arrSheets )#" step="1">
    <cfset objSheet = arrSheets[ intSheet ] />
<!---      <cfdump  var="#objsheet.query#">  --->
<!---      <cfabort>  --->
    <cfloop query="#objsheet.query#">
    <cftry>
        <cfoutput>
            <!--- Time_in --->
            <cfif isNumeric(COLUMN4)>
                <cfset time_in = timeFormat('#COLUMN4#', "HH:mm:ss.llll")>
            <cfelseif COLUMN4 eq 'wfh'>
                <cfset time_in = ''>
            <cfelseif findNoCase('Leave', COLUMN4)  gt 0>
                <cfset time_in = ''>
            </cfif> 
            <!--- Time_out --->
            <cfif isNumeric(COLUMN5)>
                <cfset time_out = timeFormat('#COLUMN5#', "HH:mm:ss.llll")>
            <cfelseif COLUMN5 eq 'wfh'>
                <cfset time_out = ''>
            <cfelseif findNoCase('Leave', COLUMN5)  gt 0>
                <cfset time_out = ''>
            </cfif>
        </cfoutput>
<!--- <cfabort> --->
        <cfset date = dateFormat(createDate(2023, 5, COLUMN3),"yyyy,mm,dd")>
        <cfquery name = "get_employee_attendance">
            select * from attendance 
            where employee_id = <cfqueryparam value="#COLUMN2#"> And date =  <cfqueryparam value="#Date#"> 
        </cfquery>
        <cfif time_in neq '' and time_out neq '' and COLUMN2 neq ''>
            <cfif get_employee_attendance.recordcount lte 0>
                <cfquery name = "insert_attendance">
                    insert into attendance 
                    (time_in, date, employee_id)
                    values(
                        <cfqueryparam value="#time_in#"> ,
                        <cfqueryparam value="#Date#">,
                        <cfqueryparam value="#COLUMN2#">
                    )
                </cfquery>
            <cfelse>
                <cfquery name = "update_attendance">
                    update attendance 
                    set 
                        time_in = <cfqueryparam value="#time_in#">
                    where 
                        employee_id = <cfqueryparam value="#COLUMN2#"> And date =  <cfqueryparam value="#Date#"> 
                </cfquery>
            </cfif>
            <cfquery name="checkout_time" result="myresult">
                update attendance
                set time_out = <cfqueryparam value="#time_out#">
                where employee_id = <cfqueryparam value="#COLUMN2#"> And date =  <cfqueryparam value="#Date#"> 
            </cfquery>
            <cfquery name="checks">
                select * from attendance
                where employee_id="#COLUMN2#" And date= "#DateFormat(date, "yyyy,mm,dd")#"
            </cfquery>
            <!---     this query run for calculate employee working group and friday    --->
            <cfquery name="working_group">
                select b.*, a.employee_id
                from payroll.employee a, payroll.working_days b
                where employee_id = "#COLUMN2#" And b.group_id = a.workingdays_group;
            </cfquery>
                <cfif working_group.recordcount gt 0>
                        <!---      this if condition caclualte employee short and exeed time on the basis of checkin checkout time   --->
                        <cfset day = dayOfWeek(date)>
                        <cfif "#day#" eq '6'>
                            <cfset total_time = datediff("n",#checks.time_in #, #checks.time_out#)>
                            <cfset required_time = dateDiff("n", "#working_group.friday_time_in#" , "#working_group.friday_time_out#")>
                            <cfset actual_time = total_time - (required_time - #working_group.break_time#)>
                            <cfif actual_time gte '0'>
                                <cfquery name=timeupdate>
                                    update attendance
                                    set exeed_time = <cfqueryparam value="#actual_time#">, short_time = <cfqueryparam value='0'>
                                    where employee_id="#COLUMN2#" And date= "#Date#" 
                                </cfquery>
                            <cfelse>
                                <cfset actual_time = abs(actual_time)>
                                <cfquery name=timeupdate>
                                    update attendance
                                    set exeed_time = <cfqueryparam value="0">, short_time = <cfqueryparam value="#actual_time#">
                                    where employee_id="#COLUMN2#" And date= "#Date#" 
                                </cfquery>
                            </cfif>
                        <cfelse>
<!---                             <cfdump  var="#working_group#">  --->
                            <cfset total_time = datediff("n",checks.time_in, checks.time_out)>
                            <cfset required_time = datediff("n", working_group.time_in , working_group.time_out)>
<!---                             <cfabort> --->
                            <cfset actual_time = total_time - (required_time - working_group.break_time)>
                            <cfif actual_time gte '0'>
                                <cfquery name=timeupdate>
                                    update attendance
                                    set exeed_time = <cfqueryparam value="#actual_time#">, short_time = <cfqueryparam value='0'>
                                    where employee_id="#COLUMN2#" And date= "#Date#" 
                                </cfquery>
                            <cfelse>
                                <cfset actual_time = abs(actual_time)>
                                <cfquery name=timeupdate>
                                    update attendance
                                    set exeed_time = <cfqueryparam value="0">, short_time = <cfqueryparam value="#actual_time#">
                                    where employee_id="#COLUMN2#" And date= "#Date#" 
                                </cfquery>
                            </cfif>
                        </cfif>   
                    </cfif>
                </cfif>
        <cfcatch type="any">
            <cfoutput>
                Employee #COLUMN2# have Error: <cfdump  var="#cfcatch#"> <br> <cfabort>
            </cfoutput>
        </cfcatch>
    </cftry>
</cfloop>
    <cfoutput>
        Attendance Updated! Please Verify the Attendance from the Addendance Sheet
    </cfoutput>


</cfloop>
