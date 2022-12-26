<cfoutput>
<cfinclude  template="..\includes\head.cfm">
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
                <center> <strong> <p class = "text-danger"> *User Name already Exists </p> </strong> </center>
                <cfset merror = 1>
            <cfelse>
                <!--- Insert query  --->
                <cfquery name = "insert_user">
                    insert into users (user_name, password, level)
                    values ('#form.user_name#', '#form.user_password#', '#form.user_level#')
                </cfquery>
                <center> <strong> <p class = "text-success"> User createed successfully </p> </strong> </center>
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <cfquery name = "update_user">
                update users 
                set password = "#form.user_password#"
                where user_name = "#form.user_name#"
            </cfquery>
            <p class = "text-success" style = "text-align:center; font-weight:bold;"> *User Data Updated Successfuly <p>
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <center>
        <table>
            <tr> 
                <td>   
                    <form Action = "create_user.cfm" Method = "post">
                        <br>
                        <select class = "form-select" name = "user_name" required="true"> 
                            <option disabled> Select Employee </option> 
                                <cfloop query="get_employees">
                                    <option value = "#employee_id#" <cfif #merror# eq 1 > <cfif structKeyExists(form, 'user_name')> <cfif form.user_name eq employee_id> selected = "true" style = "border-color : red; color : red;"</cfif> </cfif> <cfelseif structKeyExists(url, 'edit')> <cfif "#get_data.user_name#" eq employee_id> selected = "true" <cfelse> Disabled = "true" </cfif> </cfif>> #name# </option>
                                </cfloop>
                        </select>
                        <hr>
                        <input type = "password" name = "user_password" placeholder = "Create Password" class = "form-control" required<cfif #merror# eq 1 > value = "#form.user_password#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.password#"</cfif>>
                        <hr>
                        <select class = "form-select" name = "user_level" required="true"> 
                            <option disabled> Select Level </option>
                            <option> Admin </option>
                            <option <cfif #merror# eq 1 ><cfif form.user_level eq 'Employee'> selected = "true"</cfif> </cfif> > Employee </option>
                        </select>                        
                        <br>
                        <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "update" <cfelse> "create" </cfif> > <!--- name "update" will update existing data, name "create" will insert new data --->
                        <input type = "submit" class = "btn btn-info" <cfif structKeyExists(url, 'edit')> value = "Update User Data" <cfelse> value = "Create User" </cfif> >
                    </form>
                <td>
            </tr>
        </table>
        </center>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">