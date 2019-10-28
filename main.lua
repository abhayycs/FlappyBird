push = require 'push'
require 'params'
require 'bird'
require 'pipe'

START = 0
JUMP = 0

function initWindow()
	-- body
	CUSTOM_WIDTH, CUSTOM_HEIGHT = love.graphics.getDimensions()
	-- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
	push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {fullscreen = false,
		resizable = true, 
		vsync = true,
	})
	love.window.setTitle(TITLE)
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.window.background_img = love.graphics.newImage(BACKGROUND_IMG)
	love.window.ground_img  = love.graphics.newImage(GROUND_IMG)
end

function drawWindow(...)
	-- body
	love.graphics.draw(love.window.background_img, -backgroundScroll, 0, 0, 5, 3)
	love.graphics.draw(love.window.ground_img, -groundScroll, WINDOW_HEIGHT-150, 0, 5, 3)
	love.graphics.printf("Press Enter to Start the game", 0, WINDOW_HEIGHT/2, WINDOW_WIDTH, 'center')
end

function updateWindow(dt)
	-- body
	backgroundScroll = (backgroundScroll + backgroundScrollSpeed*dt)%(BACKGROUND_IMG_LOOPING_POINT)
	groundScroll = (groundScroll + groundScrollSpeed*dt)%(GROUND_IMG_LOOPING_POINT)
end

function love.keypressed(key)
	-- body
	love.keyboard.keyspressed[key] = true
	if key == 'escape' then 
		love.event.quit()
	end
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	-- body
	objMarginW = 8
	objMarginH = 4
	return (x1 < x2+w2-objMarginW and x2 < x1+w1-objMarginW and y1 < y2+h2-objMarginH and y2 < y1+h1-objMarginH)
end

function playSound(sound)
	-- body
	source = love.audio.newSource(sound, 'static')
	love.audio.play(source)
end

function love.touchpressed(id, x, y)
   --Do stuff when a touch is released
	if x < CUSTOM_WIDTH/2 then
    	START = 1
    else
    	JUMP = 1
    end
end

function love.load() 
	--init window
	love.keyboard.keyspressed = {}
	love.math.setRandomSeed(os.time())
	initWindow()
	initPipe()
end

function love.draw()
	-- body
	push:start()
	if flag == 0 then
  		push:resize(CUSTOM_WIDTH, CUSTOM_HEIGHT)
  		flag=1
	end

	drawWindow()
	drawBird()
	for _,i in ipairs(npipes) do
		drawPipe(i)
	end
	love.graphics.printf("Score: "..SCORE, 0, 0, 100, 'center')
	love.graphics.printf("FPS: "..love.timer.getFPS(), 0, 15, 100, 'center')
  	push:finish()  
end

function love.update(dt)
	-- body
	if love.keyboard.keyspressed['return'] or START == 1 then 
		-- reset environment
		if game_state == 2 then 
			initPipe()
			BIRD_Y = 0
			BIRD_DY = 0
			SCORE = 0
		end
		-- Start game
		if game_state ~= 1 then 
			start_time = os.time()
		end
		game_state = 1
	end
	-- Game started
	if game_state == 1 then
		updateWindow(dt)
		-- update bird
		if love.keyboard.keyspressed['space'] or JUMP == 1 then 
			BIRD_DY = -bird.jump
			playSound(JUMP_SOUND)
		end
		updateBird(dt)
		-- update pipes
		for _,i in ipairs(npipes) do
			updatePipe(dt, i)
		end
		SCORE = os.difftime(os.time(),start_time)
	end
	-- detect bird and pipe collision
	for _,i in ipairs(npipes) do
		if pipe[i].spawn and game_state == 1  then 
			if checkCollision(bird.x, bird.y, bird.width, bird.height, pipe[i].x, pipe[i].ytop, pipe.width, pipe.height)
			   or checkCollision(bird.x, bird.y, bird.width, bird.height, pipe[i].x, pipe[i].ybottom, pipe.width, pipe.height) then 
				game_state = 2
				playSound(HIT_SOUND)
			end
		end
	end
	-- reset keyspressed
	love.keyboard.keyspressed = {}
	START = 0
	JUMP = 0
end

function love.resize(w, h)
  -- body
  push:resize(w, h)
  CUSTOM_WIDTH=w
  CUSTOM_WIDTH=h
end