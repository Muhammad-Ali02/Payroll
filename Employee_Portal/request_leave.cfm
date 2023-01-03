<cfoutput>
    <cfinclude  template="..\includes\head.cfm">
        <cfif structKeyExists(session, 'loggedIn')>
            <!--- Back End to Insert Leaves --->
            <!--- Insert Leaves in All leaves Table --->
            <cfif structKeyExists(form, 'leave_id')>
                <cfquery name = "insert_leave_request">
                    insert into all_leaves
                    (
                        employee_id, 
                        leave_id, 
                        from_date, 
                        to_date, 
                        leave_days,
                        reason, 
                        request_date, 
                        action,
                        action_by
                    )
                    values
                    (
                        '#session.loggedin.username#', 
                        '#form.leave_id#', 
                        '#form.from_date#', 
                        '#form.to_date#', 
                        '#form.leave_days#',
                        '#form.txt_reason#', 
                        now(), 
                        'Pending',
                        'None'
                    )
                </cfquery>
                <cflocation  url="leave_requests.cfm?request_submitted=true">
            </cfif>
            <cfquery name = "Leave_list"> <!---With the help of Result, generate a dynamic list of Available Leaves --->
                select L.leave_title, L.leave_id, E.leaves_allowed, E.leaves_availed, E.leaves_balance
                from leaves L
                inner join employee_leaves E on L.leave_id = E.leave_id
                where E.employee_id = '#session.loggedin.username#' and E.status = 'Y'
            </cfquery>
            <cfquery name = "get_requested_leaves">
                select count(leave_id) as requested
                from all_leaves
                where employee_id = "#session.loggedin.username#"
            </cfquery>
            <cfquery name = "setting_info">
                select * from setup
            </cfquery>
            <!--- Calculating Working Days of Current Month --->
            <cfquery name = "workingdays">
                SELECT a.sunday, a.monday, a.tuesday, a.wednesday, a.thursday, a.friday, a.saturday
                from working_days a
                inner join employee b on b.workingdays_group = a.group_id
                where b.employee_id = "#session.loggedin.username#"
            </cfquery>
            <cfset firstDay = createDate(#setting_info.current_year#, #setting_info.current_month#, 1)>
            <cfset lastDay = createDate(#setting_info.current_year#, #setting_info.current_month#, daysInMonth(firstDay))> 
            <!--- Loop to check for working days of current month by comparing each date of month with the working days group's days --->
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
            <cfif leave_list.recordcount neq 0>
                <table class = "table mt-4 table-bordered">
                    <thead class = "thead-dark">
                        <th> Leave Title </th>
                        <th> Total Allowed</th>
                        <th> Availed </th>
                        <th> Balance </th>
                    </thead>
                    <cfloop query = "leave_list">
                        <tr>
                            <td> #leave_title# </td>
                            <td> #leaves_allowed# </td>
                            <td> #leaves_allowed# </td>
                            <td> #leaves_balance# </td>
                        </tr>
                    </cfloop>
                </table>
                <form action = "request_leave.cfm" method = "post">
                    <div class = "row">
                        <div class = "col-md-3">
                            <label for = "fromDate"> From Date: </label> 
                            <input type = "date" name = "from_date" value = "#dateFormat(now(),'yyyy-mm-dd')#" id = "fromDate" required class = "form-control" onBlur = "getDates();">
                        </div>
                        <div class = "col-md-3">
                            <label for = "toDate" > To Date: </label> 
                            <input type = "date" class = "form-control" value = "#dateFormat(now(),'yyyy-mm-dd')#"  name = "to_date" id = "toDate" required onblur="getDates();" >
                        </div>
                        <div class = "col-md-3">
                            <label for = "leave_days"> Days:</label>
                            <input type = "number" name = "leave_days" value = "0" readonly id = "leave_days" class = "form-control"> 
                        </div>
                        <div class = "col-md-3">
                            <label for = "leave_title"> Leave Title: </label>
                            <select name = "Leave_id" class = "form-select">
                                <option disabled> Available Leaves </option>
                                <cfloop query = "Leave_list"> <!--- printing dynamic list --->
                                    <option value = "#leave_id#"> #leave_title# </option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <p id = "errorMsg" class = "text-danger" style = "display:none; font-weight">
                        "From Date" is Greater Than "To Date" or Selected Dates are Off Days
                    </p>
                    <div class = "row">
                        <label for = "reason" class = "mt-3">Reason? </label>
                        <textarea name = "txt_reason" class = "form-control" id = "txt_reason" placeholder = "Please Enter a Valid Reason For Leave" required></textarea>
                    </div>
                    <div class = "row">
                        <div class = "col-md-3 mt-3">
                            <input type = "submit" id = "submit_leave" value = "Submit Leave" name = "submit_leave" class = "btn btn-outline-dark">
                        </div>
                    </div>
                </form>
            <cfelse>
                <p>Dear #session.loggedin.username#! You are Not Allowed to Request a Leave. Please Contact HR Department.</p>
            </cfif>
                <cfset offDays=ArrayNew(1)>
                <cfloop index="i" from="1" to="7">
                    <cfif  evaluate("workingdays.#dayOfWeekAsString('#i#')#") eq 0.0 >
                        <cfset days = i - 1>
                        <cfscript>
                            arrayAppend(offDays, '#days#');
                        </cfscript>    
                    </cfif>
                </cfloop>
            <!--- javascript to get the value of input tag and calculate difference between two dates--->
            <script>
                #toScript(offDays, "jsOffDays")#
                //To Focus from date in case of wrong dates selected
                function foucusDate(){
                    
                }
                // Returns an array of dates between the two dates
                function getDates(){
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
                        var flag = 0;
                        for(let i = 0; i <= jsOffDays.length; i++){   
                            if(currentDate.getDay() == jsOffDays[i]){
                                flag++
                                console.log('for loop')
                            console.log(currentDate)
                            }
                        }
                        if(flag == 0){
                            dates.push(currentDate);
                            console.log(jsOffDays.length);
                        }
                        currentDate = addDays.call(currentDate, 1);
                    }
                    document.getElementById("leave_days").value = dates.length;
                    //focus date
                    var validating = false;
                    if(dates.length == 0){
                        validating = true
                            setTimeout(function(){
                                document.getElementById("fromDate").style.borderColor = "red";
                                document.getElementById("fromDate").style.backgroundColor = "##ffb1b1";
                                document.getElementById('fromDate').focus();
                                document.getElementById('errorMsg').style.display = 'inline'
                                document.getElementById('submit_leave').disabled = true;
                                validating = false;
                                }, 1);
                    }
                    else{
                        document.getElementById("fromDate").style.color = "black";
                        document.getElementById("toDate").style.color = "black";
                        document.getElementById('submit_leave').disabled = false;
                        document.getElementById('errorMsg').style.display = 'none'
                        document.getElementById("fromDate").style.backgroundColor = "white";
                        document.getElementById("fromDate").style.borderColor = "##ced4da";
                    }
                    return dates //dates[0].getDay();
                }
                getDates();
            </script>
        </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">