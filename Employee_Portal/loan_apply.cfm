<cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(form, 'Applied_amount')>
        <cfquery name = "get_loans">
            select action, status
            from loan
            where employee_id = "#session.loggedin.username#"
        </cfquery>
        <cfif get_loans.action eq 'pending'>
            <cflocation  url="loan_requests.cfm?request_generated=false">
        <cfelseif get_loans.action eq 'approved' and get_loans.status eq 'Y'>
            <cflocation  url="loan_requests.cfm?already_taken=true">
        </cfif>
        <cfquery name = "insert_loan">
            insert into loan 
            (employee_id, applied_amount, apply_description, Apply_date, apply_by, Status)
            values('#session.loggedin.username#', '#form.Applied_amount#', '#form.apply_description#', now(), '#session.loggedin.username#', 'N')
        </cfquery>
        <cflocation  url="loan_requests.cfm?request_generated=true">
    </cfif>
    <cfoutput>
            <form action = "loan_apply.cfm" method = "post">
                <div class = "row">
                    <div class = "col-md-4">
                        <label for = "Applied_amount"> How Much Amount Do You Want?</label>
                        <input min = "0" maxlength="6" required = "true" type = "number" name = "Applied_amount" id = "Applied_amount" class = "form-control"> 
                    </div>
                </div>
                    <label for = "apply_description"> Why Need Loan? Please Describe.</label>
                    <textarea class = "form-control" required = "true" name = "apply_description" id = "apply_description" cols = "100" rows = "10" placeholder = "Describe in maximum 200 words"></textarea>
                <input type = "submit" class = "btn btn-outline-dark mt-3">
            </form>
    </cfoutput>
<cfinclude  template="..\includes\foot.cfm">