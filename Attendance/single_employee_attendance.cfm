<cfoutput> 
    <cfif structKeyExists(session, 'loggedin')>
        <cfquery name = "get_employees">
            select concat(employee_id,' | ',first_name,' ', middle_name, ' ', last_name) as name , employee_id
            from employee
            where leaving_date IS NULL or leaving_date = ""
        </cfquery>
        <cfif structKeyExists(form, 'update_time')>
            <cftry>
                <cftransaction>
                    <cfquery name = "get_duplicate_date">
                        select date from attendance
                        where date = <cfqueryparam value="#form.attendance_date#"> and employee_id = <cfqueryparam value="#form.employee_id#">
                    </cfquery>
                    <cfif get_duplicate_date.recordCount eq 0>
                        <cfquery name = "insert_checked_employees">
                            insert into attendance (employee_id, date, time_in, time_out)
                            values ( <cfqueryparam value="#form.employee_id#"> , <cfqueryparam value="#form.attendance_date#">, <cfqueryparam value="#form.time_in#"> , <cfqueryparam value="#form.time_out#">)
                        </cfquery>
                        <cfset inserted_employees = true>
                    <cfelse>
                        <cfquery name = "update_attendance">
                            update attendance 
                            set time_in = <cfqueryparam value="#form.time_in#"> , time_out = <cfqueryparam value="#form.time_out#">
                            where date = <cfqueryparam value="#form.attendance_date#"> and employee_id = <cfqueryparam value="#form.employee_id#">
                        </cfquery>
                        <cfset inserted_employees = false>
                    </cfif>
                </cftransaction>
                <!---<div class="employee_box">--->
                <!--- script for showing alert by Kamal Ahmad--->
                    <cfif inserted_employees eq true>
                        <script>
                            alert("Attendance of #form.employee_id# is Inserted.") 
                        </script>
                    <cfelse>
                        <script>
                            alert("Attendance of #form.employee_id# is Updated.")
                        </script>
                    </cfif>
                <!---</div>--->
            <cfcatch type="any">
                <cfdump  var="#cfcatch.cause.message#">
            </cfcatch>
            </cftry>
        </cfif>
    </cfif>
    <!---   Front End   --->
    <div class="employee_box">
            <div class="text-center">
                <h3 class="mb-5 box_heading"> Add Attendance Manually</h3>
            </div>
            <form action = "" method = "post">
                <cfset current_date = dateFormat(now(), 'yyyy-mm-dd') >
                <div class = "row m-4">
                    <div class = "col-md-4">  
                        Date:      
                        <input type = "date" value = "#current_date#" name = "attendance_date" required class = "form-control" <cfif isDefined('update_time')> value = "#form.attendance_date#" </cfif> > 
                    </div>
                    <div class = "col-md-4">
                        Time In: <input type = "time" value = "09:00" name = "time_in" class = "form-control">
                    </div>
                    <div class = "col-md-4">
                        Time Out: <input type = "time" value = "18:00" name = "time_out" class = "form-control">
                    </div>
                </div>
                <div class="row m-4">
                    <div class="col-md-8">
                        Select Employee:
                        <select class="form-select" onfocus='this.size=5;' onblur='this.size=1;' onchange='this.size=1; this.blur();' name="employee_id" id="employee_id">
                            <option value="">-- Select Employee --</option>
                            <cfloop query="get_employees">
                                <option value = "#employee_id#"> #name# </option>
                            </cfloop>
                        </select>
                    </div>
                    <div class = "col-md-3 mt-4">
                        <input type = "submit" class = "btn btn-outline-dark" name = "update_time" value = "Submit">
                    </div>
                </div>
            </form>
        </div>
</cfoutput>