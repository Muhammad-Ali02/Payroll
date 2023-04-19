 
<cfoutput>
    <cfif structKeyExists(url, 'request_generated')>
        <cfif url.request_generated eq 'true'>
            <script>
                alert("Your Request For Advance Salary Has Been Generated.");
            </script>
        <cfelseif url.request_generated eq 'false'>
            <script>
                alert("Can't Generate Advance Salary Request! You Have Already Generated a Request.");
            </script>
        </cfif>
    </cfif>
    <cfif structKeyExists(url, 'already_taken')>
        <cfif url.already_taken eq 'true'>
            <script>
                alert("Already Taken! You Can't Apply For Advance Salary.");
            </script>  
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
                <th>Advance ID</th>
                <th>Applied Amount</th>
                <th>Installment Amount</th>
                <th>Approved Amount</th>
                <th>Apply Date</th>
                <th>Status</th>
                <th>Action By</th>
            </thead>
            <cfloop query = "get_requests">
                <cfset No = No + 1>
                <tr>
                    <td>#No#</td>
                    <td>#Advance_Id#</td>
                    <td>#Applied_Amount#</td>
                    <td>#installmentAmount#</td>
                    <cfif Total_Amount eq ''>
                        <td> none </td>
                    <cfelse>
                        <td>#Total_Amount#</td>
                    </cfif>
                    <td>#dateFormat(Apply_Date,'dd-mmm-yyyy')#</td>
                    <td <cfif action eq 'rejected'> class = "text-danger" <cfelseif action eq 'approved'> class = "text-success" <cfelseif action eq 'partial approved'> style="color: rgb(242, 162, 24);"</cfif>>
                        <cfif action eq 'rejected' or action eq 'partial approved'>
                            <div class="hover-popup">
                                <span class="trigger">#Action#</span>
                                <div class="content ">
                                    <div class="mt-1" style="color: rgb(255, 255, 255); font-size: 12px;">
                                       <p style="text-align: justify; text-justify: inter-word;">#action_remarks#</p>
                                    </div>
                                </div>
                            </div>
                        <cfelse>
                            #Action#
                        </cfif>
                    </td>
                    <cfif action_by eq ''>
                        <td> none </td>
                    <cfelse>
                        <td>#Action_By#</td>
                    </cfif>
                </tr>
            </cfloop>
        </table>
    <cfelse>
        <p>No Advance Salary Requests! You Have Not Any Request For Advance Salary.</p>
    </cfif>
</cfoutput>
 