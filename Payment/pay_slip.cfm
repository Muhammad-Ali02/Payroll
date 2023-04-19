<cfoutput>
      
    <cfif structKeyExists(session, 'loggedin')>
        <!--- ____________________________________ Back End ______________________________________________ --->
        <cfquery name = "get_employees"> <!--- to print All employees list --->
            select a.employee_id, concat(b.employee_id,' | ',b.first_name,' ', b.middle_name, ' ', b.last_name) as name , b.official_email
            from current_month_pay a
            inner join employee b on a.employee_id = b.employee_id
            where processed = 'Y'
        </cfquery>
        <cfif structKeyExists(url, 'generate')>
            <cfquery name = "allowances"> <!--- Get Saved Allowances edited before process --->
                select a.*, b.allowance_name as name 
                from pay_allowance a
                inner join allowance b on a.allowance_id = b.allowance_id
                where a.employee_id = "#url.generate#" and a.status = "Y"
            </cfquery>
            <cfquery name = "deductions"> <!--- Get Saved Deductions edited before process --->
                select a.*, b.deduction_name as name , b.is_percent as percent
                from pay_deduction a
                inner join deduction b on a.deduction_id = b.deduction_id
                where employee_id = "#url.generate#" and a.status = "Y" and b.is_deleted = 'N'
            </cfquery>
            <cfquery name = "pay_info"> <!--- get all required  information about pay slip ---> 
                select a.*, concat(b.first_name,' ', b.middle_name, ' ', b.last_name) as employee_name, (
                    select 
                    d.designation_title 
                    from designation d
                    inner join employee e on d.designation_id = e.designation
                    where e.employee_id = "#url.generate#")
                as designation
                from current_month_pay a
                inner join employee b on a.employee_id = b.employee_id
                where a.employee_id = "#url.generate#"
            </cfquery>
        </cfif>
        <!--- ____________________________________ Front End ______________________________________________ --->
        <cfif structKeyExists(url, 'generate')>
            <cfdocument pagetype="A4" orientation = "landscape" format="PDF" filename = "pay_slip#url.generate#.pdf" overwrite = "yes"> 
                <cfinclude  template="pay_slip_process.cfm">
            </cfdocument>
            <cfheader name = "content-disposition" value = "attachment;filename=pay_slip#url.generate#.pdf">
            <cfcontent type = "application/octet-stream" file = "#expandPath('.')#\pay_slip#url.generate#.pdf" deletefile = "yes">
        <cfelse>
            <form action = "pay_slip.cfm" method = "get">
                <div class="employee_box">
                    <div class="mb-5 text-center">
                        <h3 class="box_heading">Generate Pay Slip<h3>
                    </div>
                    <div class = "row">  
                        <div class="col-md-2"></div> 
                        <div class = "col-md-5 mb-2">     
                                <select class = "form-select" name = "generate" required="true"> 
                                    <option value=""> -- Select Employee -- </option> 
                                        <cfloop query="get_employees">
                                            <option value = "#employee_id#"> #name# </option>
                                        </cfloop>
                                    </select>
                        </div>
                        <div class = "col-md-3">
                                <input type = "submit" class = "btn btn-outline-dark" value = "Generate Pay Slip">
                        </div>
                        <div class="col-md-2"></div>
                    </div>
                </div>
            </form>
        </cfif>
    </cfif>

</cfoutput>
 