<cfoutput>
    <cfinclude  template="..\includes\head.cfm">
    <cfif structKeyExists(session, 'loggedin')>
        <!--- ____________________________________ Back End ______________________________________________ --->
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
        <!--- ____________________________________ Front End ______________________________________________ --->
        <cfif structKeyExists(url, 'generate')>
            <cfdocument pagetype="A4" orientation = "landscape" format="PDF" filename = "pay_slip#url.generate#.pdf" overwrite = "yes">
            <!DOCTYPE html>
            <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta http-equiv="X-UA-Compatible" content="IE=edge">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>PDF</title>
                </head>
                <body style = "padding: 0px 100px 100px 100px;">
                <div>
                    <h2 style = "text-align:center;"> BJS Soft Solution (PVT) Ltd. </h2>
                    <hr>
                    <p style = "text-align:center;"> 7 Jahangir Khan Road, St John Park, Lahore, Punjab, Pakistan</p>
                    <br>
                    <p style = "text-align:center;"><u><strong> Employee Pay Slip </strong></u></p>
                </div>
                    <div class = "container">    
                        <div class = "row">
                            <div class = "col-6" style = "position:absolute; top:150px;left:30px; font-size:15px;">
                                <p> Employee ID: <strong><u> #url.generate# </u></strong></p> 
                                <p> Employee Name:<strong><u> #pay_info.employee_name# </u></strong></p> 
                                <p> Designation:<strong><u> #pay_info.designation#</u></strong></p>
                            </div>
                            <div class = "col-6" style = "position:absolute; top:150px;right:30px; font-size:15px;">
                                <p> Month: <u><strong>#monthAsString(pay_info.month)# </strong></u></p>
                                <p> Year: <u><strong> #pay_info.year# </strong></u></p>
                                <p> Print Date: <u><strong> #dateFormat(now(),"dd-mmm-yyyy")# </strong></u></p>
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-6" style = "position:absolute; top:230px;left:100px; font-size:25px;">
                                <h5 style = "text-align:center;" > Earnings </h5>
                                <table class = "table" style = "border:2px solid;">
                                    <cfloop query = "allowances">
                                        <tr>
                                            <td>#name#</td>
                                            <td>#allowance_amount#</td>
                                        </tr>
                                    </cfloop>
                                    <tr style = "border:1px solid;border-collapse: collapse;">
                                        <td><strong>Total Allowances</strong></td>
                                        <td><strong>#pay_info.gross_allowances#</strong></td>
                                    </tr>
                                    <tr style = "border:1px solid;border-collapse: collapse;">
                                        <td><strong>Gross Salary</strong></td>
                                        <td><strong>#pay_info.gross_salary#</strong></td>
                                    </tr>
                                </table>
                            </div>
                            <div class = "col-6" style = "position:absolute; top:230px;right:100px; font-size:25px;">
                                <h5 style = "text-align:center;"> Deductions </h5>
                                <table class = "table" style = "border:2px solid;border-collapse: collapse;">
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
                                    <tr style = "border:1px solid;border-collapse: collapse;">
                                        <td><strong>Total Deductions</strong></td>
                                        <td><strong>#pay_info.gross_deductions#</strong></td>
                                    </tr>
                                    <tr style = "border:2px solid;border-collapse: collapse;">
                                        <td><strong>Net Salary</strong></td>
                                        <td><strong><u>#pay_info.net_salary#</u></strong></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div class = "row">
                            <div class = "col-4" style = "position:absolute; bottom:20px;left:16px; font-size:18px;">
                                <p> Transaction Mode: <strong><u>#pay_info.transaction_mode#</u></strong></p>
                            </div>
                            <cfif pay_info.transaction_mode neq 'cash'>
                                <div style = "position:absolute; bottom:20px;right:16px; font-size:18px;">
                                    <div class = "col-4">
                                        <p> Bank Name: <strong><u>#pay_info.bank_name# </u></strong></p>
                                    </div>
                                    <div class = "col-4">
                                        <p> Bank Account No. <strong><u>#pay_info.bank_account_no#</u></strong></p>
                                    </div>
                                </div>
                            </cfif>
                        </div>
                    </div>
                </body>
            </html>
            </cfdocument>
            <cfheader name = "content-disposition" value = "attachment;filename=pay_slip#url.generate#.pdf">
            <cfcontent type = "application/octet-stream" file = "#expandPath('.')#\pay_slip#url.generate#.pdf" deletefile = "yes">
        <cfelse>
            <form action = "pay_slip.cfm" method = "get">
                <div class = "row">   
                    <div class = "col-md-6">     
                            <select class = "form-select" name = "generate" required="true"> 
                                <option disabled> Select Employee </option> 
                                    <cfloop query="get_employees">
                                        <option value = "#employee_id#"> #name# </option>
                                    </cfloop>
                                </select>
                    </div>
                    <div class = "col-md-6">
                            <input type = "submit" class = "btn btn-outline-dark" value = "Generate Pay Slip">
                        </form>
                    </div>
                </div>
        </cfif>
    </cfif>
</cfoutput>
<cfinclude  template="..\includes\foot.cfm">