<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>BJS Soft Solution</title>
    <cfinclude  template="bootstrap.cfm">
    <!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" type="text/css" href="/assets/bootstrap/css/bootstrap.css" />
    <!-- <link rel="stylesheet" type="text/css" href="/assets/bootstrap/js/bootstrap.js" /> -->
    <!--- <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">  --->
    <!-- Custom CSS For Sidebar -->
    <link rel="stylesheet" href="..\css\style5.css">

    <!-- Font Awesome JS -->
    <link 
        rel="stylesheet" 
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" 
        integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" 
        crossorigin="anonymous" referrerpolicy="no-referrer" 
    />    
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/solid.js" integrity="sha384-tzzSw1/Vo+0N5UhStP3bvwWPq+uvzCMfrN1fEFe+xBmv1C/AtVX5K0uZtmcHitFZ" crossorigin="anonymous"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.0.13/js/fontawesome.js" integrity="sha384-6OIrr52G08NpOFSZdxxz1xdNSndlD4vdcf/q2myIUVO0VsqaGHJsB0RaBE01VTOY" crossorigin="anonymous"></script>
</head>
<body>
<cfoutput>
    <div class="wrapper">
        <!-- Sidebar Holder -->
        <nav id="sidebar">
            <div class="sidebar-header">
        <!--- <h3>BJS Soft Solution</h3> --->
                <div class = "container">
                    <a href = "https://bjssoftsolutions.com/" target = "blank">
                        <img src = "..\img\logo.png" alt "BJS Soft Solution" >
                    </a>
                </div>
            </div>

            <ul class="list-unstyled components">
<!---                 <p>BJS Payroll</p> --->
                <cfif session.loggedIn.role neq 'employee'>
                    <li>
                        <a href="..\employees\all_employees.cfm"> 
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-person-lines-fill" viewBox="0 0 16 16">
                                <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm-5 6s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H1zM11 3.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 0 1h-4a.5.5 0 0 1-.5-.5zm.5 2.5a.5.5 0 0 0 0 1h4a.5.5 0 0 0 0-1h-4zm2 3a.5.5 0 0 0 0 1h2a.5.5 0 0 0 0-1h-2zm0 3a.5.5 0 0 0 0 1h2a.5.5 0 0 0 0-1h-2z"/>
                            </svg>
                            Employees
                        </a>
                    </li>
                    <li>
                        <a href="##attendanceSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-layout-text-window-reverse" viewBox="0 0 16 16">
                                <path d="M13 6.5a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h5a.5.5 0 0 0 .5-.5zm0 3a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h5a.5.5 0 0 0 .5-.5zm-.5 2.5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1 0-1h5z"/>
                                <path d="M14 0a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h12zM2 1a1 1 0 0 0-1 1v1h14V2a1 1 0 0 0-1-1H2zM1 4v10a1 1 0 0 0 1 1h2V4H1zm4 0v11h9a1 1 0 0 0 1-1V4H5z"/>
                            </svg>
                            Attendance
                        </a>
                        <ul class="collapse list-unstyled" id="attendanceSubmenu">
                            <li>
                                <a href="..\attendance\attendance.cfm">Attendance Sheet</a>
                            </li>
                            <li>
                                <a href="..\attendance\add_attendance.cfm">Manual Attendance</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="##adminSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-mortarboard" viewBox="0 0 16 16">
                                <path d="M8.211 2.047a.5.5 0 0 0-.422 0l-7.5 3.5a.5.5 0 0 0 .025.917l7.5 3a.5.5 0 0 0 .372 0L14 7.14V13a1 1 0 0 0-1 1v2h3v-2a1 1 0 0 0-1-1V6.739l.686-.275a.5.5 0 0 0 .025-.917l-7.5-3.5ZM8 8.46 1.758 5.965 8 3.052l6.242 2.913L8 8.46Z"/>
                                <path d="M4.176 9.032a.5.5 0 0 0-.656.327l-.5 1.7a.5.5 0 0 0 .294.605l4.5 1.8a.5.5 0 0 0 .372 0l4.5-1.8a.5.5 0 0 0 .294-.605l-.5-1.7a.5.5 0 0 0-.656-.327L8 10.466 4.176 9.032Zm-.068 1.873.22-.748 3.496 1.311a.5.5 0 0 0 .352 0l3.496-1.311.22.748L8 12.46l-3.892-1.556Z"/>
                            </svg>
                            Administrator
                        </a>
                        <ul class="collapse list-unstyled" id="adminSubmenu">
                            <li>
                                <a href="..\administrator\all_users.cfm">Manange Users</a>
                            </li>
                            <li>
                                <a href="..\administrator\leave_approval.cfm">Leave Approval</a>
                            </li>
                            <li>
                                <a href="/administrator/loan_approval.cfm">Loan Approval</a>
                            </li>
                            <li>
                                <a href="/administrator/advance_salary_approval.cfm">Advance Salary Approval</a>
                            </li>
                            <li>
                                <a href="..\administrator\change_employee_No.cfm">Change Employee No.</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="##processSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-cash-stack" viewBox="0 0 16 16">
                                <path d="M1 3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1H1zm7 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/>
                                <path d="M0 5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V5zm3 0a2 2 0 0 1-2 2v4a2 2 0 0 1 2 2h10a2 2 0 0 1 2-2V7a2 2 0 0 1-2-2H3z"/>
                            </svg>
                            Payment
                        </a>
                        <ul class="collapse list-unstyled" id="processSubmenu">
                            <li>
                                <a href="..\payment\pay.cfm">Pay Process</a>
                            </li>
                            <li>
                                <a href="..\payment\pay_slip.cfm">Generate Payslip</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="##employeeSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16">
                                <path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
                                <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/>
                            </svg>
                            General Setup
                        </a>
                        <ul class="collapse list-unstyled" id="employeeSubmenu">
                            <li>
                                <a href="..\general_setup\setting.cfm">System Setting</a>
                            </li>
                            <li>
                                <a href="..\general_setup\all_workingdays.cfm">Manange Working Days</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="##internalSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-house-gear-fill" viewBox="0 0 16 16">
                                <path d="M7.293 1.5a1 1 0 0 1 1.414 0L11 3.793V2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v3.293l2.354 2.353a.5.5 0 0 1-.708.708L8 2.207 1.354 8.854a.5.5 0 1 1-.708-.708L7.293 1.5Z"/>
                                <path d="M11.07 9.047a1.5 1.5 0 0 0-1.742.26l-.02.021a1.5 1.5 0 0 0-.261 1.742 1.5 1.5 0 0 0 0 2.86 1.504 1.504 0 0 0-.12 1.07H3.5A1.5 1.5 0 0 1 2 13.5V9.293l6-6 4.724 4.724a1.5 1.5 0 0 0-1.654 1.03Z"/>
                                <path d="m13.158 9.608-.043-.148c-.181-.613-1.049-.613-1.23 0l-.043.148a.64.64 0 0 1-.921.382l-.136-.074c-.561-.306-1.175.308-.87.869l.075.136a.64.64 0 0 1-.382.92l-.148.045c-.613.18-.613 1.048 0 1.229l.148.043a.64.64 0 0 1 .382.921l-.074.136c-.306.561.308 1.175.869.87l.136-.075a.64.64 0 0 1 .92.382l.045.149c.18.612 1.048.612 1.229 0l.043-.15a.64.64 0 0 1 .921-.38l.136.074c.561.305 1.175-.309.87-.87l-.075-.136a.64.64 0 0 1 .382-.92l.149-.044c.612-.181.612-1.049 0-1.23l-.15-.043a.64.64 0 0 1-.38-.921l.074-.136c.305-.561-.309-1.175-.87-.87l-.136.075a.64.64 0 0 1-.92-.382ZM12.5 14a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3Z"/>
                            </svg>
                            Internal Setup
                        </a>
                        <ul class="collapse list-unstyled" id="internalSubmenu">
                            <li>
                                <a href="..\internal_setup\all_designation.cfm">Designations</a>
                            </li>
                            <li>
                                <a href="..\internal_setup\all_departments.cfm" >Departments</a>
                            </li>
                            <li>
                                <a href="..\internal_setup\all_allowance.cfm">Allowances</a>
                            </li>
                            <li>
                                <a href="..\internal_setup\all_deduction.cfm">Deductions</a>
                            </li>
                            <li>
                                <a href="..\internal_setup\all_leaves.cfm">Leaves</a>
                            </li>
                        </ul>
                    </li>
                </cfif>
                <cfif session.loggedIn.role eq 'employee'>
                    <li>
                        <a href="##leavesSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-card-heading" viewBox="0 0 16 16">
                                <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h13zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-13z"/>
                                <path d="M3 8.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5zm0-5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5v-1z"/>
                            </svg>
                            Leaves
                        </a>
                        <ul class="collapse list-unstyled" id="leavesSubmenu">
                            <li>
                                <a href="..\employee_portal\allowed_leaves.cfm">Available Leaves</a>
                            </li>
                            <li>
                                <a href="..\employee_portal\leave_requests.cfm">Leave Requests</a>
                            </li>
                            <li>
                                <a href="..\employee_portal\request_leave.cfm">Request For Leave</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="##loansSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-cash-stack" viewBox="0 0 16 16">
                                <path d="M1 3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1H1zm7 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/>
                                <path d="M0 5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V5zm3 0a2 2 0 0 1-2 2v4a2 2 0 0 1 2 2h10a2 2 0 0 1 2-2V7a2 2 0 0 1-2-2H3z"/>
                            </svg>
                            Loans
                        </a>
                        <ul class="collapse list-unstyled" id="loansSubmenu">
                            <li>
                                <a href="..\employee_portal\loan_requests.cfm">Loan Requests</a>
                            </li>
                            <li>
                                <a href="..\employee_portal\loan_apply.cfm">Apply Loan</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="##salarySubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-cash-stack" viewBox="0 0 16 16">
                                <path d="M1 3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1H1zm7 8a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/>
                                <path d="M0 5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1H1a1 1 0 0 1-1-1V5zm3 0a2 2 0 0 1-2 2v4a2 2 0 0 1 2 2h10a2 2 0 0 1 2-2V7a2 2 0 0 1-2-2H3z"/>
                            </svg>
                            Advance Salary
                        </a>
                        <ul class="collapse list-unstyled" id="salarySubmenu">
                            <li>
                                <a href="..\employee_portal\AdvanceSalary_request.cfm">Advance Salary Request</a>
                            </li>
                            <li>
                                <a href="..\employee_portal\AdvanceSalary.cfm">Apply for Salary Advance</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="##settingSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-gear-fill" viewBox="0 0 16 16">
                                <path d="M9.405 1.05c-.413-1.4-2.397-1.4-2.81 0l-.1.34a1.464 1.464 0 0 1-2.105.872l-.31-.17c-1.283-.698-2.686.705-1.987 1.987l.169.311c.446.82.023 1.841-.872 2.105l-.34.1c-1.4.413-1.4 2.397 0 2.81l.34.1a1.464 1.464 0 0 1 .872 2.105l-.17.31c-.698 1.283.705 2.686 1.987 1.987l.311-.169a1.464 1.464 0 0 1 2.105.872l.1.34c.413 1.4 2.397 1.4 2.81 0l.1-.34a1.464 1.464 0 0 1 2.105-.872l.31.17c1.283.698 2.686-.705 1.987-1.987l-.169-.311a1.464 1.464 0 0 1 .872-2.105l.34-.1c1.4-.413 1.4-2.397 0-2.81l-.34-.1a1.464 1.464 0 0 1-.872-2.105l.17-.31c.698-1.283-.705-2.686-1.987-1.987l-.311.169a1.464 1.464 0 0 1-2.105-.872l-.1-.34zM8 10.93a2.929 2.929 0 1 1 0-5.86 2.929 2.929 0 0 1 0 5.858z"/>
                            </svg>
                            Settings
                        </a>
                        <ul class="collapse list-unstyled" id="settingSubmenu">
                            <li>
                                <a href="..\employee_portal\update_password.cfm">Reset Password</a>
                            </li>
                        </ul>
                    </li>
                </cfif>
            </ul>

            <!--- <ul class="list-unstyled CTAs">
                <li>
                    <a href="https://bootstrapious.com/tutorial/files/sidebar.zip" class="download">Download source</a>
                </li>
                <li>
                    <a href="https://bootstrapious.com/p/bootstrap-sidebar" class="article">Back to article</a>
                </li>
            </ul> --->
        </nav>

        <!-- Page Content Holder -->
        <div id="content">
            <cfif session.loggedIn.role eq 'employee'>
                <cfquery datasource="payroll" name="checks">
                    select * from attendance
                    where employee_id="#session.loggedIn.username#" And date= "#DateFormat(Now(), "yyyy,mm,dd")#"
                </cfquery>
                <cfif isDefined('url.action') And "#url.action#" eq "checkin">
                    <cfif checks.RecordCount gte "1" >
                        <script>
                            // alert("You have already checked In.");
                            window.location.assign("\index.cfm");
                        </script>
                    <cfelse>
                        <cfquery datasource="payroll" name="checkin">
                            insert into attendance (employee_id, date, time_in)
                            values (<cfqueryparam value="#session.loggedIn.username#">, <cfqueryparam value="#DateFormat(Now(), "yyyy,mm,dd")#">, <cfqueryparam value="#TimeFormat(Now(), "HH:mm:ss.llll")#">)
                        </cfquery>
                        <cfquery datasource="payroll" name="checks">
                            select * from attendance
                            where employee_id="#session.loggedIn.username#" And date= "#DateFormat(Now(), "yyyy,mm,dd")#"
                        </cfquery>
                    </cfif>
                </cfif>
            </cfif>
            <nav class="navbar navbar-expand-lg nav_head">
                <div class="container-fluid " >
                    <button type="button" id="sidebarCollapse" class="navbar-btn" style = "background-color:transparent; color:white;">
                        <i class="fa-solid fa-angle-left fs-12"></i>
                        <!--- <span></span>
                        <span></span>
                        <span></span> --->
                    </button>
                    <button class="btn btn-dark d-inline-block d-lg-none ml-auto" type="button" data-toggle="collapse" data-target="##navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <i class="fas fa-align-justify"></i>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="nav navbar-nav ml-auto">
                            <cfif session.loggedIn.role eq 'employee'>
                                <cfif checks.RecordCount eq "1" And checks.time_out eq "">
                                    <cfwindow title="CheckOut" name="CheckOut" bodystyle="background-color: ##4c4858;" center="true" closable="true" height="250" width="350" modal="true" initshow="false">
                                        <div class="text-center m-3 ">
                                            <h5 class="Medium fs-14 text-justify" style="color: rgb(247, 245, 245, 0.7); font-family: Arial, Helvetica, sans-serif;">
                                                Please make sure to checkout by pressing the 'Check-Out' button before proceeding logout.
                                            </h5>
                                        </div>
                                        <div class="text-center m-2">
                                            <a href="/employee_portal/checkout.cfm?action=checkout" id="out" onclick="ColdFusion.Window.hide('CheckOut')" class="btn custom_button fs-8 text-light bg-dark">
                                                check-out
                                            </a>
                                        </div>
                                    </cfwindow>
                                    <li class="nav-item">
                                    </li>
                                </cfif>
                                <cfif checks.RecordCount eq "0">
                                    <cfwindow title="CheckIn" name="checkIn" bodystyle="background-color: ##4c4858;" center="true" closable="false" height="250" width="350" modal="true" initshow="true">
                                        <div class="text-center m-3 ">
                                            <h5 class="Medium fs-14 text-justify" style="color: rgb(247, 245, 245, 0.7); font-family: Arial, Helvetica, sans-serif;">
                                                Please make sure to check in by pressing the 'Check-In' button before proceeding with any activity.
                                            </h5>
                                        </div>
                                        <div class="text-center m-2">
                                            <a href="?action=checkin"  id="in" onclick="ColdFusion.Window.hide('checkIn')" class="btn custom_button fs-8 text-light bg-dark">
                                                check-in
                                            </a>
                                        </div>
                                    </cfwindow>
                                    <li class="nav-item">
                                    </li>
                                </cfif>
                            </cfif>
                            <li class="nav-item active">
                                <a class="nav-link" href="\index.cfm">
                                    <!--- Home Icon --->
                                    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="white" class="bi bi-house navebar_icon" viewBox="0 0 16 16">
                                        <path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5ZM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5 5 5Z"/>
                                    </svg>
                                </a>
                            </li>
                            <cfif session.loggedIn.role eq 'employee'>
                                <li class="nav-item">
                                    <!--- logout icon --->
                                    <cfif checks.RecordCount eq "1" And checks.time_out eq "">
                                        <a class="nav-link" onclick="ColdFusion.Window.show('CheckOut')" href="##">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-box-arrow-right navebar_icon" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0v2z"/>
                                                <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
                                            </svg>
                                        </a>
                                    <cfelse>
                                        <a class="nav-link" href="\login\user_login.cfm?logout=true">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-box-arrow-right navebar_icon" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0v2z"/>
                                                <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
                                            </svg>
                                        </a>
                                    </cfif>
                                </li>
                            <cfelse>
                                <li class="nav-item">
                                <!--- logout icon --->
                                <a class="nav-link" href="\login\user_login.cfm?logout=true">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-box-arrow-right navebar_icon" viewBox="0 0 16 16">
                                        <path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0v2z"/>
                                        <path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
                                    </svg>
                                </a>
                            </li>
                            </cfif>
                        </ul>
                    </div>
                </div>
            </nav>
            <!-- <iframe src = "https://bjssoftsolutions.com" width='100%' height='100%' title="Wellcome to BJS Soft Solution"> </iframe> -->
</cfoutput>
<script>
    function buttonStatus(){
        debugger;
        const myButton = document.getElementById('in');
        myButton.style.display = 'none';
        // const myButton1 = document.getElementById('out');
        // myButton1.style.display = 'inline-block';
    }
    function buttonStatus2(){
        const myButton = document.getElementById('out');
        myButton.style.display = 'none';
    }
</script>