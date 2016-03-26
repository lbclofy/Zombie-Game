local composer = require( "composer" )
local physics = require ( "physics" )
physics.setDrawMode("hybrid")
local obs = require("objects.obstacles")
local po = require("objects.playobjects")
local ui = require("objects.uielements")
local drawUI = require("draw")


local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------

local isPlaying = false
local gameBall

local function gameLoop()
    print("x:" .. gameBall.x .. "y:" .. gameBall.y)
end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    local scrollGroup = display.newGroup()

    physics.start()

    gameBall = po:newBall()
    gameBall.x, gameBall.y = centerX, _H*.02
     scrollGroup:insert(gameBall)
    gameBall:applyForce( math.random(-1, 1), math.random(-1, 1), gameBall.x, gameBall.y )

    local star = po:newStar()
    star.x, star.y = centerX, _H*.25
    scrollGroup:insert(star)

    local star = po:newStar()
    star.x, star.y = centerX, _H*.5
    scrollGroup:insert(star)

    local star = po:newStar()
    star.x, star.y = centerX, _H*.75
    scrollGroup:insert(star)



    local gameGoal = po:newGoal()
    gameGoal.x, gameGoal.y = centerX, _H*1.25
    scrollGroup:insert(gameGoal)

    sceneGroup:insert(scrollGroup)

    --local bg = ui:newScroll(scrollGroup,gameGoal.y)
    --sceneGroup:insert(bg)

    local start = ui:newStart(gameBall, 90)
    start.x, start.y = _W*.1, _H*.1
    sceneGroup:insert(start)

    local menu = ui:newMenu()
    menu.x, menu.y = _W*.8, _H*.1
     sceneGroup:insert(menu)



    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then

     --   Runtime:addEventListener("enterFrame", gameLoop)

        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    --    Runtime:removeEventListener("enterFrame", gameLoop)
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view


    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene