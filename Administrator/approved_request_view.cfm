                    <!---   Page Summary  --->
        <!--- This page show the details of loan , leave and advance salary request to admin user that already got approval  --->
    <!--- back end  --->
<cfoutput>
    <cfif structKeyExists(session, 'loggedIn')>
            <!---     Getting data for leave request to show on front end    --->
        <cfif structKeyExists(url, 'leave_request_id')>
            <cfquery name = "get_leave_details">
                select a.*, l.leave_title, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
                from all_leaves a , leaves l , employee emp
                where a.leave_id = l.leave_id
                and a.employee_id = emp.employee_id
                and a.id = <cfqueryparam value="#url.leave_request_id#">
            </cfquery>
            <!---      get_leaves query return leaves details date wise    --->
            <cfquery name="get_leaves">
                select * from leaves_approval
                where leave_id = <cfqueryparam value="#url.leave_request_id#">
            </cfquery>
            <!---     Getting data for loan request to show on front end    --->
        <cfelseif structKeyExists(url, 'loan_request_id')>
            <cfquery name='get_loan_details'>
                Select loan.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
                From loan , employee emp
                Where loan.employee_id = emp.employee_id 
                and loan.loan_id = <cfqueryparam value="#url.loan_request_id#">
            </cfquery>
            <!---    get loan installments details       --->
            <cfquery name='get_installments_details'>
                select * from loan_installments
                where loan_id = <cfqueryparam value="#url.loan_request_id#">
            </cfquery>
            <!---     Getting data for advance salary request to show on front end    --->
        <cfelseif structKeyExists(url, 'salary_advance_id')>
            <cfquery name='get_advance_salary_details'>
                Select advance_salary.*, concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
                From advance_salary , employee emp
                Where advance_salary.employee_id = emp.employee_id 
                and advance_salary.advance_id = <cfqueryparam value="#url.salary_advance_id#">
            </cfquery>
            <!---      getting advance salary installments details    --->
            <cfquery name='get_advance_salary_installments_details'>
                select * from advance_salary_installments
                where advance_id = <cfqueryparam value="#url.salary_advance_id#">
            </cfquery>
        </cfif>
        <!--- front end  --->
            <!---     front end for leave request details    --->
        <cfif structKeyExists(url, 'leave_request_id')>
            <div class="employee_box">
                <div class="text-center mb-5">
                    <h3 class="box_heading">View Leave Details</h3>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-5" style="gap: 16px;">
                    <div class="">
                        Employee Name:
                        #get_leave_details.name#
                    </div>
                    <div class="">
                        Employee Id : 
                        #get_leave_details.employee_id#
                    </div>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                    <div>
                        From Date: 
                        <input type="text" class="form-control" value="#dateFormat(get_leave_details.from_date, 'dd-mmm-yyyy')#" readonly>
                    </div>
                    <div>
                        To Date: 
                        <input type="text" class="form-control" value="#dateFormat(get_leave_details.to_date, 'dd-mmm-yyyy')#" readonly>
                    </div>
                    <div>
                        Applied Date:
                        <input type="text" class="form-control" value="#dateFormat(get_leave_details.Request_date, 'dd-mmm-yyyy')#" readonly>
                    </div>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                    <div>
                        Total Days:
                        <input type="text" class="form-control" value="#get_leave_details.leave_days#" readonly>
                    </div>
                    <div>
                        Leave Type:
                        <input type="text" class="form-control" value="#get_leave_details.leave_title#" readonly>
                    </div>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                    <div>
                        Approval date:
                        <input type="text" class="form-control" value="#dateFormat(get_leave_details.action_date, 'dd-mmm-yyyy')#" readonly>
                    </div>
                    <div>
                        Approval Type:
                        <input type="text" class="form-control" value="#get_leave_details.action#" readonly>
                    </div>
                    <div>
                        Approved by:
                        <input type="text" class="form-control" value="#get_leave_details.action_by#" readonly>
                    </div>
                </div>
                <div>
                    <cfloop query="get_leaves">
                        <p>Leave Date: #dateFormat(leave_date, 'dd-mmm-yyyy')# <span class="ml-5">Approved As: <cfif approved_as eq 1>Full Day <cfelseif approved_as eq 0>Rejected <cfelse>Half Day</cfif></span></p>
                    </cfloop>
                </div>
                <div>
                    Reason : 
                    <p>#get_leave_details.Reason#</p>
                </div>
                <div>
                    Approval Remarks:
                    <p>#get_leave_details.Action_remarks#</p>
                </div>
            </div>
            <!---     front end for loan request details start here   --->
        <cfelseif structKeyExists(url, 'loan_request_id')>
    <!---         <cfdump  var="#get_loan_details#"><cfabort> --->
            <div class="employee_box">
                <div class="text-center mb-5">
                    <h3 class="box_heading">View Loan Details</h3>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-5" style="gap: 16px;">
                    <div class="">
                        Employee Name:
                        #get_loan_details.name#
                    </div>
                    <div class="">
                        Employee Id : 
                        #get_loan_details.employee_id#
                    </div>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                    <div>
                        Applied Date: 
                        <input type="text" class="form-control" value="#dateFormat(get_loan_details.apply_date, 'dd-mmm-yyyy')#" readonly>
                    </div>
                    <div>
                        Applied Amount: 
                        <input type="text" class="form-control" value="#get_loan_details.APPLIED_AMOUNT#" readonly>
                    </div>
                    <div>
                        Installment Amount:
                        <input type="text" class="form-control" value="#get_loan_details.INSTALLMENTAMOUNT#" readonly>
                    </div>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                    <div>
                        Approved Date: 
                        <input type="text" class="form-control" value="#dateFormat(get_loan_details.action_date, 'dd-mmm-yyyy')#" readonly>
                    </div>
                    <div>
                        Approval Type: 
                        <input type="text" class="form-control" value="#get_loan_details.action#" readonly>
                    </div>
                    <div>
                        Approved by:
                        <input type="text" class="form-control" value="#get_loan_details.action_by#" readonly>
                    </div>
                </div>
                <cfif get_loan_details.action neq 'rejected'>
                    <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                        <div>
                            Approved Amount: 
                            <input type="text" class="form-control" value="#get_loan_details.total_amount#" readonly>
                        </div>
                        <div>
                            Returned Amount: 
                            <input type="text" class="form-control" value="#get_loan_details.RETURNED_AMOUNT#" readonly>
                        </div>
                        <div>
                            Remaining Amount:
                            <input type="text" class="form-control" value="#get_loan_details.REMAINING_BALANCE#" readonly>
                        </div>
                        <cfif (get_loan_details.status eq 'N') and (get_loan_details.loan_End_Date neq '')>
                            <div>
                                Salary Advance End Date:
                                <input type="text" class="form-control" value="#dateFormat(get_loan_details.loan_End_Date, 'dd-mmm-yyyy')#" readonly>
                            </div>
                        </cfif>
                    </div>
                    <div>
                        <cfif get_installments_details.recordcount neq 0>
                            InstallMents Details:
                            <cfloop query="get_installments_details">
                                <p>Installment Date: #dateFormat(installment_date, 'dd-mmm-yyyy')# <span class="ml-5">Installment Amount : #installment_amount#</p>
                            </cfloop>
                        </cfif>
                    </div>
                </cfif>
                <div>
                    Apply Description : 
                    <p>#get_loan_details.Apply_Description#</p>
                </div>
                <div>
                    Approval Remarks:
                    <p>#get_loan_details.Action_remarks#</p>
                </div>
            </div>
            <!---     front end for advance salary request details start here   --->
        <cfelseif structKeyExists(url, 'salary_advance_id')>
    <!---         <cfdump  var="#get_advance_salary_details#"><cfabort> --->
    <!---         <cfdump  var="#get_advance_salary_installments_details#"><cfabort> --->
            <div class="employee_box">
                <div class="text-center mb-5">
                    <h3 class="box_heading">View Advance Salary Details</h3>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-5" style="gap: 16px;">
                    <div class="">
                        Employee Name:
                        #get_advance_salary_details.name#
                    </div>
                    <div class="">
                        Employee Id : 
                        #get_advance_salary_details.employee_id#
                    </div>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                    <div>
                        Applied Date: 
                        <input type="text" class="form-control" value="#dateFormat(get_advance_salary_details.apply_date, 'dd-mmm-yyyy')#" readonly>
                    </div>
                    <div>
                        Applied Amount: 
                        <input type="text" class="form-control" value="#get_advance_salary_details.APPLIED_AMOUNT#" readonly>
                    </div>
                    <div>
                        Installment Amount:
                        <input type="text" class="form-control" value="#get_advance_salary_details.INSTALLMENTAMOUNT#" readonly>
                    </div>
                </div>
                <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                    <div>
                        Approved Date: 
                        <input type="text" class="form-control" value="#dateFormat(get_advance_salary_details.action_date, 'dd-mmm-yyyy')#" readonly>
                    </div>
                    <div>
                        Approval Type: 
                        <input type="text" class="form-control" value="#get_advance_salary_details.action#" readonly>
                    </div>
                    <div>
                        Approved by:
                        <input type="text" class="form-control" value="#get_advance_salary_details.action_by#" readonly>
                    </div>
                </div>
                <cfif get_advance_salary_details.action neq 'rejected'>
                    <div class="d-flex justify-content-between flex-wrap mb-3" style="gap: 16px;">
                        <div>
                            Approved Amount: 
                            <input type="text" class="form-control" value="#get_advance_salary_details.total_amount#" readonly>
                        </div>
                        <div>
                            Returned Amount: 
                            <input type="text" class="form-control" value="#get_advance_salary_details.RETURNED_AMOUNT#" readonly>
                        </div>
                        <div>
                            Remaining Amount:
                            <input type="text" class="form-control" value="#get_advance_salary_details.REMAINING_BALANCE#" readonly>
                        </div>
                        <cfif (get_advance_salary_details.status eq 'N') and (get_advance_salary_details.Advance_End_Date neq '')>
                            <div>
                                Salary Advance End Date:
                                <input type="text" class="form-control" value="#dateFormat(get_advance_salary_details.Advance_End_Date, 'dd-mmm-yyyy')#" readonly>
                            </div>
                        </cfif>
                    </div>
                    <div>
                        <cfif get_advance_salary_installments_details.recordcount neq 0>
                            InstallMents Details:
                            <cfloop query="get_advance_salary_installments_details">
                                <p>Installment Date: #dateFormat(installment_date, 'dd-mmm-yyyy')# <span class="ml-5">Installment Amount : #installment_amount#</p>
                            </cfloop>
                        </cfif>
                    </div>
                </cfif>
                <div>
                    Description: 
                    <p>#get_advance_salary_details.Apply_Description#</p>
                </div>
                <div>
                    Approval Remarks:
                    <p>#get_advance_salary_details.Action_remarks#</p>
                </div>
            </div>
        </cfif>
    </cfif>
</cfoutput>