 
    <cfoutput>
        <!--- _________________________________________ Back End ______________________________________--->
        <cfquery name = "leave_requests">
            select a.*, l.leave_title 
            from all_leaves a , leaves l 
            where a.employee_id = "#session.loggedin.username#" and a.leave_id = l.leave_id order by a.request_date desc
        </cfquery>
        <!---<cfif leave_requests.action eq 'partial approved'>
            
        </cfif>--->
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
        <div class="text-center mb-5">
            <h3 class="box_heading">Leave Requests</h3>
        </div>
        <a href = "request_leave.cfm" >
            <button type = "button" class = "btn btn-outline-dark mb-3 custom_button">
                Request Leave
            </button>
        </a>
        <cfif leave_requests.recordcount neq 0>
            <cfparam name="pageNum" default="1">
            <cfset maxRows = 5>
            <cfset startRow = min( ( pageNum-1 ) * maxRows+1, max( leave_requests.recordCount,1 ) )>
            <cfset endRow = min( startRow + maxRows-1, leave_requests.recordCount )>
            <cfset totalPages = ceiling( leave_requests.recordCount/maxRows )>
            <cfset loopercount = ceiling( leave_requests.recordCount/maxRows )>
            <div>
                <table class = "table custom_table">
                    <thead>
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
                        <cfset No = #startRow# - 1>
                        <cfloop query="leave_requests" startrow="#startRow#" endrow="#endRow#">
                            <cfset No = No + 1>
                            <tr>
                                <td>#No#</td>
                                <td>#id#</td>
                                <td>#employee_id#</td>
                                <td>#leave_title#</td>
                                <td>#dateFormat(from_date,'DD-MMM-YYYY')#</td>
                                <td>#dateFormat(to_date,'DD-MMM-YYYY')#</td>
                                <td>#leave_days#</td>
                                <td <cfif action eq 'rejected'> class = "text-danger" <cfelseif action eq 'approved'> class = "text-success" <cfelseif action eq 'partial approved'> style="color: rgb(242, 162, 24);"</cfif>>
                                    <cfif action eq 'rejected'>
                                        <div class="hover-popup">
                                            <span class="trigger">
                                                #action#
                                            </span>
                                            <div class="content ">
                                                <!-- <div style="text-align: center; text-decoration: underline; color: rgb(255, 255, 255, 0.8);">
                                                    <h6>Rejected Remarks</h6>
                                                </div> -->
                                                <div class="mt-1" style="color: rgb(255, 255, 255); font-size: 12px;">
                                                   <p style="text-align: justify; text-justify: inter-word;">#action_remarks#</p>
                                                </div>
                                            </div>
                                        </div>
                                    <cfelseif action eq 'partial approved'>
                                        <cfquery name="partial_approved">
                                            select * from leaves_approval
                                            where leave_id = <cfqueryparam value="#leave_requests.id#">
                                        </cfquery>
                                        <div class="hover-popup">
                                            <span class="trigger">
                                                #action#
                                            </span>
                                            <div class="content">
                                                <!-- <div style="text-align: center; text-decoration: underline; color: rgb(255, 255, 255, 0.8);">
                                                    <h6>Rejected Remarks</h6>
                                                </div> -->
                                                <div class="mt-1" style="color: rgb(255, 255, 255); font-size: 12px;">
                                                    <p style="text-align: justify; text-justify: inter-word; font-weight: bolder; margin-left: 5px;">Date &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Action</p>
                                                    <cfloop query="partial_approved">
                                                        <p style="text-align: justify; text-justify: inter-word;">
                                                            #dateFormat('#leave_date#','yyyy-mm-dd')# <strong> : </strong> 
                                                            <cfif approved_as eq '1'>
                                                               Approve As Full Leave
                                                            <cfelseif approved_as eq '0.5'>
                                                               Approve As Half Leave 
                                                            <cfelse>
                                                                Rejected
                                                            </cfif>
                                                        </p>
                                                    </cfloop>
                                                    <p style="text-align: justify; text-justify: inter-word; font-weight: bolder; text-align: center;">Remarks</p>
                                                    <p style="text-align: justify; text-justify: inter-word;">#action_remarks#</p>
                                                </div>
                                            </div>
                                        </div>
                                    <cfelse>
                                        #action#
                                    </cfif>
                                </td>
                                <td>#action_by#</td>
                            <tr>
                            <!--- <cfif action eq 'rejected'>
                                <tr class = "table-danger">
                                    <td><strong>Rejected Remarks</strong></td>
                                    <td colspan = "8" class = "text-danger">#action_remarks#</td>
                                </tr>
                            </cfif> --->
                        </cfloop>
                </table>
            </div>
            <!---        Pageination code start      --->
            <div class="d-flex justify-content-end">
                <cfif structKeyExists(url, "pageNum")>
                    <cfif "#url.pageNum#" lte looperCount>
                        <cfif "#url.pageNum#" gt 1>
                            <a href="?pageNum=#url.pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                        <cfif "#url.pageNum#" lt looperCount>
                            <a href="?pageNum=#url.pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #url.pageNum# of #looperCount#</span>
                    </cfif>
                <cfelse>
                    <cfset pageNum = 1>
                    <cfif "#pageNum#" lt looperCount>
                        <cfif "#pageNum#" gt 1>
                            <a href="?pageNum=#pageNum-1#" class = "btn btn-outline-dark create_button mb-3 custom_button mr-2">Prev</a>
                        </cfif>
                        <cfif "#pageNum#" lte looperCount>
                            <a href="?pageNum=#pageNum+1#" class = "btn btn-outline-dark create_button mb-3 custom_button ml-2">Next</a>
                        </cfif>
                        <span class="m-2">page #pageNum# of #looperCount#</span>
                    </cfif>
                </cfif>
            </div>
            <!---      Pagination End        --->
        <cfelse>
            <p> No Leave Requests! You Have Not Any Request For Leave.</p>
        </cfif>
    </cfoutput>
 