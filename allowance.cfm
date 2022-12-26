<cfoutput>
<cfinclude  template="head.cfm">
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
                    values ('#form.txt_allowance_name#', '#form.allowance_amount#' , '#form.txt_description#')
                </cfquery>
                <center> <strong> <p class = "text-success"> Allowance added successfully </p> </strong> </center>
            </cfif>
        <cfelseif structKeyExists(form, 'update')>
            <cfquery name = "update_allowance">
                update allowance 
                set allowance_amount = "#form.allowance_amount#", description = "#form.txt_description#"
                where allowance_name = "#form.txt_allowance_name#"
            </cfquery>
            <p class = "text-success" style = "text-align:center; font-weight:bold;"> *Allowance information Updated Successfuly <p>
        </cfif>
        <!--- |________________________________\|/_Front End _\|/________________________________|--->
        <center>
        <table>
            <tr> 
                <td>   
                    <form Action = "allowance.cfm" Method = "post">
                        <input type = "text" name = "txt_allowance_name" placeholder = "Allowance Name" class = "form-control" required = "true" <cfif #merror# eq 1 > value = "#form.txt_allowance_name#" style = "border-color : red; color : red;" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.allowance_name#" readonly</cfif>>
                        <hr>
                        <input type = "number"  min = "0"name = "allowance_amount" placeholder = "Allowance amount" class = "form-control" required<cfif #merror# eq 1 > value = "#form.allowance_amount#" <cfelseif structKeyExists(url, 'edit')> value = "#get_data.allowance_amount#"</cfif>>
                        <hr>
                        <textarea rows = "5" cols = "30" name = "txt_description" placeholder = "Write Description Maximum words 200" required = "true"></textarea>
                        <br>
                        <input type = "hidden" value = "action" name = <cfif structKeyExists(url, 'edit')> "Update" <cfelse> "Add" </cfif> > <!--- name "update" will update existing data, name "add" will insert new data --->
                        <input type = "submit" class = "btn btn-info" <cfif structKeyExists(url, 'edit')> value = "Update allowance" <cfelse> value = "Add allowance" </cfif> >
                    </form>
                <td>
            </tr>
        </table>
        </center>
    </cfif>
</cfoutput>
    <cfinclude  template="foot.cfm">