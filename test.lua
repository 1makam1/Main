_G.a = true

local before = #game.CoreGui:GetDescendants()

while _G.a do wait(1)
    local now = #game.CoreGui:GetDescendants()
    if now - before > 500 then
        game.Players.LocalPlayer:Kick("coregui Detected")
    end
    before = now
end
