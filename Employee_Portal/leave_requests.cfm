<cfinclude  template="..\includes\head.cfm">
    <cfoutput>
        <!--- _________________________________________ Back End ______________________________________--->
        <cfquery name = "leave_requests">
            select a.*, l.leave_title from all_leaves a , leaves l where a.employee_id = "#session.loggedin.username#" and a.leave_id = l.leave_id
        </cfquery>
        <!--- _________________________________________ Front End ______________________________________--->
        <cfif structKeyExists(url, 'request_submitted')>
            <cfif url.request_submitted eq 'true'>
                <p class = "text-success" style = "font-weight:bold">
                    *Leave Request Submitted.
                </p>
            <cfelse>
                <p class = "text-danger" style = "font-weight:bold">
                    *Leave Request Submition Failed! Duplicate Request Found, Please Choose Different Dates.
                </p>
            </cfif>
        </cfif>
        <a href = "request_leave.cfm" >
            <button type = "button" class = "btn btn-outline-dark mb-3 custom_button">
                Request Leave
            </button>
        </a>
        <cfif leave_requests.recordcount neq 0>
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
                            <td <cfif action eq 'rejected'> class = "text-danger table-danger" <cfelseif action eq 'approved'> class = "text-success table-success"</cfif>>
                                #action#
                            </td>
                            <td>#action_by#</td>
                        <tr>
                        <cfif action eq 'rejected'>
                            <tr class = "table-danger">
                                <td><strong>Rejected Remarks</strong></td>
                                <td colspan = "8" class = "text-danger">#action_remarks#</td>
                            </tr>
                        </cfif>
                    </cfloop>
            </table>
        <cfelse>
            <p> No Leave Requests Found! </p>
        </cfif>
    </cfoutput>
<cfinclude  template="..\includes\foot.cfm">