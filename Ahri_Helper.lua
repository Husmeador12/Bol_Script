if myHero.charName ~= "Ahri" then return end

--[[       ------------------------------------------       ]]--
--[[		AUTO AHRI HELPER v1.2 by Husmeador12			]]--
--[[       ------------------------------------------       ]]--

--[[
		Changelog:
                        1.0   - First Release!
						1.1	  - Auto level fixed: Error level 8
							  - Extra Drawing circles
						1.2
							  - Harras
							  -	Auto update (AOI)
							  
						
		Credits & Mentions:
                        - Galaxix (Circles)
						

]]--
-- Auto Update
local AUTOUPDATE = true --change to false to disable auto update
local SCRIPT_NAME = "Ahri_Helper"
local MAJORVERSION = 1.2
local SUBVERSION = 1
local VERSION = tostring(MAJORVERSION) .. "." .. tostring(SUBVERSION) --neat style of version

local PATH =  SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local URL = "https://raw.githubusercontent.com/Husmeador12/Bol_Script/master/Ahri_Helper.lua"
local UPDATE_TEMP_FILE = SCRIPT_PATH.."AhriHelperUpdateTemp.txt"
local UPDATE_CHANGE_LOG = "Added Auto Update feature."

-- Update functions
function Update()
	file = io.open(UPDATE_TEMP_FILE, "rb")
	
	if file ~= nil then
		content = file:read("*all")
		file:close()
		os.remove(UPDATE_TEMP_FILE)
		
		if content then		
			local update_MAJORVERSION = string.match(string.match(content, "local MAJORVERSION = %d+"), "%d+")
			local update_SUBVERSION = string.match(string.match(content, "local SUBVERSION = %d+"), "%d+")
			local update_VERSION = tostring(update_MAJORVERSION) .. "." .. tostring(update_SUBVERSION)
			
			update_MAJORVERSION = tonumber(string.format("%d", update_MAJORVERSION ))
			update_SUBVERSION = tonumber(string.format("%d", update_SUBVERSION ))
			
			if (update_MAJORVERSION ~= nil and update_SUBVERSION ~= nil) and (update_MAJORVERSION > MAJORVERSION or (update_MAJORVERSION == MAJORVERSION and update_SUBVERSION > SUBVERSION) ) and content:find("--EOS--") then
				file = io.open(PATH, "w")
				
				if file then
					file:write(content)
					file:flush()
					file:close()
					PrintChat("<font color=\"#81BEF7\">" .. SCRIPT_NAME .. ": </font> <font color=\"#00FF00\">Successfully updated to v" .. update_VERSION .. "! Please reload this script.</font>")
					PrintChat("<font color=\"#81BEF7\">" .. SCRIPT_NAME .. ": </font> <font color=\"#00FF00\">Update Notes: " .. UPDATE_CHANGE_LOG .. "</font>")
				else
					PrintChat("<font color=\"#81BEF7\">" .. SCRIPT_NAME .. ": </font> <font color=\"#FF0000\">Update to version v" .. update_VERSION .. " failed.</font>")
				end
			elseif (update_MAJORVERSION ~= nil and update_SUBVERSION ~= nil) and (update_MAJORVERSION == MAJORVERSION and update_SUBVERSION == SUBVERSION) then
				PrintChat("<font color=\"#81BEF7\">" .. SCRIPT_NAME .. ": </font> <font color=\"#00FF00\">No updates found, latest version is installed.</font>")
			elseif (update_MAJORVERSION ~= nil and update_SUBVERSION ~= nil) then
				PrintChat("<font color=\"#81BEF7\">" .. SCRIPT_NAME .. ": </font> <font color=\"#00FF00\">A newer version of this script is already installed. Update v"..update_VERSION.." was not downloaded.</font>")
			end
		end
	end
end





 function OnLoad()	
	if AUTOUPDATE then
		DownloadFile(URL, UPDATE_TEMP_FILE, Update)
    end
	
		Variables()
		Menu()
		PrintChat("<font color=\"#81BEF7\">Ahri Helper </font><font color=\"#00FF00\">v."..version.." by <font color=\"#FF0000\">Husmeador</font> loaded.</font>")
end

-- On Draw Function --
function OnDraw()
	if myHero.dead then return end
	Ranges()
	ChampionDraw()
end

-- OnTick Function --
function OnTick()
	Autolevel()
	Checks()
	Combo()
	Harras()
end


-- Menu Function -- 
function Menu()
       AhriConfig = scriptConfig(""..myHero.charName.." Helper", "Ahri Combo")

		--Drawing menu --
		AhriConfig:addSubMenu("["..myHero.charName.." - Drawing Settings]", "drawing")
		AhriConfig.drawing:addParam("mDraw", "Disable All Ranges Drawing", SCRIPT_PARAM_ONOFF, false)
		AhriConfig.drawing:addParam("qDraw", "Draw "..qName.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
		AhriConfig.drawing:addParam("wDraw", "Draw "..wName.." (W) Range", SCRIPT_PARAM_ONOFF, false)
		AhriConfig.drawing:addParam("eDraw", "Draw "..eName.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		AhriConfig.drawing:addParam("rDraw", "Draw "..rName.." (R) Range", SCRIPT_PARAM_ONOFF, false)
		AhriConfig.drawing:addParam("LfcDraw", "Use Lagfree Circles (Requires Reload!)", SCRIPT_PARAM_ONOFF, true)
		
        AhriConfig:addParam("active", "Combo - Space Bar", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        AhriConfig:addParam("harras", "Harras", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
        AhriConfig:addParam("drawpred", "Draw Prediciton", SCRIPT_PARAM_ONOFF, false)
		AhriConfig:addParam("drawcircles", "Draw Circles", SCRIPT_PARAM_ONOFF, true)
		AhriConfig:addParam("autolevel", "Auto Level", SCRIPT_PARAM_ONOFF, true)
        AhriConfig:permaShow("active")
		AhriConfig:permaShow("autolevel")
        AhriConfig:permaShow("harras")
		
end
 
--------- Variables Function ---------
function Variables()

	-------- Skills Ready---------
	DFGReady = (DFGSlot ~= nil and myHero:CanUseSpell(DFGSlot) == READY)
	QReady = (myHero:CanUseSpell(_Q) == READY) -- Check if Q is ready to cast.
	EReady = (myHero:CanUseSpell(_E) == READY) -- Check if E is ready to cast.
	WReady = (myHero:CanUseSpell(_W) == READY) -- Check if W is ready to cast.
	DFGSlot = GetInventorySlotItem(3128) -- Check if we have DFG and return his slot.
	-------Skill Range---------
	qRange, wRange, eRange, rRange = 900, 800, 1000, 450
	qName, wName, eName, rName = "Q", "W", "E", "R"
	QReady, WReady, EReady, RReady = false, false, false, false
	hpReady, mpReady, fskReady, Recalling = false, false, false, false
	usingHPot, usingMPot = false, false
	eSpeed, eDelay, eWidth = .150, .125, 80
	-------Skills info-------
	ts = TargetSelector(TARGET_LESS_CAST,900,DAMAGE_MAGIC,false)
	tp = TargetPrediction(900,1.2,265)
	hp = TargetPrediction(900,1,240)
	RDmg = 0
	-------Autolvl info-------
	LevelSequence = {_Q,_E,_Q,_W,_Q,_R,_Q,_W,_Q,_W,_W,_E,_E,_R,_E,_E}-- order to level abilities
	AhriLevel = 0

	----- Other ----
	waittxt = {} -- prevents UI lags, all credits to Dekaron
	for i=1, heroManager.iCount do waittxt[i] = i*3 end
	lastAnimation = nil
	lastSpell = nil
	lastAttack = 0
	lastAttackCD = 0
	lastWindUpTime = 0
end


--------- Combo ---------
function Combo()
        ts:update()
        if ts.target ~= nil then
                if ts.target.visible == true and AhriConfig.active then
                        
                        if qpred ~= nil then

                                if DFGReady then CastSpell(DFGSlot, ts.target) end
                                if EReady then CastSpell(_E, qpred.x, qpred.z) end
								if QReady then CastSpell(_Q, ts.target.x, ts.target.z) end
								if WReady then CastSpell(_W, ts.target.x, ts.target.z) end
																
                        end
                end
     
                
        end
	
end

--------- Auto Level ---------
function Autolevel()

if AhriConfig.autolevel and player.level > AhriLevel then
		LevelSpell(LevelSequence[player.level])
		AhriLevel = player.level
	end 
end


---------Drawing ---------
function ChampionDraw()
        if AhriConfig.drawcircles and not myHero.dead then
                DrawCircle(myHero.x,myHero.y,myHero.z,500,0x540069)
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
	


--------- Ranges ---------
function Ranges()
	if not AhriConfig.drawing.mDraw and not myHero.dead then
		if QReady and AhriConfig.drawing.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, ARGB(255,127,0,110))
		end
		if WReady and AhriConfig.drawing.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, wRange, ARGB(255,95,159,159))
		end
		if EReady and AhriConfig.drawing.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, ARGB(255,204,50,50))
		end
		if RReady and AhriConfig.drawing.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, rRange, ARGB(255,69,139,0))
		  end
		end
end

-- Lagfree Circles by barasia, vadash and viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
		quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
		quality = 2 * math.pi / quality
		radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end
function round(num) 
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end


function DrawCircle2(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, 75)	
    end
end


--------- Spells Checks ---------
function Checks()
	-- Spells --									 
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)

	-- Lagfree Circles --
	if AhriConfig.drawing.LfcDraw then
		_G.DrawCircle = DrawCircle2
	end
end	


--------- Harras ---------
function Harras()
        if not myHero.dead and AhriConfig.harras then
		myHero:MoveTo(mousePos.x,mousePos.z)
                        
                if qpred ~= nil then
                        
						qpred = hp:GetPrediction(ts.target)
						
                        if ValidTarget(ts.target, qRange) then
							if QReady then
                                CastSpell(_Q,ts.target.x, ts.target.z)
							end
                        end    
                        
                end
       
        end
 
end

