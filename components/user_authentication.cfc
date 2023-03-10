<cfcomponent output = "false">
    <!--- Just for later use 
    <!--- validate_user method will authenticate user data --->
    <cffunction  name="validate_user" access="public" output="false" returntype="array">
        <cfargument  name="user_email" type = "string" required = "true" />
        <cfargument  name="user_password" type = "string" required = "true" />
            <!--- An Array for Error massage in case of invalid email --->
                <cfset errorMassage = arrayNew(1)>
                    <cfif NOT isValid('email', argument.user_email)>
                        <cfset arrayAppend = "Please Provide a Valid Email Address">
                    </cfif>
                    error massage for empty password 
                <cfset errorMassage = arrayNew(1)>
                    <cfif argument.user_password eq '' >
                        <cfset arrayAppend = "Please Provide a Password">
                    </cfif>
    </cffunction> --->
    <!--- user_login method will allow user to logged in to application --->
    <cffunction  name="user_login" access="public" output="false" returntype="boolean">
        <cfargument  name="user_name" type = "string" required = "true" />
        <cfargument  name="user_password" type = "string" required = "true" />
        <cfargument  name="user_level" type = "string" required = "true" />
        <cfargument  name="current_ipAddress" type = "string" required = "false" />
            <!--- creating variable to insure user is logged in or not --->
            <cfset var isUserLogin = false />
            <!--- getting user's data from the database --->
            <cfif arguments.user_level neq 'employee'>
                <cfquery name = "getData">
                    select * 
                    from users
                    where user_name = '#user_name#'
                    and password = '#user_password#'
                </cfquery>
            <cfelse>
                <cfquery name = "getData">
                    select * 
                    from emp_users
                    where user_name = '#user_name#'
                    and password = '#user_password#'
                </cfquery>
            </cfif>
<!---             <cfdump  var="#getdata#"> <cfabort> --->
            <!--- query to validate only one user --->
            <cfif getData.RecordCount eq 1>
                <cflogin applicationtoken = "payroll">
                    <cfloginuser  name="#getData.user_name#"  password="#getData.password#"  roles="#getData.level#">
                </cflogin>
            <cfif arguments.user_level neq 'employee'>
                <cfquery name = "insert_time">
                    update users
                    set last_login = now()
                    where user_name = '#getData.user_name#'
                    and password = '#getData.password#'
                </cfquery>
            <cfelse> 
                <cfset ipaddress = getData.IP_ADDRESS>
                <cfif getData.IP_ADDRESS eq arguments.current_ipAddress or getData.ip_address eq ''>
                    <cfquery name = "insert_time">
                        update emp_users
                        set last_login = now(), ip_address = '#arguments.current_ipAddress#'
                        where user_name = '#getData.user_name#'
                        and password = '#getData.password#'
                    </cfquery>
                </cfif>
            </cfif>
                <!--- saving user's information session scope --->
                <cfset session.loggedIn = {'userName' = getDAta.user_name , 'role' = getData.level }>
                <!--- using isUserLogin variable to change value --->
                <cfset var isUserLogin = true />
            </cfif>
            <!--- and return the variable's value --->
        <cfreturn isUserLogin />
    </cffunction>
    <!--- user_logout can log out a user --->
    <cffunction  name="user_logout" access="public" output="false" returntype="void">
        <cfset structDelete(session, 'loggedIn') />
        <cflogout />
    </cffunction>
</cfcomponent>