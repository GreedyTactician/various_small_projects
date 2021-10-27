--Author: Ilann Cote
--Written on the 26th of October 2021

local simlib = require('sim')

inspect = require('inspect')
local remove_all_metatables = function(item, path)
  if path[#path] ~= inspect.METATABLE then return item end
end
local removemtoption = {process = remove_all_metatables}


four_body_sim = simlib.init()

four_body_sim:add_body(1, 0, 0, -1, 1, 1)
-- four_body_sim:add_body(-1, 0, 0, 1, 1, 1)

print(inspect(four_body_sim:get_bodies(), removemtoption))

four_body_sim:updatewithrk()

print(inspect(four_body_sim:get_bodies(), removemtoption))
