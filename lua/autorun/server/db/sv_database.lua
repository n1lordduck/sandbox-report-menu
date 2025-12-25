if not SERVER then return end

sql.Begin()

sql.Query([[
    CREATE TABLE IF NOT EXISTS reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reported_sid TEXT NOT NULL,
        reporter_sid TEXT NOT NULL,
        reason TEXT NOT NULL,
        proof TEXT,
        created_at INTEGER NOT NULL,
        staff_username TEXT,
        staff_steamid INTEGER ,
        closed_at INTEGER NOT NULL,
        status TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS archivedreports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reported_sid TEXT NOT NULL,
        reporter_sid TEXT NOT NULL,
        reason TEXT NOT NULL,
        proof TEXT,
        created_at INTEGER NOT NULL,
        staff_username INTEGER,
        staff_steamid INTEGER,
        closed_at INTEGER NOT NULL,
        status TEXT NOT NULL
    );
    
]])

sql.Commit()
