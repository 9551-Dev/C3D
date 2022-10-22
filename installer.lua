fs.makeDir("C3D")
local github_api = http.get(
	"https://api.github.com/repos/9551-Dev/C3D/git/trees/master?recursive=1",
	_G._GIT_API_KEY and {Authorization = 'token ' .. _G._GIT_API_KEY}
)

local list = textutils.unserialiseJSON(github_api.readAll())
local ls = {}
local len = 0
github_api.close()
for k,v in pairs(list.tree) do
    if v.type == "blob" and v.path:lower():match(".+%.lua") then
        ls["https://raw.githubusercontent.com/9551-Dev/C3D/master/"..v.path] = v.path
        len = len + 1
    end
end
local percent = 100/len
local finished = 0
local size_gained = 0
local downloads = {}
for k,v in pairs(ls) do
    table.insert(downloads,function()
        local web = http.get(k)
        local file
        if v == "c3d.lua" then
            file = fs.open("./c3d.lua","w")
        else
            file = fs.open("./libC3D/"..v,"w")
        end
        local wd = web.readAll()
        file.write(wd)
        file.close()
        web.close()
        finished = finished + 1
        local file_size = #("%q"):format(wd)
        size_gained = size_gained + file_size
        print("downloading "..v.."  "..tostring(math.ceil(finished*percent)).."% "..tostring(math.ceil(file_size/1024*10)/10).."kB total: "..math.ceil(size_gained/1024).."kB")
    end)
end
parallel.waitForAll(table.unpack(downloads))
print("Finished downloading C3D")
