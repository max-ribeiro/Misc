function onload()
    self.createButton({
        click_function = "onClick_RotateHandsLeft",
        function_owner = self,
        label = "Rotate\nHands\nLeft",
        position = {-0.22, 0.5, 0},
        width = 230,
        height = 400,
        font_size = 70
    })
    self.createButton({
        click_function = "onClick_RotateHandsRight",
        function_owner = self,
        label = "Rotate\nHands\nRight",
        position = {0.22, 0.5, 0},
        width = 230,
        height = 400,
        font_size = 70
    })
end

lock = true

function onClick_RotateHandsLeft()
    Wait.condition(function()
        lock = false
        local players = getRealSeatedPlayers()
        local playersClockwise = playersClockwise(players)
        for i, player in ipairs(playersClockwise) do
            local moveToIndex = 1
            if i == #players then
                moveToIndex = 1
            else
                moveToIndex = i + 1
            end
            local moveToPlayer = playersClockwise[moveToIndex]
            local dest = getPlayerHandPosition(moveToPlayer)
            local rot = moveToPlayer.getHandTransform().rotation
            rot.y = rot.y + 180 -- Rotate 180 degrees
            for _, card in ipairs(player.getHandObjects()) do
                card.setPosition(dest)
                card.setRotation(rot)
            end
        end
        Wait.time(function() lock = true end, 0.15)
    end,
    function() return lock end,
    0.25)
end

function onClick_RotateHandsRight()
    Wait.condition(function()
        lock = false
        local players = getRealSeatedPlayers()
        local playersCounterClockwise = playersCounterClockwise(players)
        for i, player in ipairs(playersCounterClockwise) do
            local moveToIndex = 1
            if i == #players then
                moveToIndex = 1
            else
                moveToIndex = i + 1
            end
            local moveToPlayer = playersCounterClockwise[moveToIndex]
            local dest = getPlayerHandPosition(moveToPlayer)
            local rot = moveToPlayer.getHandTransform().rotation
            rot.y = rot.y + 180 -- Rotate 180 degrees
            for _, card in ipairs(player.getHandObjects()) do
                card.setPosition(dest)
                card.setRotation(rot)
            end
        end
        Wait.time(function() lock = true end, 0.15)
    end,
    function() return lock end,
    0.25)
end

function getRealSeatedPlayers()
    local playerColors = getSeatedPlayers()
    local players = {}
    local newI = 1
    for i, playerColor in pairs(playerColors) do
        if Player[playerColor].getPlayerHand() ~= nil then
            players[newI] = Player[playerColor]
            newI = newI + 1
        end
    end
    return players
end

function getPlayerHandPosition(player)
    local hand = player.getPlayerHand()
    return {hand.pos_x, hand.pos_y, hand.pos_z}
end

function playerAngles(players)
    local angles = {}
    for i, player in pairs(players) do
        angles[getPlayerAngle(player)] = player
    end
    return angles
end

function playersCounterClockwise(players)
    local newPlayers = {}
    local newI = 1
    for i, player in pairsByKeys(playerAngles(players)) do
        newPlayers[newI] = player
        newI = newI + 1
    end
    return newPlayers
end

function playersClockwise(players)
    local newPlayers = {}
    local newI = #players
    for i, player in pairsByKeys(playerAngles(players)) do
        newPlayers[newI] = player
        newI = newI - 1
    end
    return newPlayers
end

function getPlayerAngle(player)
    local hand = player.getPlayerHand()
    return math.atan2(hand.pos_z, hand.pos_x)
end

function pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0
        local iter = function ()
            i = i + 1
            if a[i] == nil then
                return nil
            else
                return a[i], t[a[i]]
            end
        end
    return iter
end
