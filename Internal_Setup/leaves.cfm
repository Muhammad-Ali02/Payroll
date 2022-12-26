<cfoutput>
<cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- |________________________________\|/_Back End _\|/________________________________|--->
        <cfparam  name = "merror" default = 0>
        <cfif structKeyExists(url, 'edit')>
            <cfquery  name = "get_data">
                select * from leaves where leave_id = "#url.edit#"
            </cfquery>
        <cfelseif structKeyExists(form, 'add')> <!--- show error when duplicate deparment name --->
            <cfquery name = "check">
                select leave_title as title 
                from leaves
                where leave_title = '#form.txt_leave_title#'
            </cfquery>
            <cfif check.title eq form.txt_leave_title>
                <center> <strong> <p class = "text-danger"> *Leave already Exists </p> </strong> </center>
                <cfset merror = 1>
            <cfelse>
                <!--- Insert query here --->
                <cfquery name = "insert_leave">
                    insert into leaves (leave_title, leave_type, allowed_per_year, description)
                    values ('#form.txt_leave_title#', '#form.txt_leave_type#', '#form.allowed_per_year#', '#form.txt_description#')
                </cfquery>
                <cflocation  url="all_leaves.cfm?created=true">
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <cfquery name = "update_leave">
                update leaves 
                set leave_type = "#form.txt_leave_type#", allowed_per_year = "#form.allowed_per_year#", description = "#form.txt_description#"
                where leave_title = "#form.txt_leave_title#"
            </cfquery>
            <cflocation  url="all_leaves.cfm?updated=true">
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <center>
        <table>
            <tr> 
                <td>   
                    <form Action = "leaves.cfm" Method = "post">
                        <input type = "text" name = "txt_leave_title" placeholder = "Leave Title" class = "form-control" <cfif #merror# eq 1 > value = "#form.txt_leave_title#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.leave_title#"</cfif>>
                        <hr>
                        <select name = "txt_leave_type" class = "form-select">
                            <option disabled >Leave Type</option> 
                            <option value = "Paid"> Paid </option>
                            <option value = "NonPaid" <cfif structKeyExists(url, 'edit')> <cfif get_data.leave_type eq "N" or (#merror# eq 1 and form.txt_leave_type eq "N")> selected </cfif> </cfif> > Non-Paid </option>
                        </select>
                        <hr>
                        <input type = "number"  min = "0"name = "allowed_per_year" class = "form-control" placeholder = "Allowed Leaves/Year" min = "1"<cfif merror eq 1 > value = "#form.allowed_per_year#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.allowed_per_year#" </cfif> >
                        <hr>
                        <textarea name = "txt_description" rows = "3" cols = "30" maxlength = "198" placeholder = "Description Maximum 180 words."><cfif #merror# eq 1 >#form.txt_description#<cfelseif structKeyExists(url, 'edit')>#get_data.description#</cfif></textarea>
                        <hr>
                        <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "Update" <cfelse> "Add" </cfif> > <!--- name "update" will update existing data, name "add" will insert new data --->
                        <input type = "submit" class = "btn btn-outline-dark" <cfif structKeyExists(url, 'edit')> value = "Update leave" <cfelse> value = "Add leave" </cfif> >
                    </form>
                <td>
            </tr>
        </table>
        </center>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">