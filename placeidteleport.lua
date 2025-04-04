local jobid = "asdasdasdasd"
local tp = false
if tp then
	if game.JobId ~= jobid then
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobid, game:GetService("Players").localPlayer)
	end
end
print(jobid)
