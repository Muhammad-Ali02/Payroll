<cfoutput>
<cfinclude  template="head.cfm">
<cfif structKeyExists(session, 'loggedin')>
    <cfquery name = "get_employees">
        select concat(first_name," ", middle_name, " " , last_name) as name , employee_id
        from employee
    </cfquery>
<!--- In Case of All Employees --->
    <cfloop query = "get_employees" >
        <cfif isDefined('form.chk_time#employee_id#')> <!--- for employees that are selected in checkbox --->
            <cfquery name = "get_duplicate_date">
                select date from attendance
                where date = '#form.attendance_date#' and employee_id = '#evaluate('form.employee_id#employee_id#')#'
            </cfquery>
            <cfif get_duplicate_date.recordCount eq 0>
                <cfquery name = "insert_checked_employees">
                    insert into attendance (employee_id, date, time_in, time_out)
                    values ( '#evaluate('form.employee_id#employee_id#')#' , '#form.attendance_date#', '#evaluate('form.time_in#employee_id#')#' , '#evaluate('form.time_out#employee_id#')#')
                </cfquery>
            <cfelse>
                <cfquery name = "update_attendance">
                    update attendance 
                    set time_in = '#evaluate('form.time_in#employee_id#')#' , time_out = '#evaluate('form.time_out#employee_id#')#'
                    where date = '#form.attendance_date#' and employee_id = '#evaluate('form.employee_id#employee_id#')#'
                </cfquery>
            </cfif>
        </cfif>
    </cfloop>
<!--- __________________________________ Front End ________________________________________ --->
<!--- Second Form for All Employees --->
    <form action = "add_attendance.cfm" method = "post">
        <input type = "date" name = "attendance_date" required <cfif isDefined('update_time')> value = "#form.attendance_date#" </cfif> > 
        Time In: <input type = "time" value = "09:00" name = "time_in">
        Time Out: <input type = "time" value = "18:00" name = "time_out">
        <input type = "submit" name = "update_time" value = "Submit">
    </form>
    <cfif isDefined('update_time')>    
        <form action = "add_attendance.cfm" method = "post"> 
            <p style = "display:inline; color:red; font-weight:bold;" > *Only Selected Employees will be updated</p>
            <table class = "table">
                <tr>
                    <th> Employee ID </th>
                    <th> Employee Name </th>
                    <th> Time In </th>
                    <th> Time Out </th>
                    <th>    <button type = "button" onclick = "javascript:selectAll();" >Select All </button> 
                            <button type = "button" onclick = "javascript:deSelectAll();"> Deselect All </button> 
                    </th>
                    <input  type = "date" name = "attendance_date" value = "#form.attendance_date#" required hidden = "true">

                </tr>
                <cfloop query = "get_employees">
                <tr>
                    <td> <input value = '#employee_id#' name = "employee_id#employee_id#" readonly> </td>
                    <td> <input value = '#name#' name = "first_name#employee_id#" readonly> </td>
                    <td> <input type = "time"value = "#form.time_in#" name = "time_in#employee_id#"> </td>
                    <td> <input type = "time" value = "#form.time_out#" name = "time_out#employee_id#"> </td>
                    <td> <input type = "checkbox" name = "chk_time#employee_id#" class = "chk_box"> </td>
                </tr>
                </cfloop>
            </table>
                <input type = "submit" name = "multiple_employees" value = "Submit">
        </form>
    </cfif>

<!--- JavaScript for Selecting and Deselecting All Checkboxes --->
        <script>  
            function selectAll(){  
                var elmnt = document.getElementsByClassName('chk_box');  
                for(var i=0; i<elmnt.length; i++){  
                    if(elmnt[i].type=='checkbox')  
                        elmnt[i].checked=true;  
                }  
            }  
            function deSelectAll(){  
                var elmnt = document.getElementsByClassName('chk_box');  
                for(var i=0; i<elmnt.length; i++){  
                    if(elmnt[i].type=='checkbox')  
                        elmnt[i].checked=false;    
                }  
            }             
        </script>
</cfif>
</cfoutput>
<cfinclude  template="foot.cfm">