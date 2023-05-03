 
<cfoutput>
    <cfquery name='advance_salary_request'>
        Select advance_salary.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From advance_salary , employee emp
        Where advance_salary.employee_id = emp.employee_id 
        And advance_salary.action = 'pending'
    </cfquery>
    <cfquery name='get_approved_request'>
        Select advance_salary.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From advance_salary , employee emp
        Where advance_salary.employee_id = emp.employee_id And (advance_salary.action = 'Approved' or advance_salary.action = 'Partial Approved')
    </cfquery>
    <cfquery name='get_rejected_request'>
        Select advance_salary.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From advance_salary , employee emp
        Where advance_salary.employee_id = emp.employee_id 
        And advance_salary.action = 'rejected'
    </cfquery>
    <cfif structKeyExists(form, 'Approve') or structKeyExists(form, 'Reject') or structKeyExists(form, 'Partial_approved')>
        <cfquery name="get_email">
            select concat(first_name," ", middle_name, " " , last_name) as name, official_email from employee emp JOIN advance_salary adv 
            where emp.employee_id = adv.employee_id and adv.Advance_Id = '#url.id#';
        </cfquery>
        <cfif structKeyExists(form, 'Approve')>
            <cfquery name="advance_salary_approval">
                Update advance_salary
                Set action ='Approved',
                    status = 'Y',
                    Total_amount = Applied_amount,
                    Returned_Amount = <cfqueryparam value='0'>,
                    remaining_balance = Applied_amount,
                    Action_by= <cfqueryparam value= '#session.loggedIn.username#'>,
                    Action_Date = now(),
                    action_remarks = '#form.txt_remarks#'
                    where Advance_id = <cfqueryparam value='#url.id#'>
            </cfquery>
            <cfquery name='get_applied_amount'>
                select * from advance_salary
                where Advance_id = <cfqueryparam value='#url.id#'> 
            </cfquery>
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_email.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Advance Salary Approval" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
            
                    <h2>
                        Advance Salary Approved
                    </h2>
                
                <p>
                    Dear #get_email.name#,<br>

                    I am pleased to inform you that your request for an advance salary #get_applied_amount.Applied_amount#Rs has been approved. 
                    Your dedication and hard work have not gone unnoticed, and we are happy to support you during this time.

                    The advance salary amount that you requested will be included in your next paycheck. 
                    Please review your paystub carefully to ensure that the amount is correct.
                </p>
            </cfmail>
            <cflocation  url="?action=Approved">
        <cfelseif structKeyExists(form, 'Partial_approved')>
            <cfquery name="advance_salary_approval">
                Update advance_salary
                Set action ='Partial Approved',
                    status = 'Y',
                    Total_amount = '#form.Approved_amount#',
                    returned_Amount = <cfqueryparam value='0'>,
                    remaining_balance = '#form.Approved_amount#',
                    Action_by= <cfqueryparam value= '#session.loggedIn.username#'>,
                    Action_Date = now(),
                    action_remarks = '#form.txt_remarks#'
                    where Advance_id = '#url.id#'
            </cfquery>
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_email.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Advance Salary Approval" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
            
                    <h2>
                        Advance Salary Approved Partially
                    </h2>
                
                <p>
                    Dear #get_email.name#,<br>

                    I am pleased to inform you that your request for an advance salary #form.Approved_amount#Rs has been approved partially. 
                    Your dedication and hard work have not gone unnoticed, and we are happy to support you during this time.

                    The advance salary amount that you requested will be included in your next paycheck. 
                    Please review your paystub carefully to ensure that the amount is correct.
                </p>
            </cfmail>
            <cflocation  url="?action=Partially_Approved">
        <cfelseif structKeyExists(form, 'Reject')>
            <cfquery name="advance_salary_approval">
                Update advance_salary
                Set action ='Rejected',
                    Action_by= <cfqueryparam value= '#session.loggedIn.username#'>,
                    Action_Date = now(),
                    action_remarks = '#form.txt_remarks#'
                    where Advance_id = '#url.id#'
            </cfquery>
            <cfmail from="exception@mynetiquette.com" 
                    to="#get_email.official_email#"
                    <!---to="error.netiquette@gmail.com"---> 
                    subject="Advance Salary Rejection" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
            
                    <h2>
                        Advance Salary Rejected
                    </h2>
                
                <p>
                    Dear #get_email.name#,<br>

                    I hope this email finds you well. I wanted to follow up on your recent request for an advance salary payment.

                    After careful consideration and review, I regret to inform you that your request has been rejected. 
                    While we understand that unexpected financial circumstances can arise, our company policy regarding 
                    salary advances is to ensure that they are only given in exceptional cases.

                    We appreciate your hard work and dedication to the company, and we want to make sure that all employees 
                    are treated fairly and equitably. Therefore, we must adhere to our policies and procedures to 
                    maintain consistency and fairness.
                </p>
            </cfmail>
            <cflocation  url="?action=Rejected">
        </cfif>
    </cfif>
    <!--- -------------------                           front - end                             ----------------------- --->
    <cfif structKeyExists(url, 'action')>
        <p class = "text-success">
            Advance Salary Request<strong> #url.action# </strong> Successfully.
        </p>
    </cfif>
    <cfif structKeyExists(url, 'request_id')>
        <cfquery name="get_advance_salary_details">
            select * from advance_salary
            where Advance_id = <cfqueryparam value="#url.request_id#">
        </cfquery>
        <cfif get_advance_salary_details.Action neq "Pending">
            <div class="text-center mb-5">
                <h3 class="box_heading">Advance Salary Approval</h3>
            </div>
            <h6>Sorry! You can no longer edit this advance salary request.</h6>
        <cfelse>
            <div class="employee_box">
                <div class="text-center mb-5">
                    <h3 class="box_heading">Advance Salary Approval</h3>
                </div>
                    <div class = "row">
                        <div class = "col-md-4">
                            Applied Date: 
                            <p>#dateFormat(get_advance_salary_details.Apply_date,'dd-mmm-yyyy')#<p>
                        </div>
                        <div class = "col-md-4">
                            Applied Amount: 
                            <p>#get_advance_salary_details.Applied_amount#<p>
                        </div>
                        <div class = "col-md-4">
                            Installment:
                            <p>#get_advance_salary_details.InstallmentAmount#</p>
                        </div>
                        
                    </div>
                    <div class = "row">
                        <label for = "reason" class = "mt-3">Reason: </label>
                        <p>#get_advance_salary_details.Apply_Description#<p>
                    </div>
                    <form action = "?id=#url.request_id#" onsubmit="return formValidate();" method = "post">
                        <div id="advance_salary_selection" style="display:none;">
                            <div class="row mb-2">
                                <div class="col-md-6">
                                    Enter Amount for Advance Salary Approval :
                                    <input type="number" id="Approved_amount" name="Approved_amount" maxlength="6" min="0" max="#get_advance_salary_details.Applied_amount#" class="form-control">
                                </div>
                                <div class="col-md-4">
                                    <input type ="submit" id="Partial_advance_salary" value = "Approved Partially" name="Partial_approved" onclick="document.getElementById('approval_type').value='partial_approved';" class = "btn btn-outline-danger mb-2 mt-4 ml-2">
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
                                <input type="hidden" name="employee_id" value="#advance_salary_request.employee_id#">
                                <input type="hidden" name="approval_type" id="approval_type">
                                <button id = "" onclick="document.getElementById('advance_salary_selection').style.display='inline'; this.disabled=true; document.getElementById('Approve_advance_salary').style.display='none';" name = "Partial" class = "btn btn-outline-danger">Approve Partial Advance Salary</button>
                                <input type = "submit" id = "Approve_advance_salary" value = "Approve Advance Salary" onclick="document.getElementById('approval_type').value='full_approved';" name = "Approve" class = "btn btn-outline-success">
                                <input type = "submit" id = "Reject_advance_salary" value = "Reject Advance Salary" name = "Reject" class = "btn btn-outline-danger">
                            </div>
                        </div>
                    </form>
            </div>
        </cfif>
    <cfelse>
        <div class="text-center mb-5">
            <h3 class="box_heading">Advance Salary Approval</h3>
        </div>
        <cfif advance_salary_request.recordcount neq 0>
            <p class = "text-primary">Pending Requests:</p>
            <table class = "table table-bordered custom_table">
                <thead>
                    <th>No.</th>
                    <th>Request ID</th>
                    <th>Employee ID</th>
                    <th>Name</th>
                    <th>Advance Salary Amount</th>
                    <th>Applied Date</th>
                    <th>InstallMent Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </thead>
                    <cfset No = 0>
                    <cfloop query="advance_salary_request">
                        <cfset No = No + 1>
                        <tr>
                            <td>#No#</td>
                            <td>#Advance_id#</td>
                            <td>#employee_id#</td>
                            <td>#name#</td>
                            <td>#Applied_Amount#</td>
                            <td>#dateFormat(Apply_date ,'DD-MMM-YYYY')#</td>
                            <td>#InstallMentAmount#</td>
                            <td>#action#</td>
                            <td>
                                <a href = "?request_id=#Advance_id#">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-check2-circle" viewBox="0 0 16 16">
                                        <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                                        <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
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
                    <th>Advance Salary Amount</th>
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
                            <td>#Advance_id#</td>
                            <td>#employee_id#</td>
                            <td>#name#</td>
                            <td>#Applied_Amount#</td>
                            <td>#dateFormat(Apply_date ,'DD-MMM-YYYY')#</td>
                            <td>#InstallMentAmount#</td>
                            <td>#action#</td>
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
                    <th>Advance Salary Amount</th>
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
                            <td>#Advance_id#</td>
                            <td>#employee_id#</td>
                            <td>#name#</td>
                            <td>#Applied_Amount#</td>
                            <td>#dateFormat(Apply_date ,'DD-MMM-YYYY')#</td>
                            <td>#InstallMentAmount#</td>
                            <td>#action#</td>
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
        <cfelse>
            <p class="text-light"> No Rejected Requests! </p>
        </cfif>
    </cfif>
</cfoutput>
<script>
    function formValidate(){
        debugger
        let approval_type = $('#approval_type').val();
        let txt_remarks = $('#txt_remarks').val();
        let Approved_amount = $('#Approved_amount').val();
        if(approval_type == 'partial_approved'){
            if(Approved_amount == '' || txt_remarks == ''){
                alert('All fields must be filled out.');
                return false;
            }else{
                return true;
            }
        }
    }
</script>
 