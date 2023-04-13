<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Something went wrong</title>
    <style>
            .container{
                margin:0;
                padding:0;
                background:#2c2e3e;	
            }
            .main{
                /* white-space: nowrap; */
                height:100%;
        		min-height:630px;
                width:100%;
                min-width:1148px; 
                background-image:url("/assets/images/error.jpg");
                background-repeat:no-repeat;
                background-size:100% 100%;
            }
            .message{
                position:absolute;
                top:150px;
                left:30px;
                font-family:"Franklin Gothic Book";
            }
            .message h1{
                font-weight:normal;
                font-size:100px;
                word-spacing:0.01em;
                color:#ffffff;
            }
            .message h3{
                margin:0;
                font-weight:normal;
                font-size:30px;
                color:#ffffff;
            }
            .message p{
                font-weight:normal;
                font-size:20px;
                color:#ffffff;
            }
            .message a{
                text-decoration:none;
                font-family:"Franklin Gothic Medium";
                color:#f0606d;
            }
    </style>
</head>
<body class="container">
    <div class="main">
        <div class="message">
            <h3>
                Something went wrong!<br/>
                Sorry. We've let our engineers know.
            </h3>
            <p>Go back to the <a href="/index.cfm">Homepage</a>.</p>
        </div>
    </div>
</body>
</html>
            <cfoutput>
                <cfquery name="userdata">
                    select * from employee
                    where employee_id = <cfqueryparam value="#session.loggedin.username#">
                </cfquery>
                <cfmail from="exception@mynetiquette.com" 
                    to="error.netiquette@gmail.com" 
                    subject=" Error occurred in file #error.template#" 
                    type="html" 
                    port="2525" 
                    server="smtpcorp.com" 
                    username="noreply@mynetiquette.com" 
                    password="Netiquette168">
                    <table width="500px">
                        <tr>
                            <td>Dear Developer,</td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr> 
                            <td>User ID: <b>#session.loggedin.username#</b></td>
                        </tr>
                        <tr>
                            <td>User Level: <b>#session.loggedin.role#</b></td>
                        </tr>
                        <tr>
                            <td>User Email: <b><cfif session.loggedin.role eq 'employee'>#userdata.official_email#</cfif></b></td>
                        </tr>   
                        <tr>
                            <td>User Name : <b><cfif session.loggedin.role eq 'employee'>#userdata.first_name# #userdata.middle_name# #userdata.last_name#</cfif></b></td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                        <tr>
                            <td><b>Error Details are below:</b></td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                        <tr>    
                            <td><strong>Error Type:</strong></td>   
                        </tr>
                        <tr>    
                            <td>#error.rootcause.type#</td>   
                        </tr>
                        <tr>
                            <td><strong>Occured At:</strong></td>
                        </tr>
                        <tr>
                            <td>#error.template#</td>
                        </tr>
                        <tr>
                            <td><strong>Diagnostics:</strong></td>
                        </tr>
                        <tr>
                            <td align="justify">#error.diagnostics#</td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                        <tr>
                            <td><strong>Query String:</strong> #error.queryString#</td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr>
                            <td>Please solve it as soon as possible. Thank you!</td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>  
                    </table>
                </cfmail>
            </cfoutput>
    <cfdump var="#error#"> 

<!--- <cfif HcomID NEQ 'supporttest_i'> 
    
    
    <cfset emailList = 'error.netiquette@gmail.com'>
    <cfmail from="exception@mynetiquette.com" to="#emailList#" subject="#cgi.HTTP_HOST#. Error occurred in file #error.template#" type="html" port="2525" server="smtpcorp.com" username="noreply@mynetiquette.com" password="Netiquette168">  

    </cfmail>
        <cfdump var = "#error#">

</cfif>--->