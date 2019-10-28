require 'params'

RANDOM_Y = 50
PIPE_GAP = 300
PIPE_DISTANCE = 200
pipe = {}
PIPE_IMG = 'pipe.png'
PIPE_IMG_INV = 'pipeInv.png'
pipe.img = love.graphics.newImage(PIPE_IMG)
pipe.imgInv = love.graphics.newImage(PIPE_IMG_INV)
pipe.width = pipe.img:getWidth()
pipe.height = pipe.img:getHeight()
PIPE_POSITION = 0

function initPipe()
	-- body
	--  number of pipes required for game
	npipes = {}
	n=0
	i=1
	while (n < WINDOW_WIDTH) do
		table.insert(npipes, i)
		n = n + PIPE_DISTANCE 
		i = i + 1
	end
	-- initialize the pipe values
	n=0
	for _,i in ipairs(npipes) do
		pipe[i] = {}
		pipe[i].pos = n*PIPE_DISTANCE		--pipe position x co-ordinates
		pipe[i].spawn = false				--pipe not spawned
		pipe[i].randomY = 0					--init random height of pipe 
		-- init pipe co-ordinates
		pipe[i].x = 0 			
		pipe[i].ytop = 0
		pipe[i].ybottom = 0
		n=n+1
	end
end

function drawPipe(i)
	-- body
	if pipe[i].spawn then
		-- top pipe
		love.graphics.draw(pipe.imgInv, WINDOW_WIDTH-pipe[i].pos, -PIPE_GAP+pipe[i].randomY, 0, FACTOR, FACTOR)
		-- bottom pipe
		love.graphics.draw(pipe.img, WINDOW_WIDTH-pipe[i].pos, WINDOW_HEIGHT/2+100+pipe[i].randomY, 0, FACTOR, FACTOR)
	end
end

function updatePipe(dt, i)
	--body
	PIPE_POSITION = (pipe[i].pos + groundScrollSpeed*dt)%(WINDOW_WIDTH+pipe.width+1)	--'1' is added for the below comparision
	-- spawn pipes with random heights
	if (PIPE_POSITION > WINDOW_WIDTH+pipe.width) then
		pipe[i].randomY = love.math.random(-RANDOM_Y,RANDOM_Y)
		pipe[i].spawn = true
	end
	pipe[i].pos = PIPE_POSITION
	--note down the co-ordinates of pipes for AABB collision only if pipe is spawned
	if pipe[i].spawn then 
		pipe[i].x = WINDOW_WIDTH-pipe[i].pos
		pipe[i].ytop = -PIPE_GAP+pipe[i].randomY
		pipe[i].ybottom = WINDOW_HEIGHT/2+100+pipe[i].randomY
	end
end