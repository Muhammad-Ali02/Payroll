 
<cfoutput>
    <cfquery name='loan_request'>
        Select loan.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From loan , employee emp
        Where loan.employee_id = emp.employee_id order by loan_id desc
    </cfquery>
    <!---<cfquery name='get_approved_request'>
        Select loan.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From loan , employee emp
        Where loan.employee_id = emp.employee_id And (loan.action = 'Approved' or loan.action = 'Partial Approved')
    </cfquery>
    <cfquery name='get_rejected_request'>
        Select loan.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
        From loan , employee emp
        Where loan.employee_id = emp.employee_id 
        And loan.action = 'rejected'
    </cfquery>--->
    
    <cfif structKeyExists(form, 'Approve') or structKeyExists(form, 'Reject') or structKeyExists(form, 'Partial_approved')>
        <cfquery name="get_email">
        select concat(first_name," ", middle_name, " " , last_name) as name , official_email from employee emp JOIN loan 
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
            <cfquery name='get_loan_amount'>
                select * from loan
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
                    Dear #get_email.name#,<br>

                    I am pleased to inform you that your loan request has been approved. 
                    Our team has reviewed your application and we have found that you meet our 
                    eligibility criteria for the loan.

                    As per your request, we will be providing you with a loan amount of #get_loan_amount.Applied_amount# 
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
                    Dear #get_email.name#,<br>

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
                    Dear #get_email.name#,<br>

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
            <h6>Sorry! You can no longer edit this loan request.</h6>
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
                    <form onsubmit="return formValidate();" action = "?id=#url.request_id#" method = "post">
                        <div id="loanSelection" style="display:none;">
                            <div class="row mb-2">
                                <div class="col-md-4">
                                    Enter Amount for Loan Approval  :
                                    <input type="number" id="Approved_amount" name="Approved_amount" maxlength="6" min="0" max="#get_loan_details.Applied_amount#" class="form-control">
                                </div>
                                <div class="col-md-4">
                                    <input type ="submit" id="Partial_loan" value = "Approved Partially" name="Partial_approved" onclick="document.getElementById('approval_type').value='partial_approved';" class = "btn btn-outline-danger mb-2 mt-4 ml-2">
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
                                <input type="hidden" name="approval_type" id="approval_type">
                                <button id = "" onclick="document.getElementById('loanSelection').style.display='inline'; this.disabled=true; document.getElementById('Approve_loan').style.display='none';" name = "Partial" class = "btn btn-outline-danger">Approve Partial Loan</button>
                                <input type = "submit" id = "Approve_loan" value = "Approve Loan" name = "Approve" onclick="document.getElementById('approval_type').value='full_approved';" class = "btn btn-outline-success">
                                <input type = "submit" id = "Reject_loan" value = "Reject Loan" name = "Reject" class = "btn btn-outline-danger">
                            </div>
                        </div>
                    </form>
            </div>
        </cfif>
    <cfelse>
        <div class="text-center mb-5">
            <h3 class="box_heading">Loan Approval</h3>
        </div>
        <div>
            <!---       Remove customize pagination and add data tables           --->
            <table id="mytable" class="table custom_table">
                <thead>
                    <tr>
                    <th>No.</th>
                        <th>Request ID</th>
                        <th>Employee ID</th>
                        <th>Name</th>
                        <th>Loan Amount</th>
                        <th>Applied Date</th>
                        <th>InstallMent Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
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
                            <!---     this if condition use for approved requests user can only view details of approved requests       --->
                            <cfif action neq 'Pending'>
                                <a href = "approved_request_view.cfm?loan_request_id=#loan_id#">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-check2-circle" viewBox="0 0 16 16">
                                        <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                                        <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                                    </svg>
                                </a>
                            <cfelse>
                                <a href = "?request_id=#loan_id#">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-check2-circle" viewBox="0 0 16 16">
                                        <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                                        <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                                    </svg>
                                </a>
                            </cfif>
                        </td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        </div>
        <!---<cfif loan_request.recordcount neq 0>
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
        </cfif>--->
    </cfif>
</cfoutput>
<script>
    // data table code
    $(document).ready(function() {
        $.noConflict();
        var table = $('#mytable').dataTable({
            "paging": true,
            "searching": true,
            "ordering": true,
            "info": true,
            "createdRow": function( row, data, dataIndex ) {
                $(row).css('background-color', 'rgb(0,0,0,0.2)');
            }
        });
    });
    function formValidate(){
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

 