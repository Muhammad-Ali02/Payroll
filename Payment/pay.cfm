<cfinclude  template="..\includes\head.cfm">
<cfoutput>
    <cfif structKeyExists(session, 'loggedIn')>
        <div class = "container" style = "text-align:center">   
            <a href = "process_detail.cfm"> <button type = "button" class = "btn btn-outline-dark"> Add/Update Process </button> </a>
            <a href = "pay_process.cfm"> <button type = "button" class = "btn btn-outline-dark"> Run Pay Process </button> </a>
            <a href = "pay_slip.cfm"><button type = "button" class = "btn btn-outline-dark"> Print Salary Slip </button>
        </div>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">
