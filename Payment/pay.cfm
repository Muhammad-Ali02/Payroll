<cfinclude  template="..\includes\head.cfm">
<cfoutput>
    <cfif structKeyExists(session, 'loggedIn')>
        <div class="employee_box">
            <div class="text-center">
                <h3 class="mb-5 box_heading">Pay Process</h3>
            </div>
            <div style = "display: flex; justify-content:center; gap: 16px; flex-wrap: wrap; ">   
                <a href = "process_detail.cfm"> <button type = "button" class = "btn btn-outline-dark custom_button"> Add/Update Process </button> </a>
                <a href = "pay_process.cfm"> <button type = "button" class = "btn btn-outline-dark custom_button"> Run Pay Process </button> </a>
                <a href = "pay_slip.cfm"><button type = "button" class = "btn btn-outline-dark custom_button"> Print Salary Slip </button>
            </div>
        </div>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">
