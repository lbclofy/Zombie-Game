PlayObjects = {}

local composer = require( "composer" )

local ballFilter = { categoryBits=1, maskBits=3 } 



function PlayObjects:newBall( )

	local ball = display.newCircle(  0, 0, ballR )
	ball:setFillColor(0,0,0)
	ball.type = "ball"

	physics.addBody( ball, { density=1.0 , friction=0.1, bounce=1, radius = ballR, filter = ballFilter } )


	return ball
end

function PlayObjects:newStar( )
	local starR = ballR*1.5
	local starRI = starR*.382

	local vertices = { 
	starR *math.cos( math.rad( -90 )), starR *math.sin( math.rad( -90 )),
	starRI*math.cos( math.rad( -54 )), starRI*math.sin( math.rad( -54 )), 
	starR *math.cos( math.rad( -18 )), starR *math.sin( math.rad( -18 )),
	starRI*math.cos( math.rad( 018 )), starRI*math.sin( math.rad( 018 )), 
	starR *math.cos( math.rad( 054 )), starR *math.sin( math.rad( 054 )),
	starRI*math.cos( math.rad( 090 )), starRI*math.sin( math.rad( 090 )), 
	starR *math.cos( math.rad( 126 )), starR *math.sin( math.rad( 126 )),
	starRI*math.cos( math.rad( 162 )), starRI*math.sin( math.rad( 162 )), 
	starR *math.cos( math.rad( 198 )), starR *math.sin( math.rad( 198 )),
	starRI*math.cos( math.rad( 234 )), starRI*math.sin( math.rad( 234 )),  }

	local star = display.newPolygon( 0, 0, vertices )
	star:setFillColor(0,0,0)
	star.type = "star"

	physics.addBody( star, "static", { density=0 , friction=0, bounce=0, radius = starR, filter = ballFilter } )
	star.isSensor = true

	local function onLocalCollision( self, event )
    	--print( event.target )
    	--print( event.other )           --the first object in the collision
    	display.remove(event.target)
	end
	star.collision = onLocalCollision
	star:addEventListener( "collision", star )


	return star
end

function PlayObjects:newGoal()
	local goalRadius = ballR*4
	local goal = display.newCircle( 0, 0, goalRadius )
	goal:setFillColor(1,0,0)
	goal.type = "goal"

	physics.addBody( goal, "static", { density=1.0 , friction=0.5, bounce=0.3, radius = goalRadius, filter = ballFilter } )
	goal.isSensor = true

	local function onLocalCollision( self, event )
    	--print( event.target )        --the first object in the collision
    	--print( event.other )         --the second object in the collision
    	---print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    	--print( event.otherElement )  --the element (number) of the second object which was hit in the collision
    	
  		composer.gotoScene( "levels.levelintermission" )
	end
	goal.collision = onLocalCollision
	goal:addEventListener( "collision", goal )

	return goal
end


return PlayObjects