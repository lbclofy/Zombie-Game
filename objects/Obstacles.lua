Obstacles = {}

local composer = require( "composer" )

function Obstacles:newBox( type, rotation)
	local boxRotate = rotation or 0
	local w, h = _W*.1, _W*.1


	--local boxGroup = display.newGroup()
	local box = display.newRect( 0, 0, w, h )
	box.rotation = boxRotate
	box:setFillColor(0,0,0)

	physics.addBody( box, "static", { density=1.0 , friction=0, bounce=1 } )

	return box
end

function Obstacles:newCircle(r)
	--local circleGroup = display.newGroup()
	local circle = display.newCircle( 0, 0, r )
	circle:setFillColor(0,0,0)

	physics.addBody( circle, "static", { density=1.0 , friction=0, bounce=1,  radius = r } )

	return circle
end

function Obstacles:newPolygon( vertices )

	local polygon = display.newPolygon( 0, 0, vertices )
	polygon:setFillColor(0,0,0)

	physics.addBody( polygon, "static", { density=1.0 , friction=0, bounce=1,  shape = vertices } )

	return polygon
end

function Obstacles:newBorder( w, h )

	--local boxGroup = display.newGroup()
	local border = display.newRect( 0, 0, w, h )
	border.rotation = boxRotate
	border:setFillColor(1,0,0)

	physics.addBody( border, "static", { density=1.0 , friction=0, bounce=1  } )




	return border
end


return Obstacles