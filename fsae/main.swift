//
//  main.swift
//  fsae
//
//  Created by Oguz Olcay on 4/28/26.
//

import Foundation
import SQLite3

// MARK: - Types

struct Vector3D {
    let x: Double
    let y: Double
    let z: Double

    var magnitude: Double {
        (x*x + y*y + z*z).squareRoot()
    }

    var normalized: Vector3D {
        let m = magnitude
        return Vector3D(x: x/m, y: y/m, z: z/m)
    }
}

struct Point3D {
    let oid: String
    let x: Int
    let y: Int
    let z: Int
}

struct Edge {
    let start: Point3D
    let end: Point3D

    /// Direction vector from start to end.
    var vector: Vector3D {
        Vector3D(
            x: Double(end.x - start.x),
            y: Double(end.y - start.y),
            z: Double(end.z - start.z)
        )
    }
}

class FrameGraph {
    private(set) var points: [String: Point3D] = [:]
    private(set) var edges: [Edge] = []
    private var adjacency: [String: [Point3D]] = [:]

    func addPoint(_ point: Point3D) {
        points[point.oid] = point
        adjacency[point.oid] = adjacency[point.oid] ?? []
    }

    func addEdge(from startOid: String, to endOid: String) {
        guard let start = points[startOid], let end = points[endOid] else { return }
        edges.append(Edge(start: start, end: end))
        adjacency[startOid, default: []].append(end)
        adjacency[endOid, default: []].append(start)
    }

    /// All points directly connected to the given point.
    func adjacentPoints(for oid: String) -> [Point3D] {
        adjacency[oid] ?? []
    }
}

// MARK: - Load from database

let sourceFile = URL(fileURLWithPath: #filePath)
let dbURL = sourceFile.deletingLastPathComponent().appendingPathComponent("db/fsae.db")

var db: OpaquePointer?
guard sqlite3_open(dbURL.path, &db) == SQLITE_OK else {
    print("Failed to open database: \(String(cString: sqlite3_errmsg(db)))")
    exit(1)
}

let graph = FrameGraph()
var stmt: OpaquePointer?

guard sqlite3_prepare_v2(db, "SELECT oid, x, y, z FROM points", -1, &stmt, nil) == SQLITE_OK else {
    print("Failed to prepare points query: \(String(cString: sqlite3_errmsg(db)))")
    sqlite3_close(db)
    exit(1)
}
while sqlite3_step(stmt) == SQLITE_ROW {
    let oid = String(cString: sqlite3_column_text(stmt, 0))
    let x   = Int(sqlite3_column_int(stmt, 1))
    let y   = Int(sqlite3_column_int(stmt, 2))
    let z   = Int(sqlite3_column_int(stmt, 3))
    graph.addPoint(Point3D(oid: oid, x: x, y: y, z: z))
}
sqlite3_finalize(stmt)

guard sqlite3_prepare_v2(db, "SELECT start, end FROM edges", -1, &stmt, nil) == SQLITE_OK else {
    print("Failed to prepare edges query: \(String(cString: sqlite3_errmsg(db)))")
    sqlite3_close(db)
    exit(1)
}
while sqlite3_step(stmt) == SQLITE_ROW {
    let startOid = String(cString: sqlite3_column_text(stmt, 0))
    let endOid   = String(cString: sqlite3_column_text(stmt, 1))
    graph.addEdge(from: startOid, to: endOid)
}
sqlite3_finalize(stmt)

sqlite3_close(db)

// MARK: - Demo output

let sortedPoints = graph.points.values.sorted { $0.oid < $1.oid }

print("=== Points (\(sortedPoints.count)) ===")
for p in sortedPoints {
    let neighbors = graph.adjacentPoints(for: p.oid).map { $0.oid }.sorted().joined(separator: ", ")
    print("  \(p.oid)  (\(p.x), \(p.y), \(p.z))  adjacent: [\(neighbors)]")
}

print("\n=== Edges (\(graph.edges.count)) ===")
for e in graph.edges {
    let v = e.vector
    print("  \(e.start.oid) -> \(e.end.oid)  vector: (\(v.x), \(v.y), \(v.z))  magnitude: \(String(format: "%.2f", v.magnitude))")
}
