<cfoutput>
 
<cfif structKeyExists(session, 'loggedin')>
    <cfquery name = "get_employees">
        select concat(first_name," ", middle_name, " " , last_name) as name , employee_id
        from employee
    </cfquery>
<!--- In Case of All Employees --->
    <cfif structKeyExists(form, 'multiple_employees')>
        <cfset inserted_employees = 0>
        <cfset updated_employees = 0>
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
                    <cfset inserted_employees = inserted_employees + 1>
                <cfelse>
                    <cfquery name = "update_attendance">
                        update attendance 
                        set time_in = '#evaluate('form.time_in#employee_id#')#' , time_out = '#evaluate('form.time_out#employee_id#')#'
                        where date = '#form.attendance_date#' and employee_id = '#evaluate('form.employee_id#employee_id#')#'
                    </cfquery>
                    <cfset updated_employees = updated_employees + 1>
                </cfif>
            </cfif>
        </cfloop>
        <div class="employee_box">
            <p> Attendance of #inserted_employees# Employees Inserted. </p>
            <p> Attendance of #updated_employees# Employees Updated. </p>
        </div>
    </cfif>
<!--- __________________________________ Front End ________________________________________ --->

    <cfif isDefined('update_time')> 
        <form action = "add_attendance.cfm" method = "post"> 
            <div class="d-flex justify-content-between">
                <p style = "display:inline; color:rgb(255, 255, 255, 0.8); font-weight:bold;" > *Only Selected Employees will be updated</p>
                <p style = "display:inline; color:rgb(255, 255, 255, 0.8); font-weight:bold;"><b>Attendance Date </b>: #form.ATTENDANCE_DATE#</p>
            </div>
            <div style="overflow-x: auto;">
                <table class = "table custom_table mt-3">
                    <tr>
                        <thead>
                            <th> Employee ID </th>
                            <th> Employee Name </th>
                            <th> Time In </th>
                            <th> Time Out </th>
                            <th style = "text-align:center">
                                <div class="form-check mt-1">
                                    <input type = "checkbox" onclick="chk_select();" class="form-check-input" id="chk_All" name = "chk_All"> 
                                    <label  for="chk_All" class="form-check-label"><span class="d-none"></span></label>
                                </div>
                                    <!-- <span onclick = "javascript:selectAll();" class="mr-2" > 
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check2-square" viewBox="0 0 16 16">
                                            <path d="M3 14.5A1.5 1.5 0 0 1 1.5 13V3A1.5 1.5 0 0 1 3 1.5h8a.5.5 0 0 1 0 1H3a.5.5 0 0 0-.5.5v10a.5.5 0 0 0 .5.5h10a.5.5 0 0 0 .5-.5V8a.5.5 0 0 1 1 0v5a1.5 1.5 0 0 1-1.5 1.5H3z"/>
                                            <path d="m8.354 10.354 7-7a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0z"/>
                                        </svg>
                                    </span> 
                                    <span onclick = "javascript:deSelectAll();"> 
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-slash-square" viewBox="0 0 16 16">
                                            <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
                                            <path d="M11.354 4.646a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708l6-6a.5.5 0 0 1 .708 0z"/>
                                        </svg> 
                                    </span>  -->
                            </th>
                        </thead>
                        <input  type = "date" name = "attendance_date" value = "#form.attendance_date#" required hidden = "true">
    
                    </tr>
                    <cfloop query = "get_employees">
                    <tr>
                        <td>
                            #employee_id#
                            <input value = '#employee_id#' name = "employee_id#employee_id#" readonly type = "hidden"> 
                        </td>
                        <td>
                            #name# 
                            <input value = '#name#' name = "first_name#employee_id#" readonly type = "hidden">
                        </td>
                        <td>
                            <input type = "time" class = "form-control" value = "#form.time_in#" name = "time_in#employee_id#"> 
                        </td>
                        <td>
                            <input type = "time" class = "form-control" value = "#form.time_out#" name = "time_out#employee_id#"> 
                        </td>
                        <td style = "text-align:center"> 
                            <div class="form-check mt-1">
                                <input type = "checkbox" class="form-check-input chk_box" id="chk_time#employee_id#" name = "chk_time#employee_id#"> 
                                <label  for="chk_time#employee_id#" class="form-check-label"><span class="d-none"></span></label>
                            </div>
                        </td>
                    </tr>
                    </cfloop>
                </table>
            </div>
            <div class="text-right">
                <input type = "submit" class = "btn btn-outline-dark" name = "multiple_employees" value = "Submit">
            </div>
        </form>
    <cfelse>
        <div class="employee_box">
            <div class="text-center">
                <h3 class="mb-5 box_heading"> Add Attendance Manually</h3>
            </div>
            <form action = "add_attendance.cfm" method = "post">
                <cfset current_date = dateFormat(now(), 'yyyy-mm-dd') >
                <div class = "row m-4">
                    <div class = "col-md-3">  
                        Date:      
                        <input type = "date" value = "#current_date#" name = "attendance_date" required class = "form-control" <cfif isDefined('update_time')> value = "#form.attendance_date#" </cfif> > 
                    </div>
                    <div class = "col-md-3">
                        Time In: <input type = "time" value = "09:00" name = "time_in" class = "form-control">
                    </div>
                    <div class = "col-md-3">
                        Time Out: <input type = "time" value = "18:00" name = "time_out" class = "form-control">
                    </div>
                    <div class = "col-md-3 mt-4">
                        <input type = "submit" class = "btn btn-outline-dark" name = "update_time" value = "Submit">
                    </div>
                </div>
            </form>
        </div>
    </cfif>

<!--- JavaScript for Selecting and Deselecting All Checkboxes --->
        <script>  
            function chk_select(){
                var checkBox = document.getElementById("chk_All");
                if(checkBox.checked == true){
                    selectAll();
                }else{
                    deSelectAll();
                }
            }
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
 