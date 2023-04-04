<cfinclude  template="\includes\head.cfm">
    <!---    Back End     --->
    <cfif structKeyExists(url, 'detail')>
        <cfquery name="survey_details">
            select a.survey_id, a.employee_id , concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
            from emp_survey_review a, employee emp 
            where survey_id = <cfqueryparam value="#url.detail#">
            and a.employee_id = emp.employee_id
        </cfquery>
        <!--- <cfdump  var="#survey_details#"> --->
    </cfif>
    <cfoutput>
    <!---   Front End     --->
        <div class="text-center">
            <h3 class="box_heading mb-5">Survey Details</h3>
        </div>
        <div style="overflow-x: auto;">
            <table class="table custom_table">
                <tr>
                    <th>Survey Id</th>
                    <th>Employee No</th>
                    <th>Employee Name</th>
                    <th>Action</th>
                </tr>
                <cfloop query="survey_details">
                    <tr>
                        <td>#survey_id#</td>
                        <td>#employee_id#</td>
                        <td>#Name#</td>
                        <td>
                            <a href="emp_answer_details.cfm?survey=#survey_id#&emp_id=#employee_id#">
                                <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-journal-medical" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M8 4a.5.5 0 0 1 .5.5v.634l.549-.317a.5.5 0 1 1 .5.866L9 6l.549.317a.5.5 0 1 1-.5.866L8.5 6.866V7.5a.5.5 0 0 1-1 0v-.634l-.549.317a.5.5 0 1 1-.5-.866L7 6l-.549-.317a.5.5 0 0 1 .5-.866l.549.317V4.5A.5.5 0 0 1 8 4zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/>
                                    <path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
                                    <path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
                                </svg>
                            </a>
                        </td>
                    </tr>
                </cfloop>
            </table>
        </div>
    </cfoutput>
<cfinclude  template="\includes\foot.cfm">