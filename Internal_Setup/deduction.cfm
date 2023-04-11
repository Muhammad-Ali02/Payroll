<cfoutput>
 
    <cfif structKeyExists(session, 'loggedIn')>
        <!--- |________________________________\|/_Back End _\|/________________________________|--->
        <cfparam  name = "merror" default = 0>
        <cfif structKeyExists(url, 'edit')>
            <cfquery  name = "get_data">
                select * from Deduction 
                where Deduction_id = "#url.edit#"
                and is_deleted != "Y"
            </cfquery>
        <cfelseif structKeyExists(form, 'add')> <!--- show error when duplicate deparment name --->
            <cfquery name = "check">
                select Deduction_name as Deduction from Deduction
                where Deduction_name = '#form.txt_Deduction_name#'
            </cfquery>
            <cfif check.Deduction eq form.txt_Deduction_name>
                <center> <strong> <p class = "text-danger"> *Deduction already Exists </p> </strong> </center>
                <cfset merror = 1>
            <cfelse>
                <!--- Insert query --->
                <cfquery name = "insert_Deduction">
                    insert into Deduction (Deduction_name, Deduction_amount, is_percent, description)
                    values (
                        <cfqueryparam value = '#form.txt_Deduction_name#'>, 
                        <cfqueryparam value = '#form.Deduction_amount#'>, 
                        <cfqueryparam value = '#form.is_percent#'>, 
                        <cfqueryparam value = '#form.txt_description#'>)
                </cfquery>
                <cflocation  url="all_deduction.cfm?created=true">
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <!--- update Query --->
            <cfquery name = "update_Deduction">
                update Deduction 
                set Deduction_name = <cfqueryparam value = '#form.txt_Deduction_name#'>, 
                    Deduction_amount = <cfqueryparam value = "#form.Deduction_amount#">,
                    is_percent = <cfqueryparam value = "#form.is_percent#">,
                    description = <cfqueryparam value = "#form.txt_description#">
                where Deduction_id = "#form.deduction_id#"
            </cfquery>
            <cflocation  url="all_deduction.cfm?updated=true">
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <center>
        <table>
            <tr> 
                <td> 
                    <div class="employee_box">
                        <div class="mb-5 text-center">
                            <cfif structKeyExists(url, 'edit')>
                                <h3 class="box_heading">Update Deduction</h3>
                            <cfelse>
                                <h3 class="box_heading">Create New Deduction</h3>
                            </cfif>
                        </div>  
                        <form name="deduction_form" onsubmit="return formValidate();" Action = "Deduction.cfm" Method = "post">
                            <input type ="hidden" name = "deduction_id" <cfif structKeyExists(url, 'edit')>value = "#get_data.deduction_id#"</cfif>>
                            <input type = "text" name = "txt_Deduction_name" placeholder = "Deduction Name" class = "form-control mb-3" required <cfif #merror# eq 1 > value = "#form.txt_Deduction_name#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.Deduction_name#" readonly</cfif>>
                            <input type = "number"  min = "0" name = "Deduction_amount" placeholder = "Deduction amount" class = "form-control mb-3" required <cfif #merror# eq 1 > value = "#form.Deduction_amount#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.Deduction_amount#"</cfif>>
                            <label>Amount in Percentage?</label>
                            <select name = "is_percent" id = "is_percent" class = "form-select mb-3">
                                <option value = "N">No</option>
                                <option value = "Y" <cfif structKeyExists(form, 'is_percent')> <cfif form.is_percent eq 'Y'> selected </cfif> <cfelseif structKeyExists(url, 'edit')><cfif get_data.is_percent eq 'Y'> selected </cfif></cfif>>Yes</option>
                            </select>
                            <textarea class="form-control mb-3" name = "txt_description" placeholder = "Write Description Maximum words 200" maxlength = "200" rows = "5" cols = "30" required><cfif #merror# eq 1 >#form.txt_description#<cfelseif structKeyExists(url, 'edit')>#get_data.description#</cfif></textarea>
                            <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "Update" <cfelse> "Add" </cfif> > <!--- name "update" will update existing data, name "add" will insert new data --->
                            <input type = "submit" class = "btn btn-outline-dark" <cfif structKeyExists(url, 'edit')> value = "Update Deduction" <cfelse> value = "Add Deduction" </cfif> >
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
        let txt_Deduction_name = document.forms["deduction_form"]["txt_Deduction_name"].value;
        let Deduction_amount = document.forms["deduction_form"]["Deduction_amount"].value;
        let is_percent = document.forms["deduction_form"]["is_percent"].value;
        let txt_description = document.forms["deduction_form"]["txt_description"].value;
        if( (txt_Deduction_name == "") || (Deduction_amount == "") || (is_percent =="") || (txt_description =="")){
            alert("All field must be filled out!");
            return false;
        }else{
           return true;
        }
    }
</script>
 