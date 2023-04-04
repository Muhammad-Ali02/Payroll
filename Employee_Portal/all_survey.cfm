<cfinclude  template="\includes\head.cfm">
    <!---    Back End    --->
        <cfquery name='get_survey'>
            select * from survey
            where status = 'open'
        </cfquery>
    <cfoutput>
    <!---    Front End   --->
        <div class="text-center">
            <h3 class="box_heading mb-5">Total Survey</h3>
        </div>
        <div style="overflow-x: auto;">
            <table class="table custom_table">
                <tr>
                    <th>Survey No.</th>
                    <th>Title</th>
                    <th>Action</th>
                </tr>
                <cfloop query="get_survey">
                    <tr>
                        <td>#id#</td>
                        <td>#title#</td>
                        <td>
                            <cfquery name='is_submitted'>
                                select * from emp_survey_review
                                where survey_id = <cfqueryparam value="#id#">
                                And employee_id = <cfqueryparam value = "#session.loggedin.username#">
                                And is_submitted = <cfqueryparam value= 'Y'> 
                            </cfquery>
                            <cfif is_submitted.RecordCount eq 0>
                                <a href="survey_review.cfm?view=#id#">
                                   <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                                        <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                                        <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                                    </svg> 
                                </a>
                            <cfelse>
                                <div class="text-success">Submitted</div>  
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
            </table>
        </div>
    </cfoutput>
<cfinclude  template="\includes\foot.cfm">