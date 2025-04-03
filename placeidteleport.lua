local jobid = "6ed43511-ce00-470e-aafb-a90381a5d1f9"
local tp = true
if tp then
	if game.JobId ~= jobid then
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobid, game:GetService("Players").localPlayer)
	end
end
