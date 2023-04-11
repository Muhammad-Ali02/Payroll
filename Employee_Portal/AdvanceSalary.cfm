 
    <cfif structKeyExists(form, 'Applied_amount')>
        <cfquery name = "get_Advance">
            select action, status
            from advance_salary
            where employee_id = "#session.loggedin.username#" order by Advance_id desc limit 1
        </cfquery>
        <cfif get_Advance.action eq 'pending'>
            <cflocation  url="AdvanceSalary_request.cfm?request_generated=false">
        <cfelseif (get_Advance.action eq 'approved' or get_Advance.action eq 'partial approved') and get_Advance.status eq 'Y'>
            <cflocation  url="AdvanceSalary_request.cfm?already_taken=true">
        </cfif>
        <cfif '#form.Terms1#' eq '1'>
            <cfquery name = "insert_Advance">
                insert into advance_salary 
                (employee_id, applied_amount, apply_description, Apply_date, apply_by, Status, term_condition, InstallmentAmount)
                values('#session.loggedin.username#', '#form.Applied_amount#', '#form.apply_description#', now(), '#session.loggedin.username#', 'N', 'Agreed', '#form.Applied_amount#')
            </cfquery>
            <cflocation  url="AdvanceSalary_request.cfm?request_generated=true">
        <cfelse>
            <cfquery name = "insert_Advance">
                insert into advance_salary 
                (employee_id, applied_amount, apply_description, Apply_date, apply_by, Status, term_condition, InstallmentAmount)
                values('#session.loggedin.username#', '#form.Applied_amount#', '#form.apply_description#', now(), '#session.loggedin.username#', 'N', 'Agreed', '#form.return_Amount#')
            </cfquery>
            <cflocation  url="AdvanceSalary_request.cfm?request_generated=true">
        </cfif>
    </cfif>
    <cfoutput>
            <form name="AdvanceSalaryForm" onsubmit="return formValidate();" action = "" method = "post">
                <div class="employee_box">
                    <div class = "row">
                        <div class = "col-md-4">
                            <label for = "Applied_amount"> How Much Amount Do You Want?</label>
                            <input min = "0" maxlength="6" required = "true" type = "number" name = "Applied_amount" id = "Applied_amount" class = "form-control"> 
                        </div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-md-12">
                            <label for = "apply_description"> Why Need Advance? Please Describe.</label>
                            <textarea class = "form-control" required = "true" name = "apply_description" id = "apply_description" cols = "100" rows = "10" placeholder = "Describe in maximum 200 words"></textarea>
                        </div>
                    </div>
                    <div class="row mt-2">
                        <span style="color: rgb(255, 255, 255, 0.7);">I agree to repay this Advance as follows (select one)</span>
                    </div>
                    <div class="row ml-2">
                        <div class="form-check mt-1">
                            <input type="radio" onchange="document.getElementById('payment').style.display='none';" class="form-check-input p-2" name="Terms1" id="Term1" value="1" checked>
                            <label for="Term1" class="form-check-label pl-1 text-justify" style="color: rgb(255, 255, 255, 0.7);">One lump-some payroll deduction to be made from my salary on the next first pay period immediately following the pay period from which this advance is made.</label>
                        </div>
                        <div class="form-check mt-1">
                            <input type="radio" onchange="document.getElementById('payment').style.display='inline';" class="form-check-input p-2" name="Terms1" id="Term2" value="2" >
                            <label for="Term2" class="form-check-label pl-1 text-justify" style="color: rgb(255, 255, 255, 0.7);">By equal deduction from the next Rs._____________ Paychecks immediately following the pay period from which this advance is made. </label>
                        </div>
                    </div>
                    <div class="row" style="display: none;" id="payment">
                        <div class="col-md-6">
                            <label for="return_Amount">Enter recurring deduction amount from next paycheck:</label>
                            <input type="number" class="form-control" name="return_Amount" id="return_Amount" min="0" maxlength="6" >
                        </div>
                    </div>
                    <div class="row">
                        <span class="mt-3">Term & Condition(please check the square to proceeding further)</span>
                        <div class="form-check ml-4 mt-1">
                            <input type = "checkbox" onchange="if(document.getElementById('Term_Condition').checked == true){document.getElementById('submitbutton').style.display='inline';}else{document.getElementById('submitbutton').style.display='none';}" class="form-check-input" style="border-radius: 0;" id="Term_Condition" name = "Term_Condition" required> 
                            <label  for="Term_Condition" class="form-check-label text-justify mr-3">I also agree that if I trminate/resignation employment prior to total repayment of this advance, I authorize the company to deduct any unpaid amount from the salary owed me at the time of termination/resignation of employment.</label>
                        </div>
                    </div>
                    <div style="display: none;" id="submitbutton">
                        <div class="text-right">
                            <input type = "submit" class = "btn btn-outline-dark mt-3" >
                        </div>
                    </div>
                </div>
            </form>
    </cfoutput>
    <script>
        function formValidate(){
                    var Applied_amount = document.forms["AdvanceSalaryForm"]["Applied_amount"].value;
                    var apply_description = document.forms["AdvanceSalaryForm"]["apply_description"].value;
                    var Terms1 = document.forms["AdvanceSalaryForm"]["Terms1"].value;
                    var return_Amount = document.forms["AdvanceSalaryForm"]["return_Amount"].value;
                    var Term_Condition = document.forms["AdvanceSalaryForm"]["Term_Condition"].value;
                    if(Terms1 == "2"){
                        if((Applied_amount == "")||(apply_description = "")||(return_Amount == "")||(Term_Condition == "")){
                            alert("All field must be filled out!");
                            return false;
                        }else if(parseInt(Applied_amount) < parseInt(return_Amount)){
                            alert("Installment Amount can't be Greater then Applied Amount!");
                            return false;
                        } 
                    }else if(Terms1 == "1"){
                     if((Applied_amount == "")||(apply_description = "")||(Term_Condition == "")){
                        alert("All field must be filled out!");
                         return false;
                        }
                    }
                }
    </script>
 