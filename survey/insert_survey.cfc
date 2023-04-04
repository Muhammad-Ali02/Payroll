<cfcomponent hint="Insert Question array into database.">
    <cfoutput>
    <cffunction  name="Insert_Question" returntype="any" access="remote" returnformat="plain">
        <cfset questions = listToArray(url.array)>
<!---        <cfloop from="1" to="#Arraylen(questions)#" index="i"> 
             #i# : #questions[i]#
        </cfloop>
        <cfloop array="#questions#" index="index">
            #index#
        </cfloop>
        <cfdump  var="#questions#">
        <cfdump  var="#url.title#">
        <cfdump  var="#url.description#">--->
        <cfset counter = 1>
        <cftry>
            <cfquery name="Insert_question" datasource="payroll">
                insert into survey(
                    title,
                    description
                    <cfloop array="#questions#" index="index">
                        ,question#counter#
                    <cfset counter +=1 >
                    </cfloop>
                    )
                values (
                    <cfqueryparam value="#url.title#">,
                    <cfqueryparam value="#url.description#">
                    <cfloop array="#questions#" index="index">
                        ,<cfqueryparam value="#index#">
                    </cfloop>
                    )
            </cfquery>
        <cfcatch type="any">
            <cfreturn "#cfcatch.cause.message#">
        </cfcatch>
        </cftry>
        <cfreturn true>
    </cffunction>
    </cfoutput>
</cfcomponent>