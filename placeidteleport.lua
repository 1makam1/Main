local jobid = "a4b7053b-a7d3-46f1-948f-8db640a9ce9c"
game:GetService("Lighting"):GetPropertyChangedSignal("TimeOfDay"):Connect(function()
	if game.JobId ~= jobid then
	    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobid, game:GetService("Players").localPlayer)
	end
end)
