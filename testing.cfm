<cfoutput>
        <cfquery name = "get_employees"> <!--- to print All employees list --->
            select a.employee_id, concat(b.employee_id,' | ',b.first_name,' ', b.middle_name, ' ', b.last_name) as name
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
                select a.*, b.deduction_name as name 
                from pay_deduction a
                inner join deduction b on a.deduction_id = b.deduction_id
                where employee_id = "#url.generate#" and a.status = "Y"
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
    <table border = "2">    
        <tr>
            <td colspan = "2">
                <p> Employee ID: <strong><u> #url.generate# </u></strong></p> 
                <p> Employee Name:<strong><u> #pay_info.employee_name# </u></strong></p> 
                <p> Designation:<strong><u> #pay_info.designation#</u></strong></p>
            </td>
            <td colspan = "2">
                <p> Month: <u><strong>#monthAsString(pay_info.month)# </strong></u></p>
                <p> Year: <u><strong> #pay_info.year# </strong></u></p>
                <p> Print Date: <u><strong> #dateFormat(now(),"dd-mmm-yyyy")# </strong></u></p>
            </td>
        </tr>
        <tr>
            <td colspan = "2"> Earnings </td>
            <td colspan = "2"> Deductions </td>
        </tr>

                <cfloop query = "allowances">
                    <tr>
                        <td>#name#</td>
                        <td>#allowance_amount#</td>
                    </tr>
                </cfloop>
                <tr>
                    <td><strong>Total Allowances</strong></td>
                    <td><strong>#pay_info.gross_allowances#</strong></td>
                </tr>
                <tr>
                    <td><strong>Gross Salary</strong></td>
                    <td><strong>#pay_info.gross_salary#</strong></td>
                </tr>
            </td>
                    <tr>
                        <td>Leaves</td>
                        <td>
                            <cfset leaves = (pay_info.leaves_without_pay + (pay_info.half_paid_leaves/2)) * pay_info.basic_rate> 
                            #leaves#
                        </td>
                    </tr>
                    
                    <cfloop query = "deductions">
                        <tr>
                            <td>#name#</td>
                            <td>#deduction_amount#</td>
                        </tr>
                    </cfloop>
                    <tr>
                        <td><strong>Total Deductions</strong></td>
                        <td><strong>#pay_info.gross_deductions#</strong></td>
                    </tr>
                    <tr>
                        <td><strong>Net Salary</strong></td>
                        <td><strong>#pay_info.net_salary#</strong></td>
                    </tr>
        </tr>
        <tr>
            <td>
                <p> Transaction Mode: <strong><u>#pay_info.transaction_mode#</u></strong></p>
            </td>
            <cfif pay_info.transaction_mode neq 'cash'>
                <td>
                    <p> Bank Name: <strong><u>#pay_info.bank_name# </u></strong></p>
                </td>
                <td>
                    <p> Bank Account No. <strong><u>#pay_info.bank_account_no#</u></strong></p>
                </td>
            </cfif>
        </tr>
    </table>
</cfoutput>