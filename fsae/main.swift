//
//  main.swift
//  fsae
//
//  Created by Oguz Olcay on 4/27/26.
//

import Foundation
import SQLite3

class Point3D {
    let oid: Int32
    let x: Int32
    let y: Int32
    let z: Int32
    let xyz: [Int32]
    var connections: [Point3D] = []

    init(oid: Int32, x: Int32, y: Int32, z: Int32) {
        self.oid = oid
        self.x = x
        self.y = y
        self.z = z
        self.xyz = [x, y, z]
    }
}

let sourceFile = URL(fileURLWithPath: #filePath)
let dbURL = sourceFile.deletingLastPathComponent().appendingPathComponent("db/fsae.db")

var db: OpaquePointer?
guard sqlite3_open(dbURL.path, &db) == SQLITE_OK else {
    print("Failed to open database: \(String(cString: sqlite3_errmsg(db)))")
    exit(1)
}

// Load all points
var points: [Int32: Point3D] = [:]
var stmt: OpaquePointer?

guard sqlite3_prepare_v2(db, "SELECT oid, point_x, point_y, point_z FROM frame_points", -1, &stmt, nil) == SQLITE_OK else {
    print("Failed to prepare frame_points query: \(String(cString: sqlite3_errmsg(db)))")
    sqlite3_close(db)
    exit(1)
}
while sqlite3_step(stmt) == SQLITE_ROW {
    let oid = sqlite3_column_int(stmt, 0)
    let x   = sqlite3_column_int(stmt, 1)
    let y   = sqlite3_column_int(stmt, 2)
    let z   = sqlite3_column_int(stmt, 3)
    points[oid] = Point3D(oid: oid, x: x, y: y, z: z)
}
sqlite3_finalize(stmt)

// Decorate points with connections from frame_edges
guard sqlite3_prepare_v2(db, "SELECT start, end FROM frame_edges", -1, &stmt, nil) == SQLITE_OK else {
    print("Failed to prepare frame_edges query: \(String(cString: sqlite3_errmsg(db)))")
    sqlite3_close(db)
    exit(1)
}
while sqlite3_step(stmt) == SQLITE_ROW {
    let startOid = sqlite3_column_int(stmt, 0)
    let endOid   = sqlite3_column_int(stmt, 1)
    guard startOid != endOid,
          let startPoint = points[startOid],
          let endPoint   = points[endOid] else { continue }
    startPoint.connections.append(endPoint)
    endPoint.connections.append(startPoint)
}
sqlite3_finalize(stmt)
sqlite3_close(db)

// Print all points
let allPoints = points.values.sorted { $0.oid < $1.oid }
for point in allPoints {
    let connectedOids = point.connections.map { String($0.oid) }.joined(separator: ", ")
    let connectionsStr = connectedOids.isEmpty ? "none" : connectedOids
    print("[\(point.oid)] (\(point.x), \(point.y), \(point.z))  connections: \(connectionsStr) point: \(point.xyz)")
}

// Generate output.scad
let projectRoot = sourceFile.deletingLastPathComponent().deletingLastPathComponent()
let productsDir = projectRoot.appendingPathComponent("Products")
try? FileManager.default.createDirectory(at: productsDir, withIntermediateDirectories: true)

var scad = "color(\"red\"){\n"
for point in allPoints {
    scad += "   translate([\(point.x), \(point.y), \(point.z)]) sphere(r=25);\n"
}
scad += "}\n\n"

/*
 color("yellow"){
     hull(){
         translate([0, -250, 50]) sphere(r=20);
         translate([0, 250, 50]) sphere(r=20);
     }
 }
 */
let scadURL = sourceFile.deletingLastPathComponent().appendingPathComponent("scad/frame.scad")
try scad.write(to: scadURL, atomically: true, encoding: .utf8)
print("Wrote \(scadURL.path)")


