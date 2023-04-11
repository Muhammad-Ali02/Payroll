 
            <!---       Back End        --->
    <cfquery name = "get_employee"> <!--- to print All employees list --->
        select concat(first_name,' ', middle_name, ' ', last_name) as name 
        from employee
        where employee_id = <cfqueryparam value="#session.loggedin.username#">
    </cfquery>

            <!---       Front End        --->
    <cfoutput>
        <h2 class="text-center"> Welcome #get_employee.name# </h2>
    </cfoutput>
 