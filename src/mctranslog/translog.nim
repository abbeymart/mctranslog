#
#              mconnect solutions
#        (c) Copyright 2020 Abi Akindele (mconnect.biz)
#
#    See the file "LICENSE.md", included in this
#    distribution, for details about the copyright / license.
# 
#             Transactions Log Procedures
#

## The transactions log procedures include:
## login, logout, create, update, delete and read operations
## 
## 

# types
import db_postgres, json, tables, times
import mcresponse

# Define types
type
    Database = ref object
        db: DbConn
         
    ValueType = int | string | float | bool | Positive | Natural | JsonNode | BiggestInt | BiggestFloat | Table | seq | SqlQuery | Database

    # UserParam = object
    #     name: string
    #     age: Natural
    
    LogParam = ref object
        # actionParams*: Table[string, ValueType]
        # queryParams*: Table[string, Table[string, ValueType]]
        auditDb: Database
        auditColl*: string
        maxQueryLimit: Positive
        mcMessages*: Table[string, string]
 
# default contructor
proc newLog*(auditDb: Database; options: Table[string, ValueType]): LogParam =
    var defaultMessageTable = initTable[string, string]
    new result
    result.auditDb = auditDb
    result.auditColl = options.getOrDefault("auditColl", "audits")
    result.mcMessages = options.getOrDefault("messages", defaultMessageTable)

proc createLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        echo "success"
        # validate params, optional

        # log-params
        let
            collName = coll
            collValues = collParams
            actionType = "create"
            actionBy = userId
            actionDate = now().utc

        # store action record
        log.auditDb.db.exec(sql"INSERT INTO audits VALUES (?, ?, ?, ?, ?);",
        collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

    