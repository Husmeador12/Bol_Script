--[[       ------------------------------------------       ]]--
--[[		         iARAM v1.0.1 by Husmeador12     		]]--
--[[       ------------------------------------------       ]]--


--[[
		Changelog:
        --Repaired adcs: Gangplank
		--Added champion: Braum, Gnar, Yasuo, Jinx and Vel´koz.
		--Added chat colors 
		--Added Menu
		--Add auto chat: gl and hf
		Credits & Mentions:
			-barasia
]]--

--[[ SETTINGS ]]--
local AutomaticChat = true --If is in true mode, then it will say "gl and hf" when the game starts.
local AUTOUPDATE = false --change to false to disable auto update

--[[ GLOBALS [Do Not Change] ]]--
local abilitySequence
local qOff, wOff, eOff, rOff = 0,0,0,0
buyIndex = 1
shoplist = {}
buffs = {{pos = { x = 8922, y = 10, z = 7868 },current=0},{pos = { x = 7473, y = 10, z = 6617 },current=0},{pos = { x = 5929, y = 10, z = 5190 },current=0},{pos = { x = 4751, y = 10, z = 3901 },current=0}}
lastsixpos = {0,0,0,0,0,0,0,0,0,0}


--[[ Auto Update ]]--

local SCRIPT_NAME = "iARAM"
local MAJORVERSION = 1
local SUBVERSION = 1
local VERSION = tostring(MAJORVERSION) .. "." .. tostring(SUBVERSION) --neat style of version

local PATH =  SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local URL = "https://raw.githubusercontent.com/Husmeador12/Bol_Script/master/iARAM.lua"
local UPDATE_TEMP_FILE = SCRIPT_PATH.."iARAMUpdateTemp.txt"
local UPDATE_CHANGE_LOG = "Added champion: Braum, Gnar, Yasuo, Jinx and Vel´koz.."

--[[ Update functions ]]--
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


--[[ Atack, his build and defining champion class ]]--
do
	myHero = GetMyHero()
	PrintChat("<font color=\"#81BEF7\">iARAM:</font> <font color=\"#00FF00\"> version: "..MAJORVERSION.."."..SUBVERSION.." </font>")
	Target = nil
	spawnpos  = { x = myHero.x, z = myHero.z}
	ranged = 0
	assassins = {"Akali","Diana","Evelynn","Fizz","Katarina","Nidalee"}
	adtanks = {"Braum","DrMundo","Garen","Gnar","Hecarim","Jarvan IV","Nasus","Skarner","Volibear","Yorick"}
	adcs = {"Ashe","Caitlyn","Corki","Draven","Ezreal","Gangplank","Graves","Jinx","KogMaw","Lucian","MissFortune","Quinn","Sivir","Thresh","Tristana","Tryndamere","Twitch","Urgot","Varus","Vayne"}
	aptanks = {"Alistar","Amumu","Blitzcrank","ChoGath","Leona","Malphite","Maokai","Nautilus","Rammus","Sejuani","Shen","Singed","Zac"}
	mages = {"Ahri","Anivia","Annie","Brand","Cassiopeia","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","LeBlanc","Lissandra","Lulu","Lux","Malzahar","Morgana","Nami","Nunu","Orianna","Ryze","Sona","Soraka","Swain","Syndra","Taric","TwistedFate","Veigar","Velkoz","Viktor","Xerath","Ziggs","Zilian","Zyra"}
	hybrids = {"Kayle","Teemo"}
	bruisers = {"Darius","Irelia","Khazix","LeeSin","Olaf","Pantheon","Renekton","Rengar","Riven","Shyvana","Talon","Trundle","Vi","Wukong","Zed","Yasuo"}
	fighters = {"Aatrox","Fiora","Jax","Jayce","Nocturne","Poppy","Sion","Udyr","Warwick","XinZhao"}
	apcs = {"Elise","FiddleSticks","Kennen","Mordekaiser","Rumble","Vladimir"}
	
	
	heroType = nil
	
	for i,nam in pairs(adcs) do 
		
		if nam == myHero.charName then
			heroType = 1
		end
	end
	
	for i,nam in pairs(adtanks) do 
		if nam == myHero.charName then
			heroType = 2
		end
	end
	for i,nam in pairs(aptanks) do 
		if nam == myHero.charName then
			heroType = 3
		end
	end
	for i,nam in pairs(hybrids) do 
		if nam == myHero.charName then
			heroType = 4
		end
	end
	for i,nam in pairs(bruisers) do 
		if nam == myHero.charName then
			heroType = 5
		end
	end
	for i,nam in pairs(assassins) do 
		if nam == myHero.charName then
			heroType = 6
		end
	end
	for i,nam in pairs(mages) do 
		if nam == myHero.charName then
			heroType = 7
		end
	end
	for i,nam in pairs(apcs) do 
		if nam == myHero.charName then
			heroType = 8
		end
	end
	for i,nam in pairs(fighters) do 
		if nam == myHero.charName then
			heroType = 9
		end
	end
	
	if heroType == nil then
		heroType = 10
	end
	if heroType ~= 10 then
		PrintChat("<font color=\"#81BEF7\">Hero Items Loaded</font>")
	end
	if heroType == 1 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#00FF00\">ADC</font>" )
	elseif heroType == 2 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF8000\">ADTANK</font>" )
	elseif heroType == 3 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF00FF\">APTANK</font>" )
	elseif heroType == 4 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#A9F5F2\">Hybrid</font>" )	
	elseif heroType == 5 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#8A084B\">BRUISER</font>" )	
	elseif heroType == 6 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF0000\">ASSASINS</font>" )	
	elseif heroType == 7 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#0040FF\">MAGE</font>" )	
	elseif heroType == 8 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#80FF00\">APC</font>" )	
	elseif heroType == 9 then
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FFFF00\">FIGHTER</font>")	
	else
		PrintChat("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#BDBDBD\">UNKOWN</font>" )
	end
	
	if myHero.range > 400 then
		ranged = 1
	end
	--[[ ItemsList ]]--
	if heroType == 1 then
		shopList = {3006,1042,3086,3087,3144,3153,1038,3181,1037,3035,3026,0}
	end
	if heroType == 2 then
		shopList = {3047,1011,3134,3068,3024,3025,3071,3082,3143,3005,0}
	end
	if heroType == 3 then
		shopList = {3111,1031,3068,1057,3116,1026,3001,3082,3110,3102,0}
	end
	if heroType == 4 then
		shopList = {1001,3108,3115,3020,1026,3136,3089,1043,3091,3151,3116}
	end
	if heroType == 5 then
		shopList = {3111,3134,1038,3181,3155,3071,1053,3077,3074,3156,3190}
	end
	if heroType == 6 then
		shopList = {3020,3057,3100,1026,3089,3136,3151,1058,3157,3135,0}
	end
	if heroType == 7 then 
		shopList = {3028,1001,3020,3136,1058,3089,3174,3151,1026,3001,3135,0}
	end
	if heroType == 8 then 
		shopList = {3145,3020,3152,1026,3116,1058,3089,1026,3001,3157}
	end
	if heroType == 9 or heroType == 10 then 
		shopList = {3111,3044,3086,3078,3144,3153,3067,3065,3134,3071,3156,0}
	end
end


--[[ On Load Function ]]--
 function OnLoad()	
	if AUTOUPDATE then
		DownloadFile(URL, UPDATE_TEMP_FILE, Update)
    end
		LevelSequence()
		Menu()
		if AutomaticChat then
			AutoChat()
		end
end

--[[ OnTick Function ]]--
function OnTick()
	Follow()
	LFC()
end

--[[ Follow Function and attack ]]--
function Follow()
	if iARAM.follow and not myHero.dead then
		stance = 0
		if Allies() >=  2 then
			stance = 1
			PrintFloatText(myHero, 0, "TF mode")
		else
			stance = 0
			PrintFloatText(myHero, 0, "Alone mode")
		end
		val = myHero.maxHealth/myHero.health
		if  val > 3 and GetDistance(findClosestEnemy()) > 300 then
			stance = 3
			PrintFloatText(myHero, 0, "Low Health mode")
		end
		if findLowHp() ~= 0 then
			Target = findLowHp()
			else
			Target = findClosestEnemy()
		end
		
		Allie = followHero()
		--attacks
		if Target ~= nil then
		  myHero:Attack(Target)
			if stance == 1  then
				attacksuccess = 0
				if myHero:GetSpellData(_W).range > GetDistance(Target) then
					CastSpell(_W, Target)
					attacksuccess =1
					PrintFloatText(Target,0,"Casting spell to".. Target.charName)
				end
				if myHero:GetSpellData(_Q).range > GetDistance(Target) then
					CastSpell(_Q, Target)
					attacksuccess =1 
					PrintFloatText(Target,0,"Casting spell to".. Target.charName)
				end
				if myHero:GetSpellData(_E).range > GetDistance(Target) then
					CastSpell(_E, Target)
					attacksuccess = 1
					PrintFloatText(Target,0,"Casting spell to".. Target.charName)
				end
				if myHero:GetSpellData(_R).range > GetDistance(Target) then
					CastSpell(_R, Target)
					attacksuccess =1
					PrintFloatText(Target,0,"Casting spell to".. Target.charName)
				end
				if GetDistance(Target) < getTrueRange() then
					myHero:Attack(Target)
					if ranged == 1 then
						attacksuccess = 1
						missilesent = 0
						while not missilesent do
							if myHero.dead then missilesent = 1 end
							for _, v in pairs(getChampTable()[myHero.charName].aaParticles) do
								if obj.name:lower():find(v:lower()) then
									missilesent =1 
								end
							end
						end
					end
				end
				if attacksuccess == 0 then
					--Attack Minions
				end
			elseif stance == 0 then
				--alone
			elseif stance == 3 then
				--low health
				for i,buff in pairs(buffs) do 
					if buff.current ==1 then
						if GetDistance(spawnpos,findClosestEnemy()) > GetDistance(spawnpos,buff.pos) then 
							myHero:MoveTo(buff.pos.x,buff.pos.z) 
							break 
						end
					end
				end
				--low health
			end
			allytofollow = followHero()
			if allytofollow ~= nil and GetDistance(allytofollow,myHero) > 350  then
				PrintFloatText(allytofollow, 0, "Following")
				distance1 = math.random(250,300)
				distance2 = math.random(250,300)
				neg1 = 1 
				neg2 = 1 
				if myHero.team == TEAM_BLUE then
					myHero:MoveTo(allytofollow.x-distance1*neg1,allytofollow.z-distance2*neg2)
				else
					myHero:MoveTo(allytofollow.x+distance1*neg1,allytofollow.z+distance2*neg2)
				end
			end
			if frontally() == myHero then
				myHero:MoveTo(spawnpos.x,spawnpos.z)
			end
		end	
		
	else
		--dead
		buyItems()
	end
	buyItems()
	--
	for i =1, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil and object.name == "HA_AP_HealthRelic4.1.1" then 
			buffs[4].current =1
		else 
			buffs[4].current=0 
		end
		if object ~= nil and object.name == "HA_AP_HealthRelic3.1.1" then 
			buffs[3].current =1 
		else 
			buffs[3].current=0 
		end
		if object ~= nil and object.name == "HA_AP_HealthRelic2.1.1" then 
			buffs[2].current =1 
		else 
			buffs[2].current=0 
		end
		if object ~= nil and object.name == "HA_AP_HealthRelic1.1.1" then 
			buffs[1].current =1 
		else 
			buffs[1].current=0 
		end
	end
	--
	--LEVELUP
	local qL, wL, eL, rL = player:GetSpellData(_Q).level + qOff, player:GetSpellData(_W).level + wOff, player:GetSpellData(_E).level + eOff, player:GetSpellData(_R).level + rOff
	if qL + wL + eL + rL < player.level then
		local spellSlot = { SPELL_1, SPELL_2, SPELL_3, SPELL_4, }
		local level = { 0, 0, 0, 0 }
		for i = 1, player.level, 1 do
			level[abilitySequence[i]] = level[abilitySequence[i]] + 1
		end
		for i, v in ipairs({ qL, wL, eL, rL }) do
			if v < level[i] then LevelSpell(spellSlot[i]) end
		end
	end
	--/LEVELUP
end

--[[ On Draw Function ]]--
function OnDraw()
	AirText()
	RangeCircles()
end

function RangeCircles()
	if iARAM.drawing.drawcircles and not myHero.dead then
		DrawCircle(myHero.x,myHero.y,myHero.z,getTrueRange(),RGB(0,255,0))
		DrawCircle(myHero.x,myHero.y,myHero.z,400,RGB(55,64,60))
		for i,buff in pairs(buffs) do 
			if buff.current == 1 then
				DrawCircle(buff.pos.x,buff.pos.y,buff.pos.z,150,RGB(0,0,255))
			end
		end
	end
end


function findClosestEnemy()
    local closestEnemy = nil
    local currentEnemy = nil
    for i=1, heroManager.iCount do
        currentEnemy = heroManager:GetHero(i)
        if currentEnemy.team ~= myHero.team and not currentEnemy.dead and currentEnemy.visible then
            if closestEnemy == nil then
                closestEnemy = currentEnemy
                elseif GetDistance(currentEnemy) < GetDistance(closestEnemy) then
                    closestEnemy = currentEnemy
            end
        end
    end
	PrintFloatText(closestEnemy, 0, "Enemy!")
	return closestEnemy
end

function findLowHp() 
	local lowEnemy = nil
    local currentEnemy = nil
    for i=1, heroManager.iCount do
        currentEnemy = heroManager:GetHero(i)
        if currentEnemy.team ~= myHero.team and not currentEnemy.dead and currentEnemy.visible then
		
            if lowEnemy == nil then
				lowEnemy = currentEnemy
			end
			
		    if currentEnemy.health < lowEnemy.health then
				lowEnemy = currentEnemy
			end
        end
    end
	if lowEnemy ~= nil  then
		if lowEnemy.health < 200 then
			PrintFloatText(lowEnemy, 0, "Kill Me")
			return lowEnemy
		else
			return 0
		end
	else
		return 0
	end
end

function Allies()
    local allycount = 0
    for i=1, heroManager.iCount do
        hero = heroManager:GetHero(i)
        if hero.team == myHero.team and not hero.dead and GetDistance(hero) < 350 then
					allycount = allycount + 1
				end
    end
	return allycount
end

function frontally()
	local target = nil
	local dist = 0
	for d=1, heroManager.iCount, 1 do
		TargetAlly = heroManager:getHero(d)
		if TargetAlly.afk == nil and TargetAlly.dead == false and TargetAlly.team == myHero.team and GetDistance(TargetAlly,spawnpos) > dist then
			target = TargetAlly
			dist = GetDistance(target,spawnpos)
		end
	end
	return target
end

function getlowMinionHp()
	
end

function followHero()
	local target =nil
	for d=1, heroManager.iCount, 1 do
		TargetAlly = heroManager:getHero(d)
		if TargetAlly.afk == nil and TargetAlly.dead == false and GetDistance(TargetAlly,spawnpos) > 3000 then
			if TargetAlly.team == myHero.team and TargetAlly.name ~= myHero.name then
				target = TargetAlly
			end
		end
	end
	return target
end

--[[ AutoBuyItems ]]--
function buyItems()
 if iARAM.autobuy then
	if shopList[buyIndex] ~= 0 then
		local itemval = shopList[buyIndex]
		BuyItem(itemval)
		if GetInventorySlotItem(shopList[buyIndex]) ~= nil then
			--Last Buy successful
			buyIndex = buyIndex + 1
			buyItems()
		end
		
	end
end
end


function attackMinions()


end


function getTrueRange()
    return myHero.range + GetDistance(myHero.minBBox)+100
end

--[[ Level Sequence ]]--
function LevelSequence()
    local champ = player.charName
    if champ == "Aatrox" then           abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Ahri" then         abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 2, 2, }
    elseif champ == "Akali" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Alistar" then      abilitySequence = { 1, 3, 2, 1, 3, 4, 1, 3, 1, 3, 4, 1, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Amumu" then        abilitySequence = { 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Anivia" then       abilitySequence = { 1, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 1, 1, 1, 2, 4, 2, 2, }
    elseif champ == "Annie" then        abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Ashe" then         abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Blitzcrank" then   abilitySequence = { 1, 3, 2, 3, 2, 4, 3, 2, 3, 2, 4, 3, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Brand" then        abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
	elseif champ == "Braum" then        abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Caitlyn" then      abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Cassiopeia" then   abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Chogath" then      abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Corki" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif champ == "Darius" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "Diana" then        abilitySequence = { 2, 1, 2, 3, 1, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "DrMundo" then      abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Draven" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Elise" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, } rOff = -1
    elseif champ == "Evelynn" then      abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Ezreal" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "FiddleSticks" then abilitySequence = { 3, 2, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Fiora" then        abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Fizz" then         abilitySequence = { 3, 1, 2, 1, 2, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Galio" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 3, 2, 2, 4, 3, 3, }
    elseif champ == "Gangplank" then    abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Garen" then        abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Gragas" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "Graves" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, }
	elseif champ == "Gnar" then         abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 3, 2, 2, 4, 3, 3, }
    elseif champ == "Hecarim" then      abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Heimerdinger" then abilitySequence = { 1, 2, 2, 1, 1, 4, 3, 2, 2, 2, 4, 1, 1, 3, 3, 4, 1, 1, }
    elseif champ == "Irelia" then       abilitySequence = { 3, 1, 2, 2, 2, 4, 2, 3, 2, 3, 4, 1, 1, 3, 1, 4, 3, 1, }
    elseif champ == "Janna" then        abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1, 1, 1, 4, 4, }
    elseif champ == "JarvanIV" then     abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 2, 1, 4, 3, 3, 3, 2, 4, 2, 2, }
    elseif champ == "Jax" then          abilitySequence = { 3, 2, 1, 2, 2, 4, 2, 3, 2, 3, 4, 1, 3, 1, 1, 4, 3, 1, }
    elseif champ == "Jayce" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, } rOff = -1
	elseif champ == "Jinx" then         abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1, 1, 1, 4, 4, }
    elseif champ == "Karma" then        abilitySequence = { 1, 3, 1, 2, 3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 2, 2, 2, 2, }
    elseif champ == "Karthus" then      abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 1, 3, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Kassadin" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Katarina" then     abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, }
    elseif champ == "Kayle" then        abilitySequence = { 3, 2, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Kennen" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Khazix" then       abilitySequence = { 1, 3, 1, 2 ,1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "KogMaw" then       abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Leblanc" then      abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "LeeSin" then       abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Leona" then        abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Lissandra" then    abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Lucian" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Lulu" then         abilitySequence = { 3, 2, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Lux" then          abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Malphite" then     abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif champ == "Malzahar" then     abilitySequence = { 1, 3, 3, 2, 3, 4, 1, 3, 1, 3, 4, 2, 1, 2, 1, 4, 2, 2, }
    elseif champ == "Maokai" then       abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "MasterYi" then     abilitySequence = { 3, 1, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 2, 2, 4, 2, 2, }
    elseif champ == "MissFortune" then  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "MonkeyKing" then   abilitySequence = { 3, 1, 2, 1, 1, 4, 3, 1, 3, 1, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Mordekaiser" then  abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Morgana" then      abilitySequence = { 1, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Nami" then         abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 2, 3, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Nasus" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "Nautilus" then     abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Nidalee" then      abilitySequence = { 2, 3, 1, 3, 1, 4, 3, 2, 3, 1, 4, 3, 1, 1, 2, 4, 2, 2, }
    elseif champ == "Nocturne" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Nunu" then         abilitySequence = { 3, 1, 3, 2, 1, 4, 3, 1, 3, 1, 4, 1, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Olaf" then         abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Orianna" then      abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Pantheon" then     abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif champ == "Poppy" then        abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 2, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, }
    elseif champ == "Quinn" then        abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Rammus" then       abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Renekton" then     abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Rengar" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 2, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Riven" then        abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Rumble" then       abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Ryze" then         abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Sejuani" then      abilitySequence = { 2, 1, 3, 3, 2, 4, 3, 2, 3, 3, 4, 2, 1, 2, 1, 4, 1, 1, }
    elseif champ == "Shaco" then        abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Shen" then         abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Shyvana" then      abilitySequence = { 2, 1, 2, 3, 2, 4, 2, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, }
    elseif champ == "Singed" then       abilitySequence = { 1, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 2, 3, 2, 4, 2, 3, }
    elseif champ == "Sion" then         abilitySequence = { 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Sivir" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "Skarner" then      abilitySequence = { 1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 3, 3, 4, 3, 3, }
    elseif champ == "Sona" then         abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Soraka" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif champ == "Swain" then        abilitySequence = { 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Syndra" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Talon" then        abilitySequence = { 2, 3, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Taric" then        abilitySequence = { 3, 2, 1, 2, 2, 4, 1, 2, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Teemo" then        abilitySequence = { 1, 3, 2, 3, 1, 4, 3, 3, 3, 1, 4, 2, 2, 1, 2, 4, 2, 1, }
    elseif champ == "Thresh" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Tristana" then     abilitySequence = { 3, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, }
    elseif champ == "Trundle" then      abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif champ == "Tryndamere" then   abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "TwistedFate" then  abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Twitch" then       abilitySequence = { 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 1, 2, 2, }
    elseif champ == "Udyr" then         abilitySequence = { 4, 2, 3, 4, 4, 2, 4, 2, 4, 2, 2, 1, 3, 3, 3, 3, 1, 1, }
    elseif champ == "Urgot" then        abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif champ == "Varus" then        abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Vayne" then        abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Veigar" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 2, 2, 2, 2, 4, 3, 1, 1, 3, 4, 3, 3, }
	elseif champ == "Velkoz" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 2, 2, 2, 2, 4, 3, 1, 1, 3, 4, 3, 3, }
    elseif champ == "Vi" then           abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Viktor" then       abilitySequence = { 3, 2, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, }
    elseif champ == "Vladimir" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Volibear" then     abilitySequence = { 2, 3, 2, 1, 2, 4, 3, 2, 1, 2, 4, 3, 1, 3, 1, 4, 3, 1, }
    elseif champ == "Warwick" then      abilitySequence = { 2, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, }
    elseif champ == "Xerath" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "XinZhao" then      abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Yorick" then       abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 1, 4, 2, 1, 2, 1, 4, 2, 1, }
	elseif champ == "Yasuo" then        abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Zac" then          abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Zed" then          abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Ziggs" then        abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Zilean" then       abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Zyra" then         abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    else PrintChat(string.format(" >> AutoLevelSpell  disabled for %s", champ))
    end
    if abilitySequence and #abilitySequence == 18 then
		PrintChat("<font color=\"#81BEF7\">AutoLevelSpell loaded!</font>")
    else
        PrintChat(" >> AutoLevel Error")
        OnTick = function() end
        return
    end
end


function getChampTable() 
    return {                                                   
        Ahri         = { projSpeed = 1.6, aaParticles = {"Ahri_BasicAttack_mis", "Ahri_BasicAttack_tar"}, aaSpellName = "ahribasicattack", startAttackSpeed = "0.668",  },
        Anivia       = { projSpeed = 1.05, aaParticles = {"cryo_BasicAttack_mis", "cryo_BasicAttack_tar"}, aaSpellName = "aniviabasicattack", startAttackSpeed = "0.625",  },
        Annie        = { projSpeed = 1.0, aaParticles = {"AnnieBasicAttack_tar", "AnnieBasicAttack_tar_frost", "AnnieBasicAttack2_mis", "AnnieBasicAttack3_mis"}, aaSpellName = "anniebasicattack", startAttackSpeed = "0.579",  },
        Ashe         = { projSpeed = 2.0, aaParticles = {"bowmaster_frostShot_mis", "bowmasterbasicattack_mis"}, aaSpellName = "ashebasicattack", startAttackSpeed = "0.658" },
        Brand        = { projSpeed = 1.975, aaParticles = {"BrandBasicAttack_cas", "BrandBasicAttack_Frost_tar", "BrandBasicAttack_mis", "BrandBasicAttack_tar", "BrandCritAttack_mis", "BrandCritAttack_tar", "BrandCritAttack_tar"}, aaSpellName = "brandbasicattack", startAttackSpeed = "0.625" },
		Caitlyn      = { projSpeed = 2.5, aaParticles = {"caitlyn_basicAttack_cas", "caitlyn_headshot_tar", "caitlyn_mis_04"}, aaSpellName = "caitlynbasicattack", startAttackSpeed = "0.668" },
        Cassiopeia   = { projSpeed = 1.22, aaParticles = {"CassBasicAttack_mis"}, aaSpellName = "cassiopeiabasicattack", startAttackSpeed = "0.644" },
        Corki        = { projSpeed = 2.0, aaParticles = {"corki_basicAttack_mis", "Corki_crit_mis"}, aaSpellName = "CorkiBasicAttack", startAttackSpeed = "0.658" },
        Draven       = { projSpeed = 1.4, aaParticles = {"Draven_BasicAttack_mis", "Draven_crit_mis", "Draven_Q_mis", "Draven_Qcrit_mis"}, aaSpellName = "dravenbasicattack", startAttackSpeed = "0.679",  },
        Ezreal       = { projSpeed = 2.0, aaParticles = {"Ezreal_basicattack_mis", "Ezreal_critattack_mis"}, aaSpellName = "ezrealbasicattack", startAttackSpeed = "0.625" },
        FiddleSticks = { projSpeed = 1.75, aaParticles = {"FiddleSticks_cas", "FiddleSticks_mis", "FiddleSticksBasicAttack_tar"}, aaSpellName = "fiddlesticksbasicattack", startAttackSpeed = "0.625" },
        Graves       = { projSpeed = 3.0, aaParticles = {"Graves_BasicAttack_mis",}, aaSpellName = "gravesbasicattack", startAttackSpeed = "0.625" },
        Gnar         = { projSpeed = 1.6, aaParticles = {"Gnar_BasicAttack_mis", "Gnar_BasicAttack_tar"}, aaSpellName = "gnarbasicattack", startAttackSpeed = "0.668",  },
		Heimerdinger = { projSpeed = 1.4, aaParticles = {"heimerdinger_basicAttack_mis", "heimerdinger_basicAttack_tar"}, aaSpellName = "heimerdingerbasicAttack", startAttackSpeed = "0.625" },
        Janna        = { projSpeed = 1.2, aaParticles = {"JannaBasicAttack_mis", "JannaBasicAttack_tar", "JannaBasicAttackFrost_tar"}, aaSpellName = "jannabasicattack", startAttackSpeed = "0.625" },
        Jayce        = { projSpeed = 2.2, aaParticles = {"Jayce_Range_Basic_mis", "Jayce_Range_Basic_Crit"}, aaSpellName = "jaycebasicattack", startAttackSpeed = "0.658",  },
        Karma        = { projSpeed = nil, aaParticles = {"karma_basicAttack_cas", "karma_basicAttack_mis", "karma_crit_mis"}, aaSpellName = "karmabasicattack", startAttackSpeed = "0.658",  },
        Karthus      = { projSpeed = 1.25, aaParticles = {"LichBasicAttack_cas", "LichBasicAttack_glow", "LichBasicAttack_mis", "LichBasicAttack_tar"}, aaSpellName = "karthusbasicattack", startAttackSpeed = "0.625" },
        Kayle        = { projSpeed = 1.8, aaParticles = {"RighteousFury_nova"}, aaSpellName = "KayleBasicAttack", startAttackSpeed = "0.638",  }, -- Kayle doesn't have a particle when auto attacking without E buff..
        Kennen       = { projSpeed = 1.35, aaParticles = {"KennenBasicAttack_mis"}, aaSpellName = "kennenbasicattack", startAttackSpeed = "0.690" },
        KogMaw       = { projSpeed = 1.8, aaParticles = {"KogMawBasicAttack_mis", "KogMawBioArcaneBarrage_mis"}, aaSpellName = "kogmawbasicattack", startAttackSpeed = "0.665", },
        Leblanc      = { projSpeed = 1.7, aaParticles = {"leBlanc_basicAttack_cas", "leBlancBasicAttack_mis"}, aaSpellName = "leblancbasicattack", startAttackSpeed = "0.625" },
        Lulu         = { projSpeed = 2.5, aaParticles = {"lulu_attack_cas", "LuluBasicAttack", "LuluBasicAttack_tar"}, aaSpellName = "LuluBasicAttack", startAttackSpeed = "0.625" },
        Lux          = { projSpeed = 1.55, aaParticles = {"LuxBasicAttack_mis", "LuxBasicAttack_tar", "LuxBasicAttack01"}, aaSpellName = "luxbasicattack", startAttackSpeed = "0.625" },
        Malzahar     = { projSpeed = 1.5, aaParticles = {"AlzaharBasicAttack_cas", "AlZaharBasicAttack_mis"}, aaSpellName = "malzaharbasicattack", startAttackSpeed = "0.625" },
        MissFortune  = { projSpeed = 2.0, aaParticles = {"missFortune_basicAttack_mis", "missFortune_crit_mis"}, aaSpellName = "missfortunebasicattack", startAttackSpeed = "0.656" },
        Morgana      = { projSpeed = 1.6, aaParticles = {"FallenAngelBasicAttack_mis", "FallenAngelBasicAttack_tar", "FallenAngelBasicAttack2_mis"}, aaSpellName = "Morganabasicattack", startAttackSpeed = "0.579" },
        Nidalee      = { projSpeed = 1.7, aaParticles = {"nidalee_javelin_mis"}, aaSpellName = "nidaleebasicattack", startAttackSpeed = "0.670" },
        Orianna      = { projSpeed = 1.4, aaParticles = {"OrianaBasicAttack_mis", "OrianaBasicAttack_tar"}, aaSpellName = "oriannabasicattack", startAttackSpeed = "0.658" },
        Quinn        = { projSpeed = 1.85, aaParticles = {"Quinn_basicattack_mis", "QuinnValor_BasicAttack_01", "QuinnValor_BasicAttack_02", "QuinnValor_BasicAttack_03", "Quinn_W_mis"}, aaSpellName = "QuinnBasicAttack", startAttackSpeed = "0.668" },  --Quinn's critical attack has the same particle name as his basic attack.
        Ryze         = { projSpeed = 2.4, aaParticles = {"ManaLeach_mis"}, aaSpellName = {"RyzeBasicAttack"}, startAttackSpeed = "0.625" },
        Sivir        = { projSpeed = 1.4, aaParticles = {"sivirbasicattack_mis", "sivirbasicattack2_mis", "SivirRicochetAttack_mis"}, aaSpellName = "sivirbasicattack", startAttackSpeed = "0.658" },
        Sona         = { projSpeed = 1.6, aaParticles = {"SonaBasicAttack_mis", "SonaBasicAttack_tar", "SonaCritAttack_mis", "SonaPowerChord_AriaofPerseverance_mis", "SonaPowerChord_AriaofPerseverance_tar", "SonaPowerChord_HymnofValor_mis", "SonaPowerChord_HymnofValor_tar", "SonaPowerChord_SongOfSelerity_mis", "SonaPowerChord_SongOfSelerity_tar", "SonaPowerChord_mis", "SonaPowerChord_tar"}, aaSpellName = "sonabasicattack", startAttackSpeed = "0.644" },
        Soraka       = { projSpeed = 1.0, aaParticles = {"SorakaBasicAttack_mis", "SorakaBasicAttack_tar"}, aaSpellName = "sorakabasicattack", startAttackSpeed = "0.625" },
        Swain        = { projSpeed = 1.6, aaParticles = {"swain_basicAttack_bird_cas", "swain_basicAttack_cas", "swainBasicAttack_mis"}, aaSpellName = "swainbasicattack", startAttackSpeed = "0.625" },
        Syndra       = { projSpeed = 1.2, aaParticles = {"Syndra_attack_hit", "Syndra_attack_mis"}, aaSpellName = "sorakabasicattack", startAttackSpeed = "0.625",  },
        Teemo        = { projSpeed = 1.3, aaParticles = {"TeemoBasicAttack_mis", "Toxicshot_mis"}, aaSpellName = "teemobasicattack", startAttackSpeed = "0.690" },
        Tristana     = { projSpeed = 2.25, aaParticles = {"TristannaBasicAttack_mis"}, aaSpellName = "tristanabasicattack", startAttackSpeed = "0.656",  },
        TwistedFate  = { projSpeed = 1.5, aaParticles = {"TwistedFateBasicAttack_mis", "TwistedFateStackAttack_mis"}, aaSpellName = "twistedfatebasicattack", startAttackSpeed = "0.651",  },
        Twitch       = { projSpeed = 2.5, aaParticles = {"twitch_basicAttack_mis",--[[ "twitch_punk_sprayandPray_tar", "twitch_sprayandPray_tar",]] "twitch_sprayandPray_mis"}, aaSpellName = "twitchbasicattack", startAttackSpeed = "0.679" },
        Urgot        = { projSpeed = 1.3, aaParticles = {"UrgotBasicAttack_mis"}, aaSpellName = "urgotbasicattack", startAttackSpeed = "0.644" },
        Vayne        = { projSpeed = 2.0, aaParticles = {"vayne_basicAttack_mis", "vayne_critAttack_mis", "vayne_ult_mis" }, aaSpellName = "vaynebasicattack", startAttackSpeed = "0.658",  },
        Varus        = { projSpeed = 2.0, aaParticles = {"varus_basicAttack_mis", "varus_critAttack_mis" }, aaSpellName = "varusbasicattack", startAttackSpeed = "0.658",  },
        Veigar       = { projSpeed = 1.05, aaParticles = {"ahri_basicattack_mis"}, aaSpellName = "veigarbasicattack", startAttackSpeed = "0.625" },
        Velkoz       = { projSpeed = 1.05, aaParticles = {"velkoz_basicattack_mis"}, aaSpellName = "velkozbasicattack", startAttackSpeed = "0.625" },
		Viktor       = { projSpeed = 2.25, aaParticles = {"ViktorBasicAttack_cas", "ViktorBasicAttack_mis", "ViktorBasicAttack_tar"}, aaSpellName = "viktorbasicattack", startAttackSpeed = "0.625" },
        Vladimir     = { projSpeed = 1.4, aaParticles = {"VladBasicAttack_mis", "VladBasicAttack_mis_bloodless", "VladBasicAttack_tar", "VladBasicAttack_tar_bloodless"}, aaSpellName = "vladimirbasicattack", startAttackSpeed = "0.658" },
        Xerath       = { projSpeed = 1.2, aaParticles = {"XerathBasicAttack_mis", "XerathBasicAttack_tar"}, aaSpellName = "xerathbasicattack", startAttackSpeed = "0.625" },
        Ziggs        = { projSpeed = 1.5, aaParticles = {"ZiggsBasicAttack_mis", "ZiggsPassive_mis"}, aaSpellName = "ziggsbasicattack", startAttackSpeed = "0.656" },
        Zilean       = { projSpeed = 1.25, aaParticles = {"ChronoBasicAttack_mis"}, aaSpellName = "zileanbasicattack" },
        Zyra         = { projSpeed = 1.7, aaParticles = {"Zyra_basicAttack_cas", "Zyra_basicAttack_cas_02", "Zyra_basicAttack_mis", "Zyra_basicAttack_tar", "Zyra_basicAttack_tar_hellvine"}, aaSpellName = "zileanbasicattack", startAttackSpeed = "0.625",  },
 
    }
end

--[[ Menu Function ]]-- 
function Menu()
       iARAM = scriptConfig(""..myHero.charName.." Bot", "iARAM BOT")

		--[[ Drawing menu ]]--
		iARAM:addSubMenu("["..myHero.charName.." - Drawing Settings]", "drawing")
		iARAM.drawing:addParam("drawcircles", "Draw Circles", SCRIPT_PARAM_ONOFF, true)
		iARAM.drawing:addParam("LfcDraw", "Use Lagfree Circles (Requires Reload!)", SCRIPT_PARAM_ONOFF, true)
		iARAM:addParam("autobuy", "Auto Buy Items", SCRIPT_PARAM_ONOFF, true)
		iARAM:addParam("follow", "Active bot", SCRIPT_PARAM_ONKEYTOGGLE, true, 115)

		-----------------------------------------------------------------------------------------------------
		iARAM:addParam("info", " >> edited by Husmeador12", SCRIPT_PARAM_INFO, "")
		iARAM:addParam("info2", " >> Version "..MAJORVERSION.."."..SUBVERSION.."", SCRIPT_PARAM_INFO, "")
		
		
end


--[[ Lagfree Circles by barasia, vadash and viseversa ]]---
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

---------[[ Lagfree Circles ]]---------
function LFC()
	if iARAM.drawing.LfcDraw then
		_G.DrawCircle = DrawCircle2
	end
end	

---------[[ AirText ]]---------
function AirText()
SetupDrawY = 0.15
SetupDrawX = 0.1
tempSetupDrawY = SetupDrawY
MenuTextSize = 18

	DrawText(""..myHero.charName.." Bot", MenuTextSize , (WINDOW_W - WINDOW_X) * SetupDrawX, (WINDOW_H - WINDOW_Y) * tempSetupDrawY , 0xffffff00) 
	tempSetupDrawY = tempSetupDrawY + 0.03

end
---------[[ Auto Good luck and have fun ]]---------
function AutoChat()
		if os.clock() then
			SendChat("Gl and hf")
		end

end
