<cfoutput>
    <form action = "loan_apply.cfm">
        <label for = "loan_amount">Required Amount</label>
        <input name = "loan_amount" id = "loan_amount" > 
        <br>
        <label for = "apply_description"> Why Need Loan? Describe.</label>
        <br>
        <textarea name = "apply_description" id = "apply_description" cols = "80" rows = "30"></textarea>
    </form>
</cfoutput>