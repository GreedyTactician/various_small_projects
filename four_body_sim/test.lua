
a = 0.000000000000000000054210108624274992996191744059239535173908
b = 0.000000000000000000054210108624274999014722820269351575973839
-- a = 0.000000000000000000054210108624274992996191744059239535173908
-- b = 0.000000000000000000054210108624274999014722820269351575973839

midpoint = 0.0000000000000000000542101086242749960054572821642955555738735
negativemidpoint = -0.0000000000000000000542101086242749960054572821642955555738735
-- midpoint = 0.0000000000000000000542101086242749960054572821642955555738735
-- negativemidpoint = 0.0000000000000000000542101086242749960054572821642955555738735

print(string.format("%18.60f",a))
print(string.format("%18.60f",b))
print(string.format("%18.60f",midpoint))
print(string.format("%18.60f",negativemidpoint))
print("---")
print(string.format("%18.60f",a+b))
print(string.format("%18.60f",a+midpoint))
print(string.format("%18.60f",a+negativemidpoint))
print(string.format("%18.60f",midpoint+negativemidpoint))
print(string.format("%18.60f",b+midpoint))
print(string.format("%18.60f",b+negativemidpoint))
print("---")
print(string.format("%18.60f",a-b))
print(string.format("%18.60f",a-midpoint))
print(string.format("%18.60f",a-negativemidpoint))
print(string.format("%18.60f",midpoint-negativemidpoint))
print(string.format("%18.60f",b-midpoint))
print(string.format("%18.60f",b-negativemidpoint))
print("---")
print(string.format("%18.60f",b-a))
print(string.format("%18.60f",midpoint-a))
print(string.format("%18.60f",negativemidpoint-a))
print(string.format("%18.60f",negativemidpoint-midpoint))
print(string.format("%18.60f",midpoint-b))
print(string.format("%18.60f",negativemidpoint-b))


print(a==b)
