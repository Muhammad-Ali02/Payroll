 
<cfoutput>
    <cfquery name='loan_request'>
        Select loan.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From loan , employee emp
        Where loan.employee_id = emp.employee_id 
        And loan.action = 'pending'
    </cfquery>
    <cfquery name='get_approved_request'>
        Select loan.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From loan , employee emp
        Where loan.employee_id = emp.employee_id And (loan.action = 'Approved' or loan.action = 'Partial Approved')
    </cfquery>
    <cfquery name='get_rejected_request'>
        Select loan.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From loan , employee emp
        Where loan.employee_id = emp.employee_id 
        And loan.action = 'rejected'
    </cfquery>
    
    <cfif structKeyExists(form, 'Approve') or structKeyExists(form, 'Reject') or structKeyExists(form, 'Partial_approved')>
        <cfquery name="get_email">
        select official_email from employee emp JOIN loan 
        where emp.employee_id = loan.employee_id and loan.loan_id = '#url.id#';
        </cfquery>
        <cfif structKeyExists(form, 'Approve')>
            <cfquery name="loan_approval">
                Update loan
                Set action ='Approved',
                    status = 'Y',
                    Total_amount = Applied_amount,
                    loan_balance = <cfqueryparam value='0'>,
                    remaining_balance = Applied_amount,
                    Action_by= <cfqueryparam value= '#session.loggedIn.username#'>,
                    Action_Date = now(),
                    action_remarks = <cfqueryparam value='#form.txt_remarks#'>
                    where loan_id = <cfqueryparam value='#url.id#'>
            </cfquery>
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_email.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Loan Approval" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
                
                    <h2>
                        Loan Approved
                    </h2>
                
                <p>
                    Dear Employee,

                    I am pleased to inform you that your loan request has been approved. 
                    Our team has reviewed your application and we have found that you meet our 
                    eligibility criteria for the loan.

                    As per your request, we will be providing you with a loan amount of #form.Approved_amount# 
                    The loan will be disbursed to your account within timeframe for disbursement.
                </p>
            </cfmail>
            <cflocation  url="?action=Approved">
        <cfelseif structKeyExists(form, 'Partial_approved')>
            <cfquery name="loan_approval">
                Update loan
                Set action ='Partial Approved',
                    status = 'Y',
                    Total_amount = '#form.Approved_amount#',
                    loan_balance = <cfqueryparam value='0'>,
                    remaining_balance = '#form.Approved_amount#',
                    Action_by= <cfqueryparam value= '#session.loggedIn.username#'>,
                    Action_Date = now(),
                    action_remarks = <cfqueryparam value='#form.txt_remarks#'>
                    where loan_id = <cfqueryparam value='#url.id#'>
            </cfquery>
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_email.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Loan Approval" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
                
                    <h2>
                        Loan Approved Partially
                    </h2>
                
                <p>
                    Dear Employee,

                    I am pleased to inform you that your loan request has been approved partially. 
                    Our team has reviewed your application and we have found that you meet our 
                    eligibility criteria for the loan.

                    As per your request, we will be providing you with a loan amount of #form.Approved_amount# 
                    The loan will be disbursed to your account within timeframe for disbursement.
                </p>
            </cfmail>
            <cflocation  url="?action=Partially_Approved">
        <cfelseif structKeyExists(form, 'Reject')>
            <cfquery name="loan_approval">
                Update loan
                Set action ='Rejected',
                    Action_by= <cfqueryparam value= '#session.loggedIn.username#'>,
                    Action_Date = now(),
                    action_remarks = <cfqueryparam value='#form.txt_remarks#'>
                    where loan_id = <cfqueryparam value='#url.id#'>
            </cfquery>
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_email.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Loan Rejection" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
                
                    <h2>
                        Loan Rejected
                    </h2>
                
                <p>
                    Dear Employee,

                    I regret to inform you that your loan request has been rejected. 
                    After careful consideration of your application and credit history, 
                    our financial institution has determined that we are unable to approve your loan at this time.

                    We understand that this may be disappointing news, but please note that our 
                    decision was based solely on the information provided in your application and 
                    our internal lending criteria. Unfortunately, we cannot disclose any specific details 
                    as to why your request was denied.
                </p>
            </cfmail>
            <cflocation  url="?action=Rejected">
        </cfif>
    </cfif>
    <!--- -------------------                           front - end                             ----------------------- --->
    <cfif structKeyExists(url, 'action')>
        <p class = "text-success">
            Loan Request<strong> #url.action# </strong> Successfully.
        </p>
    </cfif>
    <cfif structKeyExists(url, 'request_id')>
        <cfquery name="get_loan_details">
            select * from loan
            where loan_id = <cfqueryparam value="#url.request_id#">
        </cfquery>
        <cfif get_loan_details.Action neq "pending">
            <div class="text-center mb-5">
                <h3 class="box_heading">Loan Approval</h3>
            </div>
            <h6>Sorry! You can no longer edit it this loan request.</h6>
        <cfelse>
            <div class="employee_box">
                <div class="text-center mb-5">
                        <h3 class="box_heading">Loan Approval</h3>
                    </div>
                    <div class = "row">
                        <div class = "col-md-4">
                            Applied Date: 
                            <p>#dateFormat(get_loan_details.Apply_date,'dd-mmm-yyyy')#<p>
                        </div>
                        <div class = "col-md-4">
                            Applied Amount: 
                            <p>#get_loan_details.Applied_amount#<p>
                        </div>
                        <div class = "col-md-4">
                            Installment:
                            <p>#get_loan_details.InstallmentAmount#</p>
                        </div>
                        
                    </div>
                    <div class = "row">
                        <label for = "reason" class = "mt-3">Reason: </label>
                        <p>#get_loan_details.Apply_Description#<p>
                    </div>
                    <form action = "?id=#url.request_id#" method = "post">
                        <div id="loanSelection" style="display:none;">
                            <div class="row mb-2">
                                <div class="col-md-4">
                                    Enter Amount for Loan Approval  :
                                    <input type="number" id="Approved_amount" name="Approved_amount" maxlength="6" min="0" max="#get_loan_details.Applied_amount#" class="form-control">
                                </div>
                                <div class="col-md-4">
                                    <input type ="submit" id="Partial_loan" value = "Approved Partially" name="Partial_approved" class = "btn btn-outline-danger mb-2 mt-4 ml-2">
                                </div>
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
                                <!--- <input type="hidden" name="leave_type" value="#get_leave_detail.leave_id#"> --->
                                <input type="hidden" name="employee_id" value="#loan_request.employee_id#">
                                <button id = "" onclick="document.getElementById('loanSelection').style.display='inline'; this.disabled=true" name = "Partial" class = "btn btn-outline-danger">Approve Partial Loan</button>
                                <input type = "submit" id = "Approve_loan" value = "Approve Loan" name = "Approve" class = "btn btn-outline-success">
                                <input type = "submit" id = "Reject_loan" value = "Reject Loan" name = "Reject" class = "btn btn-outline-danger">
                            </div>
                        </div>
                    </form>
            </div>
        </cfif>
    <cfelse>
        <cfif loan_request.recordcount neq 0>
            <p class = "text-primary">Pending Requests:</p>
            <table class = "table table-bordered custom_table">
                <thead>
                    <th>No.</th>
                    <th>Request ID</th>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Loan Amount</th>
                    <th>Applied Date</th>
                    <th>InstallMent Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </thead>
                    <cfset No = 0>
                    <cfloop query="loan_request">
                        <cfset No = No + 1>
                        <tr>
                            <td>#No#</td>
                            <td>#loan_id#</td>
                            <td>#employee_id#</td>
                            <td>#name#</td>
                            <td>#Applied_Amount#</td>
                            <td>#dateFormat(Apply_date ,'DD-MMM-YYYY')#</td>
                            <td>#InstallMentAmount#</td>
                            <td>#action#</td>
                            <td>
                                <a href = "?request_id=#loan_id#">
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
        <cfif get_approved_request.recordcount neq 0>
            <p class = "text-success">Approved Requests:</p>
            <table class = "table table-bordered custom_table">
                <thead>
                    <th>No.</th>
                    <th>Request ID</th>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Loan Amount</th>
                    <th>Applied Date</th>
                    <th>InstallMent Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </thead>
                    <cfset No = 0>
                    <cfloop query="get_approved_request">
                        <cfset No = No + 1>
                        <tr>
                            <td>#No#</td>
                            <td>#loan_id#</td>
                            <td>#employee_id#</td>
                            <td>#name#</td>
                            <td>#Applied_Amount#</td>
                            <td>#dateFormat(Apply_date ,'DD-MMM-YYYY')#</td>
                            <td>#InstallMentAmount#</td>
                            <td>#action#</td>
                            <td>
                                <a title="You can no longer edit it.">
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
            <p class="text-light"> No Approved Requests! </p>
        </cfif>
        <cfif get_rejected_request.recordcount neq 0>
            <p class = "text-danger">Rejected Requests:</p>
            <table class = "table table-bordered custom_table">
                <thead>
                    <th>No.</th>
                    <th>Request ID</th>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Loan Amount</th>
                    <th>Applied Date</th>
                    <th>InstallMent Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </thead>
                    <cfset No = 0>
                    <cfloop query="get_rejected_request">
                        <cfset No = No + 1>
                        <tr>
                            <td>#No#</td>
                            <td>#loan_id#</td>
                            <td>#employee_id#</td>
                            <td>#name#</td>
                            <td>#Applied_Amount#</td>
                            <td>#dateFormat(Apply_date ,'DD-MMM-YYYY')#</td>
                            <td>#InstallMentAmount#</td>
                            <td>#action#</td>
                            <td>
                                <a title="You can no longer edit it.">
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
            <p class="text-light"> No Rejected Requests! </p>
        </cfif>
    </cfif>
</cfoutput>

 