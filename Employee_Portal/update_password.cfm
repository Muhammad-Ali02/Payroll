<cfinclude  template="\includes\head.cfm">
    <cfoutput>
        <cfif structKeyExists(form, "old_password")>
            <cfquery name="confirm_password">
                select * from emp_users
                where user_name = <cfqueryparam value="#session.loggedin.username#">
            </cfquery>
            <!--- This query get uuid against user --->
            <cfquery name="get_uuid">
                select *
                from uuid_table
                where user_name = <cfqueryparam value="#session.loggedin.username#">
            </cfquery>
            <cfset salt = get_uuid.uuid>
            <cfset password = "#form.old_password#">
            <cfset hashed_Password = hash(password & salt, "SHA-256")>
            <cfif confirm_password.password eq hashed_password>
                <cfset salt1 = get_uuid.uuid>
                <cfset password1 = "#form.new_password#">
                <cfset hashed_Password1 = hash(password1 & salt1, "SHA-256")>
                <cfquery name="update_password">
                    update emp_users
                    set password = <cfqueryparam value="#hashed_Password1#">
                    where user_name  = <cfqueryparam value="#session.loggedin.username#">
                </cfquery>
                <script>
                    alert("Your Password changed successfully!");
                    window.location.replace("\index.cfm");
                </script>
            <cfelse>
                <script>
                    alert("Sorry! You Enter Wrong Old Password");
                </script>
            </cfif>
        </cfif>
        <!--- Front End      --->
        <div class="employee_box">
            <div class="text-center mb-5">
                <h3 class="box_heading">Reset Your Password</h3>
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6">
                    <form action="" name="reset_password_form" onsubmit="return formValidate();" method="Post">
                        <table>
                            <tr>
                                <input type="password" name="old_password" id="old_password" class="form-control mb-3" placeholder="Enter Your Old Password" required>
                            </tr>
                            <tr>
                                <input type="password" name="new_password" id="new_password" class="form-control mb-3" placeholder="New Password" required>
                            </tr>
                            <tr>
                                <input type="password" name="confirm_password" id="confirm_password" class="form-control mb-3" placeholder="Confirm Password" required>
                            </tr>
                            <tr>
                                <div class="text-center">
                                    <input type="submit" value="Submit" class = "btn btn-outline-dark mt-3">
                                </div>
                            </tr>
                        </table>
                    </form>
                </div>
                <div class="col-md-3"></div>
            </div>
        </div>
    </cfoutput>
    <script>
        function formValidate(){
           var old_password = $("#old_password").val();
           var new_password = $("#new_password").val();
           var confirm_password = $("#confirm_password").val();
           if( old_password == "" || new_password == "" || confirm_password == ""){
                alert("All Field Must Be Fill Out!");
                return false;
           }else if( confirm_password != new_password){
                alert("Your Confirm Password Not Matched With New Password");
                return false;
           }else{
                return true;
           }
        }
    </script>
<cfinclude  template="\includes\foot.cfm">