--Author: Ilann Cote
--Written on the 26th of October 2021

local sim = {}
inspect = require("inspect")
createvec = require('createvec')
-- local inspect = require("inspect")
-- local remove_all_metatables = function(item, path)
--   if path[#path] ~= inspect.METATABLE then return item end
-- end
-- local removemtoption = {process = remove_all_metatables}

RK = require('rk')

function forwardeuler(fun, tspan, y0, step)
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

function getaccelerationatapointdueto_a_body(x, p, m)
  local distancevector = p - x
  local distancescalar = distancevector:length()
  if distancescalar == 0 then
    return 0 * distancevector
  end
  local unitvec = (1/distancescalar) * distancevector
  local norm = m/distancescalar^(2)
  return norm * unitvec
end


function getaccelerationatapointdueto_multiple_bodies(v, bodies, bodytoskip)

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

function getdiffequ(bodies, bodytoskip)
  local function diffequ(tn, yn)
    return createvec(yn[2], getaccelerationatapointdueto_multiple_bodies(yn[1], bodies, bodytoskip))
  end
  return diffequ
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function sim.updatewithforwardeuler(self, dt, stepsize)
  local bodies = self.bodies
  MASTERLOG[MASTERLOGINDEX] = deepcopy(bodies)
  MASTERLOGINDEX = MASTERLOGINDEX+1

  dt = dt or 0.01

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
  print(MASTERLOGINDEX)

  return dt

end

function sim.updatewithrk(self, dt, stepsize)
  local bodies = self.bodies

  dt = dt or 0.01

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

  return dt

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
  return dt
end

function sim.getgravity(self, x, y)
  return superrule(createvec(x, y), self.bodies)
end

function sim.init(bodies)
  local ret = {}
  bodies = bodies or {}
  ret.bodies = {}
  for b = 1, #bodies do
    ret.bodies[b] = {}
    for i = 1, 6 do
      ret.bodies[b][i] =bodies[b][i]
    end
  end

  MASTERLOG = {}
  MASTERLOGINDEX = 1

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

function sim.printbodies(self)
  local bodies = self.bodies
  infostr = ""
  for i = 1, 4 do
    for ii = 1, 4 do

      infostr = infostr.." "..string.format("%1.60f",bodies[i][ii])
      infostr = infostr.."\n"
    end
    infostr = infostr.."\n"
  end
  print(infostr)
end

function sim.printcenter(self)
  local bodies = self.bodies
  local center_mass = {0, 0}
  for i = 1, #bodies do

    center_mass[1] = center_mass[1] + bodies[i].x
    center_mass[2] = center_mass[2] + bodies[i].y
  end
  print(string.format("%1.60f",center_mass[1]), string.format("%1.60f",center_mass[2]))
end

return sim
