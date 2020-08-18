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
 
proc createLog*(log: LogParam; table: string; recordParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            tableName = table
            recordValues = recordParams
            logType = "create"
            logBy = userId
            logAt = now().utc

        # validate params/values
        var errorMessage = ""
        
        if tableName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if recordValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # echo "params-passed"
        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (table_name, record_values, log_type, log_by, log_at ) VALUES (?, ?, ?, ?, ?);")

        # echo "run-query"
        log.auditDb.db.exec(taskQuery, tableName, recordValues, logType, logBy, logAt)
        
        # send response
        return getResMessage("success", ResponseMessage(value: recordParams, message: "successful create-log action"))
    
    except:
        # echo getCurrentException.repr
        # echo getCurrentExceptionMsg()
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc updateLog*(log: LogParam; table: string; recordParams: JsonNode; recordNewParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            tableName = table
            recordValues = recordParams
            recordNewValues = recordNewParams
            logType = "update"
            logBy = userId
            logAt = now().utc

        # validate params
        var errorMessage = ""
        if tableName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if recordValues == nil:
            errorMessage = errorMessage & " | Old/existing record(s) information is required."        
        if recordNewValues == nil:
            errorMessage = errorMessage & " | Updated/new record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (table_name, record_values, record_new_values, log_type, log_by, log_at ) VALUES (?, ?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, tableName, recordValues, recordNewValues, logType, logBy, logAt)
        
        # send response
        return getResMessage("success", ResponseMessage(value: recordNewParams, message: "successful update-log action"))
    
    except:
        # echo getCurrentExceptionMsg()
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc readLog*(log: LogParam; table: string; recordParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            tableName = table
            recordValues = recordParams
            logType = "read"
            logBy = userId
            logAt = now().utc

        # validate params
        var errorMessage = ""
        if tableName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if recordValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (table_name, record_values, log_type, log_by, log_at ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, tableName, recordValues, logType, logBy, logAt)
        
        # send response
        return getResMessage("success", ResponseMessage(value: recordParams, message: "successful read-log action"))
    
    except:
        echo getCurrentException.repr
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc deleteLog*(log: LogParam; table: string; recordParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            tableName = table
            recordValues = recordParams
            logType = "remove"
            logBy = userId
            logAt = now().utc

        # validate params
        var errorMessage = ""
        if tableName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if recordValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (table_name, record_values, log_type, log_by, log_at ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, tableName, recordValues, logType, logBy, logAt)
        
        # send response
        return getResMessage("success", ResponseMessage(value: recordParams, message: "successful remove-log action"))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc loginLog*(log: LogParam; table: string = "users"; loginParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            tableName = table
            recordValues = loginParams
            logType = "login"
            logBy = userId
            logAt = now().utc

        # validate params
        var errorMessage = ""
        if tableName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if recordValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (table_name, record_values, log_type, log_by, log_at ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, tableName, recordValues, logType, logBy, logAt)
        
        # send response
        return getResMessage("success", ResponseMessage(value: nil, message: "successful login-log action"))
    
    except:
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))

proc logoutLog*(log: LogParam; table: string = "users"; logoutParams: JsonNode; userId: string ): ResponseMessage =
    try:
        # log-params/values
        let
            tableName = table
            recordValues = logoutParams
            logType = "logout"
            logBy = userId
            logAt = now().utc
        
        # validate params
        var errorMessage = ""
        if tableName == "":
            errorMessage = errorMessage & " | Table or Collection name is required."
        if logBy == "":
            errorMessage = errorMessage & " | userId is required."
        if recordValues == nil:
            errorMessage = errorMessage & " | Created record(s) information is required."        

        if errorMessage != "":
            raise newException(ValueError, errorMessage)

        # store action record
        var taskQuery = sql("INSERT INTO " & log.auditColl & " (table_name, record_values, log_type, log_by, log_at ) VALUES (?, ?, ?, ?, ?);")

        log.auditDb.db.exec(taskQuery, tableName, recordValues, logType, logBy, logAt)
        
        # send response
        return getResMessage("success", ResponseMessage(value: nil, message: "successful logout-log action"))
    
    except:
        # echo getCurrentExceptionMsg()
        return getResMessage("insertError", ResponseMessage(value: nil, message: getCurrentExceptionMsg()))
