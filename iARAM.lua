--[[
────────────────────────────────────────────────────────────────────────────────────
─██████████─██████████████─████████████████───██████████████─██████──────────██████─
─██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░██████████████░░██─
─████░░████─██░░██████░░██─██░░████████░░██───██░░██████░░██─██░░░░░░░░░░░░░░░░░░██─
───██░░██───██░░██──██░░██─██░░██────██░░██───██░░██──██░░██─██░░██████░░██████░░██─
───██░░██───██░░██████░░██─██░░████████░░██───██░░██████░░██─██░░██──██░░██──██░░██─
───██░░██───██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░██──██░░██──██░░██─
───██░░██───██░░██████░░██─██░░██████░░████───██░░██████░░██─██░░██──██████──██░░██─
───██░░██───██░░██──██░░██─██░░██──██░░██─────██░░██──██░░██─██░░██──────────██░░██─
─████░░████─██░░██──██░░██─██░░██──██░░██████─██░░██──██░░██─██░░██──────────██░░██─
─██░░░░░░██─██░░██──██░░██─██░░██──██░░░░░░██─██░░██──██░░██─██░░██──────────██░░██─
─██████████─██████──██████─██████──██████████─██████──██████─██████──────────██████─
────────────────────────────────────────────────────────────────────────────────────
]]--

--[[
		Credits & Mentions:
			-Barasia
			-One
			-Husky
			-Dekland
			-LegendBot
			-Justh1n10
]]--

--[[
	   SOON:
	    -Debug Option
	    -Drawcircles allies
		-Remake Auto Follow.
		-Remake Auto Update.
		-Remake Menu Function.
		-Detects if it´s playing summoner rift or other map.
		-Auto Barrier, health and clarity.
]]--
--[[
	   NOTES:
		──|> Error with stance: "low health"
		──|> Error with delay action in Alone Mode Function.
		──|> Auto Chat doesn´t work.
		──|> Auto Buy doesn´t work.
]]--

--[[ SETTINGS ]]--
local HotKey = 115 --F4 = 115, F6 = 117 default
local AutomaticChat = true --If is in true mode, then it will say "gl and hf" when the game starts.
local AUTOUPDATE = true --change to false to disable auto update
local SummonerName = myHero.charName

--[[ GLOBALS [Do Not Change] ]]--


-----[[ Attack and farm Globals ]]------
local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
local range = myHero.range
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, range, DAMAGE_PHYSICAL, false)

-----[[ Chat Global ]]------
local switcher = true

-----[[ Poro Shouter Global ]]------
local lastCast = 0
require 'VPrediction'

-----[[ Buyer Globals ]]------
local buyIndex = 1
local lastGold = 0
local lastBuy = -501

-----[[ Auto ward Globals ]]------
local drawWardSpots = false
local wardSlot = nil

-----[[ Auto Update Globals ]]------
local version = 5.1
local UPDATE_CHANGE_LOG = "Fixing Autobuy"
local UPDATE_HOST = "raw.githubusercontent.com"
local UPDATE_PATH = "/Husmeador12/Bol_Script/master/iARAM.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH


-----[[ Auto Update Function ]]------
function _AutoupdaterMsg(msg) print("<font color=\"#9bbcfe\"><b>i<font color=\"#6699ff\">ARAM:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/Husmeador12/Bol_Script/master/version/iARAM.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				_AutoupdaterMsg("New version available "..ServerVersion)
				_AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () _AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				_AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
				_AutoupdaterMsg("<font color=\"#81BEF7\">Update Notes: </font>".. UPDATE_CHANGE_LOG .."")
			end
		end
	else
		_AutoupdaterMsg("Error downloading version info")
	end
end


-----[[ Build and defining Champion Class ]]------
do
	myHero = GetMyHero()
	Target = nil
	spawnpos  = { x = myHero.x, z = myHero.z}
	ranged = 0
	assassins = {"Akali","Diana","Evelynn","Fizz","Katarina","Nidalee"}
	adtanks = {"Braum","DrMundo","Garen","Gnar","Hecarim","Jarvan IV","Nasus","Skarner","TahmKench","Thresh","Volibear","Yorick"}
	adcs = {"Ashe","Caitlyn","Corki","Draven","Ezreal","Gangplank","Graves","Jinx","Kalista","KogMaw","Lucian","MissFortune","Quinn","Sivir","Tristana","Tryndamere","Twitch","Urgot","Varus","Vayne"}
	aptanks = {"Alistar","Amumu","Blitzcrank","Chogath","Leona","Malphite","Maokai","Nautilus","Rammus","Sejuani","Shen","Singed","Zac"}
	mages = {"Ahri","Anivia","Annie","Azir","Bard","Brand","Cassiopeia","Ekko","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","LeBlanc","Lissandra","Lulu","Lux","Malzahar","Morgana","Nami","Nunu","Orianna","Ryze","Sona","Soraka","Swain","Syndra","Taric","TwistedFate","Veigar","Velkoz","Viktor","Xerath","Ziggs","Zilean","Zyra"}
	hybrids = {"Kayle","Teemo"}
	bruisers = {"Darius","Irelia","Khazix","LeeSin","Olaf","Pantheon","RekSai","Renekton","Rengar","Riven","Shyvana","Talon","Trundle","Vi","MonkeyKing","Zed","Yasuo"}
	fighters = {"Aatrox","Fiora","Jax","Jayce","MasterYi","Nocturne","Poppy","Sion","Udyr","Warwick","XinZhao"}
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
		--if iARAM.misc.miscelaneus then
			_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Items Loaded</font>")
		--end
	end
	if heroType == 1 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#00FF00\">ADC</font>" )
	elseif heroType == 2 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF8000\">ADTANK</font>" )
	elseif heroType == 3 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF00FF\">APTANK</font>" )
	elseif heroType == 4 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#A9F5F2\">Hybrid</font>" )	
	elseif heroType == 5 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#8A084B\">BRUISER</font>" )	
	elseif heroType == 6 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF0000\">ASSASINS</font>" )	
	elseif heroType == 7 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#0040FF\">MAGE</font>" )	
	elseif heroType == 8 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#80FF00\">APC</font>" )	
	elseif heroType == 9 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FFFF00\">FIGHTER</font>")	
	else
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#BDBDBD\">UNKOWN</font>" )
	end
	
	if myHero.range > 400 then
		ranged = 1
	end
	

	--[[ ItemsList ]]--
	itemCosts = {
                                        [3096]=865,--Nomad's Medallion
										[1001]=325,--Boots
										[1042]=450,--Dagger
										[1037]=875,--Pickaxe
										[3024]=950,--Glacial Shroud
                                        [3801]=600,--Crystalline Bracer
										[1026]=850,--Blasting Wand
										[3108]=820,--Fiendish Codex
                                        [1031]=750,--Chain Vest
										[3028]=900,--ºChalice of Harmony
										[1057]=850,--Negatron Cloak
                                        [3083]=300,--Warmog's Armor
										[1053]=800,--Vampiric Scepter
										[1011]=1000,--ºGiant's Belt
                                        [3190]=2800,--ºLocket of the Iron Solari
                                        [3075]=2100,--Thornmail
                                        [3068]=2600,--Sunfire Cape
                                        [3072]=1950,--Bloodthirster
                                        [3069]=1235,--ºTalisman of Ascension
                                        [1038]=1550,--B.F. Sword
                                        [3031]=2250,--ºInfinity Edge
                                        [3139]=2150,--Mercurial Scimitar
                                        [3508]=1650,--Essence Reaver
                                        [3155]=1450,--Hexdrinker
                                        [3156]=1750,--Maw of Malmortius
                                        [3082]=1050,--Warden's Mail
                                        [3110]=1400,--Frozen Heart
                                        [3211]=1200,--Spectre's Cowl
                                        [3065]=1550,--ºSpirit Visage
                                        [3102]=1550,--Banshee's Veil
                                        [1058]=1600,--Needlessly Large Rod
                                        [3089]=1700,--Rabadon's Deathcap
                                        [3157]=1700,--Zhonya's Hourglass
                                        [3285]=1500,--Luden's Echo
                                        [3001]=2440,--ºAbyssal Scepter
                                        [3101]=1250,--Stinger
                                        [3115]=1670,--Nashor's Tooth
                                        [3136]=1485,--Haunting Guise
                                        [3151]=1415,--Liandry's Torment
										[3057]=1200,--ºSheen
                                        [3100]=3000,--Lich Bane
                                        [3044]=1325,--ºPhage
                                        [3071]=3000,--ºThe Black Cleaver       
                                        [3165]=2300,--ºMorellonomicon
										[3006]=1000,--Berserker's Greaves
										[3086]=1100,--Zeal
										[3144]=1400,--Bilgewater Cutlass
										[3153]=3200,--Blade of the Ruined King
										[3181]=2275,--Sanguine Blade
										[3035]=2300,--ºLast Whisper
										[3026]=2800,--Guardian Angel
										[3047]=1000,--ºNinja Tabi
										[3134]=1337,--The Brutalizer
										[3025]=2900,--Iceborn Gauntlet
										[3111]=1200,--Mercury's Treads
										[3116]=3000,--Rylai's Crystal Scepter
										[1043]=1100,--Recurve Bow
										[3020]=1100,--ºSorcerer's Shoes
										[3091]=2600,--Wit's End
										[3152]=2500,--Will of the Ancients
										[3074]=3300,--Ravenous Hydra 
										[3135]=2500,--Void Staff
										[3145]=1200,--Hextech Revolver
										[3078]=3703,--Trinity Force
										[3174]=2700,--Athene's Unholy Grail
										[3087]=2500,--Statikk Shiv
										[3143]=2850,--Randuin's Omen
										[3005]=2250,--Atma's Impaler
										[3124]=2590,--Guinsoo's Rageblade
										[3046]=2800,--ºPhantom Dancer
										[3146]=3400,--Hextech Gunblade
										[3077]=1900--Tiamat
                                }
       
        if heroType == 1 then --ADC
			--shopList = {3006,3086,3087,3144,3153,1038,3181,1037,3035,3026,0}
			shopList = {3006,3035,3026,3031,3046,0}
		end
		if heroType == 2 then --ADTANK
			--shopList = {3047,1011,3134,3068,3024,3025,3071,3082,3143,3005,0}
			shopList = {3047,1011,3071,3190,3065,0}
		end
		if heroType == 3 then --APTANK
			--shopList = {3111,1031,3068,1057,3116,1026,3001,3082,3110,3102,0}
			shopList = {3044,1031,3068,1057,3116,1026,3001,3082,3110,3102,0}
		end
		if heroType == 4 then --HYBRID
			--shopList = {3108,3115,3020,1026,3136,3089,1043,3091,3151,3116}
			shopList = {3020,3046,3035,3001,3165,0}
		end
		if heroType == 5 then --BRUISER
			--shopList = {1001,3111,3134,1038,3181,3155,3071,1053,3077,3074,3156,3190}
			shopList = {3047,3071,3190,3046,0}
		end
		if heroType == 6 then --ASSASSIN
			--shopList = {3020,3057,3100,1026,3089,3136,3151,1058,3157,3135,0}
			shopList = {3020,3057,3001,0}
		end
		if heroType == 7 then --MAGE
			--shopList = {3028,3020,3136,1058,3089,3174,3151,1026,3001,3135,0}
			shopList = {3028,3020,3174,3001,3165,0}
		end
		if heroType == 8 then --APC
			--shopList = {3145,3020,3152,1026,3116,1058,3089,1026,3001,3157}
			shopList = {3020,3001,3046,3001,0}
		end
		if heroType == 9 or heroType == 10 then --FIGHTER and OTHERS
			--shopList = {3111,3044,3086,3078,3144,3153,3067,3065,3134,3071,3156,0}
			shopList = {3006,3044,3065,3071,3046,0}
		end
        startTime = GetTickCount()
	--yellow ward 3340
	--item ids can be found at many websites, ie: http://www.lolking.net/items/1004

end


--[[ On Draw Function ]]--
function OnDraw()
	AirText()
	RangeCircles()
	--|>Autoward
	AutoWarderDraw()
	DebugCursorPos()
	--|>FloatText
	FloatTextStance()
	--|>NameDrawer
	DrawFakeNames()
	

end


--[[ On Load Function ]]--
 function OnLoad()

	OnProcessSpell()
	timeToShoot()
	heroCanMove()
	Menu()
	OnWndMsg()
	if AutomaticChat then
		AutoChat()
	end
	--|>Auto Ward
	AutoWard()
	--|>Auto Ignite
	if ignite ~= nil then
		FunctionAutoIgnite()
	end
	--|>Mode Alone
	GetPlayer()
	LoadMapVariables()

end


--[[ On Unload Function ]]--
function OnUnload()
	print ("<font color=\"#9bbcfe\"><b>i<font color=\"#6699ff\">ARAM:</b></font> <font color=\"#FFFFFF\">disabled.</font>")
end


--[[ OnTick Function ]]--
function OnTick()
	AutoBuy()
	Follow()	
	LFC()
	AutoAttackChamp()
	AutoFarm()
	--|> Poro Shouter
	PoroCheck()
	--|>Autopotions
	AutoPotions()
	--|>Mode Alone
	FollowMinionAlly()
	HealthAlly()
	
end


---------[[ OnWndMsg Script ]]---------
function OnWndMsg(msg, keycode)
	AutoWard()
	if keycode == HotKey and msg == KEY_DOWN then
        if switcher == true then
            switcher = false
			_AutoupdaterMsg("<font color='#FF0000'>Script disabled </font>")
        else
            switcher = true
			_AutoupdaterMsg("<font color='#00FF00'>Script enabled </font>")
        end
	end
end


--[[ Follow Function ]]--
function Follow()
	if iARAM.follow and not myHero.dead then
		stance = 0
		if Allies() >= 2 then
			stance = 1		
		else
			stance = 0
		end
		if findLowHp() ~= 0 then
			Target = findLowHp()
		else
			Target = findClosestEnemy()
		end
		Allie = followHero()
		--|>Attacks Champs
		if Target ~= nil then
		stance = 3
		  myHero:Attack(Target)
			if stance == 3 then
				attacksuccess = 0
				if myHero:CanUseSpell(_W) == READY then
				 if iARAM.misc.misc2 then CastW(str) end
					CastSpell(_W, Target)
					attacksuccess =1
				end
				if myHero:CanUseSpell(_Q) == READY then
				--if iARAM.misc.misc2 then _AutoupdaterMsg("CastSpell Q") end
					CastSpell(_Q, Target)
					attacksuccess =1 
				end
				if myHero:CanUseSpell(_E) == READY  then
				--if iARAM.misc.misc2 then _AutoupdaterMsg("CastSpell E") end
					CastSpell(_E, Target)
					attacksuccess = 1
				end
				if myHero:CanUseSpell(_R) == READY then
				--if iARAM.misc.misc2 then _AutoupdaterMsg("CastSpell R") end
					CastSpell(_R, Target)
					attacksuccess =1
				end
				
				if attacksuccess == 0 then
					--|>Attack Minions
						AutoFarm()
				end
				
				--|> Alone Mode
			elseif stance == 0 then
			if frontally() == myHero then
				myHero:MoveTo(spawnpos.x,spawnpos.z)
			end
			
				--|> Enemy Target
			elseif stance == 3 then
				myHero:MoveTo(spawnpos.x,spawnpos.z)
			end
			allytofollow = followHero()
			if allytofollow ~= nil and GetDistance(allytofollow,myHero) > 350 then
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
		end	
	else
	--|> Dead
	--	AutoBuy()
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
	local barPos = WorldToScreen(D3DXVECTOR3(currentEnemy.x, currentEnemy.y, currentEnemy.z))
	DrawText("Enemy!", 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))
	--PrintFloatText(closestEnemy, 0, "Enemy!")
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
			--PrintFloatText(lowEnemy, 0, "Kill Me")
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
        if hero.team == myHero.team and not hero.dead and GetDistance(hero) < 450 then
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

function getTrueRange()
    return myHero.range + GetDistance(myHero.minBBox)+100
end


--[[ AutoBuyItems ]]--
function AutoBuy()
	if iARAM.misc.autobuy then
		if myHero.dead or shopList[buyIndex] ~= 0 then
				nowTime = GetTickCount()
			if nowTime - lastBuy > 500 then
				currentGold = myHero.gold
				nowTime = GetTickCount()
				if (currentGold < lastGold) or ((currentGold ~= lastGold) and (nowTime - lastBuy > 500)) then
					if nowTime - lastBuy > 900 then
						currentGold = myHero.gold
						local itemval = shopList[buyIndex]
						if itemval ~= nil then
							local cost = itemCosts[itemval]
							if cost ~= nil then
								if myHero.gold > cost then
									lastGold = currentGold
									lastBuy = GetTickCount()
									BuyItem(itemval)
									table.remove(shopList, 1)		
								end
							end
						end
					end
				end
			end
		end
	end
end


--[[ Menu Function ]]-- 
function Menu()
       iARAM = scriptConfig("iARAM", "iARAM BOT")

	   --[[ AutoWard Menu ]]--   
		iARAM:addSubMenu("AutoWard Settings", "AutoWard")
			iARAM.AutoWard:addParam("AutoWardEnable", "Autoward Enabled", SCRIPT_PARAM_ONOFF, true)
			iARAM.AutoWard:addParam("AutoWardDraw", "Autoward Draw Circles", SCRIPT_PARAM_ONOFF, false)
			iARAM.AutoWard:addParam("debug", "Debug Mode", SCRIPT_PARAM_ONOFF, false)
		
		--[[ Drawing menu ]]--
		iARAM:addSubMenu("Drawing Settings", "drawing")
			iARAM.drawing:addParam("drawcircles", "Draw Circles", SCRIPT_PARAM_ONOFF, true)
			iARAM.drawing:addParam("LfcDraw", "Use Lagfree Circles (Requires Reload!)", SCRIPT_PARAM_ONOFF, true)
		
		--[[ PoroShoter menu ]]--
		
		ARAM = ARAMSlot()
		vPred = VPrediction()
		TargetSelector = TargetSelector(TARGET_CLOSEST, 2500, DAMAGE_PHYSICAL)
		iARAM:addSubMenu("PoroShotter Settings", "PoroShot")
			iARAM.PoroShot:addParam("comboKey", "Auto Poro Shoot", SCRIPT_PARAM_ONOFF, true) 
			iARAM.PoroShot:addParam("range", "Poro Cast Range", SCRIPT_PARAM_SLICE, 1400, 800, 2500, 0) 
			iARAM.PoroShot:addTS(TargetSelector)
		
		--[[ Misc menu ]]--
		iARAM:addSubMenu("Miscelaneus Settings", "misc")
			iARAM.misc:addParam("misc2", "Debug Mode", SCRIPT_PARAM_ONOFF, false)
			iARAM.misc:addParam("farm", "Last Hit Farm", SCRIPT_PARAM_ONOFF, true)	
			iARAM.misc:addParam("attackchamps", "Auto Attack champs", SCRIPT_PARAM_ONOFF, true)
			iARAM.misc:addParam("autobuy", "Auto Buy Items", SCRIPT_PARAM_ONOFF, true)

		--Attack
		ignite = IgniteCheck()


		--Main Script

		iARAM:addParam("follow", "Enable bot", SCRIPT_PARAM_ONKEYTOGGLE, true, HotKey)

		-----------------------------------------------------------------------------------------------------
		iARAM:addParam("info", "edited by ", SCRIPT_PARAM_INFO, "Husmeador12") 
		iARAM:addParam("info2", "iARAM Version : ", SCRIPT_PARAM_INFO, version)
		

end


--[[ Lagfree Circles by barasia, vadash and viseversa ]]---
function RangeCircles()

	if iARAM.drawing.drawcircles and not myHero.dead then
		DrawCircle(myHero.x,myHero.y,myHero.z,getTrueRange(),RGB(0,255,0))
		DrawCircle(myHero.x,myHero.y,myHero.z,400,RGB(55,64,60))	
		--for index, allyminion in pairs(allyMinions.objects) do
		--DrawCircle(allyminion.x,allyminion.y,allyminion.z,100,RGB(0,255,0))
		--end
	end
end

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
	if iARAM.misc.misc2 then 
		DrawText(""..myHero.charName.." Bot", MenuTextSize , (WINDOW_W - WINDOW_X) * SetupDrawX, (WINDOW_H - WINDOW_Y) * tempSetupDrawY , 0xffffff00) 
		tempSetupDrawY = tempSetupDrawY + 0.03
		DrawText("Logged as: ".. GetUser() .." ", MenuTextSize , (WINDOW_W - WINDOW_X) * SetupDrawX, (WINDOW_H - WINDOW_Y) * tempSetupDrawY , 0xffffff00) 
		tempSetupDrawY = tempSetupDrawY + 0.07
	end
end


--[[ Perfect Ward, originally by Husky ]]--     
local wardSpots = {
    -- Perfect Wards
	{x=3261.93, y=60, z=7773.65}, -- BLUE GOLEM
	{x=7831.46, y=60, z=3501.13}, -- BLUE LIZARD
	{x=10586.62, y=60, z=3067.93}, -- BLUE TRI BUSH
	{x=6483.73, y=60, z=4606.57}, -- BLUE PASS BUSH
	{x=7610.46, y=60, z=5000}, -- BLUE RIVER ENTRANCE
	{x=4717.09, y=50.83, z=7142.35}, -- BLUE ROUND BUSH
	{x=4882.86, y=27.83, z=8393.77}, -- BLUE RIVER ROUND BUSH
	{x=6951.01, y=52.26, z=3040.55}, -- BLUE SPLIT PUSH BUSH
	{x=5583.74, y=51.43, z=3573.83}, --BlUE RIVER CENTER CLOSE

	{x=11600.35, y=51.73, z=7090.37}, -- RED GOLEM
	{x=11573.9, y=51.71, z=6457.76}, -- RED GOLEM 2
	{x=12629.72, y=48.62, z=4908.16}, -- RED TRIBRUSH 2
	{x=7018.75, y=54.76, z=11362.12}, -- RED LIZARD
	{x=4232.69, y=47.56, z=11869.25}, -- RED TRI BUSH
	{x=8198.22, y=49.38, z=10267.89}, -- RED PASS BUSH
	{x=7202.43, y=53.18, z=9881.83}, -- RED RIVER ENTRANCE
	{x=10074.63, y=51.74, z=7761.62}, -- RED ROUND BUSH
	{x=9795.85, y=-12.21, z=6355.15}, -- RED RIVER ROUND BUSH
	{x=7836.85, y=56.48, z=11906.34}, -- RED SPLIT PUSH BUSH

	{x=10546.35, y=-60, z=5019.06}, -- DRAGON
	{x=9344.95, y=-64.07, z=5703.43}, -- DRAGON BUSH
	{x=4334.98, y=-60.42, z=9714.54}, -- BARON
	{x=5363.31, y=-62.70, z=9157.05}, -- BARON BUSH

	{x=9757.9, y=50.73, z=8768.25}, -- RED MID T1

	{x=4749.79, y=53.59, z=5890.76}, -- BLUE MID T1
	{x=5983.58, y=52.99, z=1547.98}, -- BLUE BOT T2
	{x=1213.70, y=58.77, z=5324.73}, -- BLUE TOP T2

	{x=6523.58, y=60, z=6743.31}, -- BLUE MIDLANE
	{x=8223.67, y=60, z=8110.15}, -- RED MIDLANE
	{x=9736.8, y=51.98, z=6916.26}, -- RED MID PATH
	{x=2222.31, y=53.2, z=9964.1}, -- BLUE TRI TOP
	{x=8523.9, y=51.24, z=4707.76}, -- DRAGON PASS BUSH
	{x=6323.9, y=53.62, z=10157.76} -- NASHOR PASS BUSH

}

local safeWardSpots = {

	{    -- RED MID -> SOLO BUSH
		magneticSpot = {x=9223, y=52.95, z=7525.34},
		clickPosition = {x=9603.52, y=54.71, z=7872.23},
		wardPosition = {x=9873.90, y=51.52, z=7957.76},
		movePosition = {x=9223, y=52.95, z=7525.34}
	},
	{    -- RED MID FROM TOWER -> SOLO BUSH
		magneticSpot =  {x=9127.66, y=53.76, z=8337.72},
		clickPosition = {x=9624.05, y=72.46, z=8122.68},
		wardPosition =  {x=9873.90, y=51.52, z=7957.76},
		movePosition  = {x=9127.66, y=53.76, z=8337.72}
	},
	{    -- BLUE MID -> SOLO BUSH
		magneticSpot =  {x=5667.73, y=51.65, z=7360.45},
		clickPosition = {x=5148.87, y=50.41, z=7205.80},
		wardPosition =  {x=4923.90, y=50.64, z=7107.76},
		movePosition  = {x=5667.73, y=51.65, z=7360.45}
	},
	{    -- BLUE MID FROM TOWER -> SOLO BUSH
		magneticSpot =  {x=5621.65, y=52.81, z=6452.61},
		clickPosition = {x=5255.46, y=50.44, z=6866.24},
		wardPosition =  {x=4923.90, y=50.64, z=7107.76},
		movePosition  = {x=5621.65, y=52.81, z=6452.61}
	},
	{    -- NASHOR -> TRI BUSH
		magneticSpot =  {x=4724, y=-71.24, z=10856},
		clickPosition = {x=4627.26, y=-71.24, z=11311.69},
		wardPosition =  {x=4473.9, y=51.4, z=11457.76},
		movePosition  = {x=4724, y=-71.24, z=10856}
	},
	{    -- BLUE TOP -> SOLO BUSH
		magneticSpot  = {x=2824, y=54.33, z=10356},
		clickPosition = {x=3078.62, y=54.33, z=10868.39},
		wardPosition  = {x=3078.62, y=-67.95, z=10868.39},
		movePosition  = {x=2824, y=54.33, z=10356}
	},
	{ -- BLUE MID -> ROUND BUSH
		magneticSpot  = {x=5474, y=51.67, z=7906},
		clickPosition = {x=5132.65, y=51.67, z=8373.2},
		wardPosition  = {x=5123.9, y=-21.23, z=8457.76},
		movePosition  = {x=5474, y=51.67, z=7906}
	},
	{ -- BLUE MID -> RIVER LANE BUSH
		magneticSpot  = {x=5874, y=51.65, z=7656},
		clickPosition = {x=6202.24, y=51.65, z=8132.12},
		wardPosition  = {x=6202.24, y=-67.39, z=8132.12},
		movePosition  = {x=5874, y=51.65, z=7656}
	},
	{ -- BLUE LIZARD -> DRAGON PASS BUSH
		magneticSpot  = {x=8022, y=53.72, z=4258},
		clickPosition = {x=8400.68, y=53.72, z=4657.41},
		wardPosition  = {x=8523.9, y=51.24, z=4707.76},
		movePosition  = {x=8022, y=53.72, z=4258}
	},
	{ -- RED MID -> ROUND BUSH
		magneticSpot  = {x=9372, y=52.63, z=7008},
		clickPosition = {x=9703.5, y=52.63, z=6589.9},
		wardPosition  = {x=9823.9, y=23.47, z=6507.76},
		movePosition  = {x=9372, y=52.63, z=7008}
	},
	{ -- RED MID -> RIVER ROUND BUSH // Inconsistent Placement
		magneticSpot  = {x=9072, y=53.04, z=7158},
		clickPosition = {x=8705.95, y=53.04, z=6819.1},
		wardPosition  = {x=8718.88, y=95.75, z=6764.86},
		movePosition  = {x=9072, y=53.04, z=7158}
	},
	{ -- RED BOTTOM -> SOLO BUSH
		magneticSpot  = {x=12422, y=51.73, z=4508},
		clickPosition = {x=12353.94, y=51.73, z=4031.58},
		wardPosition  = {x=12023.9, y=-66.25, z=3757.76},
		movePosition  = {x=12422, y=51.73, z=4508}
	},
	{ -- RED LIZARD -> NASHOR PASS BUSH -- FIXED FOR MORE VISIBLE AREA
		magneticSpot  = {x=6824, y=56, z=10656},
		clickPosition = {x=6484.47, y=53.5, z=10309.94},
		wardPosition  = {x=6323.9, y=53.62, z=10157.76},
		movePosition  = {x=6824, y=56, z=10656}
	},
	{ -- BLUE GOLEM -> BLUE LIZARD
		magneticSpot  = {x=8272,    y=51.13, z=2908},
		clickPosition = {x=8163.7056, y=51.13, z=3436.0476},
		wardPosition  = {x=8163.71, y=51.6628, z=3436.05},
		movePosition  = {x=8272,    y=51.13, z=2908}
	},
	{ -- RED GOLEM -> RED LIZARD
		magneticSpot  = {x=6574, y=56.48, z=12006},
		clickPosition = {x=6678.08, y=56.48, z=11477.83},
		wardPosition  = {x=6678.08, y=53.85, z=11477.83},
		movePosition  = {x=6574, y=56.48, z=12006}
	},
	{ -- BLUE TOP SIDE BRUSH
		magneticSpot  = {x=1774, y=52.84, z=10756},
		clickPosition = {x=2302.36, y=52.84, z=10874.22},
		wardPosition  = {x=2773.9, y=-71.24, z=11307.76},
		movePosition  = {x=1774, y=52.84, z=10756}
	},
	{ -- MID LANE DEATH BRUSH
		magneticSpot  = {x=5874, y=-70.12, z=8306},
		clickPosition = {x=5332.9, y=-70.12, z=8275.21},
		wardPosition  = {x=5123.9, y=-21.23, z=8457.76},
		movePosition  = {x=5874, y=-70.12, z=8306}
	},
	{ -- MID LANE DEATH BRUSH RIGHT SIDE
		magneticSpot  = {x=9022, y=-71.24, z=6558},
		clickPosition = {x=9540.43, y=-71.24, z=6657.68},
		wardPosition  = {x=9773.9, y=9.56, z=6457.76},
		movePosition  = {x=9022, y=-71.24, z=6558}
	},
	{ -- BLUE INNER TURRET JUNGLE
		magneticSpot  = {x=6874, y=50.52, z=1708},
		clickPosition = {x=6849.11, y=50.52, z=2252.01},
		wardPosition  = {x=6723.9, y=52.17, z=2507.76},
		movePosition  = {x=6874, y=50.52, z=1708}
	},
	{ -- RED INNER TURRET JUNGLE
		magneticSpot  = {x=8122, y=52.84, z=13206},
		clickPosition = {x=8128.53, y=52.84, z=12658.41},
		wardPosition  = {x=8323.9, y=56.48, z=12457.76},
		movePosition  = {x=8122, y=52.84, z=13206}
	}
}

local wardItems = {
    { id = 2043, spellName = "VisionWard",     		range = 1450, duration = 180000},
    { id = 2044, spellName = "SightWard",      		range = 1450, duration = 180000},
	{ id = 2045, spellName = "RubySightstone",  	range = 1450, duration = 180000},
    { id = 2049, spellName = "Sightstone",  		range = 1450, duration = 180000},
    { id = 2050, spellName = "ItemMiniWard",   		range = 1450, duration = 60000},
    { id = 3154, spellName = "WriggleLantern", 		range = 1450, duration = 180000},
    { id = 3160, spellName = "FeralFlare",	   		range = 1450, duration = 180000},
	{ id = 3340, spellName = "WardingTotem(Trinket)",   range = 1450, duration = 180000},
    { id = 3350, spellName = "YellowTrinketUpgrade", range = 1450, duration = 180000}, 
	{ id = 3361, spellName = "TrinketTotemLvl3", 	range = 1450, duration = 180000},
	{ id = 3362, spellName = "TrinketTotemLvl3B", 	range = 1450, duration = 180000},

}

-- Code ------------------------------------------------------------------------

function AutoWard()
   if iARAM.AutoWard.AutoWardEnable then
	wardSlot = ITEM_7
        local item = myHero:getInventorySlot(wardSlot)
         for i,wardItems in pairs(wardItems) do
                if item == wardItems.id and myHero:CanUseSpell(wardSlot) == READY then
					drawWardSpots = true
					return
                end
         end
        for i,wardSpot in pairs(wardSpots) do
            if GetDistance(wardSpot, myHeroPos) <= 250  then
                CastSpell(wardSlot, wardSpot.x, wardSpot.z)
                return
            end
        end
    end
end

function AutoWarderDraw()
    if iARAM.AutoWard.AutoWardDraw and summonersRiftMap then
        for i, wardSpot in pairs(wardSpots) do
            local wardColor = (GetDistance(wardSpot, myHeroPos) <= 250) and ARGB(255,0,255,0) or ARGB(255,0,255,0)
            local x, y, onScreen = get2DFrom3D(wardSpot.x, wardSpot.y, wardSpot.z)
            if onScreen then
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 31, wardColor)
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 32, wardColor)
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 250, wardColor)
            end
        end
        for i,wardSpot in pairs(safeWardSpots) do
            local wardColor  = (GetDistance(wardSpot.magneticSpot, myHeroPos) <= 100) and ARGB(255,0,255,0) or ARGB(255,0,255,0)
            local arrowColor = (GetDistance(wardSpot.magneticSpot, myHeroPos) <= 100) and ARGB(255,0,255,0) or ARGB(255,0,255,0)

            local x, y, onScreen = get2DFrom3D(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z)
            if onScreen then
                DrawCircle(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z, 31, wardColor)
                DrawCircle(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z, 32, wardColor)
                DrawCircle(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z, 99, wardColor)
                DrawCircle(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z, 100, wardColor)

                local magneticWardSpotVector = Vector(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z)
                local wardPositionVector = Vector(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z)
                local directionVector = (wardPositionVector-magneticWardSpotVector):normalized()
                local line1Start = magneticWardSpotVector + directionVector:perpendicular() * 98
                local line1End = wardPositionVector + directionVector:perpendicular() * 31
                local line2Start = magneticWardSpotVector + directionVector:perpendicular2() * 98
                local line2End = wardPositionVector + directionVector:perpendicular2() * 31
                DrawLine3D(line1Start.x,line1Start.y,line1Start.z, line1End.x,line1End.y,line1End.z,1,arrowColor)
                DrawLine3D(line2Start.x,line2Start.y,line2Start.z, line2End.x,line2End.y,line2End.z,1,arrowColor)  
            end
        end
    end  
end

function get2DFrom3D(x, y, z)
    local pos = WorldToScreen(D3DXVECTOR3(x, y, z))
    return pos.x, pos.y, OnScreen(pos.x, pos.y)
end

function DebugCursorPos()
	if iARAM.AutoWard.debug then
		DrawText("Cursor Pos: X = ".. string.format("%.2f", mousePos.x) .." Y = ".. string.format("%.2f", mousePos.y) .." Z = ".. string.format("%.2f", mousePos.z), 21, 5, 140, 0xFFFFFFFF)
		local target = GetTarget()
		for i,wardItem in pairs(wardItems) do
			if target ~= nil and target.name == wardItem.spellName then
				DrawText("Target Pos: X = ".. string.format("%.2f", target.x) .." Y = ".. string.format("%.2f", target.y) .." Z = ".. string.format("%.2f", target.z), 21, 5, 160, 0xFFFFFFFF)
			end
		end
	end
end


---------[[ Auto Ignite and Auto Zhonya ]]---------
function FunctionAutoIgnite()
	if iARAM.autoIgnite then
		if myHero:CanUseSpell(ignite) == READY then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if myHero:CanUseSpell(ignite) ~= READY then return end
				if ValidTarget(enemy) and GetDistance(enemy) < 600 then
					local dmg = getDmg("ignite",enemy,myHero)
					if dmg > target.health then
						CastSpell(ignite, enemy)
					end
				end
			end
		end
	end
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
			iARAM:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
			iARAM:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	end
end


---------[[ Auto Good luck and have fun ]]---------
function AutoChat()
Text1 = {"Good luck and have fun", "gl hf", "gl hf", "Good luck have fun", "Good luck and have fun guys", "gl hf guys", "gl and have fun", "good luck and hf" } 
Phrases2 = {"c´mon guys", "we can do it", "This is my winner team", "It doesnt matter", "let´s go", "team work is OP" }
	
	CountTimer = 15
	if os.clock() < CountTimer then return end
		SendChat(Text1[math.random(#Text1)])

		CountTimer = os.clock() + math.random(0.5,2)
		
	if GetInGameTimer() < 15 then
				DelayAction(function()
				if myHero.team == TEAM_BLUE then
					myHero:MoveTo(myHero.x*5,myHero.z*5)
					if iARAM.misc.miscelaneus then
						print("moving")
					end
				else
					myHero:MoveTo(myHero.x*5,myHero.z*5)
				end
				end, 15-GetInGameTimer())
			end
			
	
	if GetInGameTimer() < 333 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 333-GetInGameTimer()) --5:35
	end
	
	--[[ if GetInGameTimer() < 360 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 360-GetInGameTimer()) --6:02
	end ]]--
	
	if GetInGameTimer() < 460 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 460-GetInGameTimer()) --7:40
	end
	
	if GetGame().isOver then 
        SendChat("gg wp")
		QuitGame(10)
    end
	
end


---------[[ Poro shouter function ]]---------
function PoroCheck()
	Target = getTarget()
	if ARAM and (myHero:CanUseSpell(ARAM) == READY) then 
		ARAMRdy = true
	else
		ARAMRdy = false
	end
	if iARAM.PoroShot.comboKey then
		shootARAM(Target)
	end

end

function getTarget()
	TargetSelector:update()	
	if TargetSelector.target and not TargetSelector.target.dead and TargetSelector.target.type == myHero.type then
		return TargetSelector.target
	else
		return nil
	end
end

function ARAMSlot()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonersnowball") then
		return SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonersnowball") then
		return SUMMONER_2
	else
		return nil
	end
end

function hit()
	if myHero:GetSpellData(SUMMONER_1).name:find("snowballfollowupcast") then
		return true
	elseif myHero:GetSpellData(SUMMONER_2).name:find("snowballfollowupcast") then
		return true
	else
		return false
	end
end

function shootARAM(unit)
	if lastCast > os.clock() - 10 then return end
	if  ValidTarget(unit, iARAM.PoroShot.range + 50) and ARAMRdy then
		local CastPosition, Hitchance, Position = vPred:GetLineCastPosition(Target, .25, 75, iARAM.range, 1200, myHero, true)
		if CastPosition and Hitchance >= 2 then
			d = CastPosition
			CastSpell(ARAM, CastPosition.x, CastPosition.z)
			lastCast = os.clock()
		end
	end
end


-----[[ AutoFarm and harras ]]------
function AutoAttackChamp()
	range = myHero.range + myHero.boundingRadius - 3
	ts.range = range
	ts:update()
	if iARAM.follow then
		if not iARAM.misc.attackchamps then return end
		local myTarget = ts.target
		if myTarget ~=	nil then		
			if timeToShoot() then
				myHero:Attack(myTarget)
				AttackChampion = true
				elseif heroCanMove() then
				AttackChampion = false
				
			end

		end
	end
end

function AutoFarm()
	if iARAM.follow then
		enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
		enemyMinions:update()
		local player = GetMyHero()
		local tick = 0
		local delay = 400
		local myTarget = ts.target
		  if iARAM.misc.farm then
			for index, minion in pairs(enemyMinions.objects) do
			  if GetDistance(minion, myHero) <= (myHero.range + 75) and GetTickCount() > tick + delay then
				local dmg = getDmg("AD", minion, myHero)
				if dmg > minion.health then
				  myHero:Attack(minion)
				  tick = GetTickCount()
				  AttackMinion = true
				  else
				  AttackMinion = false
				end
			  end
			end
		  end
	end
end

function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end 
 
function timeToShoot()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end 

function OnProcessSpell(object, spell)
	if object == myHero then
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
		end 
	end
end


-----[[ PrintFloatText ]]------
function ChampionFloatText()
	ChampionCount = 0
    ChampionTable = {}
    for i = 1, heroManager.iCount do
        local champ = heroManager:GetHero(i)       
        if champ.team ~= player.team then
            ChampionCount = ChampionCount + 1
            ChampionTable[ChampionCount] = { player = champ, indicatorText = "", damageGettingText = "", ultAlert = false, ready = true}
        end
    end
end

function _FloatTextMsg(msg) 
	local barPos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
	DrawText(" "..msg.." ", 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))
end


-----[[ MapVariables Function ]]------
function LoadMapVariables()
	gameState = GetGame()
	--print(gameState.map.shortName)
	if gameState.map.shortName then
		if gameState.map.shortName == "summonerRift" then
			summonersRiftMap = true
			if iARAM.misc.miscelaneus then _AutoupdaterMsg("Map: summonerRift") end
			
		else
			summonersRiftMap = false
		end
		
		if gameState.map.shortName == "crystalScar" then
			crystalScarMap = true
			if iARAM.misc.misc2 then _AutoupdaterMsg("Map: crystalScar") end
			
		else
			crystalScarMap = false
		end
		
		if gameState.map.shortName == "howlingAbyss" then
			howlingAbyssMap = true
			if iARAM.misc.misc2 then _AutoupdaterMsg("Map: howlingAbyss") end
		else
			howlingAbyssMap = false
		end
		
		if gameState.map.shortName == "twistedTreeline" then
			twistedTreeLineMap = true
			if iARAM.misc.misc2 then _AutoupdaterMsg("Map: twistedTreeline") end
		else
			twistedTreeLineMap = false
		end
	else
		summonersRiftMap = true
		if iARAM.misc.misc2 then _AutoupdaterMsg("Map: Unknow") end
	end
end


-----[[ AutoPotions ]]------

function AutoPotions()
	--if not iARAM.autoPots.useAutoPots then
	--	return
	--end
	for SLOT = ITEM_1, ITEM_6 do
	-- if Helper.Debug then PrintChat("ITEM : "..myHero:GetSpellData(SLOT).name) end
		-- Crystalline Flash
		if myHero:GetSpellData(SLOT).name == "ItemCrystalFlask" then
			-- Conditions
			if myHero:CanUseSpell(SLOT) == READY and ((myHero.health / myHero.maxHealth < myHero:getItem(SLOT).stacks / 4 or myHero.mana / myHero.maxMana < myHero:getItem(SLOT).stacks / 4) or ((myHero.maxHealth - myHero.health > 120 and myHero.maxMana - myHero.mana > 60) or (myHero.mana < 100 or myHero.health < 100))) then
				-- Cast
				CastSpell(SLOT)
				if iARAM.misc.misc2 then _AutoupdaterMsg("CrystalFlask Potions") end
			end
		end
		-- Health Potions
		if myHero:GetSpellData(SLOT).name == "RegenerationPotion" and not RevenerationPotion then
			-- Conditions
			if myHero:CanUseSpell(SLOT) == READY and myHero.health / myHero.maxHealth < myHero:getItem(SLOT).stacks / 6 and myHero.maxHealth - myHero.health > 150 then
				-- Cast
				CastSpell(SLOT)
				if iARAM.misc.misc2 then _AutoupdaterMsg("Health Potion") end
			end
		end
		-- Mana Potions
		if myHero:GetSpellData(SLOT).name == "FlaskOfCrystalWater" then
			-- Conditions
			if myHero:CanUseSpell(SLOT) == READY and myHero.mana / myHero.maxMana < myHero:getItem(SLOT).stacks / 6 and myHero.maxMana - myHero.mana > 100 or myHero.mana < 100 then
				-- Cast
				CastSpell(SLOT)
				if iARAM.misc.misc2 then _AutoupdaterMsg("Mana Potion") end
			end
		end
	end
end

function LoadVariables()
	LoadMapVariables()
	LoadAutoPotsMenu()
end

function LoadAutoPotsMenu()
	iARAM:addSubMenu("Auto Pot Settings", "autoPots")
	iARAM.autoPots:addParam("useAutoPots", "Use Auto Pots", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("useHealthPots", "Use Health Pots", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("useManaPots", "Use Mana Pots", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("useFlask", "Use Flask", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("useBiscuit", "Use Biscuit", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("minHealthPercent", "Min Health Percent", SCRIPT_PARAM_SLICE, 30, 1, 99, 0)
	iARAM.autoPots:addParam("HealhLost", "Health Lost Percent", SCRIPT_PARAM_SLICE, 40, 1, 99, 0)
	iARAM.autoPots:addParam("minManaPercent", "Min Mana Percent", SCRIPT_PARAM_SLICE, 30, 1, 99, 0)
	iARAM.autoPots:addParam("minHealthFlaskPercent", "Min Flask Health Percent", SCRIPT_PARAM_SLICE, 40, 1, 99, 0)
	iARAM.autoPots:addParam("minManaFlaskPercent", "Min Flask Mana Percent", SCRIPT_PARAM_SLICE, 40, 1, 99, 0)
end


--[[ AutoLevel Function ]]--
AddLoadCallback(function()

if not VIP_USER then return end
	local champ = player.charName
    if champ == "Aatrox" then           AutoLevel({ 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Ahri" then         AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 2, 2, })
    elseif champ == "Akali" then        AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Alistar" then      AutoLevel({ 1, 3, 2, 1, 3, 4, 1, 3, 1, 3, 4, 1, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Amumu" then        AutoLevel({ 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, })
    elseif champ == "Anivia" then       AutoLevel({ 1, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 1, 1, 1, 2, 4, 2, 2, })
    elseif champ == "Annie" then        AutoLevel({ 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Ashe" then         AutoLevel({ 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
	elseif champ == "Azir" then         AutoLevel({ 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "Blitzcrank" then   AutoLevel({ 1, 3, 2, 3, 2, 4, 3, 2, 3, 2, 4, 3, 2, 1, 1, 4, 1, 1, })
    elseif champ == "Brand" then        AutoLevel({ 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Bard" then         AutoLevel({ 2, 1, 3, 2, 2, 4, 1, 2, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
	elseif champ == "Braum" then        AutoLevel({ 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Caitlyn" then      AutoLevel({ 2, 1, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Cassiopeia" then   AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Chogath" then      AutoLevel({ 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Corki" then        AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, })
    elseif champ == "Darius" then       AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, })
    elseif champ == "Diana" then        AutoLevel({ 2, 1, 2, 3, 1, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "DrMundo" then      AutoLevel({ 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Draven" then       AutoLevel({ 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
	elseif champ == "Ekko" then      	AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Elise" then        AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }) rOff = -1
    elseif champ == "Evelynn" then      AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Ezreal" then       AutoLevel({ 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "FiddleSticks" then AutoLevel({ 3, 2, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "Fiora" then        AutoLevel({ 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Fizz" then         AutoLevel({ 3, 1, 2, 1, 2, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Galio" then        AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 3, 2, 2, 4, 3, 3, })
    elseif champ == "Gangplank" then    AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Garen" then        AutoLevel({ 1, 2, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, })
    elseif champ == "Gragas" then       AutoLevel({ 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, })
    elseif champ == "Graves" then       AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, })
	elseif champ == "Gnar" then         AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 3, 2, 2, 4, 3, 3, })
    elseif champ == "Hecarim" then      AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Heimerdinger" then AutoLevel({ 1, 2, 2, 1, 1, 4, 3, 2, 2, 2, 4, 1, 1, 3, 3, 4, 1, 1, })
    elseif champ == "Irelia" then       AutoLevel({ 3, 1, 2, 2, 2, 4, 2, 3, 2, 3, 4, 1, 1, 3, 1, 4, 3, 1, })
    elseif champ == "Janna" then        AutoLevel({ 3, 1, 3, 2, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1, 1, 1, 4, 4, })
    elseif champ == "JarvanIV" then     AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 2, 1, 4, 3, 3, 3, 2, 4, 2, 2, })
    elseif champ == "Jax" then          AutoLevel({ 3, 2, 1, 2, 2, 4, 2, 3, 2, 3, 4, 1, 3, 1, 1, 4, 3, 1, })
    elseif champ == "Jayce" then        AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }) rOff = -1
	elseif champ == "Jinx" then         AutoLevel({ 3, 1, 3, 2, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1, 1, 1, 4, 4, })
	elseif champ == "Kalista" then      AutoLevel({ 1, 3, 2, 1, 1, 4, 1, 1, 3, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Karma" then        AutoLevel({ 1, 3, 1, 2, 3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 2, 2, 2, 2, })
    elseif champ == "Karthus" then      AutoLevel({ 1, 3, 2, 1, 1, 4, 1, 1, 3, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Kassadin" then     AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Katarina" then     AutoLevel({ 1, 3, 2, 2, 2, 4, 2, 3, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, })
    elseif champ == "Kayle" then        AutoLevel({ 3, 2, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, })
    elseif champ == "Kennen" then       AutoLevel({ 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "Khazix" then       AutoLevel({ 1, 3, 1, 2 ,1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "KogMaw" then       AutoLevel({ 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "Leblanc" then      AutoLevel({ 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, })
    elseif champ == "LeeSin" then       AutoLevel({ 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Leona" then        AutoLevel({ 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Lissandra" then    AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Lucian" then       AutoLevel({ 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Lulu" then         AutoLevel({ 3, 2, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, })
    elseif champ == "Lux" then          AutoLevel({ 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, })
    elseif champ == "Malphite" then     AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, })
    elseif champ == "Malzahar" then     AutoLevel({ 1, 3, 3, 2, 3, 4, 1, 3, 1, 3, 4, 2, 1, 2, 1, 4, 2, 2, })
    elseif champ == "Maokai" then       AutoLevel({ 3, 1, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, })
    elseif champ == "MasterYi" then     AutoLevel({ 3, 1, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 2, 2, 4, 2, 2, })
    elseif champ == "MissFortune" then  AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "MonkeyKing" then   AutoLevel({ 3, 1, 2, 1, 1, 4, 3, 1, 3, 1, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Mordekaiser" then  AutoLevel({ 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, })
    elseif champ == "Morgana" then      AutoLevel({ 1, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "Nami" then         AutoLevel({ 1, 2, 3, 2, 2, 4, 2, 2, 3, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Nasus" then        AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, })
    elseif champ == "Nautilus" then     AutoLevel({ 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Nidalee" then      AutoLevel({ 2, 3, 1, 3, 1, 4, 3, 2, 3, 1, 4, 3, 1, 1, 2, 4, 2, 2, })
    elseif champ == "Nocturne" then     AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Nunu" then         AutoLevel({ 3, 1, 3, 2, 1, 4, 3, 1, 3, 1, 4, 1, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Olaf" then         AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Orianna" then      AutoLevel({ 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Pantheon" then     AutoLevel({ 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, })
    elseif champ == "Poppy" then        AutoLevel({ 3, 2, 1, 1, 1, 4, 1, 2, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, })
    elseif champ == "Quinn" then        AutoLevel({ 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Rammus" then       AutoLevel({ 1, 2, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, })
	elseif champ == "RekSai" then       AutoLevel({ 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Renekton" then     AutoLevel({ 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Rengar" then       AutoLevel({ 1, 3, 2, 1, 1, 4, 2, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Riven" then        AutoLevel({ 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Rumble" then       AutoLevel({ 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Ryze" then         AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Sejuani" then      AutoLevel({ 2, 1, 3, 3, 2, 4, 3, 2, 3, 3, 4, 2, 1, 2, 1, 4, 1, 1, })
    elseif champ == "Shaco" then        AutoLevel({ 2, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, })
    elseif champ == "Shen" then         AutoLevel({ 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Shyvana" then      AutoLevel({ 2, 1, 2, 3, 2, 4, 2, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, })
    elseif champ == "Singed" then       AutoLevel({ 1, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 2, 3, 2, 4, 2, 3, })
    elseif champ == "Sion" then         AutoLevel({ 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, })
    elseif champ == "Sivir" then        AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, })
    elseif champ == "Skarner" then      AutoLevel({ 1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 3, 3, 4, 3, 3, })
    elseif champ == "Sona" then         AutoLevel({ 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Soraka" then       AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, })
    elseif champ == "Swain" then        AutoLevel({ 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, })
    elseif champ == "Syndra" then       AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
	elseif champ == "TahmKench" then   	AutoLevel({ 2, 3, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "Talon" then        AutoLevel({ 2, 3, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "Taric" then        AutoLevel({ 3, 2, 1, 2, 2, 4, 1, 2, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, })
    elseif champ == "Teemo" then        AutoLevel({ 1, 3, 2, 3, 1, 4, 3, 3, 3, 1, 4, 2, 2, 1, 2, 4, 2, 1, })
    elseif champ == "Thresh" then       AutoLevel({ 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, })
    elseif champ == "Tristana" then     AutoLevel({ 3, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, })
    elseif champ == "Trundle" then      AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, })
    elseif champ == "Tryndamere" then   AutoLevel({ 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "TwistedFate" then  AutoLevel({ 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Twitch" then       AutoLevel({ 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 1, 2, 2, })
    elseif champ == "Udyr" then         AutoLevel({ 4, 2, 3, 4, 4, 2, 4, 2, 4, 2, 2, 1, 3, 3, 3, 3, 1, 1, })
    elseif champ == "Urgot" then        AutoLevel({ 3, 1, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, })
    elseif champ == "Varus" then        AutoLevel({ 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Vayne" then        AutoLevel({ 1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Veigar" then       AutoLevel({ 1, 3, 1, 2, 1, 4, 2, 2, 2, 2, 4, 3, 1, 1, 3, 4, 3, 3, })
	elseif champ == "Velkoz" then       AutoLevel({ 1, 3, 1, 2, 1, 4, 2, 2, 2, 2, 4, 3, 1, 1, 3, 4, 3, 3, })
    elseif champ == "Vi" then           AutoLevel({ 3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, })
    elseif champ == "Viktor" then       AutoLevel({ 3, 2, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, })
    elseif champ == "Vladimir" then     AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Volibear" then     AutoLevel({ 2, 3, 2, 1, 2, 4, 3, 2, 1, 2, 4, 3, 1, 3, 1, 4, 3, 1, })
    elseif champ == "Warwick" then      AutoLevel({ 2, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, })
    elseif champ == "Xerath" then       AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "XinZhao" then      AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Yorick" then       AutoLevel({ 2, 3, 1, 3, 3, 4, 3, 2, 3, 1, 4, 2, 1, 2, 1, 4, 2, 1, })
	elseif champ == "Yasuo" then        AutoLevel({ 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Zac" then          AutoLevel({ 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Zed" then          AutoLevel({ 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Ziggs" then        AutoLevel({ 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    elseif champ == "Zilean" then       AutoLevel({ 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, })
    elseif champ == "Zyra" then         AutoLevel({ 3, 2, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, })
    else _AutoupdaterMsg(string.format(" >> AutoLevelSpell  disabled for %s", champ))
    end
   -- if AutoLevel and #AutoLevel == 18 then
	--	 if iARAM.misc.misc2 then _AutoupdaterMsg("AutoLevelSpell loaded!") end
   -- else
   --     if iARAM.misc.misc2 then _AutoupdaterMsg(" >> AutoLevel Error") end
   --     OnTick = function() end
   --     return
   -- end
end)

class 'AutoLevel'
function AutoLevel:__init(table)
	if VIP_USER then
		self.clock = os.clock()
		self.LastLeveled = GetHeroLeveled()
		self.LevelSequence = table
		self.SpellSlots = {SPELL_1, SPELL_2, SPELL_3, SPELL_4}
		AddTickCallback(function()
			if os.clock() < (self.clock or 0) then return end
			self.clock = os.clock() + math.random(0.5,2)
			if #self.LevelSequence == 4 then
				if myHero.level > self.LastLeveled then
					self:LevelSpell(self.LevelSequence[1])
					self:LevelSpell(self.LevelSequence[2])
					self:LevelSpell(self.LevelSequence[3])
					self:LevelSpell(self.LevelSequence[4])
				end
				self.LastLeveled = GetHeroLeveled()
			elseif #self.LevelSequence == 18 then
				self.LastLeveled = GetHeroLeveled()
				if myHero.level > self.LastLeveled and self.LevelSequence[self.LastLeveled + 1] ~= nil then
					self.SpellToLevel = self.LevelSequence[self.LastLeveled + 1]
					if self.SpellToLevel >= 1 and self.SpellToLevel <= 4 then
						self:LevelSpell(self.SpellSlots[self.SpellToLevel])
					end
				end
			end
		end)
	else
	_AutoupdaterMsg("You are not VIP user: AutoLevel disabled")
	end
end

function AutoLevel:LevelSpell(id)
	local offsets = {
		[_Q] = 0xAA,
		[_W] = 0xAB,
		[_E] = 0xAC,
		[_R] = 0xAD,
	}
	local p = CLoLPacket(0x009C)
	p.vTable = 0xE61868
	p:EncodeF(myHero.networkID)
	for i = 1, 4 do	p:Encode1(0xB4)	end
	for i = 1, 4 do	p:Encode1(0x69)	end
	for i = 1, 4 do p:Encode1(0x09)	end
	p:Encode1(offsets[id])
	p:Encode1(0xE4)
	p:Encode1(0x00)
	for i = 1, 4 do	p:Encode1(0x00) end
	SendPacket(p)
end


--[[ PrintFloatText Function ]]--
function FloatTextStance()
	if not myHero.dead and iARAM.follow then
		if stance == 1 then
			_MyHeroText("TF mode")
		end
		if stance == 2 then
			_MyHeroText("Stance No Found")
		end
		if stance == 3 then
			_MyHeroText("Enemy target")
		end
		if stance == 0 then
			_MyHeroText("Alone Mode")
		end
	end	
end

function _MyHeroText(FloatTxt) 
	local barPos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
	DrawText(FloatTxt, 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))
end


--[[ Drawing Names Function ]]--
function DrawFakeNames()
	-- Your own hero has different height for name
	if myHero.visible == true and myHero.dead == false then
		framePos = GetAbilityFramePos(myHero)
    	DrawOverheadHUD(myHero, framePos, ""..SummonerName.."")
	end
end

function DrawOverheadHUD(unit, framePos, str, isAlly)
    local barPos = Point(framePos.x, framePos.y)
    textWidth = (GetTextArea(str, 18).x / 2)
    offset = 105
    barPos = Point(framePos.x + 66, framePos.y - 43)

    -- Enemy heros, your ally heros and your own hero have different bar heights
    if unit == myHero then
    	DrawText(str, 18, barPos.x-textWidth+1, barPos.y+1, 0xFF000000)
    	DrawText(str, 18, barPos.x-textWidth, barPos.y, 0xFFFFFFFF)
    elseif isAlly and unit ~= myHero then
		DrawText(str, 18, barPos.x-textWidth+1, barPos.y+4, 0xFF000000)
    	DrawText(str, 18, barPos.x-textWidth, barPos.y+3, 0xFFFFFFFF)
    else
    	DrawText(str, 18, barPos.x-textWidth+1, barPos.y+7, 0xFF000000)
   		DrawText(str, 18, barPos.x-textWidth, barPos.y+6, 0xFFFFFFFF)
   	end
   	UpdateWindow()
end

-- Credits to Jorj for the bar position
function GetAbilityFramePos(unit)
  local barPos = GetUnitHPBarPos(unit)
  local barOffset = GetUnitHPBarOffset(unit)

  do -- For some reason the x offset never exists
    local t = {
      ["Darius"] = -0.05,
      ["Renekton"] = -0.05,
      ["Sion"] = -0.05,
      ["Thresh"] = 0.03,
    }
   -- barOffset.x = t[unit.charName] or 0
  end
  return Point(barPos.x - 69 + barOffset.x * 150, barPos.y + barOffset.y * 50 + 12.5)
end


--[[ Improving Function ]]--
function TowerFocusPlayer()
	print("Tower focus: Player")
		if myHero.team == TEAM_BLUE then
			myHero:MoveTo(myHero.x*-3,myHero.z*-3)
		else
			myHero:MoveTo(myHero.x*3,myHero.z*3)
		end
end


--[[ Alone Mode Function ]]--
local lastPrint1 = ""
function howling1(str)
   if str ~= lastPrint1 then
    _AutoupdaterMsg("Following Minion in Howling Abyss Map")
      lastPrint1 = str
   end
end

local lastPrintSRM = ""
function PrintSumonerRift(SRM)
   if SRM ~= lastPrintSRM then
    _AutoupdaterMsg("Following Minion in Summoners Rift Map")
      lastPrintSRM = SRM
   end
end

function FollowMinionAlly()
	if stance == 0 and iARAM.follow then
		if summonersRiftMap == true then
			if iARAM.misc.misc2 then PrintSumonerRift() end
			CountTimer = 15
			if os.clock() < CountTimer then return end
			CountTimer = os.clock() + math.random(0.5,2)
			if GetInGameTimer() < 15 then
				DelayAction(function()
				--print("lol")
				if myHero.team == TEAM_BLUE then
					myHero:MoveTo(myHero.x*5,myHero.z*5)
				else
					myHero:MoveTo(myHero.x*5,myHero.z*5)
				end
				end, 15-GetInGameTimer())
			end
			
			allyMinions = minionManager(MINION_ALLY, 3000, player, MINION_SORT_HEALTH_DEC)
			allyMinions:update()
			local player = GetMyHero()
			local tick = 0
			local delay = 400
			local myTarget = ts.target
			if heroCanMove() then
				for index, allyminion in pairs(allyMinions.objects) do
					if GetDistance(allyminion, myHero) <= 1600 and GetTickCount() > tick + delay then
						distance1 = math.random(130,250)
						distance2 = math.random(130,250)
						neg1 = -1 
						neg2 = -1 	
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(allyminion.x+distance1*neg1,allyminion.z+distance2*neg2)
							tick = GetTickCount()
						else
							myHero:MoveTo(allyminion.x-distance1*neg1,allyminion.z-distance2*neg2)
							tick = GetTickCount()
						end
					end
				end
			end
		end
		if howlingAbyssMap == true then
			allyMinions = minionManager(MINION_ALLY, 3000, player, MINION_SORT_HEALTH_DEC)
			allyMinions:update()
			local player = GetMyHero()
			local tick = 0
			local delay = 400
			local myTarget = ts.target
			if heroCanMove() then
				for index, allyminion in pairs(allyMinions.objects) do
					if GetDistance(allyminion, myHero) <= 3000 and GetTickCount() > tick + delay then
					if iARAM.misc.misc2 then howling1(str) end
						distance1 = math.random(130,250)
						distance2 = math.random(130,250)
						neg1 = -1 
						neg2 = -1 	
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(allyminion.x+distance1*neg1,allyminion.z+distance2*neg2)
							tick = GetTickCount()
						else
							myHero:MoveTo(allyminion.x-distance1*neg1,allyminion.z-distance2*neg2)
							tick = GetTickCount()
						end
					end
				end
			end
		end
	end
end

function HealthAlly()
	if stance == 1 or stance == 3 and iARAM.follow then
	local champ = player.charName
	local ally = GetPlayer(myHero.team, false, false, myHero, 450, "health")
		if ally ~= nil and (ally.health/ally.maxHealth) < 99999 then
			
			if champ == "Soraka" then
				if iARAM.misc.misc2 then _AutoupdaterMsg("Healing Ally") end
				CastSpell(_W, ally)
			elseif champ == "Taric" then  
				if iARAM.misc.misc2 then _AutoupdaterMsg("Healing Ally") end
				CastSpell(_Q, ally)
			elseif champ == "Nami" then 
				if iARAM.misc.misc2 then _AutoupdaterMsg("Healing Ally") end			
				CastSpell(_W, ally)
			elseif champ == "Sona" then  
				if iARAM.misc.misc2 then _AutoupdaterMsg("Healing Ally") end
				CastSpell(_W, ally)
			end
		end
	end
end

function GetPlayer(team, includeDead, includeSelf, distanceTo, distanceAmount, resource)
	local target = nil
	for i=1, heroManager.iCount do
		local member = heroManager:GetHero(i)
		if member ~= nil and member.type == "AIHeroClient" and member.team == team and (member.dead ~= true or includeDead) then
			if member.charName ~= myHero.charName or includeSelf then
				if distanceAmount == GLOBAL_RANGE or member:GetDistance(distanceTo) <= distanceAmount then
					if target == nil then target = member end
					if resource == "health" then --least health
						if member.health < target.health then target = member end
					elseif resource == "mana" then --least mana
						if member.mana < target.mana then target = member end
					elseif resource == "AD" then --highest AD
						if member.totalDamage > target.totalDamage then target = member end
					elseif resource == NO_RESOURCE then
						return member -- as any member is eligible
					end
				end
			end
		end
	end
	return target
end


--[[ PrinterDelay Function ]]--
local lastPrint2 = ""
function CastW(str)
   if str ~= lastPrint2 then
    _AutoupdaterMsg("CastSpell W")
      lastPrint2 = str
   end
end
