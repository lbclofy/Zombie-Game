
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
local chars = require("objects.characters")

local physics = require( "physics" )
physics.setDrawMode( "hybrid" ) 
physics.start()
physics.setGravity( 0,0 )

--require "follow.lua" module (remove if using only main draw code)
--local followModule = require( "follow" )
--declare follow module parameters (remove if using only main draw code)


--adjust this number to effect the "smoothness" of the path; lower value yields a more precise path

--[[
	local follower = display.newPolygon( 0, 0, { 0,-28, 30,28, 0,20, -30,28 } )
	follower:setFillColor( 1 )
	follower.x = 100
	follower.y = 100
	physics.addBody(follower, {radius = 20})
]]


local function distanceBetween( point1, point2 )
	local xfactor = point2.x-point1.x ; local yfactor = point2.y-point1.y
	local distanceBetween = math.sqrt((xfactor*xfactor) + (yfactor*yfactor))
	return distanceBetween
end







local box = obs:newBox( 100, 0 )
box.x, box.y = 200,200

local box = obs:newTrap( 100, 0 )
box.x, box.y = 400,200

local zombie = chars:newZombie()

