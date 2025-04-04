function generateHexList()
  local hexList = {}
  for i = 1, 5 do
    local hexNum = string.format('%02X', math.random(0, 255))
    table.insert(hexList, hexNum)
  end
  return hexList
end

function love.load()
  love.window.setMode(800, 600)
  love.window.setTitle 'Hex Grid Minigame'
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1) -- Dark grey background
  Font = love.graphics.newFont(18)

  GridSize = 5
  BufferSize = 4
  Padding = 10
  CellSize = 75 -- Adjust based on spacing needs
  Timer = 30
  TimerOn = false
  HexGrid = {}
  Buffer = { "", "", "", "" }
  BufferPos = 1
  Candidates = generateHexList()

  for row = 1, GridSize do
    HexGrid[row] = {}
    for col = 1, GridSize do
      HexGrid[row][col] = {
        value = Candidates[math.random(1, 5)],
        x = (col - 1) * CellSize + 50,
        y = (row - 1) * CellSize + 50,
        width = CellSize,
        height = CellSize,
        active = false,
      }
    end
  end
end

function love.draw()
  love.graphics.setFont(Font)
  love.graphics.setColor(1, 1, 0) -- Neon yellow for grid outline
  love.graphics.rectangle('line', 50, 50, GridSize * CellSize, GridSize * CellSize)

  for row = 1, GridSize do
    for col = 1, GridSize do
      local cell = HexGrid[row][col]

      love.graphics.setColor(1, 1, 1) -- White text
      love.graphics.print(cell.value, cell.x + cell.width / 2 - 10, cell.y + cell.height / 2 - 10)
      -- draw a border around the last clicked item
      if HexGrid[row][col].active then
        love.graphics.setColor(1, 1, 0) -- Neon yellow border for each cell
        love.graphics.rectangle('line', cell.x, cell.y, cell.width, cell.height)
      end
    end
  end
  -- draw the buffer representing selected cells
  for i, v in ipairs(Buffer) do
    love.graphics.setColor(1, 1, 0)   -- Neon yellow border for each cell
    local x = (i - 1) * CellSize + 450
    local ds = (CellSize / 2) - 15
    love.graphics.rectangle('line', x, 50, CellSize - Padding, CellSize - Padding)
    love.graphics.setColor(1, 1, 1)   -- White text
    love.graphics.print(Buffer[i], x + ds, 50 + ds)
  end
  -- draw the puzzle timer 
    love.graphics.print(string.format("Time left: %.1f", Timer), 50, 500)

end

function love.update(dt)
  if Timer > 0 and TimerOn then
    Timer = Timer - dt     -- Reduce time by delta time
    if Timer < 0 then
      Timer = 0            -- Ensure timer doesn't go below zero
    end
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then -- Left mouse button
    for row = 1, GridSize do
      for col = 1, GridSize do
        local cell = HexGrid[row][col]
        if x >= cell.x
            and x <= cell.x + cell.width
            and y >= cell.y
            and y <= cell.y + cell.height
            and BufferPos <= BufferSize then
          -- turn on timer in case game hadn't started yet 
          TimerOn = true
          -- for debugging purposes
          print('Clicked on: ' .. cell.value)
          print(HexGrid[row][col].active)
          -- mark last clicked and update append to buffer
          HexGrid[row][col].active = true
          Buffer[BufferPos] = cell.value
          BufferPos = BufferPos + 1
        else
          HexGrid[row][col].active = false
        end
      end
    end
  end
end
