import unittest
import mctranslog
import mcdb
import json

# test data sets
var defaultSecureOption = DbSecureType(secureAccess: false)

var defaultDbOptions = DbOptionType(fileName: "testdb.db",
                                hostName: "localhost",
                                hostUrl: "localhost:5432",
                                userName: "postgres",
                                password: "ab12trust",
                                dbName: "mccentral",
                                port: 5432,
                                dbType: "postgres",
                                poolSize: 20,
                                secureOption: defaultSecureOption )

# db connection / instance
var dbConnect = newDatabase(defaultDbOptions)

# echo "db-connect-info:", dbConnect.repr

var logInstanceResult = LogParam(auditDb: dbConnect, auditColl: "nim_audits")

# audit-log instance
var mcLog = newLog(dbConnect, "nim_audits")

# Working/Test data
type
    TestParam = object
        name: string
        desc: string
        url: string
        priority: int
        cost: float

var
    tableName: string = "services"
    userId: string = "085f48c5-8763-4e22-a1c6-ac1a68ba07de"

var recordParams = %*(TestParam(name: "Abi",
                            desc: "Testing only",
                            url: "localhost:9000",
                            priority: 1,
                            cost: 1000.00
                            )
                )

var recordNewParams = %*(TestParam(name: "Abi Akindele",
                            desc: "Testing only - updated",
                            url: "localhost:9900",
                            priority: 1,
                            cost: 2000.00
                            )
                )

var
    loginParams = recordParams
    logoutParams = recordParams

suite "audit/transactions log testing":
    # "setup: run once before the tests"

    test "should connect and return an instance object":
        echo logInstanceResult
        check mcLog == logInstanceResult

    test "should store create-transaction log and return success":
        let res = mcLog.createLog(tableName, recordParams, userId)
        echo "create-log-response: ", res
        check res.code == "success"
        check res.value == recordParams
    
    test "should store update-transaction log and return success":
        let res = mcLog.updateLog(tableName, recordParams, recordNewParams, userId)
        echo "update-log-response: ", res
        check res.code == "success"
        check res.value == recordNewParams

    test "should store read-transaction log and return success":
        let res = mcLog.readLog(tableName, recordParams, userId)
        check res.code == "success"
        check res.value == recordParams

    test "should store delete-transaction log and return success":
        let res = mcLog.deleteLog(tableName, recordParams, userId)
        check res.code == "success"
        check res.value == recordParams

    test "should store login-transaction log and return success":
        tableName = "users"
        let res = mcLog.loginLog(tableName, loginParams, userId)
        check res.code == "success"
        check res.value == nil

    test "should store logout-transaction log and return success":
        tableName = "users"
        let res = mcLog.logoutLog(tableName, logoutParams, userId)
        check res.code == "success"
        check res.value == nil

    test "should return paramsError for incomplete/undefined inputs":
        try:
            let res = mcLog.logoutLog(tableName, logoutParams, "")
            echo "paramsError-response: ", res
            check res.code == "insertError"
            check res.value == nil
        except:
            echo getCurrentExceptionMsg()
    teardown:
        # close db after testing
        dbConnect.close()
