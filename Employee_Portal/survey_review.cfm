 
        <!---     Back End          --->
    <cfif structKeyExists(url, 'view')>
        <cfif structKeyExists(form, 'question1')>
            <cfquery name="insert_emp_response">
                insert into emp_survey_review(
                    survey_id,
                    employee_id
                    <cfloop from='1' to='10' index="index">
                        <cfif isDefined("form.question#index#")>
                            ,question#index#
                        </cfif>
                    </cfloop>
                    ,is_submitted
                )
                values(
                    <cfqueryparam value="#form.survey_id#">,
                    <cfqueryparam value="#session.loggedin.username#">
                    <cfloop from='1' to='10' index="index">
                        <cfif isDefined("form.question#index#")>
                            ,<cfqueryparam value="#evaluate("form.question#index#")#">
                        </cfif>
                    </cfloop>
                    ,<cfqueryparam value="Y">
                )
            </cfquery>
            <script>
                alert('Your Response Have Been Submitted Successfully!');
                window.location.replace('all_survey.cfm');
            </script>
        </cfif>
        <cfquery name="get_survey">
            select * from survey 
            where id = <cfqueryparam value="#url.view#"> And status = 'open'
        </cfquery>
    <!---         <cfdump  var="#get_survey#"> --->
        <cfoutput>
            <!---     front end     --->
            <cfif get_survey.recordcount neq 0>
                <div class="employee_box">
                    <div class="text-center">
                        <h3 class="box_heading mb-5">#get_survey.title#</h3>
                    </div>
                    <div>
                        <h6>Description</h6>
                        <p>#get_survey.description#</p>
                    </div>
                    <div>
                        <form action="" name="emp_survey_review" onsubmit="return formvalidate();" method="post">
                        <cfloop from='1' to='10' index="index">
                            <cfif evaluate("get_survey.question#index#") neq ''>
                                <label for="question#index#">#evaluate("get_survey.question#index#")#</label>
                                <input class="form-control mb-3" type="text" name='question#index#' id='question#index#' required>
                            </cfif>
                        </cfloop>
                        <div class="text-right">
                            <input type="hidden" name='survey_id' value="#url.view#">
                            <input type="submit" class="btn btn-outline-dark custom_button">
                        </div>
                        </form>
                    </div>
                </div>
            <cfelse>
                <div class="text-center">Oops! Noting Found.</div>
            </cfif>
            <script>
                function formvalidate(){
                    <cfloop from='1' to='10' index="index">
                        <cfif evaluate("get_survey.question#index#") neq ''>
                            var question#index# =  $('##question#index#').val();
                            if(question#index# == ''){
                                alert('All Fields Must Be Filled Out!')
                                return false;
                            }
                        </cfif>
                    </cfloop>
                    return true;
                }
            </script>
        </cfoutput>
    </cfif>
 