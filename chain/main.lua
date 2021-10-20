

function love.load()

  width, height = love.graphics.getDimensions( )

  chain = require('chain')

  achain = chain.new_chain(100, 200, 5)


end

function love.update(dt)

  chain.iterate(achain, dt)



end


function love.draw()

  love.graphics.setColor(1, 0.5, 0.3)
  local x1, x2, y1, y2
  x1 = achain[1][1]
  y1 = achain[1][2]

  for i = 2, achain.n do
    love.graphics.setColor(0.3, 0.5, 0.3)
    love.graphics.circle("fill", x1, y1, 5)

    love.graphics.setColor(1, 0.5, 0.3)

    x2 = achain[i][1]
    y2 = achain[i][2]
    love.graphics.line(x1, y1, x2, y2)

    x1 = x2
    y1 = y2
  end


end

function love.mousepressed( x, y, button, istouch, presses )

  achain[1][1] = x
  achain[1][2] = y

end

function love.mousemoved( x, y, dx, dy, istouch )
  achain[1][1] = x
  achain[1][2] = y

end

function love.keypressed( key, scancode, isrepeat )



end

function love.wheelmoved(x, y)

end
