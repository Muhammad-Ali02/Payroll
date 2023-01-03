<cfinclude  template="..\includes\head.cfm">
    <cfoutput>
        <!--- _________________________________________ Back End ______________________________________--->
        <cfquery name = "leave_requests">
            select a.*, l.leave_title from all_leaves a , leaves l where a.employee_id = "#session.loggedin.username#" and a.leave_id = l.leave_id
        </cfquery>
        <!--- ___________________________________________ Front End _________________________________________________--->
        <cfif structKeyExists(url, 'request_submitted')>
            <p class = "text-success">
                Leave Request Submitted.
            </p>
        </cfif>
        <table class = "table table-hover table-bordered">
            <thead class = "thead-dark">
                <th>No.</th>
                <th>Request ID</th>
                <th>Employee ID</th>
                <th>Leave Title </th>
                <th>From Date</th>
                <th>To Date </th>
                <th>Leave Days</th>
                <th>Action</th>
                <th>Action By </th>
            </thead>
                <cfset No = 0>
                <cfloop query="leave_requests">
                    <cfset No = No + 1>
                    <tr>
                        <td>#No#</td>
                        <td>#id#</td>
                        <td>#employee_id#</td>
                        <td>#leave_title#</td>
                        <td>#dateFormat(from_date,'DD-MMM-YYYY')#</td>
                        <td>#dateFormat(to_date,'DD-MMM-YYYY')#</td>
                        <td>#leave_days#</td>
                        <td>#action#</td>
                        <td>#action_by#</td>
                    <tr>
                </cfloop>
        </table>
    </cfoutput>
<cfinclude  template="..\includes\foot.cfm">