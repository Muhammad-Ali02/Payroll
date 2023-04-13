 
    <cfif structKeyExists(form, 'Applied_amount')>
        <cfquery name = "get_loans">
            select action, status
            from loan
            where employee_id = "#session.loggedin.username#" order by loan_id desc limit 1
        </cfquery>
        <cfif get_loans.action eq 'pending'>
            <cflocation  url="loan_requests.cfm?request_generated=false">
        <cfelseif (get_loans.action eq 'approved' or get_loans.action eq 'Partial approved') and get_loans.status eq 'Y'>
            <cflocation  url="loan_requests.cfm?already_taken=true">
        </cfif>
        <cfif '#form.Terms1#' eq '1'>
            <cfquery name = "insert_loan">
                insert into loan 
                (employee_id, applied_amount, apply_description, Apply_date, apply_by, Status, term_condition, InstallmentAmount)
                values('#session.loggedin.username#', '#form.Applied_amount#', '#form.apply_description#', now(), '#session.loggedin.username#', 'N', 'Agreed', '#form.Applied_amount#')
            </cfquery>
            <cflocation  url="loan_requests.cfm?request_generated=true">
        <cfelse>
            <cfquery name = "insert_loan">
                insert into loan 
                (employee_id, applied_amount, apply_description, Apply_date, apply_by, Status, term_condition, InstallmentAmount)
                values('#session.loggedin.username#', '#form.Applied_amount#', '#form.apply_description#', now(), '#session.loggedin.username#', 'N', 'Agreed', '#form.return_Amount#')
            </cfquery>
            <cflocation  url="loan_requests.cfm?request_generated=true">
        </cfif>
    </cfif>
    <cfoutput>
            <form name="loanForm" id="loanform" onsubmit="return formValidate();" action="" method="post">
                <div class="employee_box">
                    <div class = "row">
                        <div class = "col-md-4">
                            <label for = "Applied_amount"> How Much Amount Do You Want?</label>
                            <input min = "0" maxlength="6" required = "true" type = "number" name = "Applied_amount" id = "Applied_amount" class = "form-control" > 
                        </div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-md-12">
                            <label for = "apply_description"> Why Need Loan? Please Describe.</label>
                            <textarea class = "form-control" required = "true" name = "apply_description" id = "apply_description" cols = "100" rows = "10" placeholder = "Describe in maximum 200 words"></textarea>
                        </div>
                    </div>
                    <div class="row mt-2">
                        <span style="color: rgb(255, 255, 255, 0.7);">I agree to repay this loan as follows (select one)</span>
                    </div>
                    <div class="row ml-2">
                        <div class="form-check mt-1">
                            <input type="radio" onchange="document.getElementById('payment').style.display='none';" class="form-check-input p-2" name="Terms1" id="Term1" value="1" checked>
                            <label for="Term1" class="form-check-label pl-1 text-justify" style="color: rgb(255, 255, 255, 0.7);">One lump-some payroll deduction to be made from my salary on the next first pay period immediately following the pay period from which this advance is made.</label>
                        </div>
                        <div class="form-check mt-1">
                            <input type="radio" onchange="document.getElementById('payment').style.display='inline';" class="form-check-input p-2" name="Terms1" id="Term2" value="2">
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
                        <span class="mt-3">Term & Condition(please check the round to proceeding further)</span>
                        <div class="form-check ml-4 mt-1">
                            <input type = "checkbox" onchange="if(document.getElementById('TermCondition').checked == true){document.getElementById('submitbutton').style.display='inline';}else{document.getElementById('submitbutton').style.display='none';}" class="form-check-input" style="border-radius: 0;" id="TermCondition" name = "TermCondition" required> 
                            <label  for="TermCondition" class="form-check-label text-justify mr-3">I also agree that if I terminate/resignation employment prior to total repayment of this loan, I authorize the company to deduct any unpaid amount from the salary owed me at the time of termination/resignation of employment.</label>
                        </div>
                    </div>
                    <div style="display: none;" id="submitbutton">
                        <div class="text-right">
                            <input type = "submit" class = "btn btn-outline-dark mt-3">
                        </div>
                    </div>
                </div>
            </form>
    </cfoutput>
    <script>
        function formValidate(){
            var Applied_amount = $('#Applied_amount').val();
            var Apply_description = $('#apply_description').val();
            var Terms2 =$("input[name=Terms1]:checked").val();
            var return_Amount =$('#return_Amount').val();
            var TermCondition =$('#TermCondition').val();
            if(Terms2 == "2"){
                if((Applied_amount == "")||(Apply_description == "")||(return_Amount == "")||(TermCondition == "")){
                    alert("All field must be filled out!");
                    return false;
                }else if(parseInt(Applied_amount) < parseInt(return_Amount)){
                    alert("Installment Amount can't be Greater then Applied Amount!");
                    return false;
                }else if(Apply_description.length > "900"){
                    alert("Text is too much long in describe reason box.");
                    $('#apply_description').focus();
                    return false;
                }else{
                    return true;
                }
            }else{
                if((Applied_amount == "")||(Apply_description == "")||(Terms2 == "")||(TermCondition == "")){
                    alert("All field must be filled out!");
                    return false;
                }else if(Apply_description.length > "900"){
                    alert("Text is too much long in describe reason box.");
                    $('#apply_description').focus();
                    return false;
                }else{
                    return true;
                }
            }
        }
    </script>
 