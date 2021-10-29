--Author: Ilann Cote
--Written on the 26th of October 2021

function love.load()

  width, height = love.graphics.getDimensions( )

  local simlib = require('sim')

  four_body_sim = simlib.init()

  four_body_sim:add_body(1, 0, 0, -1, 1, 1)
  four_body_sim:add_body(-1, 0, 0, 1, 1, 2)
  four_body_sim:add_body(0, 1, 1, 0, 1, 3)
  four_body_sim:add_body(0, -1, -1, 0, 1, 4)

  body_colours = {{0.7, 0.3, 0}, {0.2, 0.4, 0}, {0.4, 0, 0.3}, {0, 0.3, 0.7}}
  border_colour = {0.7, 0.7, 0.5}

  trails = {{}, {}, {}, {}}
  trailindex = 0

  -- four_body_sim:add_body(1, 0, 0, 1, 1, 1)
  -- -- four_body_sim:add_body(-10000, 0, 0, 0, 1, 2)
  -- -- four_body_sim:add_body(0, 1000, 1, 0, 1, 3)
  -- four_body_sim:add_body(0, -1, 0, 0, 1, 4)

  debug = ""

  inspect = require('inspect')

  zoom = 170

  time = 0
  framecount = 0

  --adds the starting positions to the trail
  local sx, sy
  local bodies = four_body_sim:get_bodies()
  for i = 1, 4 do
    sx, sy = toscreen(bodies[i].x, bodies[i].y)

    trails[i][2*trailindex+1] = sx
    trails[i][2*trailindex+2] = sy

    --twice because a line segment ought to have at least 2 points
    trails[i][2*trailindex+3] = sx
    trails[i][2*trailindex+4] = sy
  end
  trailindex = trailindex + 2


end

--functions to convert back and forth between screen coordinates and simulation coordinates
function toscreen(x, y)
  return width/2 + x*zoom, height/2 - y*zoom
end
function tosim(x, y)
  return (x- width/2)/zoom, -(y-height/2)/zoom
end

function love.update(dt)

  -- local dt = four_body_sim:updatewithforwardeuler()
  local dt = four_body_sim:updatewithrk()
  time = time + dt
  framecount = framecount+1

end



function love.draw()

  local bodies = four_body_sim:get_bodies()
  love.graphics.setBackgroundColor(0.02, 0.06, 0.1)

  local center_mass = {0, 0}
  local center_velocity = {0, 0}

  for i = 1, #bodies do
    love.graphics.setColor(body_colours[bodies[i].id])
    love.graphics.points(trails[i])
  end

  local sx, sy
  for i = 1, #bodies do

    center_mass[1] = center_mass[1] + bodies[i].x
    center_mass[2] = center_mass[2] + bodies[i].y
    center_velocity[1] = center_velocity[1] + bodies[i].vx
    center_velocity[2] = center_velocity[2] + bodies[i].vy
    sx, sy = toscreen(bodies[i].x, bodies[i].y)

    --adds points to the trail
    trails[i][2*trailindex+1] = sx
    trails[i][2*trailindex+2] = sy

    --draws the border
    love.graphics.setColor(border_colour)
    love.graphics.circle("fill", sx, sy, 20)
    --draws the inside colour
    love.graphics.setColor(body_colours[bodies[i].id])
    love.graphics.circle("fill", sx, sy, 16)
  end

  -- if center_mass[1] ~= 0 or center_mass[2] ~= 0 then
  --   error(framecount)
  -- end

  love.graphics.setColor(1, 1, 1, 0.7)
  local infostr = ""

  -- for i = 1, 4 do
  --   for ii = 1, 4 do
  --
  --     infostr = infostr.." "..string.format("%1.60f",bodies[i][ii])
  --     infostr = infostr.."\n"
  --   end
  --   infostr = infostr.."\n"
  -- end
  local center_txt = "\nCenter mass at: "..center_mass[1]..", "..center_mass[2].."\nCenter velocity at: "..center_velocity[1]..", "..center_velocity[2]
  love.graphics.print("Time: "..time..center_txt.."\nUsing RK4. Bodies updated all at once.\nFixed step size of 0.01\n"..infostr.."\nRight Left Top Down OR Orange Green Purple Blue")
  -- love.graphics.print("Time: "..time.."\nCenter mass at: "..center_mass[1]..", "..center_mass[2].."\nUsing RK4. Bodies updated all at once.\nFixed step size of 0.000001\nThe right cicle starts with an error of +0.000000005")

  -- love.graphics.captureScreenshot("RK4_slower_with_error"..framecount..".PNG")
  love.graphics.captureScreenshot("Forward_Euler_"..framecount..".PNG")

  --adds to the size of the trail
  trailindex = trailindex + 1

  -- debug = inspect(bodies)
  -- love.graphics.print(debug)


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
