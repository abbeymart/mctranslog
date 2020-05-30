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
import db_postgres, json, tables

# Define types
type
    Database = ref object
        db: DbConn
         
    ValueType = int | string | float | bool | JsonNode | BiggestInt | BiggestFloat | Table | seq | SqlQuery | Database

    UserParam = object
        name: string
        age: Natural
    
    LogParam = ref object
        # actionParams*: Table[string, ValueType]
        # queryParams*: Table[string, Table[string, ValueType]]
        auditDb: Database
        auditColl*: string
        maxQueryLimit: Positive
        mcMessages*: Table[string, string]
 
# default contructor
proc newLog*(auditDb: Database; options: Table[string, ValueType]): LogParam =
    var defaultTable = initTable[string, ValueType]
    new result
    result.auditDb = auditDb
    result.auditColl = options.getOrDefault("auditColl", "audits")
    result.mcMessages = options.getOrDefault("messages", defaultTable)

proc createLog*(log: LogParam, collParams: Table[string, ValueType], userId: string ) =
    echo "create log"
