import unittest
import mctranslog
import db_postgres

type
    Database = ref object
        db: DbConn

test "return correct instance":
    echo "testing"
    echo "new-instance: "