if myHero.charName ~= "Ahri" then return end

--[[       ------------------------------------------       ]]--
--[[		AUTO AHRI HELPER v1.1 by Husmeador12			]]--
--[[       ------------------------------------------       ]]--

--[[
		Changelog:
                        1.0   - First Release!
						1.1	  - Auto level fixed: Error level 8
							  -Extra Drawing circles

		Credits & Mentions:
                        - Galaxix 

]]--


 function OnLoad()	
		Variables()
		Menu()
		PrintChat("<font color=\"#81BEF7\">"..ScriptName.." </font><font color=\"#00FF00\">v."..CurVer.." by <font color=\"#FF0000\">Husmeador</font> loaded.</font>")
end

-- On Draw Function --
function OnDraw()
	if myHero.dead then return end
	Ranges()
	Championdraw()
end

-- OnTick Function --
function OnTick()
	Checks()
	Combo()
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
		
        AhriConfig:addParam("active", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        AhriConfig:addParam("drawpred", "Draw Prediciton", SCRIPT_PARAM_ONOFF, false)
		AhriConfig:addParam("drawcircles", "Draw Circles", SCRIPT_PARAM_ONOFF, true)
		AhriConfig:addParam("autolevel", "Auto Level", SCRIPT_PARAM_ONOFF, true)
        AhriConfig:permaShow("active")
		AhriConfig:permaShow("autolevel")
		
end
 
 -- Combo --
function Combo()
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



function Championdraw()
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
	
-- Variables Function --
function Variables()
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
	-------Info------
	CurVer = 1.1
	ScriptName = "Ahri_Helper"

	waittxt = {} -- prevents UI lags, all credits to Dekaron
	for i=1, heroManager.iCount do waittxt[i] = i*3 end
	lastAnimation = nil
	lastSpell = nil
	lastAttack = 0
	lastAttackCD = 0
	lastWindUpTime = 0
end



-- Ranges --
function Ranges()
	-- Ranges --
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


-- Spells Checks --
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
