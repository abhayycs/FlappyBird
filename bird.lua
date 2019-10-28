require 'params'

BIRD_IMG = 'bird.png'
BIRD_Y = 0
BIRD_DY = 0
BIRD_JUMP = 400
BIRD_GRAVITY = 1000

bird = {}
bird.img = love.graphics.newImage(BIRD_IMG)
bird.width = bird.img:getWidth()
bird.height = bird.img:getHeight()
bird.gravity = BIRD_GRAVITY
bird.jump = BIRD_JUMP
bird.x = 0
bird.y = 0

function drawBird()
	-- body
	love.graphics.draw(bird.img, WINDOW_WIDTH/2-bird.width, WINDOW_HEIGHT/2-bird.height+BIRD_Y, 0, FACTOR, FACTOR)	
end

function updateBird(dt)
	-- body
	BIRD_DY = BIRD_DY + bird.gravity*dt
	BIRD_Y = BIRD_Y + BIRD_DY*dt
	bird.x = WINDOW_WIDTH/2-bird.width
	bird.y = WINDOW_HEIGHT/2-bird.height+BIRD_Y
	if bird.y < 0 or bird.y + bird.height  > WINDOW_HEIGHT then 
		game_state = 2
		playSound(HIT_SOUND)
	end
end