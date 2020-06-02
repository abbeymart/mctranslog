import unittest
import mctranslog
import mcdb
import json

# test data sets
var defaultSecureOption = DbSecureType(secureAccess: false)

var defaultDbOptions = DbOptionType(fileNaMe: "testdb.db", hostName: "localhost",
                                hostUrl: "localhost:5432",
                                userName: "postgres", password: "postgres",
                                dbName: "mccentral", port: 5432,
                                dbType: "postgres", poolSize: 20,
                                secureOption: defaultSecureOption )

# db connection / instance
var dbConnect = newDatabase(defaultDbOptions)

var logInstanceResult = LogParam(auditDb: dbConnect, auditColl: "audits")

# audit-log instance
var mcLog = newLog(dbConnect, "audits")

# Working/Test data
type
    TestParam = object
        name: string
        desc: string
        url: string
        priority: int
        cost: float

var
    collName: string = "services"
    userId: string = "abbeycityunited"

var collParams = %*(TestParam(name: "Abi",
                            desc: "Testing only",
                            url: "localhost:9000",
                            priority: 1,
                            cost: 1000.00
                            )
                )

var collNewParams = %*(TestParam(name: "Abi Akindele",
                            desc: "Testing only - updated",
                            url: "localhost:9900",
                            priority: 1,
                            cost: 2000.00
                            )
                )

var
    loginParams = collParams
    logoutParams = collParams

test "should connect and return an instance object":
    echo logInstanceResult
    check mcLog == logInstanceResult

test "should store create-transaction log and return success":
    try:
        var res = mcLog.createLog(collName, collParams, userId)
        echo "create-log-response: ", res
        check res.code == "success"
        check res.value == collParams
    except:
        echo getCurrentExceptionMsg()

test "should store update-transaction log and return success":
    var res = mcLog.updateLog(collName, collParams, collNewParams, userId)
    # echo "update-log-response: ", res
    check res.code == "success"
    check res.value == collNewParams

test "should store read-transaction log and return success":
    var res = mcLog.readLog(collName, collParams, userId)
    check res.code == "success"
    check res.value == collParams

test "should store delete-transaction log and return success":
    var res = mcLog.deleteLog(collName, collParams, userId)
    check res.code == "success"
    check res.value == collParams

test "should store login-transaction log and return success":
    collName = "users"
    var res = mcLog.loginLog(collName, loginParams, userId)
    check res.code == "success"
    check res.value == nil

test "should store logout-transaction log and return success":
    collName = "users"
    var res = mcLog.logoutLog(collName, logoutParams, userId)
    check res.code == "success"
    check res.value == nil

test "should return paramsError for incomplete/undefined inputs":
    var res = mcLog.logoutLog(collName, logoutParams, "")
    check res.code == "insertError"
    check res.value == nil
