<cfinclude  template="..\includes\head.cfm">
    <cfoutput>
        <div class = "container">
            <form action = "loan_apply.cfm">
                <div class = "row">
                    <div class = "col-md-4">
                        <label for = "loan_amount">How Much Amount Do You Want?</label>
                        <input min = "0" maxlength="6" type = "number" name = "loan_amount" id = "loan_amount" class = "form-control"> 
                    </div>
                </div>
                <div class = "row">
                    <label for = "apply_description"> Why Need Loan? Please Describe.</label>
                    <textarea name = "apply_description" id = "apply_description" cols = "100" rows = "15" placeholder = "Describe in maximum 200 words"></textarea>
                </div>
                <input type = "submit" class = "btn btn-outline-dark"
            </form>
        </div>
    </cfoutput>
<cfinclude  template="..\includes\foot.cfm">