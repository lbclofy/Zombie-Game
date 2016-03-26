UIElements = {}

local composer = require( "composer" )
local widget = require( "widget" )
local drawUI = require("draw")

function UIElements:newStart( gameBall, angle )
	
	local start = display.newText( "Start", 0, 0, native.systemFont, 16 )
	start:setFillColor(0,0,0)
	start.ball = gameBall
    -- NEED TO PUT IN THING TO STOP// WHY NOT JUST OVERLAY THAT 

	function start:resetBall( ball )
		start.ball = ball
	end

	
	local function startGame( self, event )
    	start.ball:applyForce( math.cos(math.rad(angle))*forceFactor, math.sin(math.rad(angle))*forceFactor, start.ball.x, start.ball.y)
	    return true
	end 
	start.touch = startGame
	start:addEventListener( "touch", start )

	return start
end

function UIElements:newReset( gameBall )
    
    local reset = display.newText( "Reset", 0, 0, native.systemFont, 16 )
    reset:setFillColor(0,0,0)
    reset.ball = gameBall
    -- NEED TO PUT IN THING TO STOP// WHY NOT JUST OVERLAY THAT 

--[[
    
    local function resetBall( self, event )
        start.ball:applyForce( math.cos(math.rad(angle))*forceFactor, math.sin(math.rad(angle))*forceFactor, start.ball.x, start.ball.y)
        return true
    end 
    reset.touch = startGame
    reset:addEventListener( "touch", reset )]]

    return start
end

function UIElements:newMenu( )

	local menu = display.newText( "Menu", 0, 0, native.systemFont, 16 )
	menu:setFillColor(0,0,0)

	local function gotoMenu( self, event )
	    composer.gotoScene( "menu" )
	    return true
	end 
	menu.touch = gotoMenu
	menu:addEventListener( "touch", menu )

	return menu
end



function UIElements:newScroll( group, botY)
	local endY =  botY or _H
	local scrollView

	-- ScrollView listener
	local function scrollListener( event )

		local x, y = scrollView:getContentPosition()

    	local phase = event.phase
        --[[
    	if ( phase == "began" ) then --print( "Scroll view was touched" )
    	elseif ( phase == "moved" ) then --print( "Scroll view was moved" )
   		elseif ( phase == "ended" ) then --print( "Scroll view was released" )
  	    end

    -- In the event a scroll limit is reached...
	    if ( event.limitReached ) then
	        if ( event.direction == "up" ) then 
	        elseif ( event.direction == "down" ) then 
	        elseif ( event.direction == "left" ) then print( "Reached right limit" )
	        elseif ( event.direction == "right" ) then print( "Reached left limit" )
	        end
	    end
]]
	--    return true
	end

	-- Create the widget
	scrollView= widget.newScrollView(
	    {
	        top = 0,
	        left = 0,
	        width = _W,
	        height = _H,
	        scrollWidth = _W,
	        scrollHeight = endY,
	        hideScrollBar = false,
	        listener = scrollListener,
	        horizontalScrollDisabled = true,
	        backgroundColor = { 0, 0, 1, .1 }
	    }
	)
	scrollView:insert( group )

	return scrollView
end

function UIElements:newDraw( scrollView, canvas )

	local draw = display.newText( "Draw", 0, 0, native.systemFont, 16 )
	draw:setFillColor(0,0,0)

	local function onObjectTap( event )
		scrollView:setIsLocked( true ) 
		isDrawing = true
	end 
	draw.tap = onObjectTap
	draw:addEventListener( "tap", object )

	return draw
end

function UIElements:newStatusBar( canvas, draw, eraser )

	local progressView = widget.newProgressView(
    {
        left = 0,
        top = 0,
        width = _W*.1,
        
    }
)
	progressView:setProgress( 1 )
	
	return progressView

end

function UIElements:newEraser( scrollView, canvas, status, xCoords, yCoords )

local eraserFilter = { categoryBits=4, maskBits=2 } 
local eraseR = ballR*2



local function eraseLine( event )
    local t = event.target

    -- Print info about the event. For actual production code, you should
    -- not call this function because it wastes CPU resources.

    local phase = event.phase
    if "began" == phase then
        -- Make target the top-most object
        local parent = t.parent
        parent:insert( t )
        display.getCurrentStage():setFocus( t )

        -- Spurious events can be sent to the target, e.g. the user presses 
        -- elsewhere on the screen and then moves the finger over the target.
        -- To prevent this, we add this flag. Only when it's true will "move"
        -- events be sent to the target.
        t.isFocus = true

        -- Store initial position
        t.x0 = event.x - t.x
        t.y0 = event.y - t.y
    elseif t.isFocus then
        if "moved" == phase then
            -- Make object move (we subtract t.x0,t.y0 so that moves are
            -- relative to initial grab point, rather than object "snapping").
            t.x = event.x - t.x0
            t.y = event.y - t.y0
        elseif "ended" == phase or "cancelled" == phase then
            display.getCurrentStage():setFocus( nil )
            t.isFocus = false
           -- t.canErase = false

            local distance = math.sqrt((event.x - event.xStart) ^ 2 + (event.y - event.yStart) ^ 2)
            local transTime = distance/maxSpeed*1000
            local function listener()
            	 t.canErase = true
            end

            --transition.to( t, { time=transTime, x = xCoords, y = yCoords, easing = easing.outBack, onComplete = listener } )
           
            
        end
    end

    -- Important to return true. This tells the system that the event
    -- should not be propagated to listeners of any objects underneath.
    return true

end



local function onLocalCollision( self, event )
  --  print( event.target )        
  --  print( event.other )  
    if self.canErase == true then
    	if (event.other.distance) then
   -- 		print ("ERASED DISTANCE : " .. event.other.distance )  
    --		print(canvas.totalDistance .. " " .. canvas.distanceDrawn)
    		canvas.distanceDrawn = canvas.distanceDrawn - event.other.distance
    	end   
    	status:setProgress( (canvas.totalDistance - canvas.distanceDrawn)/canvas.totalDistance )

    display.remove(event.other)
	end

end

local function onLocalPostCollision( self, event )
    if self.canErase == true then
    	if (event.other.distance) then
    		canvas.distanceDrawn = canvas.distanceDrawn - event.other.distance
    	end   
    	status:setProgress( (canvas.totalDistance - canvas.distanceDrawn)/canvas.totalDistance )
    display.remove(event.other)
	end
end

    local eraser =  display.newCircle(  0, 0, eraseR )
    eraser.x, eraser.y = xCoords, yCoords
    eraser.canErase = true
    eraser:setFillColor( 1, 0,0 )
    eraser.strokeWidth = 6
    eraser:setStrokeColor( 200,200,200,255 )
    physics.addBody( eraser, "dynamic", { density=0, friction=0, bounce=0, filter = eraserFilter, radius = eraseR} )
    eraser.gravityScale = 0
    eraser.isSensor = true
    eraser.canvas = canvas

    eraser.postCollision = onLocalPostCollision
    eraser:addEventListener( "postCollision", eraser )
     eraser.collision = onLocalCollision
    eraser:addEventListener( "collision", eraser )
    eraser:addEventListener( "touch", eraseLine )



	return eraser
end




return UIElements