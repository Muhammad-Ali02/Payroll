<cfoutput>
    <cfinclude  template="\includes\bootstrap.cfm">
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
                <!---   encrypt the user password that coming to the form    --->
                <cfquery name="get_uuid">
                    select * from uuid_table
                    where user_name = "#form.txt_user_name#"
                </cfquery>
                <cfif get_uuid.recordcount gt 0>
                    <cfset salt = "#get_uuid.uuid#">
                    <cfset password = "#form.user_password#">
                    <cfset hashed_Password = hash(password & salt, "SHA-256")>
<!---                     <cfdump  var="#get_employee.password#"> <br> --->
<!---                     <cfdump  var="#hashed_Password#"><cfabort> --->
                </cfif>

                <cfif (hashed_Password eq showError.password) or (isDefined("get_employee.password")  and (hashed_Password eq get_employee.password))> 
                    <cfif structKeyExists(form, 'login')>
                        <cfif user_level eq 'employee'>
                            <cfif structKeyExists(get_employee, 'user_name') and ((get_employee.ip_address eq current_ipAddress) or (get_employee.last_login eq '')) and ((get_employee.machine_name eq machine_name) or (get_employee.machine_name eq ''))>
                                <cfset user_authentication = createObject("component", '\components.user_authentication')>
                                <!--- login processing --->

                                <cfset isUserlogin = user_authentication.user_login(form.txt_user_name, hashed_Password, user_level, current_ipAddress, machine_name )>
                                <cfif structKeyExists(session, 'loggedIn')>
                                    <cflocation  url="\index.cfm">
                                </cfif>
                            <cfelse>
                                <!--- get current ip addres and store in database in case of failure to login--->
                                <cfquery name = 'insert_ip_address'>
                                    insert into ip_address_audit (user_name, password, last_login, level, attempt_time, current_ip_address, current_machine_name)
                                    values ('#form.txt_user_name#','#form.user_password#', '#get_employee.last_login#', '#user_level#', now(), '#current_ipAddress#', '#machine_name#')
                                </cfquery>
                                <script>
                                    alert('You are not allowed to Login, Please Contact HR');
                                </script>
                            </cfif>
                        <cfelse> <!--- if user is admin then the else part will be executed --->
                            <cfset user_authentication = createObject("component", '\components.user_authentication')>
                                <!--- login processing --->
                                <cfset isUserlogin = user_authentication.user_login(form.txt_user_name, hashed_Password, user_level )>
                                <cfif structKeyExists(session, 'loggedIn')>
                                    <cflocation  url="\index.cfm">
                                </cfif>
                        </cfif>
                    </cfif>
                <cfelse>
                    <script>
                        alert('Incorrect User name or Password');
                    </script>
                </cfif>
            </cfif>
            <div id = "backgroundPic" class = "backgroundPic"> 
                <div class = "over_background p-5">   
                    <div class="login_box">
                        <div class = "row">
                            <div class = "heading_div">
<!---                                  <img class = "bjs_logo" src = "..\img\logo.png">  --->
                                <div>
                                    <h1 class = "login_heading">BJS</h1> 
                                    <h1 class = "login_heading2">Soft Solution</h1>
                                    <h2 class = "login_heading3">Secure Solution Providers</h2>
                                </div>
                            </div>
                            <div class = "pt-5 px-5 pb-2">
                                <form action = "user_login.cfm" method = "post">
                                    <input class = "form-control custom_input"type = "text" name="txt_user_name" required = "true" placeholder = "Enter Your Login User Name "><br>
                                    <input class = "form-control custom_input" type = "password" name = "user_password" required = "true" placeholder = "Enter Your Login Password "> <br>
                                    <input class = "btn btn-outline-secondary custom_button" type = "submit" name="login" value = "login">
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <cfelse>
            <cflocation  url="\index.cfm">
        </cfif>
</cfoutput>
