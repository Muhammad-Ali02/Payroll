<cfoutput>
<cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- |________________________________\|/_Back End _\|/________________________________|--->
        <cfparam  name = "merror" default = 0>
        <cfif structKeyExists(url, 'edit')>
            <cfquery  name = "get_data"> <!--- result of query will be shown in inputs when want to update --->
                select * 
                from designation 
                where designation_id = "#url.edit#"
            </cfquery>
        <cfelseif structKeyExists(form, 'add')> <!--- show error when duplicate designation title --->
            <cfquery name = "check">
                select designation_title as title, short_word 
                from designation
                where designation_title = '#form.txt_designation_title#'
            </cfquery>
            <cfif check.recordcount neq 0>
                <center> <strong> <p class = "text-danger"> *Designation already Exists </p> </strong> </center>
                <cfset merror = 1>
            <cfelse>
                <!--- Insert query here --->
                <cfquery name = "insert_designation">
                    insert into designation (designation_title, description, short_word, basic_salary)
                    values ('#form.txt_designation_title#', '#form.txt_description#', '#form.txt_short_word#', '#form.basic_salary#')
                </cfquery>
                <cflocation  url="all_designation.cfm?updated=true">
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <cfquery name = "update_designation">
                update designation 
                set basic_salary = "#form.basic_salary#", description = '#form.txt_description#', short_word = '#form.txt_short_word#'
                where designation_title = "#form.txt_designation_title#"
            </cfquery>
            <cflocation  url="all_designation.cfm?updated=true">
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <center>
        <table>
            <tr> 
                <td>
                    <div class="employee_box">
                        <div class="mb-5 text-center">
                            <cfif structKeyExists(url, 'edit')>
                                <h3 class="box_heading">Update Designation</h3>
                            <cfelse>
                                <h3 class="box_heading">Create New Designation</h3>
                            </cfif>
                        </div>
                        <form name="designation_form" Action = "designation.cfm" onsubmit="return formValidate();" Method = "post">
                            <input type = "text" name = "txt_designation_title" placeholder = "Designation Title" class = "form-control mb-3" <cfif #merror# eq 1 > value = "#form.txt_designation_title#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.designation_title#"</cfif>>
                            <input type = "number" min = "0" name = "basic_salary" placeholder = "Basic Salary" class = "form-control mb-3" required = "true" <cfif #merror# eq 1 > value = "#form.basic_salary#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.basic_salary#"</cfif>>
                            <input type = "Text" name = "txt_short_word" minlength = "2" maxlength = "2" placeholder = "Short Word like 'SE'" class = "form-control mb-3" required = "true" <cfif #merror# eq 1 > value = "#form.txt_short_word#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.short_word#"</cfif>>
                            <textarea class="form-control mb-3" name = "txt_description" rows = "5" cols = "30" maxlength = "200" placeholder = "Write Description. Maximum Words 200 ..."  required = "true"><cfif #merror# eq 1 >#form.txt_description#<cfelseif structKeyExists(url, 'edit')>#get_data.description#</cfif></textarea>
                            <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "update" <cfelse> "add" </cfif> > <!--- name "update" will update existing data, name "add" will insert new data --->
                            <input type = "submit" class = "btn btn-outline-dark" <cfif structKeyExists(url, 'edit')> value = "Update Designation" <cfelse> value = "Add Designation" </cfif> >
                        </form>
                    </div>   
                <td>
            </tr>
        </table>
        </center>
    </cfif>
</cfoutput>
<script>
    function formValidate(){
            let txt_designation_title = document.forms["designation_form"]["txt_designation_title"].value;
            let basic_salary = document.forms["designation_form"]["basic_salary"].value;
            let txt_short_word = document.forms["designation_form"]["txt_short_word"].value;
            let txt_description = document.forms["designation_form"]["txt_description"].value;
            if( (txt_designation_title == "") || (basic_salary == "") || (txt_short_word =="") || (txt_description =="")){
                alert("All field must be filled out!");
                return false;
            }else{
                return true;
            }
        }
</script>
<cfinclude  template="..\includes\foot.cfm">