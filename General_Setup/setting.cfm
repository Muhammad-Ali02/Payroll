<cfoutput>
    <cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedIn')>
        <cfset date1 = dateformat(now(), "mmmm")>
        <cfif structKeyExists(form, 'current_month')>
            <!--- to check if current month is already in the table --->
            <cfquery name = "existing_data">
                select * from setup
                where current_month > 0
            </cfquery>
            <cfif existing_data.recordcount eq 0 >
                <cfquery name = "insert_setting">
                    insert into setup (current_month, current_year)
                    values ('#form.current_month#', '#form.current_year#')
                </cfquery>
            <cfelse>
                <cfquery name = "update_setting">
                    update setup
                    set current_month = '#form.current_month#', current_year = '#form.current_year#'
                </cfquery>
            </cfif>
            <script>
                alert(" Setting Updated Successfully! ");
            </script>
        </cfif>
        <cfquery name = "existing_data">
            select * from setup
            where current_month > 0
        </cfquery>
        <form action = "setting.cfm" method = "post">
            <div class="employee_box">
                <div class = "row">  
                    <div class = "col-md-6">          
                            Current Month: 
                            <select name = "current_month" class = "form-select">
                                <cfloop from = "1" to="12" index="i">
                                    <option value = "#i#" <cfif i eq existing_data.current_month> selected </cfif> > #monthAsString(i)# </option>
                                </cfloop>
                            </select>
                    </div>
                    <div class = "col-md-4">
                            Current Year:
                            <select name = "current_year" class = "form-select">
                                <cfloop from = "2022" to="2050" index="i">
                                    <option value = "#i#" <cfif i eq existing_data.current_year> selected </cfif> > #i# </option>
                                </cfloop>
                            </select>
                    </div>
                    <div class = "col-md-2 mt-4">
                            <input type = "submit" value = "Save" class = "btn btn-outline-dark">
                    </div>
                </div>
            </div>
        </form>
        <!--- <script>
        // function monthList(){
                var theMonths = ["January", "February", "March", "April", "May",
                    "June", "July", "August", "September", "October", "November", "December"];
                    document.write("<select name = 'current_month'>");
                        for (i=0; i<12; i++){
                        document.write("<option>"+theMonths[i]+"</option>");
                        }
                    document.write("</select>");
        // } --->
        <!---     </script> --->
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">