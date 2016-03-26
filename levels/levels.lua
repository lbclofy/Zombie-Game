Levels = {}

Levels.levels = {

--[[
	1: 		Goal Locations
	2-4:	Star locations
	Next:
			1: box , x,y, type: 1 box, 2 rectangle, 3 wall,

]]

--[[
	{ 	--level1
		{_W*.250,_W*1.25},
		{centerX,centerX},
		{_W*.75,_W*.75},
		{centerX,_W*1.00},
		{1, _W*.250, _W*.250, 5 },
	},

	{ 	--level2
		{_W*.750,_W*1.50},
		{centerX,centerX},
		{_W*.75,_W*.75},
		{centerX,_W*1.00},
		{1, _W*.250, _W*.250, 5 },
	},



	{ 	--level3
		{centerX,_W*1.75},
		{centerX,_W*.5},
		{centerX,_W*1},
		{centerX,_W*1.5},
		{1, centerX, _W*.75, 	2 },
		{1, _W*.25, _W*1,  		2, 45 },
		{1, _W*.75, _W*1,  		2, 45 },
		{1, centerX, _W*1.25, 	2, 45 },
	},


	{ 	--level4
		{centerX,_W*2.00},
		{_W*.333,_W*.45},
		{_W*.666,_W*.75},
		{centerX,_W*1.1},
		{1, _W*.25, _W*.45,  	5 },
		{1, _W*.75, _W*.45,  	5 },
		{1, _W*.25, _W*1.1,  	5 },
		{1, _W*.75, _W*1.1,  	5 },
		--{1, centerX, _W*1.5, 	2, 45 },
	},

	{ 	--level5	--- SURE ITS A REHASH BUT WE'LL SEE
		{centerX,_W*2.00},
		{_W*.333,_W*.45},
		{_W*.666,_W*.75},
		{centerX,_W*1.1},
		{1, _W*.25, _W*.45,  	5 },
		{1, _W*.75, _W*.45,  	5 },
		{1, _W*.25, _W*1.1,  	5 },
		{1, _W*.75, _W*1.1,  	5 },
		{1, centerX, _W*.75, 	1, 45 },
		{1, centerX, _W*1.5, 	2, 45 },
	},
	]]

	{ 	--level6	--- SURE ITS A REHASH BUT WE'LL SEE
		{centerX,_W*2.00},
		{_W*.333,_W*.8},
		{_W*.666,_W*.8},
		{centerX,_W*1.425},
		{1, _W*.50, _W*.4,  	3, 90 },
		{1, _W*.50, _W*.8,  	3 },
		{1, _W*.50, _W*1.2,  	3 },
		{1, _W*.50, _W*1.65,  	1, 45 },
		{1, _W*.30, _W*2.00,  	2 },
		{1, _W*.70, _W*2.00,  	2 },
	},


}

Levels.startAngle = {
--[[
		135,
		135,
		90,
		90,
		90,
	]]
		90,
}

Levels.drawLength = {
	--[[
		_W*.25,
		_W*.5,
		_W*.75,
		_W*1.0,
		_W*1.2,
		_W*1.6,
	]]
		_W*1.6,
}

function Levels:buildLevel()

end


return Levels