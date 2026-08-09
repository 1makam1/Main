local function saveLoadString(url: string)
    local success, result = pcall(game.HttpGet, game, url)
    if success then return loadstring(result) end
end
(saveLoadString("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau") or saveLoadString("https://gitlab.com/upio/cobalt/-/releases/permalink/latest/downloads/Cobalt.luau"))()
