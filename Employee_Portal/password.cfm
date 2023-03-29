<!--- <cfoutput> 
    <cfquery name= "hash_pass">
        select * from users;
    </cfquery>
    <cfloop query="hash_pass">
        <cfset salt = uCase("#hash_pass.user_name#")>
        <cfset password = "#hash_pass.password#">
        <cfset hashed_Password = hash(password & salt, "SHA-256")>
    <cftry>
        <cfquery name="hash_pass_update">
            update users
            set password = <cfqueryparam value="#hashed_Password#">
            where user_name = <cfqueryparam value="#hash_pass.user_name#">
        </cfquery>

    <cfcatch type="any">
        hash_pass:<cfdump  var="#cfcatch.cause.message#"><br>
    </cfcatch>
    </cftry>
    </cfloop>
</cfoutput> --->
<cfoutput>
   <!--- <cfquery name= "insert_uuid">
            select * from emp_users;
    </cfquery>

    <cfloop query="insert_uuid">
        <cftry>
            <cfquery name="get_uuid">
                insert into uuid_table (uuid , user_name)
                values (<cfqueryparam value="#CreateUUID()#">, <cfqueryparam value="#insert_uuid.user_name#">)
            </cfquery>
        <cfcatch type="any">
                get_uuid:<cfdump  var="#cfcatch.cause.message#"><br>
        </cfcatch>
        </cftry>
    </cfloop>--->
    <!--- <cfquery name= "insert_uuid">
            select * from emp_users;
    </cfquery>
    <cfloop query="insert_uuid">
        <cfquery name="get_uuid">
            select *
            from uuid_table
            where user_name = <cfqueryparam value="#insert_uuid.user_name#">
        </cfquery>

        <cfset salt = "#get_uuid.uuid#">
        <cfset password = "1">
        <cfset hashed_Password = hash(password & salt, "SHA-256")>
        <cftry>
            <cfquery name="get_hash_password">
                update emp_users
                set password = <cfqueryparam value="#hashed_Password#">
                where user_name = <cfqueryparam value="#insert_uuid.user_name#">
            </cfquery>
        <cfcatch type="any">
                get_uuid:<cfdump  var="#cfcatch.cause.message#"><br>
        </cfcatch>
        </cftry>
    </cfloop>--->

    <!--- <cfquery name= "insert_uuid">
            select * from emp_users;
    </cfquery>
    <cfloop query="insert_uuid">
        <cfquery name="get_uuid">
            select *
            from uuid_table
            where user_name = <cfqueryparam value="#insert_uuid.user_name#">
        </cfquery>
        <cfset salt = "#get_uuid.uuid#">
        <cfset password = "1">
        <cfset hashed_Password = hash(password & salt, "SHA-256")>
        <cftry>
            <cfquery name="get_hash_password">
                update emp_users
                set password = <cfqueryparam value="#hashed_Password#">
                where user_name = <cfqueryparam value="#insert_uuid.user_name#">
            </cfquery>
        <cfcatch type="any">
                get_uuid:<cfdump  var="#cfcatch.cause.message#"><br>
        </cfcatch>
        </cftry>
    </cfloop>--->

    <!---<cfset salt = "92758FE9-A379-3D9C-8E98CBAB58F17B99">
    <cfset password = "1">
    <cfset hashed_Password = hash(password & salt, "SHA-256")>
        <cfdump  var="#hashed_Password#"><br>
        <cfdump  var="#salt#">--->

    <!---<cfset salt = "92758FE9-A379-3D9C-8E98CBAB58F17B99">
    <cfset password = "1">
    <cfset hashed_Password = hash(password & salt, "SHA-256")>
    <cfset lent = len(hashed_Password)> 
    <cfdump  var="#hashed_Password#">
    <p>Your new UUID is: <cfoutput>#lent#</cfoutput></p>--->


        <!--- this query section run for insert employee uuid in to uuid table --->
            <cfquery name= "insert_uuid">
                select * from emp_users;
            </cfquery>

            <cfloop query="insert_uuid">
                <cftry>
                    <cfquery name="add_uuid">
                        insert ignore into uuid_table (uuid , user_name)
                        values (<cfqueryparam value="#CreateUUID()#">, <cfqueryparam value="#insert_uuid.user_name#">)
                    </cfquery>
                <cfcatch type="any">
                        add_uuid:<cfdump  var="#cfcatch.cause.message#"><br>
                </cfcatch>
                </cftry>
            </cfloop>

        <!--- this query section run for insert user uuid in to uuid table --->
            <cfquery name= "insert1_uuid">
                select * from users;
            </cfquery>

            <cfloop query="insert1_uuid">
                <cftry>
                    <cfquery name="add1_uuid">
                        insert ignore into uuid_table (uuid , user_name)
                        values (<cfqueryparam value="#CreateUUID()#">, <cfqueryparam value="#insert1_uuid.user_name#">)
                    </cfquery>
                <cfcatch type="any">
                        add1_uuid:<cfdump  var="#cfcatch.cause.message#"><br>
                </cfcatch>
                </cftry>
            </cfloop>


        <!--- this query run for admin uses  --->

     <cfquery name= "get_users">
            select * from users;
    </cfquery>
<!---     <cfdump  var="#insert_uuid#"> --->
    <cfloop query="get_users">
        <cfquery name="get_uuid">
            select *
            from uuid_table
            where user_name = <cfqueryparam value="#get_users.user_name#">
        </cfquery>
<!---         <cfdump  var="#get_uuid#"> --->

        <cfset salt = get_uuid.uuid>
        <cfset password1 = "1">
        <cfset hashed_Password1 = hash(password1 & salt, "SHA-256")>

<!---         <cfdump  var="#hashed_Password1#"><br> --->
<!---         <cfdump  var="#salt#"><cfabort> --->
        <cftry>
            <cfquery name="get_hash_password">
                update users
                set password = <cfqueryparam value="#hashed_Password1#">
                where user_name = <cfqueryparam value="#get_users.user_name#">
            </cfquery>
        <cfcatch type="any">
                get_uuid:<cfdump  var="#cfcatch.cause.message#"><br>
        </cfcatch>
        </cftry>
    </cfloop>

        <!---  This section of code run for employee users    --->

    <cfquery name= "get_emp_users">
            select * from emp_users;
    </cfquery>
    <cfloop query="get_emp_users">
        <cfquery name="get_emp_uuid">
            select *
            from uuid_table
            where user_name = <cfqueryparam value="#get_emp_users.user_name#">
        </cfquery>
        <cfset salt2 = get_emp_uuid.uuid>
        <cfset password2 = "1">
        <cfset hashed_Password2 = hash(password2 & salt2, "SHA-256")>

        <cftry>
            <cfquery name="get_hash_password_emp">
                update emp_users
                set password = <cfqueryparam value="#hashed_Password2#">
                where user_name = <cfqueryparam value="#get_emp_users.user_name#">
            </cfquery>
        <cfcatch type="any">
                get_hash_password_emp:<cfdump  var="#cfcatch.cause.message#"><br>
        </cfcatch>
        </cftry>
    </cfloop>




    <!---<cfset salt = "#get_uuid.uuid#">
        <cfset password = "1">
        <cfset hashed_Password = hash(password & salt, "SHA-256")>
        <cftry>
            <cfquery name="get_hash_password">
                update users
                set password = <cfqueryparam value="#hashed_Password#">
                where user_name = <cfqueryparam value="#insert_uuid.user_name#">
            </cfquery>
        <cfcatch type="any">
                get_uuid:<cfdump  var="#cfcatch.cause.message#"><br>
        </cfcatch>
        </cftry>--->

    <!--- <cfquery name= "insert_uuid">
            select * from users;
    </cfquery>
    <cfloop query="insert_uuid">
        <cftry>
            <cfquery name="get_uuid">
                insert into uuid_table (uuid , user_name)
                values (<cfqueryparam value="#CreateUUID()#">, <cfqueryparam value="#insert_uuid.user_name#">)
            </cfquery>
        <cfcatch type="any">
                get_uuid:<cfdump  var="#cfcatch.cause.message#"><br>
        </cfcatch>
        </cftry>
    </cfloop>--->
</cfoutput>

