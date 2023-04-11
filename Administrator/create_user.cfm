<cfoutput>
 
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- |________________________________\|/_Back End _\|/________________________________|--->
        <cfparam  name = "merror" default = 0>
        <cfquery name = "get_employees"> <!--- to print All employees list --->
            select concat(employee_id,' | ',first_name,' ', middle_name, ' ', last_name) as name , employee_id
            from employee
        </cfquery>
        <cfif structKeyExists(url, 'edit')>
            <cfquery  name = "get_data"> <!--- result of query will be shown in inputs when want to update --->
                select * from users where id = "#url.edit#"
            </cfquery>
        <cfelseif structKeyExists(form, 'create')> <!--- show error when duplicate deparment name --->
            <cfquery name = "check">
                select user_name as name from users
                where user_name = '#form.user_name#'
            </cfquery>
            <cfif check.name eq form.user_name>
                <script>
                    alert("User Name Already Exists!");
                </script>
                <cfset merror = 1>
            <cfelse>
            <!--- Generate hashed password --->
            <!---    Insert uuid in uuid table accross the user name     --->
                <cfquery name="insert_uuid">
                    insert into uuid_table (uuid , user_name)
                    values (<cfqueryparam value="#CreateUUID()#">, <cfqueryparam value="#form.user_name#">)
                </cfquery>
            <!---      Get uuid of newly created user from uuid table and then hash the password and insert into user table  --->
                <cfquery name="get_uuid">
                    select * from uuid_table
                    where user_name = "#form.user_name#"
                </cfquery>
                <cfset salt = "#get_uuid.uuid#">
                <cfset password = "#form.user_password#">
                <cfset hashed_Password = hash(password & salt, "SHA-256")>
                <!--- Insert query  --->
                <cfquery name = "insert_user">
                    insert into users (user_name, password, level)
                    values (
                        <cfqueryparam value = '#form.user_name#'>, 
                        <cfqueryparam value = '#hashed_Password#'>, 
                        <cfqueryparam value = '#form.user_level#'>)
                </cfquery>
                <cflocation  url="all_users.cfm?created=true">
            </cfif>
        <cfelseif structKeyExists(form, 'update')>

            <!--- Generate hashed password --->
                <cfquery name="get_uuid">
                    select * from uuid_table
                    where user_name = "#form.user_name#"
                </cfquery>
                <cfset salt = "#get_uuid.uuid#">
                <cfset password = "#form.user_password#">
                <cfset hashed_Password = hash(password & salt, "SHA-256")>
                
            <cfquery name = "update_user">
                update users 
                set user_name = <cfqueryparam value = "#form.user_name#">,
                    password = <cfqueryparam value = "#hashed_Password#">,
                    level = <cfqueryparam value = "#form.user_level#">
                where id = "#form.user_id#"
            </cfquery>
            <cflocation  url="all_users.cfm?updated=true">
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <cfif not structKeyExists(url, 'employee_as_admin') and not structKeyExists(url, 'new_user') >
            <div class = "employee_box">
                <div class = "row">
                    <div class = "col-md-6">
                        <div style = "text-align:center">
                            <p>
                                <svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" fill="currentColor" class="bi bi-person-add" viewBox="0 0 16 16">
                                    <path d="M12.5 16a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Zm.5-5v1h1a.5.5 0 0 1 0 1h-1v1a.5.5 0 0 1-1 0v-1h-1a.5.5 0 0 1 0-1h1v-1a.5.5 0 0 1 1 0Zm-2-6a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM8 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z"/>
                                    <path d="M8.256 14a4.474 4.474 0 0 1-.229-1.004H3c.001-.246.154-.986.832-1.664C4.484 10.68 5.711 10 8 10c.26 0 .507.009.74.025.226-.341.496-.65.804-.918C9.077 9.038 8.564 9 8 9c-5 0-6 3-6 4s1 1 1 1h5.256Z"/>
                                </svg>
                            </p>
                            <a href = "create_user.cfm?new_user=true">
                                <button class = "btn btn-outline-dark custom_button">Create New User</button>
                            </a>
                        </div>
                    </div>
                    <div class = "col-md-6">
                        <div style = "text-align:center">
                            <p>
                                <svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" fill="currentColor" class="bi bi-person-up" viewBox="0 0 16 16">
                                    <path d="M12.5 16a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7Zm.354-5.854 1.5 1.5a.5.5 0 0 1-.708.708L13 11.707V14.5a.5.5 0 0 1-1 0v-2.793l-.646.647a.5.5 0 0 1-.708-.708l1.5-1.5a.5.5 0 0 1 .708 0ZM11 5a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM8 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4Z"/>
                                    <path d="M8.256 14a4.474 4.474 0 0 1-.229-1.004H3c.001-.246.154-.986.832-1.664C4.484 10.68 5.711 10 8 10c.26 0 .507.009.74.025.226-.341.496-.65.804-.918C9.077 9.038 8.564 9 8 9c-5 0-6 3-6 4s1 1 1 1h5.256Z"/>
                                </svg>
                            </p>
                            <a href = "create_user.cfm?employee_as_admin=true">
                                <button class = "btn btn-outline-dark custom_button">Update Employee as Admin</button>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </cfif>
        <cfif structKeyExists(url, 'employee_as_admin') or structKeyExists(url, 'new_user')>
            <div class = "employee_box">
                <div class="text-center">
                    <cfif structKeyExists(url, 'employee_as_admin')>
                        <h3 class="mb-5 box_heading">Update Employee as Admin</h3>
                    <cfelseif structKeyExists(url, 'new_user')>
                        <h3 class="mb-5 box_heading">Create New User</h3>
                    </cfif>
                </div>
                <div class = container>
                    <div class = "row"> 
                        <div class = "col-md-2">
                        </div>
                        <div class = "col-md-8" >
                            <cfif structKeyExists(url, 'employee_as_admin')>
                                <form name="createUser" Action = "create_user.cfm?employee_as_admin=true" onsubmit="return formvalidate();" Method = "post">
                                    <br>
                                    <select class = "form-select" name = "user_name" required="true"> 
                                        <option value=""> -- Select Employee -- </option> 
                                            <cfloop query="get_employees">
                                                <option value = "#employee_id#" <cfif #merror# eq 1 > <cfif structKeyExists(form, 'user_name')> <cfif form.user_name eq employee_id> selected = "true" style = "border-color : red; color : red;"</cfif> </cfif> <cfelseif structKeyExists(url, 'edit')> <cfif "#get_data.user_name#" eq employee_id> selected = "true" <cfelse> Disabled = "true" </cfif> </cfif>> #name# </option>
                                            </cfloop>
                                    </select>
                            <cfelseif structKeyExists(url, 'new_user')>
                                <form name="createUser" Action = "create_user.cfm?new_user=true" onsubmit="return formvalidate();" Method = "post">
                                    <input type = "text" name = "user_name" required = "true" class = "form-control" placeholder = "User Name" <cfif merror eq 1 > <cfif structKeyExists(form, 'user_name')> value = "#form.user_name#" style = "border-color : red; color : red;"</cfif> <cfelseif structKeyExists(url, 'edit')> value = "#get_data.user_name#" </cfif>>
                            </cfif>
                                    <hr>
                                    <input type = "password" name = "user_password" placeholder = "Create Password" class = "form-control" required<cfif #merror# eq 1 > value = "#form.user_password#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.password#"</cfif>>
                                    <hr>
                                    <select class = "form-select" name = "user_level" required="true"> 
                                        <option value=""> --Select Level-- </option>
                                        <option> Admin </option>
                                        <option <cfif #merror# eq 1 ><cfif form.user_level eq 'Employee'> selected = "true"</cfif> </cfif> > Employee </option>
                                    </select>  
                                    <input type = "hidden" name = "user_id" <cfif structKeyExists(url, 'edit')> value = "#get_data.id#" </cfif> >                      
                                    <br>
                                    <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "update" <cfelse> "create" </cfif> > <!--- name "update" will update existing data, name "create" will insert new data --->
                                    <div class="text-center">
                                        <input type = "submit" class = "btn btn-info" <cfif structKeyExists(url, 'edit')> value = "Update User Data" <cfelse> value = "Create User" </cfif> >
                                    </div>
                                </form>
                        </div>
                        <div class = "col-md-2">
                        </div>
                    </div>
                </div>
            </div>
        </cfif>
    </cfif>
</cfoutput>
<script>
    function formvalidate(){
        let user_name = document.forms["createUser"]["user_name"].value;
        let user_password = document.forms["createUser"]["user_password"].value;
        let user_level = document.forms["createUser"]["user_level"].value;
        if( (user_name == "") || (user_password == "")||(user_level == "")){
            alert("All field must be filled out!");
            return false;
        }
    }
</script>
 