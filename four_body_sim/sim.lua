--Author: Ilann Cote
--Written on the 26th of October 2021

local sim = {}

local createvec = require('createvec')
-- local inspect = require("inspect")
-- local remove_all_metatables = function(item, path)
--   if path[#path] ~= inspect.METATABLE then return item end
-- end
-- local removemtoption = {process = remove_all_metatables}

local RK = require('rk')

local function forwardeuler(fun, tspan, y0, step)
  local ret = {}
  local tn = tspan[1]
  local yn = y0

  while tn<tspan[2] do
    yn = yn + step * fun(tn, yn)
    table.insert(ret, {tn, yn})

    tn = tn + step
  end

  return ret
end

local function getaccelerationatapointdueto_a_body(x, p, m)
  local distancevector = p - x
  local distancescalar = distancevector:length()
  print(distancescalar)
  if distancescalar == 0 then
    return 0 * distancevector
  end
  local unitvec = (1/distancescalar) * distancevector
  local norm = m/distancescalar^(2)
  return norm * unitvec
end


local function getaccelerationatapointdueto_multiple_bodies(v, bodies, bodytoskip)

  local ret = createvec(0, 0)
  local p
  for i = 1, #bodies do
    if bodytoskip ~= i then
      p = createvec(bodies[i].x, bodies[i].y)
      ret = ret+getaccelerationatapointdueto_a_body(v, p, bodies[i].mass)
    end
  end
  return ret
end

local function getdiffequ(bodies, bodytoskip)
  local function diffequ(tn, yn)
    return createvec(yn[2], getaccelerationatapointdueto_multiple_bodies(yn[1], bodies, bodytoskip))
  end
  return diffequ
end


function sim.updatewithforwardeuler(self, dt, stepsize)
  local bodies = self.bodies

  dt = dt or 0.1

  local results = {}

  local fun
  local stepsize = stepsize or 0.01
  local numberofsteps = math.floor(dt/stepsize)
  local numberofsteps = numberofsteps == 0 and 1 or numberofsteps
  local tspan = {0, numberofsteps*stepsize}
  local y0, p0, v0

  for i = 1, #bodies do
    fun = getdiffequ(bodies, i)

    p0 = createvec(bodies[i].x, bodies[i].y)
    v0 = createvec(bodies[i].vx, bodies[i].vy)
    y0 = createvec(p0, v0)
    results[i] = forwardeuler(fun, tspan, y0, stepsize)
  end

  for i = 1, #bodies do
    __, y0 = unpack(results[i][#results[i]])
    p0 = y0[1]
    v0 = y0[2]
    bodies[i][1] = p0[1]
    bodies[i][2] = p0[2]
    bodies[i][3] = v0[1]
    bodies[i][4] = v0[2]
  end

end

function sim.updatewithrk(self, dt, stepsize)
  local bodies = self.bodies

  dt = dt or 0.04

  local results = {}

  local fun
  local stepsize = stepsize or 0.0001
  local numberofsteps = math.floor(dt/stepsize)
  local numberofsteps = numberofsteps == 0 and 1 or numberofsteps
  local tspan = {0, numberofsteps*stepsize}
  local y0, p0, v0
  local t, y


  for i = 1, #bodies do
    fun = getdiffequ(bodies, i)
    p0 = createvec(bodies[i].x, bodies[i].y)
    v0 = createvec(bodies[i].vx, bodies[i].vy)
    y0 = createvec(p0, v0)

    t, y = RK.rk4(fun, stepsize, tspan, y0)

    results[i] = y
  end

  for i = 1, #bodies do
    y0 = results[i][#results[i]]
    p0 = y0[1]
    v0 = y0[2]
    bodies[i][1] = p0[1]
    bodies[i][2] = p0[2]
    bodies[i][3] = v0[1]
    bodies[i][4] = v0[2]
  end

end

function sim.updatewithrkFLAWED(self, dt, stepsize)
  local bodies = self.bodies

  dt = dt or 0.04

  local results = {}

  local fun
  local stepsize = stepsize or 0.0001
  local numberofsteps = math.floor(dt/stepsize)
  local numberofsteps = numberofsteps == 0 and 1 or numberofsteps
  local tspan = {0, numberofsteps*stepsize}
  local y0, p0, v0
  local t, y


  for i = 1, #bodies do
    fun = getdiffequ(bodies, i)

    p0 = createvec(bodies[i].x, bodies[i].y)
    v0 = createvec(bodies[i].vx, bodies[i].vy)
    y0 = createvec(p0, v0)

    t, y = RK.rk4(fun, stepsize, tspan, y0)

    results[i] = y

    --put it in right away
    y0 = results[i][#results[i]]
    p0 = y0[1]
    v0 = y0[2]
    bodies[i][1] = p0[1]
    bodies[i][2] = p0[2]
    bodies[i][3] = v0[1]
    bodies[i][4] = v0[2]
  end

  -- for i = 1, #bodies do
  --   y0 = results[i][#results[i]]
  --   p0 = y0[1]
  --   v0 = y0[2]
  --   bodies[i][1] = p0[1]
  --   bodies[i][2] = p0[2]
  --   bodies[i][3] = v0[1]
  --   bodies[i][4] = v0[2]
  -- end

end

function sim.getgravity(self, x, y)
  return superrule(createvec(x, y), self.bodies)
end

function sim.init()
  local ret = {}
  ret.bodies = {}
  setmetatable(ret, {__index = sim})
  return ret
end

local function char_key_to_index_key(table, key)
  local convert = {x = 1, y = 2, vx = 3, vy = 4, mass = 5,  id = 6}
  if type(table) == 'table' then
    return table[convert[key]]
  end
  return nil
end

function sim.add_body(self, x, y, vx, vy, mass, id)
  local val = {x, y, vx, vy, mass, id}
  setmetatable(val, {__index = char_key_to_index_key})
  table.insert(self.bodies, val)
end

function sim.get_bodies(self)
  return self.bodies
end

return sim
