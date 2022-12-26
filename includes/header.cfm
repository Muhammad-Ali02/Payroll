<cfoutput>
<cfinclude  template="bootstrap.cfm">
<style>
    .cls_btn{
        width: 182px;    
    }
    .inpt{
        width: 100%;
    }
    .inpt:hover{
        background-color: rgba(156, 159, 162, 0.55);
    }
    /*
    body{
        background-color: rgba(203, 217, 235, 0.55);
        font-weight : bold;
        color: rgba(85, 85, 89, 0.99);
    } */
    .nav-link{
        color: rgba(85, 85, 89, 0.99);
    }
</style>
<div Class = "container">
    <div class = "row bg-info">
            <center><h2 class = "text-light" style = "height: 60px;"> Payroll </h2></center>
    </div>
    <div class = "container" style = "text-align: center;">
        <cfif structKeyExists(session, 'loggedIn')>
        <a href = "index.cfm" style = "color: red;"> Home </a>
        <a href="user_login.cfm?logout" style = "margin: 10px;"> Logout </a>
        <cfelse>
        <p style = "text-align : center; color : red; font-weight : bold;"> *Please Login First </p>
        <a href="user_login.cfm" style = "margin: 10px;"> Login </a>
        </cfif>
    </div>
</div>
</cfoutput>