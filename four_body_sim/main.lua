--Author: Ilann Cote
--Written on the 26th of October 2021

function love.load()

  width, height = love.graphics.getDimensions( )

  local simlib = require('sim')

  four_body_sim = simlib.init()

  four_body_sim:add_body(1, 0, 0, -1, 1, 1)
  four_body_sim:add_body(-1, 0, 0, 1, 1, 2)
  four_body_sim:add_body(0, -1, -1, 0, 1, 4)
  four_body_sim:add_body(0, 1, 1, 0, 1, 3)


  -- four_body_sim:add_body(1, 0, 0, 1, 1, 1)
  -- -- four_body_sim:add_body(-10000, 0, 0, 0, 1, 2)
  -- -- four_body_sim:add_body(0, 1000, 1, 0, 1, 3)
  -- four_body_sim:add_body(0, -1, 0, 0, 1, 4)

  debug = ""

  inspect = require('inspect')

  zoom = 100


end

local function getaccelerationatapointdueto_a_body(x, p, m)
  local distancevector = p - x
  local distancescalar = distancevector:length()
  if distancescalar == 0 then
    return 0 * distancevector
  end
  local unitvec = (1/distancescalar) * distancevector
  local norm = m/distancescalar^(2)
  return norm * unitvec
end

function toscreen(x, y)
  return width/2 + x*zoom, height/2 - y*zoom
end

function tosim(x, y)
  return (x- width/2)/zoom, -(y-height/2)/zoom
end

function love.update(dt)



  -- four_body_sim:updatewithforwardeuler()
  four_body_sim:updatewithrk()

end

createvec = require("createvec")


function love.draw()

  local bodies = four_body_sim:get_bodies()

  love.graphics.setColor(0.1, 0.3, 0)
  local sx, sy
  for i = 1, #bodies do
    sx, sy = toscreen(bodies[i].x, bodies[i].y)
    love.graphics.circle("fill", sx, sy, 10)
  end


  debug = inspect(bodies)
  love.graphics.print(debug)


  --draws a poor map of the ode
  -- --
  -- local gridsize = 30
  -- local vec
  -- local x, y, sx2, sy2
  --
  --
  -- for sx = 0, width, gridsize do
  --   for sy = 0, height, gridsize do
  --     x, y = tosim(sx, sy)
  --
  --     -- vec = four_body_sim:getgravity(tosim(sx, sy))
  --     vec = getaccelerationatapointdueto_a_body(createvec(x, y), createvec(bodies[1].x, bodies[1].y), 1)
  --
  --     sx2, sy2 = toscreen(vec[1]+x, vec[2]+y)
  --
  --     love.graphics.setColor(0.3, 0.1, 0.5)
  --     love.graphics.line(sx, sy, sx2, sy2)
  --
  --     love.graphics.setColor(1, 0.1, 0.5)
  --     love.graphics.circle("fill",sx, sy, 2)
  --     -- love.graphics.circle("fill", sx, sy, 5)
  --   end
  -- end



end

function love.mousepressed( x, y, button, istouch, presses )




end

function love.mousemoved( x, y, dx, dy, istouch )

end

function love.keypressed( key, scancode, isrepeat )


  if key == 'space' then
    four_body_sim:updatewithforwardeuler()
  end

end

function love.wheelmoved(x, y)

end
