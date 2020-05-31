import unittest
import mctranslog
import db_postgres

type
    Database = ref object
        db: DbConn

    SecureType = object
        secureAccess: bool
        secureCert: string
        secureKey: string
    OptionType = object
        fileName: string
        hostName: string
        hostUrl: string
        userName: string
        password: string
        dbName: string
        port: uint
        dbType: string
        poolSize: uint
        secureOption: SecureType

var defaultSecureOption = SecureType(secureAccess: false)

var defaultOptions = OptionType(fileNaMe: "testdb.db", hostName: "localhost",
                                hostUrl: "postgres://localhost:5432/mc-dev",
                                userName: "postgres", password: "postgres",
                                dbName: "mccentral", port: 5432,
                                dbType: "postgres", poolSize: 20,
                                secureOption: defaultSecureOption )

# database constructor 
proc newDatabase*(options: OptionType = defaultOptions): Database =
    new result
    result.db = open("localhost", "user", "password", "dbname")

var auditDb = newDatabase()

test "return correct instance":
    echo "testing"
    echo "new-instance: "