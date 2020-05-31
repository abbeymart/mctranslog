import unittest
import mctranslog
import mcdb

# test data sets
var defaultSecureOption = SecureType(secureAccess: false)

var defaultOptions = OptionType(fileNaMe: "testdb.db", hostName: "localhost",
                                hostUrl: "postgres://localhost:5432/mc-dev",
                                userName: "postgres", password: "postgres",
                                dbName: "mccentral", port: 5432,
                                dbType: "postgres", poolSize: 20,
                                secureOption: defaultSecureOption )

# db connection / instance
var dbConnect = newDatabase(defaultOptions)

test "return correct instance":
    echo "testing"
    echo "new-instance: "