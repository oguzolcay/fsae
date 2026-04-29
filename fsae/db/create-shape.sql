CREATE TABLE "points" (
	"oid"	TEXT NOT NULL UNIQUE,
	"x"	INTEGER NOT NULL,
	"y"	INTEGER NOT NULL,
	"z"	INTEGER NOT NULL,
	PRIMARY KEY("oid")
);

CREATE TABLE "edges" (
	"start"	TEXT NOT NULL,
	"end"	TEXT NOT NULL,
	FOREIGN KEY("start") REFERENCES "points"("oid"),
	FOREIGN KEY("end") REFERENCES "points"("oid")
);

INSERT INTO points (oid, x, y, z) VALUES ('0x001', 0, 0, 0);
INSERT INTO points (oid, x, y, z) VALUES ('0x002', 40, 0, 0);
INSERT INTO points (oid, x, y, z) VALUES ('0x003', 80, 0, 0);
INSERT INTO points (oid, x, y, z) VALUES ('0x004', 0, 50, 0);
INSERT INTO points (oid, x, y, z) VALUES ('0x005', 40, 50, 0);
INSERT INTO points (oid, x, y, z) VALUES ('0x006', 80, 50, 0);
INSERT INTO points (oid, x, y, z) VALUES ('0x007', 0, 0, 10);
INSERT INTO points (oid, x, y, z) VALUES ('0x008', 40, 0, 10);
INSERT INTO points (oid, x, y, z) VALUES ('0x009', 80, 0, 10);
INSERT INTO points (oid, x, y, z) VALUES ('0x00A', 0, 50, 10);
INSERT INTO points (oid, x, y, z) VALUES ('0x00B', 40, 50, 10);
INSERT INTO points (oid, x, y, z) VALUES ('0x00C', 80, 50, 10);
INSERT INTO points (oid, x, y, z) VALUES ('0x00D', 30, 0, 50);
INSERT INTO points (oid, x, y, z) VALUES ('0x00E', 60, 0, 50);
INSERT INTO points (oid, x, y, z) VALUES ('0x00F', 30, 50, 50);
INSERT INTO points (oid, x, y, z) VALUES ('0x010', 60, 50, 50);



INSERT INTO edges (start, end) VALUES ('0x001', '0x002');
INSERT INTO edges (start, end) VALUES ('0x001', '0x004');
INSERT INTO edges (start, end) VALUES ('0x001', '0x007');
INSERT INTO edges (start, end) VALUES ('0x002', '0x003');
INSERT INTO edges (start, end) VALUES ('0x002', '0x005');
INSERT INTO edges (start, end) VALUES ('0x002', '0x008');
INSERT INTO edges (start, end) VALUES ('0x003', '0x006');
INSERT INTO edges (start, end) VALUES ('0x003', '0x009');
INSERT INTO edges (start, end) VALUES ('0x004', '0x005');
INSERT INTO edges (start, end) VALUES ('0x004', '0x00A');
INSERT INTO edges (start, end) VALUES ('0x005', '0x006');
INSERT INTO edges (start, end) VALUES ('0x005', '0x00B');
INSERT INTO edges (start, end) VALUES ('0x006', '0x00C');
INSERT INTO edges (start, end) VALUES ('0x007', '0x008');
INSERT INTO edges (start, end) VALUES ('0x007', '0x00A');
INSERT INTO edges (start, end) VALUES ('0x008', '0x009');
INSERT INTO edges (start, end) VALUES ('0x008', '0x00B');
INSERT INTO edges (start, end) VALUES ('0x008', '0x00D');
INSERT INTO edges (start, end) VALUES ('0x008', '0x00E');
INSERT INTO edges (start, end) VALUES ('0x009', '0x00C');
INSERT INTO edges (start, end) VALUES ('0x009', '0x00E');
INSERT INTO edges (start, end) VALUES ('0x00A', '0x00B');
INSERT INTO edges (start, end) VALUES ('0x00B', '0x00C');
INSERT INTO edges (start, end) VALUES ('0x00B', '0x00F');
INSERT INTO edges (start, end) VALUES ('0x00B', '0x010');
INSERT INTO edges (start, end) VALUES ('0x00C', '0x010');
INSERT INTO edges (start, end) VALUES ('0x00D', '0x00E');
INSERT INTO edges (start, end) VALUES ('0x00D', '0x00F');
INSERT INTO edges (start, end) VALUES ('0x00E', '0x010');
INSERT INTO edges (start, end) VALUES ('0x00F', '0x010');