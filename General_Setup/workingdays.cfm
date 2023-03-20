<cfoutput>
    <cfinclude  template="\includes\head.cfm">
<cfif structKeyExists(session, 'loggedin')>
    <cfif structKeyExists(form, 'submit')> <!--- To create new workingdays group --->
        <cfquery name = "get_existing_group">
            select group_name from working_days
            where group_name = "#form.txt_group_name#"
        </cfquery>
        <cfif get_existing_group.recordcount eq "0">
            <cfif form.txt_group_name neq ''>
                <cfquery name = "insert_group">
                    insert into working_days (group_name, monday, tuesday, wednesday, thursday, friday, saturday, sunday, time_in, time_out, break_time, friday_time_in, friday_time_out )
                    values ('#form.txt_group_name#', '#form.monday#', '#form.tuesday#', '#form.wednesday#', '#form.thursday#' , '#form.friday#', '#form.saturday#', '#form.sunday#', '#form.time_in#', '#form.time_out#', '#form.break_time#', '#form.friday_time_in#', '#form.friday_time_out#')
                </cfquery>
            <cfelse>
                <script>
                alert("Working Days Group Not Created, Group Name Can't Be Null!")
                </script>
            </cfif>
        <cfelse>
            <script>
                alert("Working Days Group Not Created, Group Name Already Exists!")
            </script>
        </cfif>
    <cfelseif structKeyExists(form, 'update')> <!--- To update existing workingdays group --->
        <cfquery name = "update_workingdays">
            update working_days
            set group_name = '#form.txt_group_name#' , monday = '#form.monday#', tuesday = '#form.tuesday#', wednesday = '#form.wednesday#', thursday = '#form.thursday#', friday = '#form.friday#', saturday = '#form.saturday#' , sunday = '#form.sunday#', time_in = '#form.time_in#', time_out = '#form.time_out#', break_time = '#form.break_time#', friday_time_in = '#form.friday_time_in#', friday_time_out = '#form.friday_time_out#'
            where group_id = '#form.group_id#'
        </cfquery>
    <cfelseif structKeyExists(url, 'edit')>
        <cfquery name = "get_workingdays"> <!--- Result of this query used when user want to update workingdays table. --->
            select * 
            from working_days 
            where group_id = "#url.edit#" 
        </cfquery>
    </cfif>
    <cfset week_days = arrayNew(1)>
    <cfloop index="i" from="1" to="7">
        <cfset day = dayOfWeekAsString(i)>
        <cfset arrayAppend = arrayAppend(week_days, '#day#')>
    </cfloop>
    <form action = "workingdays.cfm" method = "post">
        <div class = "employee_box">
            <div class="mb-5 text-center">
            <h3 class="box_heading">Create New Working Group</h3>
            </div>
            <div class = "row mt-3">
                <div class = "col-md-6">
                    <label for = "txt_group_name" class = "form-control-label"> Group Name: </td> 
                </div>
                <div class = "col-md-6">
                    <input type = "Text" maxlength = "20" id = "txt_group_name" class = "form-control" name = "txt_group_name" <cfif structKeyExists(url, 'edit')> value = "#get_workingdays.group_name#" </cfif> > </td>
                </div>
            </div>
            <cfloop array="#week_days#" index="week_day">
                <div class = "row mt-3">
                    <div class = "col-md-6">
                        <label for = "#week_day#" class = "form-select-label"> #week_day# : </td> 
                    </div>
                    <div class = "col-md-6">
                        <select name = "#week_day#" class = "form-select" id = "#week_day#">
                            <option value = "1" > Working Day </option>
                            <option value = "0"  <cfif structKeyExists(url, 'edit')> <cfif evaluate('get_workingdays.#week_day#') eq 0> selected  </cfif> </cfif> > Off Day </option>
                            <option value = "0.5" <cfif structKeyExists(url, 'edit')> <cfif evaluate('get_workingdays.#week_day#') eq 0.5> selected  </cfif> </cfif> > Half Day </option>
                        </select>
                    </div>
                </div>
            </cfloop>
            <div class = "row mt-3">
                <div class = "col-md-6">
                    <label for = "time_in" class = "form-control-label"> Time In: </label> 
                </div>
                <div class = "col-md-6">
                    <input name = "time_in" id = "time_in" type = "time" class = "form-control" <cfif structKeyExists(url, 'edit')> value = "#Timeformat(get_workingdays.time_in , "hh:mm")#" <cfelse> value = "09:00" </cfif> >
                </div>
            </div>
            <div class = "row mt-3">
                <div class = "col-md-6">
                    <label for = "time_out" class = "form-control-label"> Time Out: </label> 
                </div>
                <div class = "col-md-6">
                    <input name = "time_out" id = "time_out" type = "time" class = "form-control" <cfif structKeyExists(url, 'edit')> value = "#Timeformat(get_workingdays.time_out , "hh:mm")#" <cfelse> value = "18:00" </cfif>>
                </div>
            </div>
            <div class = "row mt-3">
                <div class = "col-md-6">
                    <label for = "break_time"> Break Time: </label>
                </div>
                <div class = "col-md-6">
                    <input name = "break_time" id = "break_time" type = "number" class = "form-control"  min = "0"min = "0" <cfif structKeyExists(url, 'edit')> value = "#get_workingdays.break_time#" </cfif> >
                </div>
            </div>
            <div class = "row mt-3">
                <div class = "col-md-6">
                    <label for = "friday_time_in" class = "form-control-label"> Friday Time In: </label> 
                </div>
                <div class = "col-md-6">
                    <input name = "Friday_time_in" id = "friday_time_in" type = "time" value = "09:00" class = "form-control" <cfif structKeyExists(url, 'edit')> value = "#Timeformat(get_workingdays.friday_time_in , "hh:mm")#" <cfelse> value = "09:00" </cfif>>
                </div>
            </div>
            <div class = "row mt-3">
                <div class = "col-md-6">
                    <label for = "friday_time_out" class = "form-control-label"> Friday Time Out: </label> 
                </div>
                <div class = "col-md-6">
                    <input name = "Friday_time_out" id = "friday_time_out" type = "time" value = "18:30" class = "form-control" <cfif structKeyExists(url, 'edit')> value = "#Timeformat(get_workingdays.time_out , "hh:mm")#" <cfelse> value = "18:30" </cfif>>
                </div>
            </div>
            <div class="text-right mt-3">
                <cfif structKeyExists(url, 'edit')> 
                    <input type = "hidden" name = "group_id" value = "#url.edit#"> 
                </cfif>
                <input type = "submit" onclick = "javascript:validateRequired();" class = "btn btn-outline-dark" <cfif structKeyExists(url, 'edit')> name = "update" value = "Update" <cfelse> value = "Submit" name = "submit" </cfif>>
            </div>
        </div>
    </form>
</cfif> 
<script>
    function validateRequired(){
        var group_name = document.getElementById('txt_group_name').value;
        var break_time = document.getElementById('break_time').value;
        if(group_name == ''){
            alert("Group Name is Must Required!");
            return false;
        }
        if(break_time == ''){
            alert("Break Time Must Required!")
        }
    }
</script>
</cfoutput>
<cfinclude  template="\includes\foot.cfm">