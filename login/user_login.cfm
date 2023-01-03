<cfoutput>
    <cfinclude  template="..\includes\bootstrap.cfm">
    <cfif structKeyExists(URL, 'logout')>
        <cfset createObject("component", '\components.user_authentication').user_logout() />
        <cflocation  url="user_login.cfm">
    </cfif>
    <cfif not structKeyExists(session, 'loggedIn')>
        <cfif isDefined('form.txt_user_name') and isDefined('form.user_password')>
            <!--- code for admin user --->
            <cfquery name = "showError" >
                select * 
                from users
                where user_name = '#form.txt_user_name#'
            </cfquery>
            <cfset user_level = showError.level>
            <cfif showError.recordcount eq 0>
                <!--- code for employee user --->
                <cfquery name = "get_employee">
                    select * 
                    from emp_users
                    where user_name = "#form.txt_user_name#" 
                </cfquery>
                <cfset user_level = get_employee.level>
            </cfif>
            <cfif form.user_password eq showError.password or form.user_password eq get_employee.password> 
                <cfif structKeyExists(form, 'login')>
                    <cfset user_authentication = createObject("component", '\components.user_authentication')>
                    <!--- login processing --->
                    <cfset isUserlogin = user_authentication.user_login(form.txt_user_name, form.user_password, user_level )>
                    <cfif structKeyExists(session, 'loggedIn')>
                        <cflocation  url="..\index.cfm">
                    </cfif>
                </cfif>
            <cfelse>
                <p class = "text-light bg-danger" style = "text-align:center; font-weight:bold;"> Incorrect User name or Password </p>
            </cfif>
        </cfif>
        <div id = "backgroundpic" >    
            <div class="container">
                <div class = "row p-5">
                    <div class = "col-md-8 p-5">
                        
                    </div>
                    <div class = "col-md-4 mt-100 bg-danger p-5">    
                        <form action = "user_login.cfm" method = "post">
                            <input class = "form-control"type = "text" name="txt_user_name" required = "true" placeholder = "Enter Your Login User Name "><br>
                            <input class = "form-control" type = "password" name = "user_password" required = "true" placeholder = "Enter Your Login Password "> <br>
                            <input class = "btn btn-success" type = "submit" name="login" value = "login">
                        </form>
                    <div>
                </div>
            </div>
        </div>
    <cfelse>
        <cflocation  url="..\index.cfm">
    </cfif>
</cfoutput>
