<cfoutput>
 
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
                    values (
                        <cfqueryparam value = '#form.txt_department_name#'>, 
                        <cfqueryparam value = '#form.txt_department_description#'>)
                </cfquery>
                <cflocation  url="all_departments.cfm?created=true">
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <cfquery name = "update_department">
                update department
                set department_name = <cfqueryparam value = '#form.txt_department_name#'>, description = <cfqueryparam value = '#form.txt_department_description#'>
                where department_id = "#form.department_id#"
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
                            <div class="employee_box">
                                <div class="mb-5 text-center">
                                    <cfif structKeyExists(url, 'edit')>
                                        <h3 class="box_heading">Update Department</h3>
                                    <cfelse>
                                        <h3 class="box_heading">Create New Department</h3>
                                    </cfif>
                                </div>   
                                <form name="create_department" onsubmit="return formValidate();" Action = "department.cfm" Method = "post">
                                    <input type= "hidden" name = "department_id" <cfif structKeyExists(url, 'edit')> value ="#get_data.department_id#"</cfif> >
                                    <input type = "text" name = "txt_department_name" placeholder = "Department Name" class = "form-control mb-3" required = "true" <cfif #merror# eq 1 > value = "#form.txt_department_name#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.department_name#" </cfif>>
                                    <textarea class="form-control mb-3" name = "txt_department_description" maxlength = "200" cols = "30" rows = "5" Placeholder = "Write Description Maximum Charactors 200 ..." required = "true"><cfif #merror# eq 1 >#form.txt_department_description#<cfelseif structKeyExists(url, 'edit')>#get_data.description#</cfif></textarea>
                                    <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "update" <cfelse> "create" </cfif> > <!--- name "update" will update existing data, name "create" will insert new data --->
                                    <input type = "submit" class = "btn btn-outline-dark" <cfif structKeyExists(url, 'edit')> value = "Update Department" <cfelse> value = "Create Department" </cfif> >
                                </form>
                            </div>
                        <td>
                    </tr>
                </table>
            </center>
        </cfif>
    </cfif>
</cfoutput>
<script>
    function formValidate(){
        let txt_department_name = document.forms["create_department"]["txt_department_name"].value;
        let txt_department_description = document.forms["create_department"]["txt_department_description"].value;
        if((txt_department_name == "") || (txt_department_description == "")){
            alert("All field must be filled out!");
            return false;
        }else{
            return true;
        }
    }
</script>
 