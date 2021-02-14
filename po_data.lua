local po_path = hs.fs.pathToAbsolute("~/").."/.po/"

-- Check that the po path is there
os.execute("mkdir -p "..po_path)

local base_type = {pomos = {}} -- an empty pomodoro base for new projects

function add_entry(project_name)
    local proj_path = po_path .. project_name .. ".json"
    local data = nil
    if hs.fs.displayName(proj_path) then -- check if file exists
        data = hs.json.read(proj_path)
    else -- project json doesnt exist yet
        data = base_type
    end
    data.pomos[#data.pomos+1] = os.date("%d-%m-%Y %H-%M-%S")
    hs.json.write(data, proj_path, true, true)
end

