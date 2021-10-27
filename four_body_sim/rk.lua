--Author: Ilann Cote
--Written on the 26th of October 2021

local rk4 = {}

function rk4.rk4(f, step, tspan, y0)
  local nexty = function(f, h, tn, yn)

    local k1 = f(tn, yn)
    local k2 = f(tn+h*0.5, yn+h*(k1*0.5))
    local k3 = f(tn+h*0.5, yn+h*(k2*0.5))
    local k4 = f(tn+h, yn+h*k3)

    ynplus1 = yn + h*(k1+2*k2+2*k3+k4)*(1/6)
    tnplus1 = tn+h
    return tnplus1, ynplus1
  end


  local y = {y0}
  local t = {tspan[1]}
  for i = tspan[1], tspan[2]-step, step do
    t[#t+1], y[#y+1] = nexty(f, step, i, y[#y])
  end

  if t[#t] ~= tspan[2] then
    t[#t+1], y[#y+1] = nexty(f, tspan[2]-t[#t], t[#t], y[#y])
  end

  return t, y
end


-- f = function(t, y) return y end
-- step = 0.3
-- tspan = {0, 1}
-- y0 = 1
--
-- t, y = rk4(f, step, tspan, y0)
--
-- print(t[#t], y[#y])

return rk4
