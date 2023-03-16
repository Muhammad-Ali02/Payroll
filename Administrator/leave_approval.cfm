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
            and action = 'approved'
        </cfquery>
        <cfquery name = "get_rejected_requests">
            select a.*, l.leave_title, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
            from all_leaves a , leaves l , employee emp 
            where a.leave_id = l.leave_id 
            and a.employee_id = emp.employee_id
            and action = 'rejected'
        </cfquery>
        <!--- update leave as approved or rejected --->
        <cfif structKeyExists(form, 'Approve') or structKeyExists(form, 'Reject')>
            <cfquery name = "update_all_leaves" result="update_leave_result">
                update all_leaves
                set 
                    <cfif isDefined('form.Approve')>
                        action = "Approved",
                    <cfelseif isDefined('form.Reject')>
                        action = "Rejected",
                    </cfif>
                    action_by = "#session.loggedIn.username#",
                    action_date = now(),
                    action_remarks = '#form.txt_remarks#'
                    where id = '#url.id#'
            </cfquery>
<!---             <cfif "#update_leave_result#" eq "1"> 
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
            <cfelse>
                <cflocation  url="leave_approval.cfm?action=Rejected">
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
        <!--- ___________________________________________ Front End _________________________________________________--->
            <div class="employee_box">
                <div class="text-center mb-4">
                    <h3>Leave Approval</h3>
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
                    <div class = "row">
                        <div class="col-md-12">
                            <label for = "txt_remarks">Remarks:</label>
                            <textarea class = "form-control" id = "txt_remarks" name = "txt_remarks" placeholder = "Please Write Some Remarks According to Your Action (Approve or Reject)" required></textarea>
                        </div>
                    </div>
                    <div class = "row mt-3">
                        <div class="d-flex justify-content-end" style="gap: 8px;">
                            <input type = "submit" id = "Approve_leave" value = "Approve Leave" name = "Approve" class = "btn btn-outline-success">
                            <input type = "submit" id = "Reject_leave" value = "Reject Leave" name = "Reject" class = "btn btn-outline-danger">
                        </div>
                    </div>
                </form>
            </div>
        <cfelse>
            <cfif leave_requests.recordcount neq 0>
                <p class = "text-primary">Pending Requests:</p>
                <table class = "table table-bordered">
                    <thead class = "table-light">
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
                <table class = "table table-bordered">
                    <thead class = "table-success">
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
                <table class = "table table-bordered">
                    <thead class = "table-danger">
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