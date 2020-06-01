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
import db_postgres, json, tables, times, strutils
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


# Initialise cache table/object
var defaultOptions = initTable[string, JsonNode]()

# contructor
proc newLog*(auditDb: Database; options: Table[string, ValueType] = defaultOptions): LogParam =
    var defaultMessageTable = initTable[string, string]()
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

        # validate params/values
        var errorMessage = ""
        
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if actionBy == "":
            errorMessage = errorMessage & " | UserID is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc updateLog*(log: LogParam; coll: string; collParams: JsonNode; collNewParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            collNewValues = collNewParams
            actionType = "update"
            actionBy = userId
            actionDate = now().utc

        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if actionBy == "":
            errorMessage = errorMessage & " | UserID is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Old/existing record(s) information is required."        
        if collNewValues == nil:
            errorMessage = errorMessage & " | Updated/new record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (collName, collValues, collNewValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, collNewValues, actionType, actionBy, actionDate)
        
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
            actionType = "read"
            actionBy = userId
            actionDate = now().utc

        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if actionBy == "":
            errorMessage = errorMessage & " | UserID is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

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
            actionType = "remove"
            actionBy = userId
            actionDate = now().utc

        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if actionBy == "":
            errorMessage = errorMessage & " | UserID is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc loginLog*(log: LogParam; coll: string = "users"; loginParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = loginParams
            actionType = "login"
            actionBy = userId
            actionDate = now().utc

        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if actionBy == "":
            errorMessage = errorMessage & " | UserID is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc logoutLog*(log: LogParam; coll: string = "users"; logoutParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = logoutParams
            actionType = "logout"
            actionBy = userId
            actionDate = now().utc
        
        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if actionBy == "":
            errorMessage = errorMessage & " | UserID is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (collName, collValues, actionType, actionBy, actionDate ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, actionType, actionBy, actionDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))
