local composer = require( "composer" )
local physics = require ( "physics" )
local obs = require("objects.obstacles")
local po = require("objects.playobjects")
local ui = require("objects.uielements")
local lvls = require("levels.levels")
local lm = require("ogt_levelmanager")
--local drawUI = require("draw_lofy")
local drawUI = require("draw")


local scene = composer.newScene()
physics.setDrawMode("hybrid")
physics.setScale( forceFactor*.10 )

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------

local isPlaying = false
local gameBall
local levelGroup

local function gameLoop()
    --print("x:" .. gameBall.x .. "y:" .. gameBall.y)
end

local function buildLevel( start )

    local group = display.newGroup()

    gameBall = po:newBall()
    gameBall.x, gameBall.y = centerX, _H*.05
    group:insert(gameBall)
    start:resetBall( gameBall )

    for k, v in pairs(lvls.levels[1]) do

        if k == 1 then
            print("Making Goal @ x: " .. lvls.levels[1][k][1] .. " y: " .. lvls.levels[1][k][2])
            local gameGoal = po:newGoal()
            gameGoal.x, gameGoal.y = lvls.levels[1][k][1], lvls.levels[1][k][2]
            group:insert(gameGoal)
        elseif k <=4 then
            print("Making Star @ x: " .. lvls.levels[1][k][1] .. " y: " .. lvls.levels[1][k][2])
            local star = po:newStar()
            star.x, star.y = lvls.levels[1][k][1], lvls.levels[1][k][2]
            group:insert(star)
        else
            if (lvls.levels[1][k][1] == 1) then
                -- lvls.levels[1][k][2 = x], lvls.levels[1][k][3 = y], lvls.levels[1][k][4 = type/size], lvls.levels[1][k][5 = rotation]
                local box = obs:newBox( lvls.levels[1][k][4], lvls.levels[1][k][5] )
                box.x, box.y = lvls.levels[1][k][2], lvls.levels[1][k][3]
                group:insert(box)

            else
              --  print(lvls.levels[1][i][1])
            end
        end
    end


    return group

end

local function buildStars()
end

local function resetLevel( start, canvas, status )
    display.remove(levelGroup)
    levelGroup = nil
    levelGroup = buildLevel( start ) 
    print(canvas)
    canvas:ghost()
    status:setProgress( 1)
    -- gameBall.x, gameBall.y = centerX, _H*.05
    --gameBall:setLinearVelocity( 0, 0 )
end

local function buildBorders( group1, group2, start, endY, canvas, status )

    local function resetCollision( self, event )
       
        local function onTimer( event )
            resetLevel(start, canvas, status)
            group1:insert( levelGroup )
        end
        local tm = timer.performWithDelay( 1, onTimer )
    end

    local leftBorder = obs:newBorder(10, endY)
    leftBorder.x, leftBorder.y = 0, endY*.5
    group1:insert(leftBorder)
    leftBorder.collision = resetCollision
    leftBorder:addEventListener( "collision", leftBorder )

    local rightBorder = obs:newBorder(10, endY)
    rightBorder.x, rightBorder.y = _W,  endY*.5
    group1:insert(rightBorder)
    rightBorder.collision = resetCollision
    rightBorder:addEventListener( "collision", rightBorder )

    local botBorder = obs:newBorder(_W, 10)
    botBorder.x, botBorder.y = centerX, endY
    group1:insert(botBorder)
    botBorder.collision = resetCollision
    botBorder:addEventListener( "collision", botBorder )

    local topBorder = obs:newBorder(_W, 10)
    topBorder.x, topBorder.y = centerX, 0
    group1:insert(topBorder)
    topBorder.collision = resetCollision
    topBorder:addEventListener( "collision", topBorder )

end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    local scrollGroup = display.newGroup()
    
    local goalY = lvls.levels[1][1][2]

    physics.start()
    physics.setGravity( 0, 0 )

-- NEED TO CHANGE LATER TO k.currentLevel
    local start = ui:newStart(gameBall, lvls.startAngle[1])
    start.x, start.y = _W*.1, _H*.05
    sceneGroup:insert(start)

    
   
    levelGroup = buildLevel( start )
    scrollGroup:insert( levelGroup )

   -- bg:setScrollWidth(_W*.5)

    sceneGroup:insert(scrollGroup)

    local bg = ui:newScroll( scrollGroup,goalY)
    sceneGroup:insert(bg)

  
    
    local menu = ui:newMenu()
    menu.x, menu.y = _W*.8, _H*.05
    sceneGroup:insert(menu)

    local status = ui:newStatusBar()
    status.x, status.y = _W*.25, _H*.1
    sceneGroup:insert(status)
    
    local canvas = drawUI.newCanvas({group = scrollGroup,  scrollView = bg, statusBar = status, totalDistance = lvls.drawLength[1]})
    sceneGroup:insert(canvas)
    print(canvas)

     buildBorders( scrollGroup, sceneGroup, start , goalY + ballR * 8, canvas, status)

    local draw = ui:newDraw( bg, canvas )
    draw.x, draw.y = _W*.25, _H*.05
    sceneGroup:insert(draw)

    local erase = ui:newEraser(gameBall, canvas, status, _W*.6, _H*.05 )
    scrollGroup:insert(erase)



    start:toFront()

    
    --bg:setIsLocked( true ) 
    




    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

       -- physics.pause()
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