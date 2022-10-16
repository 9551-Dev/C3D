local selfDir = fs.getDir(select(2,...) or "")

local old_path = package.path
package.path = string.format(
    "/%s/?.lua;/rom/modules/main/?.lua",
    selfDir
)

local utils = {
    colors=require("common.color_util"),
    draw=require("common.draw_util"),
    generic=require("common.generic"),
    string=require("common.string_util"),
    table=require("common.table_util"),
    window=require("common.window_util"),
    parse=require("common.parser_util")
}

local runtime_env = setmetatable({
    c3d={},
    utils=utils
},{__index=_ENV})

local ok,err = pcall(require("main"),runtime_env,selfDir,...)

package.path = old_path

return {init_ok=ok,env=err,util=utils}