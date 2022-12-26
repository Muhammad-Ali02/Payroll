<cfinclude  template="head.cfm">
<cfoutput>
    <cfif structKeyExists(session, 'loggedIn')>
        <a href = "process_detail.cfm"> <button type = "button"> Add/Update Process </button> </a>
        <a href = "pay_process.cfm"> <button type = "button"> Run Pay Process </button> </a>
        <a href = "pay_slip.cfm"><button type = "button"> Print Salary Slip </button>
    </cfif>
</cfoutput>
<cfinclude  template="foot.cfm">
