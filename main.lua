function generateHexList()
    local hexList = {}
    for i = 1, 5 do
        local hexNum = string.format("%02X", math.random(0, 255))
        table.insert(hexList, hexNum)
    end
    return hexList
end

function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("Hex Grid Minigame")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1) -- Dark grey background
    
    gridSize = 5
    cellSize = 100 -- Adjust based on spacing needs
    hexGrid = {}
    candidates = generateHexList()
    
    for row = 1, gridSize do
        hexGrid[row] = {}
        for col = 1, gridSize do
            hexGrid[row][col] = {
                value = candidates[math.random(1, 5)],
                x = (col - 1) * cellSize + 50,
                y = (row - 1) * cellSize + 50,
                width = cellSize,
                height = cellSize,
                active = false
            }
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 0) -- Neon yellow for grid outline
    love.graphics.rectangle("line", 50, 50, gridSize * cellSize, gridSize * cellSize)
    
    for row = 1, gridSize do
        for col = 1, gridSize do
            local cell = hexGrid[row][col]
            
            love.graphics.setColor(1, 1, 1) -- White text
            love.graphics.print(cell.value, cell.x + cell.width / 2 - 10, cell.y + cell.height / 2 - 10)
            -- draw a border around the last clicked item
            if hexGrid[row][col].active then
                love.graphics.setColor(1, 1, 0)     -- Neon yellow border for each cell
                love.graphics.rectangle("line", cell.x, cell.y, cell.width, cell.height)
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then -- Left mouse button
        for row = 1, gridSize do
            for col = 1, gridSize do
                local cell = hexGrid[row][col]
                if x >= cell.x and x <= cell.x + cell.width and y >= cell.y and y <= cell.y + cell.height then
                    print("Clicked on: " .. cell.value)
                    print(hexGrid[row][col].active)
                    hexGrid[row][col].active = true
                end
            end
        end
    end
end
