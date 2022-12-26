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
                <cflocation  url="all_departments.cfm?updated=true">
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <cfquery name = "update_designation">
                update designation 
                set basic_salary = "#form.basic_salary#", description = '#form.txt_description#', short_word = '#form.txt_short_word#'
                where designation_title = "#form.txt_designation_title#"
            </cfquery>
            <cflocation  url="all_departments.cfm?updated=true">
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <center>
        <table>
            <tr> 
                <td>   
                    <form Action = "designation.cfm" Method = "post">
                        <input type = "text" name = "txt_designation_title" placeholder = "Designation Title" class = "form-control" <cfif #merror# eq 1 > value = "#form.txt_designation_title#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.designation_title#"</cfif>>
                        <hr>
                        <input type = "number" min = "0" name = "basic_salary" placeholder = "Basic Salary" class = "form-control" required = "true" <cfif #merror# eq 1 > value = "#form.basic_salary#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.basic_salary#"</cfif>>
                        <hr>
                        <input type = "Text" name = "txt_short_word" minlength = "2" maxlength = "2" placeholder = "Short Word like 'SE'" class = "form-control" required = "true" <cfif #merror# eq 1 > value = "#form.txt_short_word#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.short_word#"</cfif>>
                        <hr>
                        <textarea name = "txt_description" rows = "5" cols = "30" maxlength = "200" placeholder = "Write Description. Maximum Words 200 ..."  required = "true"><cfif #merror# eq 1 >#form.txt_description#<cfelseif structKeyExists(url, 'edit')>#get_data.description#</cfif></textarea>
                        <br>
                        <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "update" <cfelse> "add" </cfif> > <!--- name "update" will update existing data, name "add" will insert new data --->
                        <input type = "submit" class = "btn btn-outline-dark" <cfif structKeyExists(url, 'edit')> value = "Update Designation" <cfelse> value = "Add Designation" </cfif> >
                    </form>
                <td>
            </tr>
        </table>
        </center>
    </cfif>ssd
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">