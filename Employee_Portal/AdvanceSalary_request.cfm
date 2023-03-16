<cfinclude  template="..\includes\head.cfm">
<cfoutput>
    <cfif structKeyExists(url, 'request_generated')>
        <cfif url.request_generated eq 'true'>
            Your Request For Advance Salary Has Been Generated.
        <cfelseif url.request_generated eq 'false'>
            Can't Generate Advance Salary Request! You Have Already Generated a Request.
        </cfif>
    </cfif>
    <cfif structKeyExists(url, 'already_taken')>
        <cfif url.already_taken eq 'true'>
            Already Taken! You Can't Apply For Advance Salary.  
        </cfif>
    </cfif>
    <div>
        <a href = "AdvanceSalary.cfm" target = "_self">
            <button type = "button" class = "btn btn-outline-dark create_button mb-3 custom_button">
                Apply For Advance Salary
            </button>
        </a>
    </div>
    <cfquery name = "get_requests">
        select * from advance_salary where employee_id = "#session.loggedin.username#"
    </cfquery>
    <cfif get_requests.recordcount neq 0>
        <cfset No = 0>
        <table class = 'table custom_table'>
            <thead>
                <th>No</th>
                <th>Advance Salary ID</th>
                <th>Applied Amount</th>
                <th>Apply Date</th>
                <th>Status</th>
                <th>Action By</th>
            </thead>
            <tbody>
            <cfloop query = "get_requests">
                <cfset No = No + 1>
                <th>#No#</th>
                <th>#Advance_Id#</th>
                <th>#Applied_Amount#</th>
                <th>#dateFormat(Apply_Date,'dd-mmm-yyyy')#</th>
                <th>#Action#</th>
                <th>#Action_By#</th>
            </cfloop>
            </tbody>
        </table>
    <cfelse>
        No Advance Salary Requests! You Have Never Apply For Advance Salary.
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">