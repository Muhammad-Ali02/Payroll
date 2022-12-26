<cfoutput>
    <cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <form action = "request_leave.cfm" method = "post">
            Employee ID: <input type = "text"  min = "0" name = "txt_employee_id">
            Leave Balance: <input type = "submit" name = "check" value = "Check" >
        </form>
        <cfif structKeyExists(form, 'txt_employee_id')>
            <cfquery name = "Leave_list"> <!---With the help of Result, generate a dynamic list of Available Leaves --->
                select L.leave_title, L.leave_id, E.leaves_allowed, E.leaves_availed, E.leaves_balance
                from leaves L
                inner join employee_leaves E on L.leave_id = E.leave_id
                where E.employee_id = '#form.txt_employee_id#'
            </cfquery>
            <cfquery name = "get_requested_leaves">
                select count(leave_id) as requested
                from all_leaves
                where status = "P"
            </cfquery>
            <table>
                <tr>
                    <th> Leave Title </th>
                    <th> Total </th>
                    <th> Availed </th>
                    <th> Balance </th>
                </tr>
                <cfloop query = "leave_list">
                    <tr>
                        <td> #leave_title# </td>
                        <td> #leaves_allowed# </td>
                        <td> #leaves_availed# </td>
                        <td> #leaves_balance# </td>
                    </tr>
                </cfloop>
            </table>
            <!--- javascript to get the value of input tag --->
            <script>
                function dayDifference () {
                    var from_date = new Date(document.getElementById("fromDate").value);    
                    var to_date = new Date(document.getElementById("toDate").value);
                }
            </script>
            <!--- Calculating days between two dates according to current month(saved in setting)
            <cfset working_days = 0>
                <cfloop from = "#day(firstDay)#" to = "#day(lastday)#" index = "i"> 
                    <cfset date = createDate(#setting_info.current_year#, #setting_info.current_month#, #i#)>
                    <cfset day_of_week = dayOfWeek(#date#)>
                        <cfif  evaluate("workingdays.#dayOfWeekAsString('#day_of_week#')#") eq 1.0 >
                            <cfset working_days = working_days + 1>
                        <cfelseif evaluate("workingdays.#dayOfWeekAsString('#day_of_week#')#") eq 0.5>
                            <cfset working_days = working_days + 0.5>
                        </cfif>
                </cfloop>
             --->

            From Date: <input type = "date" name = "from_date" id = "fromDate" required >
            To Date: <input type = "date" name = "to_date" id = "toDate" required onblur="getDates(); console.log(getDates()); " >
            Days: <input type = "number" name = "total_days" value = "0" readonly id = "total_days"> 
            Leave Title:
            <select name = "Leave_title">
                <option disabled> Available Leaves </option>
                <cfloop query = "Leave_list"> <!--- printing dynamic list --->
                    <option value = "#leave_id#"> #leave_title# </option>
                </cfloop>
            </select>
            <input type = "submit" value = "Submit Leave" name = "submit_leave" class = "btn btn-outline-success">
            <script>
                // Calculate_day() function to calculate days between selectd dates 
                function calculate_day(){
                    var date1 = new Date(document.getElementById("fromDate").value);
                    var date2 = new Date(document.getElementById("toDate").value);
                    var difference = date2 - date1;
                    var days = difference/(24*3600*1000);
                    // document.getElementById("total_days").value = days
                    }
                // Returns an array of dates between the two dates
                function getDates () {
                    const dates = []
                    var from_date = new Date(document.getElementById("fromDate").value);    
                    var to_date = new Date(document.getElementById("toDate").value);
                    let currentDate = from_date
                    const addDays = function (days) {
                        const date = new Date(this.valueOf())
                        date.setDate(date.getDate() + days)
                        return date
                    }
                    while (currentDate <= to_date ) {
                        if(currentDate.getDay() != 0 && currentDate.getDay() != 6)
                        dates.push(currentDate)
                        currentDate = addDays.call(currentDate, 1)
                    }
                    document.getElementById("total_days").value = dates.length;
                    return dates //dates[0].getDay();
                    }
            </script>
        </cfif>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">