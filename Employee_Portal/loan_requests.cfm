<cfinclude  template="..\includes\head.cfm">
<cfoutput>
    <cfif structKeyExists(url, 'request_generated')>
        <cfif url.request_generated eq 'true'>
            Your Request For Loan Has Been Generated.
        <cfelseif url.request_generated eq 'false'>
            Can't Generate Loan Request! You Have Already Generated a Request.
        </cfif>
    </cfif>
    <cfif structKeyExists(url, 'already_taken')>
        <cfif url.already_taken eq 'true'>
            Already Taken! You Can't Apply For Loan.  
        </cfif>
    </cfif>
    <div>
        <a href = "loan_apply.cfm" target = "_self">
            <button type = "button" class = "btn btn-outline-dark create_button mb-3 custom_button">
                Apply For Loan
            </button>
        </a>
    </div>
    <cfquery name = "get_requests">
        select * from loan where employee_id = "#session.loggedin.username#"
    </cfquery>
    <cfif get_requests.recordcount neq 0>
        <cfset No = 0>
        <table class = 'table table-bordered'>
            <thead class = "thead-dark">
                <th>No</th>
                <th>Loan ID</th>
                <th>Applied Amount</th>
                <th>Apply Date</th>
                <th>Status</th>
                <th>Action By</th>
            </thead>
            <tbody>
            <cfloop query = "get_requests">
                <cfset No = No + 1>
                <th>#No#</th>
                <th>#Loan_ID#</th>
                <th>#Applied_Amount#</th>
                <th>#dateFormat(Apply_Date,'dd-mmm-yyyy')#</th>
                <th>#Action#</th>
                <th>#Action_By#</th>
            </cfloop>
            </tbody>
        </table>
    <cfelse>
        No Loan Requests! You Have Never Apply For Loan.
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">