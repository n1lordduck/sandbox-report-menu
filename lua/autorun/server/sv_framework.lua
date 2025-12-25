ReportMenu:print("Adding serverside definitions")

local Report = {}
Report.__index = Report

function Report:Close()
    self.status = "closed"
    self.closed_at = os.time()
end

function createReport(info)
    return setmetatable(info, Report)
end

ReportMenu:print("Adding sql functions")

function reportLookupByID(reportID)
    if not SERVER then return end

    if not reportID then return nil end

    local query = string.format([[
        SELECT * FROM reports WHERE id = %s;
    ]], sql.SQLStr(reportID))

    local result = sql.Query(query)

    if result == false then
        print("[ReportMenu] SQL error:", sql.LastError())
        return nil
    end

    return result and result[1] or "No report found"
end


-- @param report Report
function insertReportDB(report)
    if not SERVER then return end 

    sql.Query(string.format([[
        INSERT INTO reports (
            reported_sid,
            reporter_sid,
            reported_name,
            reason,
            proof,
            created_at,
            status
        ) VALUES (%s, %s, %s, %s, %s, %d, %s);
    ]],
        sql.SQLStr(report.reported_sid),
        sql.SQLStr(report.reporter_sid),
        sql.SQLStr(report.reported_name or ""),
        sql.SQLStr(report.reason),
        sql.SQLStr(report.proof or ""),
        report.created_at,
        sql.SQLStr(report.status)
    ))
end

ReportMenu:print("Finished adding serverside functions")
