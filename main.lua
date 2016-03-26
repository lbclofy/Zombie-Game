
-- Abstract: Path Drawing
--
-- Version: 1.0
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2014 Corona Labs Inc. All Rights Reserved.
------------------------------------------------------------

local performance = require('performance')
performance:newPerformanceMeter()


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

_G._W = display.contentWidth
_G._H = display.contentHeight
_G.centerX = _W*.5
_G.centerY = _H*.5

_G.scale = _H/960
_G.ballR = _W*.025
_G.phi = 1.61803398875

_G.maxSpeed  = _W

_G.forceFactor = _W*.4

_G.isDrawing = false

_G.font = "Dyslexie Regular"
--attempting to get font to work
--_G.font = "data\Dyslexie Regular LP129383 (1)"

--Colors    { R = ,   G = ,     B = }
_G.Red =      { R = 244/255,  G = 067/255,  B = 054/255 }
_G.Red100 =   { R = 255/255,  G = 205/255,  B = 210/255 }
_G.Red300 =   { R = 229/255,  G = 115/255,  B = 115/255 }
_G.Red700 =   { R = 211/255,  G = 047/255,  B = 047/255 }
_G.Yellow =   { R = 225/255,  G = 196/255,  B = 000/255 }
_G.Green =    { R = 076/255,  G = 175/255,  B = 080/255 }
_G.Blue =     { R = 000/255,  G = 191/255,  B = 165/255 }--{ R = 033/255,  G = 150/255,  B = 243/255 }
_G.Blue100 =  { R = 187/255,  G = 222/255,  B = 251/255 }
_G.Blue300 =  { R = 100/255,  G = 181/255,  B = 246/255 }
_G.Blue700 =  { R = 025/255,  G = 118/255,  B = 210/255 }
_G.Purple =   { R = 156/255,  G = 039/255,  B = 176/255 }
_G.BlueGrey = { R = 096/255,  G = 125/255,  B = 139/255 }
_G.Black =    { R = 000/255,  G = 000/255,  B = 000/255 }
_G.White =    { R = 255/255,  G = 255/255,  B = 255/255 }
_G.hlColor =  { R = 244/255,  G = 067/255,  B = 054/255 }
_G.priColor = { R = Yellow.R, G = Yellow.G, B = Yellow.B}
_G.secColor = { R =  Blue.R,  G = Blue.G,   B = Blue.B  }

_G.outlineColor = { highlight = { r= 0, g=0, b=0 }, shadow = { r=0, g=0, b=0 } }



_G.fontSize = _W*.05
_G.phi = 1.618033988749894

display.setStatusBar( display.HiddenStatusBar )

local obs = require("objects.obstacles")

local physics = require( "physics" )
physics.setDrawMode( "hybrid" ) 
physics.start()
physics.setGravity( 0,0 )

--require "follow.lua" module (remove if using only main draw code)
--local followModule = require( "follow" )
--declare follow module parameters (remove if using only main draw code)
local followParams = { segmentTime=50, constantRate=true, showPoints=true }

local path
local leadingSegment
local pathPoints = {}
local anchorPoints = { {},{} }

--adjust this number to effect the "smoothness" of the path; lower value yields a more precise path
local pathPrecision = 20

	local follower = display.newPolygon( 0, 0, { 0,-28, 30,28, 0,20, -30,28 } )
	follower:setFillColor( 1 )
	follower.x = 100
	follower.y = 100
	physics.addBody(follower, {radius = 20})



local function distanceBetween( point1, point2 )
	local xfactor = point2.x-point1.x ; local yfactor = point2.y-point1.y
	local distanceBetween = math.sqrt((xfactor*xfactor) + (yfactor*yfactor))
	return distanceBetween
end

local function angleBetween( srcX, srcY, dstX, dstY )
	local angle = ( math.deg( math.atan2( dstY-srcY, dstX-srcX ) )+90 )
	return angle % 360
end

local function distBetween( x1, y1, x2, y2 )
	local xFactor = x2 - x1
	local yFactor = y2 - y1
	local dist = math.sqrt( (xFactor*xFactor) + (yFactor*yFactor) )
	return dist
end



local function follow( params, obj, pathPoints, pathPrecision )

	if obj.currTrans ~= nil then
		transition.cancel( obj.currTrans )
	end

	local function nextTransition()

		if ( obj.nextPoint > #pathPoints ) then
			--print( "FINISHED" )

		else
			--set variable for time of transition on this segment
			local transTime = params.segmentTime
			local dist = distBetween( obj.x, obj.y, pathPoints[obj.nextPoint].x, pathPoints[obj.nextPoint].y )
			--if "params.constantRate" is true, adjust time according to segment distance
			if ( params.constantRate == true ) then
				
				transTime = 2*(dist/pathPrecision) * params.segmentTime

			end
			
			--rotate object to face next point
			if ( obj.nextPoint < #pathPoints ) then
				obj.rotation = angleBetween( obj.x, obj.y, pathPoints[obj.nextPoint].x, pathPoints[obj.nextPoint].y )
			end
			--print(obj.rotation)
			local velocity = dist/transTime

			local flightAngel = math.atan2((obj.y - pathPoints[obj.nextPoint].y) , (obj.x - pathPoints[obj.nextPoint].x) ) * (180 / math.pi)
	
			local velocityX = math.cos(math.rad(flightAngel)) * 100 * -1
 			local velocityY = math.sin(math.rad(flightAngel)) * 100 * -1
	
			obj.rotation = flightAngel - 90

			obj:setLinearVelocity( velocityX, velocityY)
			--obj:setLinearVelocity( 50*math.cos( math.rad(obj.rotation) ), 50*math.sin( math.rad(obj.rotation) ) )
			--
			--transition along segment
			obj.currTrans = transition.to( obj, {
				tag = "moveObject",
				time = transTime,
				--x = pathPoints[obj.nextPoint].x,
				--y = pathPoints[obj.nextPoint].y,
				onComplete = nextTransition
			})
			obj.nextPoint = obj.nextPoint+1

		end
	end
	
	obj.nextPoint = 2
	nextTransition()

end

function followPoints(plane)

	if(plane.points == nil or #plane.points == 0) then return end;

	point = plane.points[1]

	local flightAngel = math.atan2((plane.y - point.y) , (plane.x - point.x) ) * (180 / math.pi)
	
	local velocityX = math.cos(math.rad(flightAngel)) * 100 * -1
 	local velocityY = math.sin(math.rad(flightAngel)) * 100 * -1
	
	plane.rotation = flightAngel - 90

	plane:setLinearVelocity( velocityX, velocityY)
	
	local enterFrameFunction = nil
	local checkForNextPoint
	checkForNextPoint = function(plane)
	
		if(plane ~= nil) then
	
			local dest = plane.dest

			local velX, velY = plane:getLinearVelocity()
		
			if(	(velX < 0 and plane.x < dest.x and velY < 0 and plane.y < dest.y) or  (velX > 0 and plane.x > dest.x and velY < 0 and plane.y < dest.y) or
				(velX > 0 and plane.x > dest.x and velY > 0 and plane.y > dest.y) or  (velX < 0 and plane.x < dest.x and velY > 0 and plane.y > dest.y) or #plane.points == 0) then
			
				Runtime:removeEventListener("enterFrame", enterFrameFunction)
				table.remove(plane.points, 1)

				if(#plane.points > 0) then
					followPoints(plane)
				end

			end		
		else
			Runtime:removeEventListener("enterFrame", enterFrameFunction)
		end
	end
	
	plane.dest = point
	enterFrameFunction = function(event) checkForNextPoint(plane) end

	Runtime:addEventListener("enterFrame", enterFrameFunction)

end

function onPlaneTouched(self, event)


	if(event.phase == "began") then
	
		self.points = {}
		table.insert(self.points, {x = event.x, y = event.y})

		display.getCurrentStage():setFocus( self )
		self.isFocus = true
		
	elseif (event.phase == "moved" and self.isFocus == true ) then

		display.newCircle(event.x, event.y, 5)
		
		if(#self.points == 0) then
			self.points = {}
			table.insert(self.points, {x = self.x, y = self.y})
			table.insert(self.points, {x = event.x, y = event.y})
		end

		local distance = math.sqrt(math.pow(self.points[#self.points].x - event.x, 2) + math.pow(self.points[#self.points].y - event.y, 2))
		if(distance > 20) then
			
			table.insert(self.points, {x = event.x, y = event.y})
		
			if(self.allowLineDraw == true) then 
				--followPoints(self)		 
				follow( followParams, self, self.points, pathPrecision )
 
				timer.performWithDelay(lineDrawInterval, function(new) self.allowLineDraw = true end)
			end
		end
	elseif(event.phase == "ended" and #self.points > 0) then
	
		local distance = math.sqrt(math.pow(self.points[#self.points].x - event.x, 2) + math.pow(self.points[#self.points].y - event.y, 2))
		if(self.isFocus == true and distance > 20) then
			table.insert(self.points, {x = event.x, y = event.y})
		end

		display.getCurrentStage():setFocus(nil)
		self.isFocus = false
		--followPoints(self)		 
		follow( followParams, self, self.points, pathPrecision )

		
	end
end

follower.touch = onPlaneTouched
follower:addEventListener("touch", follower)

local box = obs:newBox( 100, 0 )
box.x, box.y = 200,200

