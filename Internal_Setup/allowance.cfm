<cfoutput>
 
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- |________________________________\|/_Back End _\|/________________________________|--->
        <cfparam  name = "merror" default = 0>
        <cfif structKeyExists(url, 'edit')>
            <cfquery  name = "get_data">
                select * from allowance where allowance_id = "#url.edit#"
            </cfquery>
        <cfelseif structKeyExists(form, 'add')> <!--- show error when duplicate deparment name --->
            <cfquery name = "check">
                select allowance_name as allowance from allowance
                where allowance_name = '#form.txt_allowance_name#'
            </cfquery>
            <cfif check.allowance eq form.txt_allowance_name>
                <center> <strong> <p class = "text-danger"> *Allowance Name already Exists </p> </strong> </center>
                <cfset merror = 1>
            <cfelse>
                <!--- Insert query here --->
                <cfquery name = "insert_allowance">
                    insert into allowance (allowance_name, allowance_amount, description)
                    values (
                        <cfqueryparam value = '#form.txt_allowance_name#'>, 
                        <cfqueryparam value = '#form.allowance_amount#'> , 
                        <cfqueryparam value = '#form.txt_description#'>)
                </cfquery>
                <cflocation  url="all_allowance.cfm?created=true">
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <cfquery name = "update_allowance">
                update allowance 
                set allowance_name = <cfqueryparam value = "#form.txt_allowance_name#">, 
                    allowance_amount = <cfqueryparam value = "#form.allowance_amount#">, 
                    description = <cfqueryparam value = "#form.txt_description#">
                where allowance_id = "#form.allowance_id#"
            </cfquery>
            <cflocation  url="all_allowance.cfm?updated=true">
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <center>
        <table>
            <tr> 
                <td>
                    <div class="employee_box">
                        <div class="mb-5 text-center">
                            <cfif structKeyExists(url, 'edit')>
                                <h3 class="box_heading">Upadate Allowance</h3>
                            <cfelse>
                                <h3 class="box_heading">Create New Allowance</h3>
                            </cfif>
                        </div>
                        <form name="allowance_form" onsubmit="return formValidate();" Action = "allowance.cfm" Method = "post">
                            <input type = "hidden" name = "allowance_id" <cfif structKeyExists(url, 'edit')> value = "#get_data.allowance_id#"</cfif> >
                            <input type = "text" name = "txt_allowance_name" placeholder = "Allowance Name" class = "form-control mb-3" required = "true" <cfif #merror# eq 1 > value = "#form.txt_allowance_name#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.allowance_name#"</cfif> >
                            <input type = "number"  min = "0" name = "allowance_amount" placeholder = "Allowance amount" class = "form-control mb-3" required<cfif #merror# eq 1 > value = "#form.allowance_amount#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.allowance_amount#"</cfif>>
                            <textarea class="form-control mb-3" rows = "5" cols = "30" name = "txt_description" placeholder = "Write Description Maximum words 200" required = "true" ><cfif structKeyExists(url, 'edit')>#get_data.description#</cfif></textarea>
                            <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "Update" <cfelse> "Add" </cfif> > <!--- name "update" will update existing data, name "add" will insert new data --->
                            <input type = "submit" class = "btn btn-outline-dark" <cfif structKeyExists(url, 'edit')> value = "Update allowance" <cfelse> value = "Add allowance" </cfif> >
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
        let txt_allowance_name = document.forms["allowance_form"]["txt_allowance_name"].value;
        let allowance_amount = document.forms["allowance_form"]["allowance_amount"].value;
        let txt_description = document.forms["allowance_form"]["txt_description"].value;
        if((txt_allowance_name == "") || (allowance_amount == "") || (txt_description == "")){
            alert("All field must be filled out!");
            return false;
        }else{
            return true;
        }
    }
</script>
 