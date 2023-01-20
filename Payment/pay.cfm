<cfinclude  template="..\includes\head.cfm">
<cfoutput>
    <cfif structKeyExists(session, 'loggedIn')>
        <div class = "container" style = "text-align:center">   
            <a href = "process_detail.cfm"> <button type = "button" class = "btn btn-outline-dark custom_button"> Add/Update Process </button> </a>
            <a href = "pay_process.cfm"> <button type = "button" class = "btn btn-outline-dark custom_button"> Run Pay Process </button> </a>
            <a href = "pay_slip.cfm"><button type = "button" class = "btn btn-outline-dark custom_button"> Print Salary Slip </button>
        </div>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">
