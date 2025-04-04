-- local jobid = "asdasdasdasd"
-- local tp = false
-- if tp then
-- 	if game.JobId ~= jobid then
-- 		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobid, game:GetService("Players").localPlayer)
-- 	end
-- end
-- print(jobid)
print("โค้ดจาก GitHub ถูกโหลดแล้ว!")
game.StarterGui:SetCore("SendNotification", {
	Title = "✅สำเร็จ";
	Text = "โหลดจาก GitHub ได้แล้ว!";
	Duration = 5;
})
