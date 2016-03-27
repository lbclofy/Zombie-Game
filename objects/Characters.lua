Characters = {}





function Characters:newZombie()

	local followParams = { segmentTime=50, constantRate=true, showPoints=true }
	local pathPrecision = 20

	local zombie = display.newPolygon( 0, 0, { 0,-28, 30,28, 0,20, -30,28 } )
	zombie:setFillColor( 1 )
	zombie.x = 100
	zombie.y = 100
	physics.addBody(zombie, {radius = 20})


	local function distBetween( x1, y1, x2, y2 )
		return math.sqrt( math.pow((x2 - x1),2) + math.pow((y2 - y1),2) )
	end

	local function angleBetween( srcX, srcY, dstX, dstY )
		return ( math.deg( math.atan2( dstY-srcY, dstX-srcX ) )+90 ) % 360
	end


	local function follow( params, obj, pathPoints, pathPrecision )

	if obj.currTrans ~= nil then
		transition.cancel( obj.currTrans )
	end

	local function nextTransition()

		if ( obj.nextPoint < #pathPoints ) then
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

				onComplete = nextTransition
			})
			obj.nextPoint = obj.nextPoint+1

		end
	end
	
	obj.nextPoint = 2
	nextTransition()

end


function onPlaneTouched(self, event)


	if(event.phase == "began") then
	
		self.points = {}
		table.insert(self.points, {x = event.x, y = event.y})

		display.getCurrentStage():setFocus( self )
		self.isFocus = true
		
	elseif (event.phase == "moved" and self.isFocus == true ) then

		
		
		if(#self.points == 0) then
			self.points = {}
			table.insert(self.points, {x = self.x, y = self.y})
			table.insert(self.points, {x = event.x, y = event.y})
		end

		local distance = math.sqrt(math.pow(self.points[#self.points].x - event.x, 2) + math.pow(self.points[#self.points].y - event.y, 2))
		if(distance > 20) then
			display.newCircle(event.x, event.y, 5)
			
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

zombie.touch = onPlaneTouched
zombie:addEventListener("touch", zombie)



	return zombie
end



return Characters