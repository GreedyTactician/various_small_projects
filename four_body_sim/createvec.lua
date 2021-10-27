--Author: Ilann Cote 
--Written on the 26th of October 2021

local function add(a, b)
  local ret = {}
  setmetatable(ret, getmetatable(a))

  local minlength = math.min(#a, #b)
  for i = 1, minlength do
    table.insert(ret, a[i]+b[i])
  end
  return ret
end

local function sub(a, b)
  local ret = {}
  setmetatable(ret, getmetatable(a))

  local minlength = math.min(#a, #b)
  for i = 1, minlength do
    table.insert(ret, a[i]-b[i])
  end
  return ret
end

local function scalarmul(a, b)
  local scalar, vec
  if type(a) == "number" and type(b) == "table" then
    scalar = a
    vec = b
  elseif type(b) == "number" and type(a) == "table" then
    scalar = b
    vec = a
  else
    error("This is not a scalar operation", 2)
  end

  local ret = {}
  setmetatable(ret, getmetatable(vec))

  for i = 1, #vec do
    table.insert(ret, scalar*vec[i])
  end
  return ret
end

local function pow(a, b)
  if type(b) == "number" and type(a) == "table" then
    local ret = {}
    setmetatable(ret, getmetatable(a))
    for i = 1, #a do
      ret[i] = a[i]^b
    end
    return ret
  else
    error("Exponent is not a number")
  end
end

local index = {}

function index.dot(a, b)
  if #a == #b then
    local ret = {}
    setmetatable(ret, getmetatable(a))
    for i = 1, #a do
      ret[i] = a[i]*b[i]
    end
    return ret
  end
  error("Not the same size", 2)
end

function index.abs(a)
  local ret = {}
  setmetatable(ret, getmetatable(a))
  for i = 1, #a do
    ret[i] = math.abs(a[i])
  end
  return ret
end

--any 0 component will be kept at 0
function index.inverse(a)
  local ret = {}
  setmetatable(ret, getmetatable(a))
  for i = 1, #a do
    ret[i] = a[i] == 0 and 0 or 1/a[i]
  end
  return ret
end

function index.length(a)
  local ret = 0
  for i = 1, #a do
    ret = ret + a[i]^2
  end
  return ret^0.5
end



local inspect = require("inspect")

local function tostring(a)
  local remove_all_metatables = function(item, path)
    if path[#path] ~= inspect.METATABLE then return item end
  end

  return inspect(a, {process = remove_all_metatables})
end

local function createvec(...)
  arg = {...}
  setmetatable(arg, {__add = add, __sub = sub, __mul = scalarmul, __pow = pow, __tostring = tostring, __index = index})
  return arg
end
return createvec
