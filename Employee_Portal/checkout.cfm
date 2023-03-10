<cfif isDefined('url.action') And "#url.action#" eq "checkout">
<cfquery name="checks1">
    select * from attendance
    where employee_id="#session.loggedIn.username#" And date= "#DateFormat(Now(), "yyyy,mm,dd")#"
</cfquery>
<cfif checks1.RecordCount gte "1" And checks1.time_out neq "">
    <script>
        alert("You have already checked Out.")
        window.location.assign("\index.cfm");
    </script>
<cfelse>
    <cfquery name="checkout_time" result="myresult">
        update attendance
        set time_out = <cfqueryparam value="#TimeFormat(Now(), "HH:mm:ss.llll")#">
        where employee_id = <cfqueryparam value="#session.loggedIn.username#"> And date =  <cfqueryparam value="#DateFormat(Now(), "yyyy-mm-dd")#"> 
    </cfquery>
    <cfquery name="checks">
        select * from attendance
        where employee_id="#session.loggedIn.username#" And date= "#DateFormat(Now(), "yyyy,mm,dd")#"
    </cfquery>
<!---     <cfoutput>
      #myresult.recordcount#
    </cfoutput>
    <cfdump  var="#myresult#" > --->
<!---     <cfabort> --->
    <!---     this query run for calculate employee working group and friday    --->
    <cfquery name="working_group">
        select b.*, a.employee_id
        from payroll.employee a, payroll.working_days b
        where employee_id = "#session.loggedIn.username#" And b.group_id = a.workingdays_group;
    </cfquery>
    <!---      this if condition caclualte employee short and exeed time on the basis of checkin checkout time   --->
    <cfset date = dateFormat(Now(),"yyyy,mm,dd")>
    <cfset day = dayOfWeek(date)>
    <cfif "#day#" eq '6'>
        <cfset total_time = datediff("n",#checks.time_in #, #checks.time_out#)>
        <cfset required_time = dateDiff("n", "#working_group.friday_time_in#" , "#working_group.friday_time_out#")>
        <cfset actual_time = total_time - (required_time - #working_group.break_time#)>
        <cfif actual_time gte '0'>
            <cfquery name=timeupdate>
                update attendance
                set exeed_time = <cfqueryparam value="#actual_time#">, short_time = <cfqueryparam value='0'>
                where employee_id="#session.loggedIn.username#" And date= "#DateFormat(Now(), "yyyy,mm,dd")#" 
            </cfquery>
            <cflocation  url="\login\user_login.cfm?logout=true">
        <cfelse>
            <cfset actual_time = abs(actual_time)>
            <cfquery name=timeupdate>
                update attendance
                set exeed_time = <cfqueryparam value="0">, short_time = <cfqueryparam value="#actual_time#">
                where employee_id="#session.loggedIn.username#" And date= "#DateFormat(Now(), "yyyy,mm,dd")#" 
            </cfquery>
            <cflocation  url="\login\user_login.cfm?logout=true">
        </cfif>
    <cfelse>
        <cfset total_time = datediff("n",#checks.time_in #, #checks.time_out#)>
        <cfset required_time = datediff("n", working_group.time_in , working_group.time_out)>
        <cfset actual_time = total_time - (required_time - #working_group.break_time#)>
        <cfif actual_time gte '0'>
            <cfquery name=timeupdate>
                update attendance
                set exeed_time = <cfqueryparam value="#actual_time#">, short_time = <cfqueryparam value='0'>
                where employee_id="#session.loggedIn.username#" And date= "#DateFormat(Now(), "yyyy,mm,dd")#" 
            </cfquery>
            <cflocation  url="\login\user_login.cfm?logout=true">
        <cfelse>
            <cfset actual_time = abs(actual_time)>
            <cfquery name=timeupdate>
                update attendance
                set exeed_time = <cfqueryparam value="0">, short_time = <cfqueryparam value="#actual_time#">
                where employee_id="#session.loggedIn.username#" And date= "#DateFormat(Now(), "yyyy,mm,dd")#" 
            </cfquery>
            <cflocation  url="\login\user_login.cfm?logout=true">
        </cfif>
    </cfif>   
</cfif>
</cfif>