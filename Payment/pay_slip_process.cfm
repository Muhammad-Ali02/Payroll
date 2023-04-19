<cfoutput>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PDF</title>
        <style>
            td{
                padding-left: 14px;
            }
        </style>
    </head>
    <body style = "padding: 0px 100px 100px 100px;">
        <div>
            <h2 style="text-align: center;"> BJS Soft Solution (PVT) Ltd. </h2>
            <p style="text-align: center;"> 7 Jahangir Khan Road, St John Park, Lahore, Punjab, Pakistan</p>
            <!-- <div style="display: flex; justify-content: center; align-items: center; gap: 40px;">
                <div style="margin-top: 30px;">
                    <img style="width: 90px; height: 90px;" alt="bjs_logo" src="\img\logo_background.png">
                </div>
                <div style="text-align: start;">
                </div>    
            </div> -->
        <hr>
        <br>
        <p style = "text-align:center;"><u><strong> Employee Pay Slip </strong></u></p>
    </div>
        <div class = "container">    
            <div class = "row">
                <div class = "col-6" style = "position:absolute; top:150px;left:30px; font-size:15px;">
                    <p> Employee ID: <strong><u> #get_employees.employee_id# </u></strong></p> 
                    <p> Employee Name:<strong><u> #pay_info.employee_name# </u></strong></p> 
                    <p> Designation:<strong><u> #pay_info.designation#</u></strong></p>
                </div>
                <div class = "col-6" style = "position:absolute; top:150px;right:30px; font-size:15px;">
                    <p> Month: <u><strong>#monthAsString(pay_info.month)# </strong> <strong> #pay_info.year# </strong></u></p>
<!---                                 <p> Year: <u></u></p> --->
                    <p> Days Worked : <strong>#pay_info.days_worked#</strong></p>
                    <p> Working Days : <strong>#pay_info.working_days#</strong></p>
                    <p> Print Date: <u><strong> #dateFormat(now(),"dd-mmm-yyyy")# </strong></u></p>
                </div>
            </div>
            <div class = "row">
                <div class = "col-6" style = "position:absolute; top:250px;left:100px; font-size:25px;">
                    <h5 style = "text-align:center;" > Earnings </h5>
                    <table class = "table" style = "border:2px solid; padding: 4px;">
                        <cfloop query = "allowances">
                            <tr>
                                <td>#name#</td>
                                <td>#allowance_amount#</td>
                            </tr>
                        </cfloop>
                        <tr>
                            <cfset basic_pay = pay_info.gross_salary - pay_info.gross_allowances>
                            <td><strong>Basic Salary</strong></td>
                            <td>
                                <strong>
                                    #evaluate("NumberFormat(#basic_pay#,'0.00')")#
                                </strong>
                            </td>
                        </tr>
                        <tr style = "border:1px solid;border-collapse: collapse;">
                            <td><strong>Total Allowances</strong></td>
                            <td><strong>#evaluate("numberFormat(#pay_info.gross_allowances#,'0.00')")#</strong></td>
                        </tr>
                        <tr style = "border:1px solid;border-collapse: collapse;">
                            <td><strong>Gross Salary</strong></td>
                            <td><strong>#evaluate("numberFormat(#pay_info.gross_salary#,'0.00')")#</strong></td>
                        </tr>
                    </table>
                </div>
                <div class = "col-6" style = "position:absolute; top:250px;right:100px; font-size:25px;">
                    <h5 style = "text-align:center;"> Deductions </h5>
                    <table class = "table" style = "border:2px solid; padding: 4px;">
                        <tr>
                            <td>Leaves</td>
                            <td>
                                <cfset leaves = (pay_info.leaves_without_pay + (pay_info.half_paid_leaves/2)) * pay_info.basic_rate> 
                                #leaves#
                            </td>
                        </tr>
                        
                        <cfloop query = "deductions">
                            <tr>
                                <cfif percent eq 'Y'>
                                    <cfset amount_of_percentage_tax = (#pay_info.gross_salary#/100) * deduction_amount >
                                    <td>#name# #deduction_amount# %</td>
                                    <td>#evaluate("numberFormat(#amount_of_percentage_tax#,'0.00')")#</td>
                                <cfelse>
                                    <td>#name#</td>
                                    <td>#deduction_amount#</td>
                                </cfif>
                            </tr>
                        </cfloop>
                        <tr style = "border:1px solid;border-collapse: collapse;">
                            <td><strong>Total Deductions</strong></td>
                            <td><strong>#evaluate("numberFormat(#pay_info.gross_deductions#,'0.00')")#</strong></td>
                        </tr>
                        <tr style = "border:2px solid;border-collapse: collapse;">
                            <td><strong>Net Salary</strong></td>
                            <td><strong><u>#evaluate("numberFormat(#pay_info.net_salary#, '0.00')")#</u></strong></td>
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
</cfoutput>