--Author: Ilann Cote
--Written on the 26th of October 2021
local chain = {}

--creates a table describing the links of a chain
--the chain will lie on the x axis starting from the origin
function chain.new_chain(length, nodes, stretch_factor, propagation)
  propagation = propagation or 1
  local chain = {}
  chain.n = nodes
  local nodedistance = (length/nodes)
  chain.k = stretch_factor * (propagation/nodedistance)^2
  chain.nodedistance = nodedistance
  chain.damping = 0.995
  for i = 1, nodes do
    table.insert(chain, {nodedistance*(i-1), 0, 0, 0}) --{x, y, vx, vy}
  end
  return chain
end

local function sign(number)
   if number > 0 then
      return 1
   elseif number < 0 then
      return -1
   else
      return 0
   end
end

--does a simple euler method iteration of the chain
function chain.iterate(chain, dt)
  local xforces = {}
  local yforces = {}

  local dx = {}
  local dy = {}

  for i = 1, chain.n-1 do
    dx[i+0.5] = chain[i][1] - chain[i+1][1]
    dy[i+0.5] = chain[i][2] - chain[i+1][2]
  end

  local x1, x2
  for i = 2, chain.n-1 do
    x1 = sign(dx[i-0.5])*(math.abs(dx[i-0.5]) - chain.nodedistance)
    x2 = -sign(dx[i+0.5])*(math.abs(dx[i+0.5]) - chain.nodedistance)
    xforces[i] = chain.k*(x1+x2)

    y1 = sign(dy[i-0.5])*(math.abs(dy[i-0.5]) - chain.nodedistance)
    y2 = -sign(dy[i+0.5])*(math.abs(dy[i+0.5]) - chain.nodedistance)
    yforces[i] = chain.k*(y1+y2)
  end

  for i = 2, chain.n-1 do
    --update velocity
    chain[i][3] = chain[i][3] * chain.damping + xforces[i] * dt
    chain[i][4] = chain[i][4] * chain.damping + yforces[i] * dt

    --update position
    chain[i][1] = chain[i][1] + chain[i][3]
    chain[i][2] = chain[i][2] + chain[i][4]
  end
end


return chain
