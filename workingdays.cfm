<cfoutput>
    <cfinclude  template="head.cfm">
<cfif structKeyExists(session, 'loggedin')>
    <cfif structKeyExists(form, 'submit')> <!--- To create new workingdays group --->
        <cfquery name = "insert_group">
            insert into working_days (group_name, monday, tuesday, wednesday, thursday, friday, saturday, sunday, time_in, time_out, break_time, friday_time_in, friday_time_out )
            values ('#form.txt_group_name#', '#form.monday#', '#form.tuesday#', '#form.wednesday#', '#form.thursday#' , '#form.friday#', '#form.saturday#', '#form.sunday#', '#form.time_in#', '#form.time_out#', '#form.break_time#', '#form.friday_time_in#', '#form.friday_time_out#')
        </cfquery>
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
    <table>
        <form action = "workingdays.cfm" method = "post">
            <tr> 
                <td> Group Name: </td> 
                <td> <input type = "Text" maxlength = "20" name = "txt_group_name" required <cfif structKeyExists(url, 'edit')> value = "#get_workingdays.group_name#" </cfif> > </td>
            </tr>
            <tr>
                <td> Monday : </td> 
                <td> <select name = "monday">
                        <option value = "1" > Working Day </option>
                        <option value = "0"  <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.monday eq 0> selected  </cfif> </cfif> > Off Day </option>
                        <option value = "0.5" <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.monday eq 0.5> selected  </cfif> </cfif> > Half Day </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td> Tuesday : </td> 
                <td> <select name = "tuesday">
                        <option value = "1" > Working Day </option>
                        <option value = "0"  <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.tuesday eq 0> selected  </cfif> </cfif> > Off Day </option>
                        <option value = "0.5" <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.tuesday eq 0.5> selected  </cfif> </cfif> > Half Day </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td> Wednesday : </td> 
                <td> <select name = "wednesday">
                        <option value = "1" > Working Day </option>
                        <option value = "0"  <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.wednesday eq 0> selected  </cfif> </cfif> > Off Day </option>
                        <option value = "0.5" <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.wednesday eq 0.5> selected  </cfif> </cfif> > Half Day </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td> Thursday : </td> 
                <td> <select name = "thursday">
                        <option value = "1" > Working Day </option>
                        <option value = "0"  <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.thursday eq 0> selected  </cfif> </cfif> > Off Day </option>
                        <option value = "0.5" <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.thursday eq 0.5> selected  </cfif> </cfif> > Half Day </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td> Friday : </td> 
                <td> <select name = "friday">
                        <option value = "1" > Working Day </option>
                        <option value = "0"  <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.friday eq 0> selected  </cfif> </cfif> > Off Day </option>
                        <option value = "0.5" <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.friday eq 0.5> selected  </cfif> </cfif> > Half Day </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td> Saturday : </td> 
                <td> <select name = "saturday">
                        <option value = "1" > Working Day </option>
                        <option value = "0"  <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.saturday eq 0> selected  </cfif> </cfif> > Off Day </option>
                        <option value = "0.5" <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.saturday eq 0.5> selected  </cfif> </cfif> > Half Day </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td> Sunday : </td> 
                <td> <select name = "sunday">
                        <option value = "1" > Working Day </option>
                        <option value = "0"  <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.sunday eq 0> selected  </cfif> </cfif> > Off Day </option>
                        <option value = "0.5" <cfif structKeyExists(url, 'edit')> <cfif get_workingdays.sunday eq 0.5> selected  </cfif> </cfif> > Half Day </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td> Time In: </td> 
                <td> <input name = "time_in" type = "time" <cfif structKeyExists(url, 'edit')> value = "#Timeformat(get_workingdays.time_in , "hh:mm")#" <cfelse> value = "09:00" </cfif> > </td>
            </tr>
                <td> Time Out: </td> 
                <td> <input name = "time_out" type = "time" <cfif structKeyExists(url, 'edit')> value = "#Timeformat(get_workingdays.time_out , "hh:mm")#" <cfelse> value = "18:00" </cfif>> </td>
            </tr>
            <tr>
                <td> Break Time: </td>
                <td> <input name = "break_time" type = "number"  min = "0"min = "0" required <cfif structKeyExists(url, 'edit')> value = "#get_workingdays.break_time#" </cfif> > </td>
            </tr>
            <tr>
                <td> Friday Time In: </td> 
                <td> <input name = "Friday_time_in" type = "time" value = "09:00" <cfif structKeyExists(url, 'edit')> value = "#Timeformat(get_workingdays.friday_time_in , "hh:mm")#" <cfelse> value = "09:00" </cfif>> </td>
            </tr>
                <td> Friday Time Out: </td> 
                <td> <input name = "Friday_time_out" type = "time" value = "18:30" <cfif structKeyExists(url, 'edit')> value = "#Timeformat(get_workingdays.time_out , "hh:mm")#" <cfelse> value = "18:30" </cfif>> </td>
            </tr>
            <tr>
                <cfif structKeyExists(url, 'edit')> 
                <input type = "hidden" name = "group_id" value = "#url.edit#"> 
                </cfif>
                <td> <input type = "submit" <cfif structKeyExists(url, 'edit')> name = "update" value = "Update" <cfelse> value = "Submit" name = "submit" </cfif> > </td>
            </tr>
        </form>
    </table>
</cfif> 
</cfoutput>
<cfinclude  template="foot.cfm">