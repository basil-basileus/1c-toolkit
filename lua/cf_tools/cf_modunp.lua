local ffi = require("ffi")

local iconv = require 'iconv'

local lfs = require "lfs"

local cf_inside = require 'cf_tools.cf_inside'

local function write(path, data)
    local file  = assert(io.open(path, "wb"))
    file:write(data)
    file:close()
end

local src, dst = arg[1], arg[2]

if src and dst then

    local dir = dst:sub(-1) == '/' and dst or dst..'/'
    lfs.mkdir(dir)

    local utf8_to_cp1251 = iconv.new('CP1251', 'UTF-8')

    local list = cf_inside.ReadModulesFromFile(src)
    local fname
    for _, item in ipairs(list) do
        fname = utf8_to_cp1251:iconv(item.mod_type == 'object' and 'МодульОбъекта' or item.mod_name)
        write(dir..fname..'.txt', item.mod_text)
    end

end