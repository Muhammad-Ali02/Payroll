<cfoutput>
    <!--- _________________________________________ Back End ______________________________________--->
    <cfquery name="leave_requests">
        select a.*, l.leave_title, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        from all_leaves a , leaves l , employee emp
        where a.leave_id = l.leave_id
        and a.employee_id = emp.employee_id
        and action = 'pending'
    </cfquery>
    <cfquery name="get_approved_requests">
        select a.*, l.leave_title, emp.official_email, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        from all_leaves a , leaves l , employee emp
        where a.leave_id = l.leave_id
        and a.employee_id = emp.employee_id
        and (action = 'approved' or action ='partial approved')
    </cfquery>
    <cfquery name="get_rejected_requests">
        select a.*, l.leave_title, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        from all_leaves a , leaves l , employee emp
        where a.leave_id = l.leave_id
        and a.employee_id = emp.employee_id
        and action = 'rejected' order by a.request_date desc
    </cfquery>
    
    <!--- update leave as approved or rejected --->
    <cfif structKeyExists(form, 'Approve') or structKeyExists(form, 'Reject') or structKeyExists(form, 'Partial_leave')>
        <cfquery name="update_all_leaves" result="update_leave_result">
            update all_leaves
            set 
            <cfif isDefined('form.Approve')>
                action = "Approved", 
            <cfelseif isDefined('form.Reject')>
                action = "Rejected", 
            <cfelseif isDefined('form.Partial_leave')>
                action = "Partial Approved", 
            </cfif>
            action_by = "#session.loggedIn.username#",
            action_date = now(),
            action_remarks = <cfqueryparam value='#form.txt_remarks#'>
            where id = <cfqueryparam value='#url.id#'>
        </cfquery>
        <cfquery name="get_leave_detail">
            select * from all_leaves where id = <cfqueryparam value='#url.id#'>
        </cfquery>
        <cfquery name="get_working_days">
            select b.* , a.workingdays_group, a.official_email 
            from employee a, working_days b 
            where a.employee_id = '#get_leave_detail.employee_id#' 
            and b.group_id = a.workingdays_group
        </cfquery>
        <cfquery name="get_name"><!---query for get name of employee for email by Kamal--->
            select concat(first_name," ", middle_name, " " , last_name) as name
            from employee 
            where employee_id = '#get_leave_detail.employee_id#'
        </cfquery>
        <cfset counter1 = 0>
        <cfloop index="index" from="#get_leave_detail.from_date#" to="#get_leave_detail.to_date#">
            <cfset day = dayOfWeek(index)>
            <cfset dayName = dayOfWeekAsString('#day#')>
            <cfset counter1 += 1>
            <cfif evaluate("get_working_days.#dayName#") eq '1'>
                <cfif isDefined('form.Approve')>
                    <cfquery name="Approved_leaves">
                        Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                        values (<cfqueryparam value='#url.id#'>
                        , '#dateFormat('#index#', 'yyyy-mm-dd')#', 'Approved', '1')
                    </cfquery>
                    <cfquery name="update_leave_balance">
                        Update employee_leaves
                        Set
                        leaves_balance = (leaves_balance - 1),
                        leaves_availed = (IFNULL(leaves_availed, 0) + 1)
                        where leave_id = <cfqueryparam value="#form.leave_type#">
                        And employee_id = <cfqueryparam value="#form.employee_id#">
                    </cfquery>
                <cfelseif isdefined("form.Reject")>
                    <cfquery name="Approved_leaves">
                        Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                        values (<cfqueryparam value='#url.id#'>, '#dateFormat('#index#', 'yyyy-mm-dd')#', 'Rejected', '0')
                    </cfquery>
                <cfelseif isDefined("form.Partial_leave")>
                    <cfif evaluate('form.date#counter1#') eq 1>
                        <cfquery name="Approved_leaves">
                            Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                            values (<cfqueryparam value='#url.id#'>, '#dateFormat('#index#', 'yyyy-mm-dd')#', 'Approved', '1')
                        </cfquery>
                    <cfelseif evaluate('form.date#counter1#') eq 0.5>
                        <cfquery name="Approved_leaves">
                            Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                            values (<cfqueryparam value='#url.id#'>, '#dateFormat('#index#', 'yyyy-mm-dd')#', 'Approved', '0.5')
                        </cfquery>
                    <cfelseif evaluate('form.date#counter1#') eq 0>
                        <cfquery name="Approved_leaves">
                            Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                            values (<cfqueryparam value='#url.id#'>, '#dateFormat('#index#', 'yyyy-mm-dd')#', 'Rejected', '0')
                        </cfquery>
                    </cfif>
                    <cfif evaluate('form.date#counter1#') eq 1 or evaluate('form.date#counter1#') eq 0.5>
                        <cfquery name="update_leave_balance">
                            Update employee_leaves
                            Set
                            leaves_balance = (leaves_balance - 1),
                            leaves_availed = (IFNULL(leaves_availed, 0) + 1)
                            Where leave_id = <cfqueryparam value="#form.leave_type#">
                            And employee_id = <cfqueryparam value="#form.employee_id#">
                        </cfquery>
                    </cfif>
                </cfif>
            </cfif>
        </cfloop>
        <!---           <cfif "#update_leave_result#" eq "1"> 
                        <cfquery name = "update_employee_leave">
                        update employee_leave
                        set availed_leave
                            action_by = "#session.loggedIn.username#",
                            action_date = now(),
                            action_remarks = '#form.txt_remarks#'
                            where id = '#url.id#'
                    </cfquery>
                    </cfif>--->
        <!---             <cfdump  var="#update_leave_result#"> --->
        <!---             <cfabort> --->
        <cfif isDefined('form.Approve')>
            
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_working_days.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Leave Approval" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
                
                    <h4>Leave Title:</h4>
                    <h2>
                        #leave_requests.leave_title# Leave Approved
                    </h2>
                
                <p>
                    Dear #get_name.name#, <br>
                    I am writing to inform you that your leave request has been approved. You are 
                    entitled to take off from work starting on [#dateFormat(get_leave_detail.from_date, 'dd-mmm-yyyy')#] 
                    and returning on [#dateFormat(get_leave_detail.to_date, 'dd-mmm-yyyy')#].
                    Please make sure to complete any pending tasks and delegate responsibilities to 
                    your team members before you leave. Also, ensure that you have a proper handover 
                    plan in place for any ongoing projects.
                </p>
            </cfmail>
            <cflocation url="leave_approval.cfm?action=Approved">
        <cfelseif isDefined("form.Reject")>
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_working_days.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Leave Rejection" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
                
                    <h4>Leave Title:</h4>
                    <h2>
                        #leave_requests.leave_title# Leave Rejected 
                    </h2>
                
                <p>
                    Dear #get_name.name#, <br>
                    I hope this email finds you well. I regret to inform you that your request for leave has been rejected.

                    I understand that taking time off is important and can be necessary for personal reasons, but unfortunately, 
                    the timing of your request does not align with the needs of the company at this moment. 
                    We are currently experiencing a high volume of work, and your absence would significantly impact our operations.
                </p>
            </cfmail>
            <cflocation url="leave_approval.cfm?action=Rejected">
        <cfelse>
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_working_days.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Leave Approvals" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
                
                    <h4>Leave Title:</h4>
                    <h2>
                        #leave_requests.leave_title# Leave Approved Partially
                    </h2>
                
                <p>
                    Dear #get_name.name#, <br>
                    I am writing to inform you that your leave request has been partially approved. You are 
                    entitled to take off from work starting on [#dateFormat(get_leave_detail.from_date, 'dd-mmm-yyyy')#] 
                    and returning on [#dateFormat(get_leave_detail.to_date, 'dd-mmm-yyyy')#].
                    Please make sure to complete any pending tasks and delegate responsibilities to 
                    your team members before you leave. Also, ensure that you have a proper handover 
                    plan in place for any ongoing projects.
                </p>
            </cfmail>
            <cflocation url="leave_approval.cfm?action=Partially_Approved">
        </cfif>
    </cfif>
    <cfif structKeyExists(url, 'action')>
        <p class="text-success">Leave Request <strong>#url.action#</strong> Successfully.</p>
    </cfif>
    <cfif structKeyExists(url, 'request_id')><!--- Front end when admin user want to approve or reject a leave--->
        <cfquery name="get_leave_detail">
            select * from all_leaves where id = <cfqueryparam value="#url.request_id#">
        </cfquery>
        <cfquery name="employee_detail">
            select concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
            from employee emp
            where emp.employee_id = <cfqueryparam value="#get_leave_detail.employee_id#">
        </cfquery>
        <cfquery name="get_working_days">
            select b.* , a.workingdays_group 
            from employee a, working_days b 
            where a.employee_id = '#get_leave_detail.employee_id#' and b.group_id = a.workingdays_group
        </cfquery>
        <!---            <cfdump  var="#employee_detail#"> <cfabort> --->
        <!--- ___________________________________________ Front End _________________________________________________--->
        <cfif get_leave_detail.Action neq "Pending">
            <div class="text-center mb-5">
                <h3 class="box_heading"> Leave Approval</h3>
            </div>
            <h6>Sorry! You can no longer edit this leave request.</h6>
        <cfelse>
            <div class="employee_box">
                <div class="text-center mb-5">
                    <h3 class="box_heading">Leave Approval</h3>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        Employee Name:
                        <p>#employee_detail.name#</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        From Date: 
                        <p>#dateFormat(get_leave_detail.from_date, 'dd-mmm-yyyy')#<p>
                    </div>
                    <div class="col-md-3">
                        To Date: 
                        <p>#dateFormat(get_leave_detail.to_date, 'dd-mmm-yyyy')#<p>
                    </div>
                    <div class="col-md-3">
                        Days:
                        <p>#get_leave_detail.leave_days#</p>
                    </div>
                    <div class="col-md-3">
                        Leave Title:
                        <p>#leave_requests.leave_title#</p>
                    </div>
                </div>
                <div class="row">
                    <label for="reason" class="mt-3">
                        Reason: 
                    </label>
                    <p>#get_leave_detail.reason#<p>
                </div>
                <form onsubmit="return formValidate();" action="leave_approval.cfm?id=#url.request_id#" method="post">
                    <div id="leaveSelection" style="display:none;">
                        <!--- <script>
                            document.getElementById('Approve_leave').style.display='none';
                            document.getElementById('Reject_leave').style.display='none';
                        </script> --->
                        <div class="text-center mb-2">
                            <p style="font-weight: 600;">Select Payment Type For Partial Leave Approval According Dates</p>
                        </div>
                        <div class="row mb-2">
                            <cfset counter = 0>
                            <!---          This loop show all leave with date for approval on click of partial approval                --->
                            <cfloop index="index" from="#get_leave_detail.from_date#" to="#get_leave_detail.to_date#">
                                <cfset counter += 1>
                                <cfset day = dayOfWeek(index)>
                                <cfset dayName = dayOfWeekAsString('#day#')>
                                <cfif evaluate("get_working_days.#dayName#") eq '1'>
                                    <div class="col-md-6 mb-2 mt-2">
                                        <!---<div class="form-check ml-3 mb-2">
                                        <input type = "checkbox" class="form-check-input" style="border-radius: 0;" id="#DateFormat("#index#", "yyyy-mm-dd")#" 
                                        name = "#DateFormat("#index#", "yyyy-mmm-dd")#" required>  </div>--->
                                        <span class="form-check-label ml-4 mt-1">#DateFormat("#index#", "yyyy-mmm-dd")# ( #dayName# )</span>
                                    </div>
                                    <div class="col-md-4 mb-2 ml-4">
                                        <select class="form-select" name="date#counter#" id="Payment_type">
                                            <option value="1">Full Paid</option>
                                            <option value="0.5">Half Paid</option>
                                            <option value="0">Reject</option>
                                        </select>
                                    </div>
                                </cfif>
                            </cfloop>
                        </div>
                        <div class="text-left">
                            <input type="submit" id="Partial_leave" value="Approved Partially" name="Partial_leave" class="btn btn-outline-danger mb-2 ml-2">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <label for="txt_remarks">Remarks:</label>
                            <textarea class="form-control" id="txt_remarks" name="txt_remarks" placeholder="Please Write Some Remarks According to Your Action (Approve or Reject)" required></textarea>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="d-flex justify-content-end flex-wrap" style="gap: 8px;">
                            <input type="hidden" name="leave_type" value="#get_leave_detail.leave_id#">
                            <input type="hidden" name="employee_id" value="#leave_requests.employee_id#">
                            <button id="" onclick="document.getElementById('leaveSelection').style.display='inline'; this.disabled=true" name="Partial" class="btn custom_button btn-outline-danger"> Approve Partial Leave </button>
                            <input type="submit" id="Approve_leave" value="Approve Leave" name="Approve" class="btn btn-outline-success">
                            <input type="submit" id="Reject_leave" value="Reject Leave" name="Reject" class="btn btn-outline-danger">
                        </div>
                    </div>
                </form>
            </div>
        </cfif>
    <cfelse>
        <div class="text-center mb-5">
            <h3 class="box_heading">Leave Approval</h3>
        </div>
        <!--- following code shows all approved, rejected and pending requests  --->
        <cfif leave_requests.recordcount neq 0>
            <p class="text-primary">
                Pending Requests:
            </p>
            <!---        variable for pagination      --->
            <cfparam name="pageNum" default="1">
            <cfset maxRows = 5>
            <cfset startRow = min( ( pageNum-1 ) * maxRows+1, max( leave_requests.recordCount,1 ) )>
            <cfset endRow = min( startRow + maxRows-1, leave_requests.recordCount )>
            <cfset totalPages = ceiling( leave_requests.recordCount/maxRows )>
            <cfset loopercount = ceiling( leave_requests.recordCount/maxRows )>
            <div style="overflow-x: auto;">
                <table class="table table-bordered custom_table">
                    <thead>
                        <th>
                            No.
                        </th>
                        <th>
                            Request ID
                        </th>
                        <th>
                            Employee ID
                        </th>
                        <th>
                            Name
                        </th>
                        <th>
                            Leave Title 
                        </th>
                        <th>
                            From Date
                        </th>
                        <th>
                            To Date 
                        </th>
                        <th>
                            Days
                        </th>
                        <th>
                            Status
                        </th>
                        <th>
                            Action
                        </th>
                    </thead>
                    <cfset No = startRow -1>
                    <cfloop query="leave_requests" startrow="#startRow#" endrow="#endRow#">
                        <cfset No = No + 1>
                        <tr>
                        <td>
                            #No#
                        </td>
                        <td>
                            #id#
                        </td>
                        <td>
                            #employee_id#
                        </td>
                        <td>
                            #name#
                        </td>
                        <td>
                            #leave_title#
                        </td>
                        <td>
                            #dateFormat(from_date, 'DD-MMM-YYYY')#
                        </td>
                        <td>
                            #dateFormat(to_date, 'DD-MMM-YYYY')#
                        </td>
                        <td>
                            #leave_days#
                        </td>
                        <td>
                            #action#
                        </td>
                        <td>
                            <a href="leave_approval.cfm?request_id=#id#">
                                <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-check2-circle" viewBox="0 0 16 16">
                                    <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                                    <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                                </svg>
                            </a>
                        </td>
                        <tr>
                    </cfloop>
                </table>
            </div>
            <!---        Pageination code start      --->
            <div class="d-flex justify-content-end">
                <cfif structKeyExists(url, "pageNum")>
                    <cfif "#url.pageNum#" lte looperCount>
                        <cfif "#url.pageNum#" gt 1>
                            <a href="?pageNum=#url.pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                        <cfif "#url.pageNum#" lt looperCount>
                            <a href="?pageNum=#url.pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #url.pageNum# of #looperCount#</span>
                    </cfif>
                <cfelse>
                    <cfset pageNum = 1>
                    <cfif "#pageNum#" lt looperCount>
                        <cfif "#pageNum#" gt 1>
                            <a href="?pageNum=#pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                        <cfif "#pageNum#" lte looperCount>
                            <a href="?pageNum=#pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #pageNum# of #looperCount#</span>
                    </cfif>
                </cfif>
            </div>
            <!---      Pagination End        --->
        <cfelse>
            <p class="text-light">
                No Pending Requests! 
            </p>
        </cfif>
        <cfif get_approved_requests.recordcount neq 0>
            <p class="text-success">
                Approved Requests:
            </p>
            <!---        variable for pagination      --->
            <cfparam name="app_pageNum" default="1">
            <cfset app_maxRows = 5>
            <cfset approved_request_startRow = min( ( app_pageNum-1 ) * app_maxRows+1, max( get_approved_requests.recordCount,1 ) )>
            <cfset approved_request_endRow = min( approved_request_startRow + app_maxRows-1, get_approved_requests.recordCount )>
            <cfset approved_request_totalPages = ceiling( get_approved_requests.recordCount/app_maxRows )>
            <cfset approved_request_loopercount = ceiling( get_approved_requests.recordCount/app_maxRows )>
            <div style="overflow-x: auto;">
                <table class="table table-bordered custom_table">
                    <thead>
                        <th>
                            No.
                        </th>
                        <th>
                            Request ID
                        </th>
                        <th>
                            Employee ID
                        </th>
                        <th>
                            Name
                        </th>
                        <th>
                            Leave Title 
                        </th>
                        <th>
                            From Date
                        </th>
                        <th>
                            To Date 
                        </th>
                        <th>
                            Days
                        </th>
                        <th>
                            Status
                        </th>
                        <th>
                            Action
                        </th>
                    </thead>
                    <cfset No = approved_request_startRow - 1>
                    <cfloop query="get_approved_requests" startrow="#approved_request_startRow#" endrow="#approved_request_endRow#">
                        <cfset No = No + 1>
                        <tr>
                        <td>
                            #No#
                        </td>
                        <td>
                            #id#
                        </td>
                        <td>
                            #employee_id#
                        </td>
                        <td>
                            #name#
                        </td>
                        <td>
                            #leave_title#
                        </td>
                        <td>
                            #dateFormat(from_date, 'DD-MMM-YYYY')#
                        </td>
                        <td>
                            #dateFormat(to_date, 'DD-MMM-YYYY')#
                        </td>
                        <td>
                            #leave_days#
                        </td>
                        <td>
                            #action#
                        </td>
                        <td>
                            <a title="You can no longer edit it.">
                                <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-check2-circle" viewBox="0 0 16 16">
                                    <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                                    <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                                </svg>
                            </a>
                        </td>
                        <tr>
                    </cfloop>
                </table>
            </div>
            <!---        Pageination code start      --->
            <div class="d-flex justify-content-end">
                <cfif structKeyExists(url, "app_pageNum")>
                    <cfif "#url.app_pageNum#" lte approved_request_looperCount>
                        <cfif "#url.app_pageNum#" gt 1>
                            <a href="?app_pageNum=#url.app_pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                        <cfif "#url.app_pageNum#" lt approved_request_looperCount>
                            <a href="?app_pageNum=#url.app_pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #url.app_pageNum# of #approved_request_looperCount#</span>
                    </cfif>
                <cfelse>
                    <cfset app_pageNum = 1>
                    <cfif "#app_pageNum#" lt approved_request_looperCount>
                        <cfif "#app_pageNum#" gt 1>
                            <a href="?app_pageNum=#app_pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                        <cfif "#app_pageNum#" lte approved_request_looperCount>
                            <a href="?app_pageNum=#app_pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #app_pageNum# of #approved_request_looperCount#</span>
                    </cfif>
                </cfif>
            </div>
            <!---      Pagination End        --->
        <cfelse>
            <p class="text-success">
                No Approved Requests! 
            </p>
        </cfif>
        <cfif get_rejected_requests.recordcount neq 0>
            <p class="text-danger">
                Rejected Requests:
            </p>
            <!---        variable for pagination      --->
            <cfparam name="rej_pageNum" default="1">
            <cfset rej_maxRows = 5>
            <cfset rejected_requests_startRow = min( ( rej_pageNum-1 ) * rej_maxRows+1, max( get_rejected_requests.recordCount,1 ) )>
            <cfset rejected_requests_endRow = min( rejected_requests_startRow + rej_maxRows-1, get_rejected_requests.recordCount )>
            <cfset rejected_requests_totalPages = ceiling( get_rejected_requests.recordCount/rej_maxRows )>
            <cfset rejected_requests_loopercount = ceiling( get_rejected_requests.recordCount/rej_maxRows )>
            <div style="overflow-x: auto;">
                <table class="table table-bordered custom_table">
                    <thead>
                        <th>
                            No.
                        </th>
                        <th>
                            Request ID
                        </th>
                        <th>
                            Employee ID
                        </th>
                        <th>
                            Name
                        </th>
                        <th>
                            Leave Title 
                        </th>
                        <th>
                            From Date
                        </th>
                        <th>
                            To Date 
                        </th>
                        <th>
                            Days
                        </th>
                        <th>
                            Status
                        </th>
                        <th>
                            Action
                        </th>
                    </thead>
                    <cfset No = rejected_requests_startRow - 1>
                    <cfloop query="get_rejected_requests" startrow="#rejected_requests_startRow#" endrow="#rejected_requests_endRow#">
                        <cfset No = No + 1>
                        <tr>
                        <td>
                            #No#
                        </td>
                        <td>
                            #id#
                        </td>
                        <td>
                            #employee_id#
                        </td>
                        <td>
                            #name#
                        </td>
                        <td>
                            #leave_title#
                        </td>
                        <td>
                            #dateFormat(from_date, 'DD-MMM-YYYY')#
                        </td>
                        <td>
                            #dateFormat(to_date, 'DD-MMM-YYYY')#
                        </td>
                        <td>
                            #leave_days#
                        </td>
                        <td>
                            #action#
                        </td>
                        <td>
                            <a title="You can no longer edit it.">
                                <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-check2-circle" viewBox="0 0 16 16">
                                    <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                                    <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                                </svg>
                            </a>
                        </td>
                        <tr>
                    </cfloop>
                </table>
            </div>
            <!---        Pageination code start      --->
            <div class="d-flex justify-content-end">
                <cfif structKeyExists(url, "rej_pageNum")>
                    <cfif "#url.rej_pageNum#" lte rejected_requests_looperCount>
                        <cfif "#url.rej_pageNum#" gt 1>
                            <a href="?rej_pageNum=#url.rej_pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                        <cfif "#url.rej_pageNum#" lt rejected_requests_looperCount>
                            <a href="?rej_pageNum=#url.rej_pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #url.rej_pageNum# of #rejected_requests_looperCount#</span>
                    </cfif>
                <cfelse>
                    <cfset rej_pageNum = 1>
                    <cfif "#rej_pageNum#" lt rejected_requests_looperCount>
                        <cfif "#rej_pageNum#" gt 1>
                            <a href="?rej_pageNum=#rej_pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                        <cfif "#rej_pageNum#" lte rejected_requests_looperCount>
                            <a href="?rej_pageNum=#rej_pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #rej_pageNum# of #rejected_requests_looperCount#</span>
                    </cfif>
                </cfif>
            </div>
            <!---      Pagination End        --->
        <cfelse>
            <p class="text-danger">
                No Rejected Requests! 
            </p>
        </cfif>
    </cfif>
</cfoutput>
<script>
    // following function run on form submit 
    function formValidate(){
        let remarks = $('#txt_remarks').val();
        if(remarks == ''){
            alert('All Fields Must Be filled Out');
            $('#txt_remarks').focus();
            return false;
        }else{
            return true;
        }
    }
</script>