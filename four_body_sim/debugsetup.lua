simlib = require('debugsim')

four_body_sim = simlib.init()

four_body_sim:add_body(1, 0, 0, -1, 1, 1)
four_body_sim:add_body(-1, 0, 0, 1, 1, 2)
four_body_sim:add_body(0, 1, 1, 0, 1, 3)
four_body_sim:add_body(0, -1, -1, 0, 1, 4)
