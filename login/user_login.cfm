<cfoutput>
    <cfinclude  template="..\includes\bootstrap.cfm">
    <cfif structKeyExists(URL, 'logout')>
        <cfset createObject("component", '\components.user_authentication').user_logout() />
        <cflocation  url="user_login.cfm">
    </cfif>
    <cfif not structKeyExists(session, 'loggedIn')>
        <cfif isDefined('form.txt_user_name')>
            <cfquery name = "showError" >
                select * 
                from users
                where user_name = '#form.txt_user_name#'
            </cfquery>
            <cfif #form.user_password# eq #showError.password#> 
                <cfif structKeyExists(form, 'login')>
                    <cfset user_authentication = createObject("component", '\components.user_authentication')>
                    <!--- login processing --->
                    <cfset isUserlogin = user_authentication.user_login(form.txt_user_name, form.user_password)>
                    <cfif structKeyExists(session, 'loggedIn')>
                            <cflocation  url="..\index.cfm">
                    </cfif>
                </cfif>
            <cfelse>
                <h1 class = "text-light bg-danger "> Incorrect User name or Password </h1>
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
