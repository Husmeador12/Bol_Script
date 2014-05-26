-- AUTO AHRI HELPER v1.0 --


-- / Auto-Update Function / -- 

local Ahri_Autoupdate = true --false for not update
local UPDATE_SCRIPT_NAME = "Ahri-Helper"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/UglyOldGuy/BoL/master/Katarina%20-%20The%20Sinister%20Blade.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#FF0000\">"..UPDATE_SCRIPT_NAME..":</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if Ahri_Autoupdate then
	local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
	if ServerData then
		local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
		ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
		if ServerVersion then
			ServerVersion = tonumber(ServerVersion)
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end)	 
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end
--[[
--]]
-- / Auto-Update Function / --


if myHero.charName ~= "Ahri" then return end
 
local ts = TargetSelector(TARGET_LESS_CAST,900,DAMAGE_MAGIC,false)
local tp = TargetPrediction(900,1.2,265)
local hp = TargetPrediction(900,1,240)
local RDmg = 0
--Level
local LevelSequence = {_Q,_E,_Q,_W,_Q,_R,_Q,_Q,_W,_W,_W,_E,_E,_R,_E,_E}-- order to level abilities
local AhriLevel = 0

 
function OnLoad()
        --Menu Config
        AhriConfig = scriptConfig("Ahri Combo", "Ahri Combo")
        AhriConfig:addParam("active", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        AhriConfig:addParam("harras", "Harras", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
        AhriConfig:addParam("drawpred", "Draw Prediciton", SCRIPT_PARAM_ONOFF, false)
				AhriConfig:addParam("autolevel", "Auto Level", SCRIPT_PARAM_ONOFF, true)
        AhriConfig:permaShow("active")
				AhriConfig:permaShow("autolevel")
        AhriConfig:permaShow("harras")
		PrintChat("<font color=\"#81BEF7\">Ahri Helper: </font><font color=\"#00FF00\">v"..version.." by <font color=\"#FF0000\">Jaguare19</font> loaded.</font>")
end
 
function OnTick()
        ts:update()
        if ts.target ~= nil then
                if ts.target.visible == true and AhriConfig.active then
                        qpred = tp:GetPrediction(ts.target)
                        if qpred ~= nil then
                                EReady = (myHero:CanUseSpell(_E) == READY) -- Check if E is ready to cast.
                                DFGSlot = GetInventorySlotItem(3128) -- Check if we have DFG and return his slot.
                                DFGReady = (DFGSlot ~= nil and myHero:CanUseSpell(DFGSlot) == READY)
                                if DFGReady then CastSpell(DFGSlot, ts.target) end
                                if EReady then CastSpell(_E, qpred.x, qpred.z) end
                        end
                end
                if ts.target.canMove and AhriConfig.active then
                        QReady = (myHero:CanUseSpell(_Q) == READY)
                        WReady = (myHero:CanUseSpell(_W) == READY)
                        if QReady then CastSpell(_Q, ts.target.x, ts.target.z) end
                        if WReady then CastSpell(_W, ts.target.x, ts.target.z) end
                end
                if AhriConfig.harras then
                        qpred = hp:GetPrediction(ts.target)
                        if qpred ~= nil then
                                QReady = (myHero:CanUseSpell(_Q) == READY)
                                if QReady then CastSpell(_Q,epred.x,epred.z) end
                        end
                end
        end
	-- Auto Level
	if AhriConfig.autolevel and player.level > AhriLevel then
		LevelSpell(LevelSequence[player.level])
		AhriLevel = player.level
	end
        
end
 

 
function OnDraw()
        if not myHero.dead then
                DrawCircle(myHero.x,myHero.y,myHero.z,900,0x540069)
                if AhriConfig.drawpred and ts.target ~= nil then
                        qpred = tp:GetPrediction(ts.target)
                        if qpred ~= nil then
                                for j=0, 10 do
                                        DrawCircle(qpred.x,qpred.y,qpred.z,100 + j*1.5, 0x540069)
                                end
                        end
                end
        end
end
