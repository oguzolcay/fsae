//
//  main.swift
//  fsae
//
//  Created by Oguz Olcay on 4/27/26.
//

import Foundation
import SQLite3

let sourceFile = URL(fileURLWithPath: #filePath)
let dbURL = sourceFile.deletingLastPathComponent().appendingPathComponent("db/fsae.db")

var db: OpaquePointer?
guard sqlite3_open(dbURL.path, &db) == SQLITE_OK else {
    print("Failed to open database: \(String(cString: sqlite3_errmsg(db)))")
    exit(1)
}

var statement: OpaquePointer?
let query = "SELECT oid, point_x, point_y, point_z FROM frame_points"
guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
    print("Failed to prepare statement: \(String(cString: sqlite3_errmsg(db)))")
    sqlite3_close(db)
    exit(1)
}

while sqlite3_step(statement) == SQLITE_ROW {
    let oid   = sqlite3_column_int(statement, 0)
    let x     = sqlite3_column_int(statement, 1)
    let y     = sqlite3_column_int(statement, 2)
    let z     = sqlite3_column_int(statement, 3)
    print("oid: \(oid)  x: \(x)  y: \(y)  z: \(z)")
}

sqlite3_finalize(statement)
sqlite3_close(db)

