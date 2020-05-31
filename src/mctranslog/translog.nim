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

    LogParam = ref object
        auditDb: Database
        auditColl*: string
        maxQueryLimit: Positive
        mcMessages*: Table[string, string]
 
# contructor
proc newLog*(auditDb: Database; options: Table[string, ValueType]): LogParam =
    var defaultMessageTable = initTable[string, string]
    new result
    result.auditDb = auditDb
    result.auditColl = options.getOrDefault("auditColl", "audits")
    result.mcMessages = options.getOrDefault("messages", defaultMessageTable)

proc createLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            actionType = "create"
            actionBy = userId
            actionDate = now().utc

        # store action record
        var taskQuery = sql("INSERT INTO" & log.auditColl & "(collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc updateLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            actionType = "create"
            actionBy = userId
            actionDate = now().utc

        # store action record
        var taskQuery = sql("INSERT INTO" & log.auditColl & "(collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc readLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            actionType = "create"
            actionBy = userId
            actionDate = now().utc

        # store action record
        var taskQuery = sql("INSERT INTO" & log.auditColl & "(collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc deleteLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            actionType = "create"
            actionBy = userId
            actionDate = now().utc

        # store action record
        var taskQuery = sql("INSERT INTO" & log.auditColl & "(collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc loginLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            actionType = "create"
            actionBy = userId
            actionDate = now().utc

        # store action record
        var taskQuery = sql("INSERT INTO" & log.auditColl & "(collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc logoutLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            actionType = "create"
            actionBy = userId
            actionDate = now().utc

        # store action record
        var taskQuery = sql("INSERT INTO" & log.auditColl & "(collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc auditLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            actionType = "create"
            actionBy = userId
            actionDate = now().utc

        # store action record
        var taskQuery = sql("INSERT INTO" & log.auditColl & "(collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))
