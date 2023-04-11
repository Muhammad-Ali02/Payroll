 
        <!---      Back End       --->
        <cfif structKeyExists(url, 'emp_id')>
            <cfquery name="get_answer_detail">
                select a.* , concat(emp.first_name,' ',emp.middle_name,' ',emp.last_name) as name
                from emp_survey_review a, employee emp
                where a.survey_id=<cfqueryparam value="#url.survey#"> 
                And a.employee_id = <cfqueryparam value="#url.emp_id#">
                And emp.employee_id=<cfqueryparam value="#url.emp_id#">
            </cfquery>
            <cfquery name="get_survey">
                select * from survey
                where id =<cfqueryparam value="#url.survey#">
            </cfquery> 
        </cfif>
    <cfoutput>
        <!---       Front End      --->
        <div class="employee_box">
            <div class="text-center">
                <h3 class="box_heading mb-5">Employee Response Details</h3>
            </div>
            <div style="gap: 16px;" class="d-flex align-items-center justify-content-between flex-wrap mb-4 p-2">
                <div>
                    Name : #get_answer_detail.name#
                </div>
                <div>
                    Survey Title : #get_survey.title#
                </div>
            </div>
            <div style="overflow-x: auto;">
                <table class="table custom_table">
                    <tr>
                        <th>Question</th>
                        <th>Answer</th>
                    </tr>
                    <cfloop from='1' to='10' index="index">
                        <cfif evaluate("get_survey.question#index#") neq ''>
                            <tr>
                                <td>#evaluate("get_survey.question#index#")#</td>
                                <td>#evaluate("get_answer_detail.question#index#")#</td>
                            </tr>
                        </cfif>
                    </cfloop>
                </table>
            </div>
        </div>
    </cfoutput>
 