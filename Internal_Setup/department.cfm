<cfoutput>
<cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- |________________________________\|/_Back End _\|/________________________________|--->
        <cfparam  name = "merror" default = "0">
        <cfparam  name="existing_department" default = "1">
        <cfif structKeyExists(url, 'edit')>
            <cfquery  name = "get_data">
                select * 
                from department 
                where department_id = "#url.edit#"
                and is_deleted <> "Y" or is_deleted is null
            </cfquery>
            <cfif get_data.recordcount eq 0>
                <cfset existing_department = 0>
            </cfif>
        <cfelseif structKeyExists(form, 'create')> <!--- show error when duplicate deparment name --->
            <cfquery name = "check">
                select department_name as department from department
                where department_name = '#form.txt_department_name#'
            </cfquery>
            <cfif check.department eq form.txt_department_name>
                <center> <strong> <p class = "text-danger"> *Department Name already Exists </p> </strong> </center>
                <cfset merror = 1>
            <cfelse>
                <!--- Insert query here --->
                <cfquery name = "insert_department">
                    insert into department (department_name, description)
                    values ('#form.txt_department_name#', '#form.txt_department_description#')
                </cfquery>
                <cflocation  url="all_departments.cfm?created=true">
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <cfquery name = "update_department">
                update department
                set department_name = '#form.txt_department_name#', description = '#form.txt_department_description#'
                where department_name = "#form.txt_department_name#"
            </cfquery>
            <cflocation  url="all_departments.cfm?updated=true">
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <cfif existing_department eq 0>
            <h1> Department Not Found </h1>
        <cfelse>
            <center>
                <table>
                    <tr> 
                        <td>   
                            <form Action = "department.cfm" Method = "post">
                                <input type = "text" name = "txt_department_name" placeholder = "Department Name" class = "form-control" required = "true" <cfif #merror# eq 1 > value = "#form.txt_department_name#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.department_name#" </cfif>>
                                <hr>
                                <textarea name = "txt_department_description" maxlength = "200" cols = "30" rows = "5" Placeholder = "Write Description Maximum Charactors 200 ..." required = "true"><cfif #merror# eq 1 >#form.txt_department_description#<cfelseif structKeyExists(url, 'edit')>#get_data.description#</cfif></textarea>
                                <br>
                                <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "update" <cfelse> "create" </cfif> > <!--- name "update" will update existing data, name "create" will insert new data --->
                                <hr>
                                <input type = "submit" class = "btn btn-outline-dark" <cfif structKeyExists(url, 'edit')> value = "Update Department" <cfelse> value = "Create Department" </cfif> >
                            </form>
                        <td>
                    </tr>
                </table>
            </center>
        </cfif>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">