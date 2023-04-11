 
    <cfoutput>
        <!---     Back end    --->
        <cfif structKeyExists(url, "edit")>
            <cfquery name="update_status">
                update survey
                set status = <cfqueryparam value="closed">
                where id = <cfqueryparam value="#url.edit#">
            </cfquery>
        </cfif>
        <cfquery name='total_Survey'>
            select * from survey;
        </cfquery>
        <!---    Front End   --->
        <div class="text-center">
            <h3 class="box_heading mb-5">Survey View</h3>
        </div>
    <!-- <div class="employee_box">
    </div> -->
    <div class="text-left ml-2 mb-3">
        <a href="create_survey.cfm" class="btn btn-outline-dark custom_button">Create Survey</a>
    </div>
    <div style="overflow-x: auto; padding: 10px;">
        <table class="table custom_table">
            <tr>
                <th> Survey No.</th>
                <th> Title </th>
                <th> Total Responces </th>
                <th> Status </th>
                <th style = "text-align:center"> Action </th>
            </tr>
            <cfloop query="total_Survey">
                <tr>
                    <td>
                        #id#
                    </td>
                    <td>#title#</td>
                    <td>
                        <cfquery name='total_response'>
                            select count(*) as total 
                            from emp_survey_review
                            where survey_id = <cfqueryparam value="#id#">
                        </cfquery>
                        #total_response.total#
                    </td>
                    <td <cfif status eq 'open'> class="text-success"<cfelse>style="color: rgb(242, 162, 24);"</cfif>>#uCase(Status)#</td>
                    <td class="text-center">
                        <cfif status eq 'open'>
                            <a title="Close Survey" onclick="return confirmation();" href="?edit=#id#">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-x-square" viewBox="0 0 16 16">
                                    <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
                                    <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                </svg>
                            </a>
                            <a title="View Details" class="ml-2" href="survey_details.cfm?detail=#id#">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-journal-medical" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M8 4a.5.5 0 0 1 .5.5v.634l.549-.317a.5.5 0 1 1 .5.866L9 6l.549.317a.5.5 0 1 1-.5.866L8.5 6.866V7.5a.5.5 0 0 1-1 0v-.634l-.549.317a.5.5 0 1 1-.5-.866L7 6l-.549-.317a.5.5 0 0 1 .5-.866l.549.317V4.5A.5.5 0 0 1 8 4zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/>
                                    <path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
                                    <path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
                                </svg>
                            </a>
                        <cfelse>
                            <a title="View Details" href="survey_details.cfm?detail=#id#">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-journal-medical" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M8 4a.5.5 0 0 1 .5.5v.634l.549-.317a.5.5 0 1 1 .5.866L9 6l.549.317a.5.5 0 1 1-.5.866L8.5 6.866V7.5a.5.5 0 0 1-1 0v-.634l-.549.317a.5.5 0 1 1-.5-.866L7 6l-.549-.317a.5.5 0 0 1 .5-.866l.549.317V4.5A.5.5 0 0 1 8 4zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5z"/>
                                    <path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
                                    <path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
                                </svg>
                            </a>
                        </cfif>
                    </td>
                </tr>
            </cfloop>
        </table>
    </div>
    </cfoutput>
    <script>
        function confirmation(){
            var con= confirm("Are you sure to close the survey?");
            if(con == true){
                return true;
            }else{
                return false;
            }
        }
    </script>
 