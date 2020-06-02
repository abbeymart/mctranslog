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
import db_postgres, json, times
import mcresponse
import mcdb

# Define types
type
    LogParam* = object
        auditDb*: Database
        auditColl*: string

# contructor
proc newLog*(auditDb: Database; auditColl: string = "audits"): LogParam =
    # new result
    result.auditDb = auditDb
    result.auditColl = auditColl
 
proc createLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            logType = "create"
            logBy = userId
            logDate = now().utc

        # validate params/values
        var errorMessage = ""
        
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (coll_name, coll_values, log_type, log_by, log_date ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, logType, logBy, logDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: "successful create-log action"))
    
    except:
        # echo getCurrentExceptionMsg()
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc updateLog*(log: LogParam; coll: string; collParams: JsonNode; collNewParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            collNewValues = collNewParams
            logType = "update"
            logBy = userId
            logDate = now().utc

        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Old/existing record(s) information is required."        
        if collNewValues == nil:
            errorMessage = errorMessage & " | Updated/new record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (coll_name, coll_values, coll_new_values, log_type, log_by, log_date ) VALUES (?, ?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, collNewValues, logType, logBy, logDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collNewParams, message: "successful update-log action"))
    
    except:
        # echo getCurrentExceptionMsg()
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc readLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            logType = "read"
            logBy = userId
            logDate = now().utc

        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (coll_name, coll_values, log_type, log_by, log_date ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, logType, logBy, logDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: "successful read-log action"))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc deleteLog*(log: LogParam; coll: string; collParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = collParams
            logType = "remove"
            logBy = userId
            logDate = now().utc

        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (coll_name, coll_values, log_type, log_by, log_date ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, logType, logBy, logDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: collParams, message: "successful remove-log action"))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc loginLog*(log: LogParam; coll: string = "users"; loginParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = loginParams
            logType = "login"
            logBy = userId
            logDate = now().utc

        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (coll_name, coll_values, log_type, log_by, log_date ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, logType, logBy, logDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: nil, message: "successful login-log action"))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc logoutLog*(log: LogParam; coll: string = "users"; logoutParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            collName = coll
            collValues = logoutParams
            logType = "logout"
            logBy = userId
            logDate = now().utc
        
        # validate params
        var errorMessage = ""
        if collName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if collValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (coll_name, coll_values, log_type, log_by, log_date ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, collName, collValues, logType, logBy, logDate)
        
        # send response
        return getResMessage("success", ResponseMessage(value: nil, message: "successful logout-log action"))
    
    except:
        # echo getCurrentExceptionMsg()
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))
