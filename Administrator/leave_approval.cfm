<cfinclude  template="..\includes\head.cfm">
    <cfoutput>
        <!--- _________________________________________ Back End ______________________________________--->
        <cfquery name = "leave_requests">
            select a.*, l.leave_title, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
            from all_leaves a , leaves l , employee emp 
            where a.leave_id = l.leave_id 
            and a.employee_id = emp.employee_id
            and action = 'pending'
        </cfquery>
        <cfquery name = "get_approved_requests">
            select a.*, l.leave_title, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
            from all_leaves a , leaves l , employee emp 
            where a.leave_id = l.leave_id 
            and a.employee_id = emp.employee_id
            and (action = 'approved' or action ='partial approved')
        </cfquery>
        <cfquery name = "get_rejected_requests">
            select a.*, l.leave_title, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
            from all_leaves a , leaves l , employee emp 
            where a.leave_id = l.leave_id 
            and a.employee_id = emp.employee_id
            and action = 'rejected'
        </cfquery>
        <!--- update leave as approved or rejected --->
        <cfif structKeyExists(form, 'Approve') or structKeyExists(form, 'Reject') or structKeyExists(form, 'Partial_leave')>
            <cfquery name = "update_all_leaves" result="update_leave_result">
                update all_leaves
                set 
                    <cfif isDefined('form.Approve')>
                        action = "Approved",
                    <cfelseif isDefined('form.Reject')>
                        action = "Rejected",
                    <cfelseif isDefined('form.Partial_leave')>
                        action = "Partial Approve",
                    </cfif>
                    action_by = "#session.loggedIn.username#",
                    action_date = now(),
                    action_remarks = '#form.txt_remarks#'
                    where id = '#url.id#'
            </cfquery>
            <cfquery name = "get_leave_detail">
                select * from all_leaves where id = "#url.id#"
            </cfquery>
            <cfquery name = "get_working_days">
                select b.* , a.workingdays_group from employee a, working_days b where a.employee_id = '#get_leave_detail.employee_id#' and b.group_id = a.workingdays_group
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
                            values ('#url.id#', '#dateFormat('#index#','yyyy-mm-dd')#', 'Approved', '1')
                        </cfquery>
                        <cfquery name="update_leave_balance">
                            Update employee_leaves
                            Set 
                                leaves_balance = leaves_balance - 1,
                                leaves_availed = IFNULL(leaves_availed, 0) + 1
                            where leave_id = "#form.leave_type#" And employee_id = "#form.employee_id#"
                        </cfquery>
                    <cfelseif isdefined("form.Reject")>
                        <cfquery name="Approved_leaves">
                            Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                            values ('#url.id#', '#dateFormat('#index#','yyyy-mm-dd')#', 'Reject', '0')
                        </cfquery>
                        <cfquery name="update_leave_balance">
                            Update employee_leaves
                            Set 
                                leaves_balance = leaves_balance - 1,
                                leaves_availed = IFNULL(leaves_availed, 0) + 1
                            where leave_id = "#form.leave_type#" And employee_id = "#form.employee_id#"
                        </cfquery>
                    <cfelseif isDefined("form.Partial_leave")>
                        <cfif evaluate('form.date#counter1#') eq 1>
                            <cfquery name="Approved_leaves">
                                Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                                values ('#url.id#', '#dateFormat('#index#','yyyy-mm-dd')#', 'Approved', '1')
                            </cfquery>
                        <cfelseif evaluate('form.date#counter1#') eq 0.5>
                            <cfquery name="Approved_leaves">
                                Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                                values ('#url.id#', '#dateFormat('#index#','yyyy-mm-dd')#', 'Approved', '0.5')
                            </cfquery>
                        <cfelseif evaluate('form.date#counter1#') eq 0>
                            <cfquery name="Approved_leaves">
                                Insert into leaves_approval (leave_id, leave_Date, action, approved_as)
                                values ('#url.id#', '#dateFormat('#index#','yyyy-mm-dd')#', 'Rejected', '0')
                            </cfquery>
                        </cfif>
                        <cfif evaluate('form.date#counter1#') eq 1 or evaluate('form.date#counter1#') eq 0.5>
                            <cfquery name="update_leave_balance">
                                Update employee_leaves
                                Set 
                                    leaves_balance = leaves_balance - 1,
                                    leaves_availed = IFNULL(leaves_availed, 0) + 1
                                Where leave_id = <cfqueryparam value="#form.leave_type#"> And employee_id = <cfqueryparam value= "#form.employee_id#">
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
                <cflocation  url="leave_approval.cfm?action=Approved">
            <cfelseif isDefined("form.Reject")>
                <cflocation  url="leave_approval.cfm?action=Rejected">
            <cfelse>
                <cflocation  url="leave_approval.cfm?action=Partially_Approved">
            </cfif>
        </cfif>
        <cfif structKeyExists(url, 'action')>
            <p class = "text-success">
                Leave Request<strong> #url.action# </strong> Successfully.
            </p>
        </cfif>
        <cfif structKeyExists(url, 'request_id')><!--- Front end when admin user want to approve or reject a leave--->
            <cfquery name = "get_leave_detail">
                select * from all_leaves where id = "#url.request_id#"
            </cfquery>
            <cfquery name = "get_working_days">
                select b.* , a.workingdays_group from employee a, working_days b where a.employee_id = '#get_leave_detail.employee_id#' and b.group_id = a.workingdays_group
            </cfquery>
<!---             <cfdump  var="#get_working_days#"> <cfabort> --->

        <!--- ___________________________________________ Front End _________________________________________________--->
            <div class="employee_box">
                <div class="text-center mb-5">
                    <h3 class="box_heading">Leave Approval</h3>
                </div>
                <div class = "row">
                    <div class = "col-md-3">
                        From Date: 
                        <p>#dateFormat(get_leave_detail.from_date,'dd-mmm-yyyy')#<p>
                    </div>
                    <div class = "col-md-3">
                        To Date: 
                        <p>#dateFormat(get_leave_detail.to_date,'dd-mmm-yyyy')#<p>
                    </div>
                    <div class = "col-md-3">
                        Days:
                        <p>#get_leave_detail.leave_days#</p>
                    </div>
                    <div class = "col-md-3">
                        Leave Title:
                        <p>#leave_requests.leave_title#</p>
                    </div>
                </div>
                <div class = "row">
                    <label for = "reason" class = "mt-3">Reason: </label>
                    <p>#get_leave_detail.reason#<p>
                </div>
                <form action = "leave_approval.cfm?id=#url.request_id#" method = "post">
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
                            <cfloop index="index" from="#get_leave_detail.from_date#" to="#get_leave_detail.to_date#">
                                <cfset counter += 1>
                                <cfset day = dayOfWeek(index)>
                                <cfset dayName = dayOfWeekAsString('#day#')>
                                <cfif evaluate("get_working_days.#dayName#") eq '1'>
                                    <div class="col-md-6 mb-2 mt-2">
                                         <!---<div class="form-check ml-3 mb-2">
                                            <input type = "checkbox" class="form-check-input" style="border-radius: 0;" id="#DateFormat("#index#", "yyyy-mm-dd")#" name = "#DateFormat("#index#", "yyyy-mmm-dd")#" required> 
                                        </div>--->
                                            <span class="form-check-label ml-4 mt-1">#DateFormat("#index#", "yyyy-mmm-dd")# ( #dayName# )</span>
                                    </div>
                                    <div class="col-md-4 mb-2 ml-4">
                                        <select class="form-select" name="date#counter#" id="Payment_type" >
                                            <option value="1">Full Paid</option>
                                            <option value="0.5">Half Paid</option>
                                            <option value="0">No Paid</option>
                                        </select>
                                    </div>
                                </cfif>
                            </cfloop>
                        </div>
                        <div class="text-left">
                            <input type ="submit" id="Partial_leave" value = "Approved Partially" name="Partial_leave" class = "btn btn-outline-danger mb-2 ml-2">
                        </div>
                    </div>
                    <div class = "row">
                        <div class="col-md-12">
                            <label for = "txt_remarks">Remarks:</label>
                            <textarea class = "form-control" id = "txt_remarks" name = "txt_remarks" placeholder = "Please Write Some Remarks According to Your Action (Approve or Reject)" required></textarea>
                        </div>
                    </div>
                    <div class = "row mt-3">
                        <div class="d-flex justify-content-end" style="gap: 8px;">
                            <input type="hidden" name="leave_type" value="#get_leave_detail.leave_id#">
                            <input type="hidden" name="employee_id" value="#leave_requests.employee_id#">
                            <button id = "" onclick="document.getElementById('leaveSelection').style.display='inline'; this.disabled=true" name = "Partial" class = "btn btn-outline-danger">Approve Partial Leave</button>
                            <input type = "submit" id = "Approve_leave" value = "Approve Leave" name = "Approve" class = "btn btn-outline-success">
                            <input type = "submit" id = "Reject_leave" value = "Reject Leave" name = "Reject" class = "btn btn-outline-danger">
                        </div>
                    </div>
                </form>
                <div class="text-rigth">
                </div>
            </div>
        <cfelse>
            <cfif leave_requests.recordcount neq 0>
                <p class = "text-primary">Pending Requests:</p>
                <table class = "table table-bordered custom_table">
                    <thead>
                        <th>No.</th>
                        <th>Request ID</th>
                        <th>Employee ID</th>
                        <th>Name</th>
                        <th>Leave Title </th>
                        <th>From Date</th>
                        <th>To Date </th>
                        <th>Days</th>
                        <th>Status</th>
                        <th>Action</th>
                    </thead>
                        <cfset No = 0>
                        <cfloop query="leave_requests">
                            <cfset No = No + 1>
                            <tr>
                                <td>#No#</td>
                                <td>#id#</td>
                                <td>#employee_id#</td>
                                <td>#name#</td>
                                <td>#leave_title#</td>
                                <td>#dateFormat(from_date,'DD-MMM-YYYY')#</td>
                                <td>#dateFormat(to_date,'DD-MMM-YYYY')#</td>
                                <td>#leave_days#</td>
                                <td>#action#</td>
                                <td>
                                    <a href = "leave_approval.cfm?request_id=#id#">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-journal-medical" viewBox="0 0 16 16">
                                            <path fill-rule="evenodd" d="M8 4a.5.5 0 0 1 .5.5v.634l.549-.317a.5.5 0 1 1 .5.866L9 6l.549.317a.5.5 0 1 1-.5.866L8.5 6.866V7.5a.5.5 0 0 1-1 0v-.634l-.549.317a.5.5 0 1 1-.5-.866L7 6l-.549-.317a.5.5 0 0 1 .5-.866l.549.317V4.5A.5.5 0 0 1 8 4zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/>
                                            <path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
                                            <path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
                                        </svg>
                                    </a>
                                </td>
                            <tr>
                        </cfloop>
                </table>
            <cfelse>
                <p class="text-light"> No Pending Requests! </p>
            </cfif>
            <cfif get_approved_requests.recordcount neq 0>
                <p class = "text-success">Approved Requests:</p>
                <table class = "table table-bordered custom_table">
                    <thead>
                        <th>No.</th>
                        <th>Request ID</th>
                        <th>Employee ID</th>
                        <th>Name</th>
                        <th>Leave Title </th>
                        <th>From Date</th>
                        <th>To Date </th>
                        <th>Days</th>
                        <th>Status</th>
                        <th>Action</th>
                    </thead>
                        <cfset No = 0>
                        <cfloop query="get_approved_requests">
                            <cfset No = No + 1>
                            <tr>
                                <td>#No#</td>
                                <td>#id#</td>
                                <td>#employee_id#</td>
                                <td>#name#</td>
                                <td>#leave_title#</td>
                                <td>#dateFormat(from_date,'DD-MMM-YYYY')#</td>
                                <td>#dateFormat(to_date,'DD-MMM-YYYY')#</td>
                                <td>#leave_days#</td>
                                <td>#action#</td>
                                <td>
                                    <a href = "leave_approval.cfm?request_id=#id#">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-journal-medical" viewBox="0 0 16 16">
                                            <path fill-rule="evenodd" d="M8 4a.5.5 0 0 1 .5.5v.634l.549-.317a.5.5 0 1 1 .5.866L9 6l.549.317a.5.5 0 1 1-.5.866L8.5 6.866V7.5a.5.5 0 0 1-1 0v-.634l-.549.317a.5.5 0 1 1-.5-.866L7 6l-.549-.317a.5.5 0 0 1 .5-.866l.549.317V4.5A.5.5 0 0 1 8 4zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/>
                                            <path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
                                            <path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
                                        </svg>
                                    </a>
                                </td>
                            <tr>
                        </cfloop>
                </table>
            <cfelse>
                <p class="text-success"> No Approved Requests! </p>
            </cfif>
            <cfif get_rejected_requests.recordcount neq 0>
                <p class = "text-danger">Rejected Requests:</p>
                <table class = "table table-bordered custom_table">
                    <thead>
                        <th>No.</th>
                        <th>Request ID</th>
                        <th>Employee ID</th>
                        <th>Name</th>
                        <th>Leave Title </th>
                        <th>From Date</th>
                        <th>To Date </th>
                        <th>Days</th>
                        <th>Status</th>
                        <th>Action</th>
                    </thead>
                        <cfset No = 0>
                        <cfloop query="get_rejected_requests">
                            <cfset No = No + 1>
                            <tr>
                                <td>#No#</td>
                                <td>#id#</td>
                                <td>#employee_id#</td>
                                <td>#name#</td>
                                <td>#leave_title#</td>
                                <td>#dateFormat(from_date,'DD-MMM-YYYY')#</td>
                                <td>#dateFormat(to_date,'DD-MMM-YYYY')#</td>
                                <td>#leave_days#</td>
                                <td>#action#</td>
                                <td>
                                    <a href = "leave_approval.cfm?request_id=#id#">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-journal-medical" viewBox="0 0 16 16">
                                            <path fill-rule="evenodd" d="M8 4a.5.5 0 0 1 .5.5v.634l.549-.317a.5.5 0 1 1 .5.866L9 6l.549.317a.5.5 0 1 1-.5.866L8.5 6.866V7.5a.5.5 0 0 1-1 0v-.634l-.549.317a.5.5 0 1 1-.5-.866L7 6l-.549-.317a.5.5 0 0 1 .5-.866l.549.317V4.5A.5.5 0 0 1 8 4zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/>
                                            <path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
                                            <path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
                                        </svg>
                                    </a>
                                </td>
                            <tr>
                        </cfloop>
                </table>
            <cfelse>
                <p class="text-danger"> No Rejected Requests! </p>
            </cfif>
        </cfif>
    </cfoutput>
<cfinclude  template="..\includes\foot.cfm">