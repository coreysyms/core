
	<cfscript>
	function arrayReverse(inArray){
		var outArray = ArrayNew(1);
		var i=0;
			var j = 1;
		for (i=ArrayLen(inArray);i GT 0;i=i-1){
			outArray[j] = inArray[i];
			j = j + 1;
		}
		return outArray;
	}

	</cfscript>

	<cffunction name="arrayKeyToList">
		<cfargument name="array" required="true">
		<cfargument name="key" required="true">
		<cfargument name="delimiter" required="false" default=",">

		<cfscript>
			list = '';
			for(i=1;i LTE arrayLen(arguments.array);i=i+1)
			{
				if (len(list))
					list = list & arguments.delimiter;
				arrayEntry = arguments.array[i];
				list = list	& arrayEntry[arguments.key];
			}	
		</cfscript>
		<cfreturn list>
	</cffunction>

	<cffunction name="QueryToStructure">
		<cfargument name="query" type="query" required="true">
		<cfscript>
			stStruct = structNew();
			cols = ListtoArray(arguments.query.columnlist);
			for(index=1; index LTE arraylen(cols); index=index+1)
			{
				stStruct[cols[index]] = arguments.query[cols[index]][1];
			}
		</cfscript>
		<cfreturn stStruct>
	</cffunction>
	
	<cffunction name="QueryToArrayOfStructures" returntype="array">
		<cfargument name="theQuery" required="true">
		<cfargument name="theArray" required="false" default="#arrayNew(1)#">
		<cfset var cols = ListtoArray(theQuery.columnlist)>
		<cfset var row = 1>
		<cfset var thisRow = "">
		<cfset var col = 1>
		<cfscript>	
			for(row = 1; row LTE theQuery.recordcount; row = row + 1)
		{
			thisRow = structnew();
			for(col = 1; col LTE arraylen(cols); col = col + 1){
				thisRow[cols[col]] = theQuery[cols[col]][row];
			}
			arrayAppend(arguments.theArray,duplicate(thisRow));
		}
	
	</cfscript>
	<cfreturn arguments.theArray>
	</cffunction>	