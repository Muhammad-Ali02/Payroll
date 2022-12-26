<cfoutput>
<cfinclude  template="head.cfm">
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
                    values ('#form.txt_Deduction_name#', '#form.Deduction_amount#', '#form.is_percent#', '#form.txt_description#')
                </cfquery>
                <center> <strong> <p class = "text-success"> Deduction added successfully </p> </strong> </center>
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <!--- update Query --->
            <cfquery name = "update_Deduction">
                update Deduction 
                set Deduction_amount = "#form.Deduction_amount#"
                where Deduction_name = "#form.txt_Deduction_name#"
            </cfquery>
            <p class = "text-success" style = "text-align:center; font-weight:bold;"> *Deduction information Updated Successfuly <p>
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <center>
        <table>
            <tr> 
                <td>   
                    <form Action = "Deduction.cfm" Method = "post">
                            <input type = "text" name = "txt_Deduction_name" placeholder = "Deduction Name" class = "form-control" required <cfif #merror# eq 1 > value = "#form.txt_Deduction_name#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.Deduction_name#" readonly</cfif>>
                        <hr>
                            <input type = "number"  min = "0"name = "Deduction_amount" placeholder = "Deduction amount" class = "form-control" required <cfif #merror# eq 1 > value = "#form.Deduction_amount#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.Deduction_amount#"</cfif>>
                        <hr>
                            <label>Amount in Percentage?</label>
                            <select name = "is_percent" id = "is_percent" class = "form-select">
                                <option value = "N">No</option>
                                <option value = "Y" <cfif structKeyExists(form, 'is_percent')> <cfif form.is_percent eq 'Y'> selected </cfif> <cfelseif structKeyExists(url, 'edit')><cfif get_data.is_percent eq 'Y'> selected </cfif></cfif>>Yes</option>
                            </select>
                        <hr>
                            <textarea name = "txt_description" placeholder = "Write Description Maximum words 200" maxlength = "200" rows = "5" cols = "30" required><cfif #merror# eq 1 >#form.txt_description#<cfelseif structKeyExists(url, 'edit')>#get_data.description#</cfif></textarea>
                        <br>
                        <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "Update" <cfelse> "Add" </cfif> > <!--- name "update" will update existing data, name "add" will insert new data --->
                        <input type = "submit" class = "btn btn-info" <cfif structKeyExists(url, 'edit')> value = "Update Deduction" <cfelse> value = "Add Deduction" </cfif> >
                    </form>
                <td>
            </tr>
        </table>
        </center>
    </cfif>
</cfoutput>
<cfinclude  template="foot.cfm">