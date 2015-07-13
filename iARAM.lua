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
]]--

--[[

		──|> Error with stance: "low health"
		──|> Error with delay action in Alone Mode Function.
		──|> Auto heal doesn´t work.
		──|> Auto Buy menu doesn´t work again.
		──|> Auto Chat doesn´t work.
		──|> Auto Poro Shouter doesn´t work.
]]--

--[[ SETTINGS ]]--
local HotKey = 115 --F4 = 115, F6 = 117 default
local AutomaticChat = true --If is in true mode, then it will say "gl and hf" when the game starts.
local AUTOUPDATE = true --change to false to disable auto update


--[[ GLOBALS [Do Not Change] ]]--


-----[[ Attack and farm Globals ]]------
local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
local range = myHero.range
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, range, DAMAGE_PHYSICAL, false)


-----[[ Chat Global ]]------
local switcher = true


-----[[ Poro Shouter Global ]]------
local lastCast = 0
--require 'VPrediction'

-----[[ Buyer Globals ]]------
local shoplist = {}
local buyDelay = 100 --default 100
local nextbuyIndex = 1
local lastBuy = 0
local lastBoughtItem = nil
local UP_TO_DATE = true


-----[[ Autopotions Globals ]]------
local _b = false
local ab = true
local db = {br0l4nds = true, corearmies = true}


-----[[ Auto ward Globals ]]------
local drawWardSpots      = false
local wardSlot           = nil


-----[[ Ignite and Zhonya Globals ]]------
local SlotIgnite
local SlotZhonya
nTarget = TargetSelector(TARGET_NEAR_MOUSE, 700, DAMAGE_MAGIC, true)


-----[[ Auto Update Globals ]]------
local version = 3.9
local UPDATE_CHANGE_LOG = "AutoBuy Fixed"
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
	adtanks = {"Braum","DrMundo","Garen","Gnar","Hecarim","Jarvan IV","Nasus","Skarner","Thresh","Volibear","Yorick"}
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
	--	_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Items Loaded</font>")
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
	
	itemCosts = {
                                        [3096]=865,--Nomad's Medallion
                                        [3801]=600,--Crystalline Bracer
                                        [1011]=1000,--Giant's Belt
                                        [3083]=300,--*Warmog's Armor
                                        [3190]=2800,--Locket of the Iron Solari
                                        [3075]=2100,--Thornmail
                                        [3068]=2600,--Sunfire Cape
                                        [3072]=1950,--*Bloodthirster
										[1053]=800,--Vampiric Scepter
                                        [3069]=1235,--*Talisman of Ascension
                                        [1038]=1550,--B.F. Sword
                                        [3031]=2250,--*Infinity Edge
                                        [3139]=2150,--*Mercurial Scimitar
                                        [3508]=1650,--*Essence Reaver
                                        [3155]=1450,--Hexdrinker
                                        [3156]=1750,--*Maw of Malmortius
                                        [3082]=1050,--Warden's Mail
                                        [3110]=1400,--*Frozen Heart
                                        [3211]=1200,--Spectre's Cowl
                                        [3065]=1550,--*Spirit Visage
                                        [3102]=1550,--*Banshee's Veil
                                        [1058]=1600,--Needlessly Large Rod
                                        [3089]=1600,--*Rabadon's Deathcap
										[1026]=860,--Blasting Wand
                                        [3157]=1700,--*Zhonya's Hourglass
                                        [3285]=1500,--*Luden's Echo
                                        [3001]=2440,--Abyssal Scepter
                                        [3101]=1250,--Stinger
                                        [3115]=1670,--*Nashor's Tooth
                                        [3136]=1485,--Haunting Guise
                                        [3151]=1415,--Liandry's Torment
                                        [3100]=3000,--Lich Bane
                                        [3044]=1325,--Phage
                                        [3071]=1675,--*The Black Cleaver       
                                        [3108]=820,--Fiendish Codex
										[3165]=2300,--*Morellonomicon
										[1001]=325,--Boots of Speed
										[3006]=1000,--*Berserker's Greaves
										[3047]=1000,--*Ninja Tabi
										[2003]=35,--Health Potion
										[3340]=0--Warding Totem
                                }

	--[[ ItemsList ]]--
	
	if heroType == 1 then --ADC
		shopList = {1001,2003,1038,1053,3072,3006,3031,3139,3508}
	end
	if heroType == 2 then --ADTANK
		shopList = {2003,1001,3047,3083,3155,3156,3068,3211,3102,3075}
	end
	if heroType == 3 then --APTANK
		shopList = {1001,2003,3083,1058,3089,1058,3157,1058,3285,3001}
	end
	if heroType == 4 then --HYBRID
		shopList = {2003,1001,3101,3115,3136,3151,1058,3089,3100}
	end
	if heroType == 5 then --BRUISER
		shopList = {1001,2003,3211,3102,3075,1038,3072,3044,3071}
	end
	if heroType == 6 then --ASSASSIN
		shopList = {2003,1001,3211,3065,3190,3075,3068}
	end
	if heroType == 7 then --MAGE
		shopList = {1001,2003,3108,3165,1058,1026,3089,1058,3157,1058,3285}
	end
	if heroType == 8 then  --APC
		shopList = {1001,2003,3165,1058,3089,1058,3157,1058,3285}
	end
	if heroType == 9 or heroType == 10 then --FIGHTER and OTHERS
		shopList = {1001,2003,3211,3065,3190,3075,3068}
	end
	startTime = GetTickCount()
	--item ids can be found at many websites, ie: http://www.lolking.net/items/
	
end


--[[ Checks Function ]]--
function Checks()
	
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

		--|>Autopotions
		LoadTables()
		LoadVariables()
		OnRemoveBuff()
		OnApplyBuff()
		
		--|>Auto Ignite
		AutoIgniteandZhonya()	

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
	Checks()
	LoadAutoIgniteZhonya()
	AutotatackChamp()
	AutoFarm()
	--|> Poro Shouter
	PoroCheck()

	--|> AutoPotions
	if not myHero.dead then
		Consumables()	
	end

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
		if Allies() >=  2 then
			stance = 1		
		else
			stance = 0
		end
		
		if findLowHp() ~= 0 then
			Target = findLowHp()
		else
			Target = findClosestEnemy()
		end
			
		if Target ~= nil then
			stance = 3
		else
			stance = 0
		end
		--[[]]
		--|> Alone Mode
		if stance == 0 then
			if howlingAbyssMap == true then
			--[[
				randomposx = math.random(4700,5100)
				randomposz = math.random(5600,5900)
				distance3 = math.random(250,300)
				distance4 = math.random(250,300)
				neg3 = 1 
				neg4 = 1 
				if myHero.team == TEAM_BLUE then
					myHero:MoveTo(randomposx*neg3,randomposz-distance4*neg4)
				else
					myHero:MoveTo(randomposx*neg3,-randomposz+distance4*neg4)
				end
				
				--myHero:MoveTo(49000,-17000)
			]]
			elseif summonersRiftMap == true then
			--[[
				timerito = 1			
				DelayAction(function() 
					timerito = 2
					randomposx = math.random(4700,5150)
					randomposz = math.random(5600,5900)
					distance3 = math.random(250,300)
					distance4 = math.random(250,300)
					neg3 = 1 
					neg4 = 1 
					if myHero.team == TEAM_BLUE then
						myHero:MoveTo(randomposx*neg3,randomposz-distance4*neg4)
					else
						myHero:MoveTo(randomposx*neg3,-randomposz+distance4*neg4)
					end
				end, timerito)
				]]
			end
			
		end
		
		Allie = followHero()
		--|>Attacks Champs
		if Target ~= nil then
		stance = 3
		  myHero:Attack(Target)
			if stance == 1 or stance == 3 then
				attacksuccess = 0
				if myHero:CanUseSpell(_W) == READY then
					CastSpell(_W, Target)
					attacksuccess =1
										
				end
				if myHero:CanUseSpell(_Q) == READY then
					CastSpell(_Q, Target)
					attacksuccess =1 
				end
				if myHero:CanUseSpell(_E) == READY  then
					CastSpell(_E, Target)
					attacksuccess = 1
				end
				if myHero:CanUseSpell(_R) == READY then
					CastSpell(_R, Target)
					attacksuccess =1
				end
				
				if attacksuccess == 0 then
					--|>Attack Minions
				end
			elseif stance == 0 then
			
				--|> Enemy Target
			elseif stance == 3 then
				myHero:MoveTo(spawnpos.x,spawnpos.z)
			end
			allytofollow = followHero()
			if allytofollow ~= nil and GetDistance(allytofollow,myHero) > 350  then
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
		--|> Dead
		AutoBuy()
	end
	AutoBuy()

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
local IDBytes = {
	[0x00] = 0x10, [0x01] = 0xC5, [0x02] = 0x0C, [0x03] = 0x9F, [0x04] = 0x9C, [0x05] = 0x75, [0x06] = 0xE5, [0x07] = 0x09, [0x08] = 0xC2, [0x09] = 0x43, [0x0A] = 0x97, [0x0B] = 0xB2, 
	[0x0C] = 0xA9, [0x0D] = 0x9A, [0x0E] = 0x0F, [0x0F] = 0x57, [0x10] = 0x54, [0x11] = 0x51, [0x12] = 0x01, [0x13] = 0x8A, [0x14] = 0x1B, [0x15] = 0xC8, [0x16] = 0xD3, [0x17] = 0x58, 
	[0x18] = 0x50, [0x19] = 0x23, [0x1A] = 0x4F, [0x1B] = 0xFF, [0x1C] = 0x95, [0x1D] = 0x84, [0x1E] = 0xA1, [0x1F] = 0x8C, [0x20] = 0x69, [0x21] = 0x30, [0x22] = 0xA8, [0x23] = 0xEF, 
	[0x24] = 0xBF, [0x25] = 0xFC, [0x26] = 0x59, [0x27] = 0x4E, [0x28] = 0x39, [0x29] = 0x5D, [0x2A] = 0x1F, [0x2B] = 0xE8, [0x2C] = 0xB7, [0x2D] = 0xAE, [0x2E] = 0xAC, [0x2F] = 0x9E, 
	[0x30] = 0xF8, [0x31] = 0xE0, [0x32] = 0x62, [0x33] = 0xA0, [0x34] = 0xC7, [0x35] = 0xD4, [0x36] = 0xBD, [0x37] = 0x0D, [0x38] = 0x5F, [0x39] = 0xE3, [0x3A] = 0x2E, [0x3B] = 0xD5, 
	[0x3C] = 0xCE, [0x3D] = 0x6D, [0x3E] = 0x81, [0x3F] = 0x63, [0x40] = 0xC0, [0x41] = 0xCF, [0x42] = 0x40, [0x43] = 0x1C, [0x44] = 0xB8, [0x45] = 0x3B, [0x46] = 0xD9, [0x47] = 0x94, 
	[0x48] = 0xBA, [0x49] = 0x88, [0x4A] = 0xC6, [0x4B] = 0x27, [0x4C] = 0x48, [0x4D] = 0x3E, [0x4E] = 0x1E, [0x4F] = 0xD0, [0x50] = 0x15, [0x51] = 0x7E, [0x52] = 0x08, [0x53] = 0x7C, 
	[0x54] = 0x70, [0x55] = 0x04, [0x56] = 0x41, [0x57] = 0xB1, [0x58] = 0xA6, [0x59] = 0xD1, [0x5A] = 0x4D, [0x5B] = 0xC3, [0x5C] = 0x05, [0x5D] = 0x90, [0x5E] = 0xC4, [0x5F] = 0x98, 
	[0x60] = 0xFE, [0x61] = 0x35, [0x62] = 0xED, [0x63] = 0xA5, [0x64] = 0xC9, [0x65] = 0x85, [0x66] = 0xF9, [0x67] = 0x74, [0x68] = 0x96, [0x69] = 0x8D, [0x6A] = 0xBC, [0x6B] = 0xFA, 
	[0x6C] = 0x31, [0x6D] = 0x11, [0x6E] = 0x5B, [0x6F] = 0xAD, [0x70] = 0x4C, [0x71] = 0xA2, [0x72] = 0xB3, [0x73] = 0xEE, [0x74] = 0xE6, [0x75] = 0xD8, [0x76] = 0x02, [0x77] = 0x3C, 
	[0x78] = 0x8B, [0x79] = 0xE2, [0x7A] = 0x7A, [0x7B] = 0xDD, [0x7C] = 0x4A, [0x7D] = 0x00, [0x7E] = 0x6A, [0x7F] = 0xE9, [0x80] = 0x7B, [0x81] = 0xF6, [0x82] = 0x89, [0x83] = 0x2C, 
	[0x84] = 0xEB, [0x85] = 0xCA, [0x86] = 0x6C, [0x87] = 0x2A, [0x88] = 0xDB, [0x89] = 0xE7, [0x8A] = 0xAF, [0x8B] = 0x4B, [0x8C] = 0x0E, [0x8D] = 0x16, [0x8E] = 0x2F, [0x8F] = 0x76, 
	[0x90] = 0x91, [0x91] = 0xF1, [0x92] = 0x92, [0x93] = 0x66, [0x94] = 0x44, [0x95] = 0xAA, [0x96] = 0x72, [0x97] = 0xF7, [0x98] = 0xF4, [0x99] = 0x93, [0x9A] = 0x2D, [0x9B] = 0x80, 
	[0x9C] = 0x03, [0x9D] = 0x65, [0x9E] = 0x42, [0x9F] = 0xF2, [0xA0] = 0x18, [0xA1] = 0xCC, [0xA2] = 0x8E, [0xA3] = 0x99, [0xA4] = 0x14, [0xA5] = 0x7D, [0xA6] = 0xC1, [0xA7] = 0xD2, 
	[0xA8] = 0x5E, [0xA9] = 0x33, [0xAA] = 0x64, [0xAB] = 0x3F, [0xAC] = 0x38, [0xAD] = 0x0A, [0xAE] = 0xD6, [0xAF] = 0xD7, [0xB0] = 0x6E, [0xB1] = 0xF3, [0xB2] = 0x1A, [0xB3] = 0xE4, 
	[0xB4] = 0x68, [0xB5] = 0x13, [0xB6] = 0x46, [0xB7] = 0xB0, [0xB8] = 0x73, [0xB9] = 0x12, [0xBA] = 0x06, [0xBB] = 0x5C, [0xBC] = 0x37, [0xBD] = 0x86, [0xBE] = 0x61, [0xBF] = 0x78, 
	[0xC0] = 0xB9, [0xC1] = 0xF0, [0xC2] = 0x21, [0xC3] = 0xBE, [0xC4] = 0x24, [0xC5] = 0xEA, [0xC6] = 0x32, [0xC7] = 0xDE, [0xC8] = 0xDA, [0xC9] = 0x8F, [0xCA] = 0x47, [0xCB] = 0x1D, 
	[0xCC] = 0xDF, [0xCD] = 0xBB, [0xCE] = 0x3D, [0xCF] = 0xE1, [0xD0] = 0x6F, [0xD1] = 0xA3, [0xD2] = 0x55, [0xD3] = 0xAB, [0xD4] = 0x83, [0xD5] = 0x17, [0xD6] = 0x7F, [0xD7] = 0x2B, 
	[0xD8] = 0x34, [0xD9] = 0x52, [0xDA] = 0x87, [0xDB] = 0xB6, [0xDC] = 0x45, [0xDD] = 0xFD, [0xDE] = 0x28, [0xDF] = 0xB4, [0xE0] = 0x26, [0xE1] = 0xCB, [0xE2] = 0xA4, [0xE3] = 0xA7, 
	[0xE4] = 0xF5, [0xE5] = 0xCD, [0xE6] = 0x77, [0xE7] = 0xDC, [0xE8] = 0x22, [0xE9] = 0x6B, [0xEA] = 0xEC, [0xEB] = 0x49, [0xEC] = 0x29, [0xED] = 0x9D, [0xEE] = 0x79, [0xEF] = 0x67, 
	[0xF0] = 0x3A, [0xF1] = 0x82, [0xF2] = 0x5A, [0xF3] = 0x9B, [0xF4] = 0xB5, [0xF5] = 0x0B, [0xF6] = 0x56, [0xF7] = 0x71, [0xF8] = 0x19, [0xF9] = 0x25, [0xFA] = 0x07, [0xFB] = 0xFB, 
	[0xFC] = 0x20, [0xFD] = 0x60, [0xFE] = 0x36, [0xFF] = 0x53,
}

function OnRecvPacket(p)
	if VIP_USER and UP_TO_DATE then
		if p.header == 0x005C then
			p.pos=2
			if p:DecodeF() == myHero.networkID then
				p.pos=12
				local bytes = {}
				for i=4, 1, -1 do
					bytes[i] = IDBytes[p:Decode1()]
				end
				lastBoughtItem = bit32.bxor(bit32.lshift(bit32.band(bytes[1],0xFF),24),bit32.lshift(bit32.band(bytes[2],0xFF),16),bit32.lshift(bit32.band(bytes[3],0xFF),8),bit32.band(bytes[4],0xFF))
			end
		end
	end
end

function BuyItem1(id)
	local rB = {}
	for i=0, 255 do rB[IDBytes[i]] = i end
	local p = CLoLPacket(0x0008)
	p.vTable = 0xEAC648
	p:EncodeF(myHero.networkID)
	local b1 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFF),24),0xFF)],0xFF),24)
	local b2 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFFFF),16),0xFF)],0xFF),16)
	local b3 = bit32.lshift(bit32.band(rB[bit32.band(bit32.rshift(bit32.band(id,0xFFFFFFFF),8),0xFF)],0xFF),8)
	local b4 = bit32.band(rB[bit32.band(id ,0xFF)],0xFF)
	p:Encode4(bit32.bxor(b1,b2,b3,b4))
	p:Encode4(0xE1240DFD)
	SendPacket(p)
end

function AutoBuy()
	if InFountain() or myHero.dead then
			-- Item purchases
		if GetTickCount() > lastBuy + buyDelay then
			if lastBoughtItem == shopList[nextbuyIndex] then
				--Last Buy successful
				nextbuyIndex = nextbuyIndex + 1
			else
				lastBuy = GetTickCount()
				if VIP_USER and UP_TO_DATE then BuyItem1(shopList[nextbuyIndex])
				else BuyItem(shopList[nextbuyIndex]) end
			end
		end
	end
end


--[[ Attack Distance ]]-- 
function getChampTable() 
    return {                                                   
        Ahri         = { projSpeed = 1.6, aaParticles = {"Ahri_BasicAttack_mis", "Ahri_BasicAttack_tar"}, aaSpellName = "ahribasicattack", startAttackSpeed = "0.668",  },
        Anivia       = { projSpeed = 1.05, aaParticles = {"cryo_BasicAttack_mis", "cryo_BasicAttack_tar"}, aaSpellName = "aniviabasicattack", startAttackSpeed = "0.625",  },
        Annie        = { projSpeed = 1.0, aaParticles = {"AnnieBasicAttack_tar", "AnnieBasicAttack_tar_frost", "AnnieBasicAttack2_mis", "AnnieBasicAttack3_mis"}, aaSpellName = "anniebasicattack", startAttackSpeed = "0.579",  },
        Ashe         = { projSpeed = 2.0, aaParticles = {"bowmaster_frostShot_mis", "bowmasterbasicattack_mis"}, aaSpellName = "ashebasicattack", startAttackSpeed = "0.658" },
		Azir         = { projSpeed = 1.6, aaParticles = {"Azir_BasicAttack_mis", "Azir_BasicAttack_tar"}, aaSpellName = "Azirbasicattack", startAttackSpeed = "0.668",  },
        Brand        = { projSpeed = 1.975, aaParticles = {"BrandBasicAttack_cas", "BrandBasicAttack_Frost_tar", "BrandBasicAttack_mis", "BrandBasicAttack_tar", "BrandCritAttack_mis", "BrandCritAttack_tar", "BrandCritAttack_tar"}, aaSpellName = "brandbasicattack", startAttackSpeed = "0.625" },
		Bard         = { projSpeed = 1.0, aaParticles = {"BardBasicAttack_tar", "BardBasicAttack_tar_frost", "BardBasicAttack2_mis", "BardBasicAttack3_mis"}, aaSpellName = "Bardbasicattack", startAttackSpeed = "0.579",  },        
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
        Kalista      = { projSpeed = 1.6, aaParticles = {"Kalista_BasicAttack_mis", "Kalista_BasicAttack_tar"}, aaSpellName = "Kalistabasicattack", startAttackSpeed = "0.668",  },
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
       iARAM = scriptConfig("iARAM: "..myHero.charName.." Bot", "iARAM BOT")

	   --[[ AutoWard Menu ]]--   
			iARAM:addSubMenu("Config Autoguard", "AutoWard")
			iARAM.AutoWard:addParam("AutoWardEnable", "Autoward Enabled", SCRIPT_PARAM_ONOFF, true)
			iARAM.AutoWard:addParam("AutoWardDraw", "Autoward Draw Circles", SCRIPT_PARAM_ONOFF, false)
			iARAM.AutoWard:addParam("debug", "Debug Mode", SCRIPT_PARAM_ONOFF, false)
		
		--[[ Drawing menu ]]--
		iARAM:addSubMenu("Drawing Settings", "drawing")
		iARAM.drawing:addParam("drawcircles", "Draw Circles", SCRIPT_PARAM_ONOFF, true)
		iARAM.drawing:addParam("LfcDraw", "Use Lagfree Circles (Requires Reload!)", SCRIPT_PARAM_ONOFF, true)
		
		--[[ PoroShoter menu ]]--
		
		ARAM = ARAMSlot()
		--vPred = VPrediction()
		TargetSelector = TargetSelector(TARGET_CLOSEST, 2500, DAMAGE_PHYSICAL)
		iARAM:addSubMenu("PoroShotter Settings", "PoroShot")
		iARAM.PoroShot:addParam("comboKey", "Auto Poro Shoot", SCRIPT_PARAM_ONOFF, true) 
		iARAM.PoroShot:addParam("range", "Poro Cast Range", SCRIPT_PARAM_SLICE, 1400, 800, 2500, 0) 
		iARAM.PoroShot:addTS(TargetSelector)
		
		
		--Zhonya
		iARAM:addParam("zhonya", "Use Zhonyas", SCRIPT_PARAM_ONOFF, true)
		iARAM:addParam("zhonyaHP", "Max HP when using Zhonya", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)

		--Attack
		iARAM:addParam("farm", "last hit farm", SCRIPT_PARAM_ONOFF, true)	
		iARAM:addParam("key", "Auto Attack champs", SCRIPT_PARAM_ONOFF, true)

		--Main Script
		iARAM:addParam("autobuy", "Auto Buy Items(Broken)", SCRIPT_PARAM_ONOFF, true)
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

	DrawText(""..myHero.charName.." Bot", MenuTextSize , (WINDOW_W - WINDOW_X) * SetupDrawX, (WINDOW_H - WINDOW_Y) * tempSetupDrawY , 0xffffff00) 
	tempSetupDrawY = tempSetupDrawY + 0.03
	
	--DrawText(" ".. GetUser() .." ", MenuTextSize , (WINDOW_W - WINDOW_X) * SetupDrawX, (WINDOW_H - WINDOW_Y) * tempSetupDrawY , 0xffffff00) 
	tempSetupDrawY = tempSetupDrawY + 0.07

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

	--{x=12731.25, y=50.32, z=9132.66}, -- RED BOT T2
	--{x=8036.52, y=45.19, z=12882.94}, -- RED TOP T2
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
	{ id = 2045, spellName = "RubySightstone",  		range = 1450, duration = 180000},
    { id = 2049, spellName = "Sightstone",  		range = 1450, duration = 180000},
    { id = 2050, spellName = "ItemMiniWard",   		range = 1450, duration = 60000},
    { id = 3154, spellName = "WriggleLantern", 		range = 1450, duration = 180000},
    { id = 3160, spellName = "FeralFlare",	   		range = 1450, duration = 180000},
	{ id = 3340, spellName = "WardingTotem(Trinket)",   range = 1450, duration = 180000},
    { id = 3350, spellName = "YellowTrinketUpgrade", range = 1450, duration = 180000}, 
	{ id = 3361, spellName = "TrinketTotemLvl3", 	range = 1450, duration = 180000},--added
	{ id = 3362, spellName = "TrinketTotemLvl3B", 	range = 1450, duration = 180000},--added

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
--[ Scripted By LeoFRM ]
function AutoIgniteandZhonya()   
                iARAM:addSubMenu("Other Settings", "Other")                      
                        iARAM.Other:addParam("AutoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
                        iARAM.Other:addParam("AutoZhonya", "Enable Auto Zhonya", SCRIPT_PARAM_ONOFF, true)
                        iARAM.Other:addParam("AutoZhonya", "Auto Zhonya If Heal", SCRIPT_PARAM_SLICE, 500, 0, 1500, 0)       
                --iARAM.Other:permaShow("AutoIgnite")
                if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
                        SlotIgnite = SUMMONER_1
                elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
                        SlotIgnite = SUMMONER_2
                end 
end
 
function LoadAutoIgniteZhonya()
        nTarget:update()                
        if iARAM.Other.AutoIgnite then FunctionAutoIgnite() end
        if iARAM.Other.AutoZhonya then FunctionAutoZhonya() end 
end
 
function FunctionAutoIgnite()
        if nTarget.target ~= nil and nTarget.target.type == myHero.type then
                if SlotIgnite ~= nil and myHero:CanUseSpell(SlotIgnite) == READY then        
                        if nTarget.target.health <= (50 + (20 * myHero.level)) and GetDistanceSqr(nTarget.target) <= 600*600 then
                                CastSpell(SlotIgnite, nTarget.target)
                             
                        end
                end
        end
end
 
function FunctionAutoZhonya()
        SlotZhonya = GetInventorySlotItem(3157)
        if SlotZhonya ~= nil and myHero:CanUseSpell(SlotZhonya) == READY then
                if myHero.health <= iARAM.Other.AutoZhonya then
                        CastSpell(SlotZhonya)
                 
                end
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
function AutotatackChamp()
	
	range = myHero.range + myHero.boundingRadius - 3
	ts.range = range
	ts:update()
	if iARAM.follow then
		if not iARAM.key then return end
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
	  
		
		  if iARAM.farm then
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

function LoadMapVariables()
	gameState = GetGame()
	if gameState.map.shortName then
		if gameState.map.shortName == "summonerRift" then
			summonersRiftMap = true
			--print("summonerRift")
		else
			summonersRiftMap = false
		end
		
		if gameState.map.shortName == "crystalScar" then
			crystalScarMap = true
			
		else
			crystalScarMap = false
		end
		
		if gameState.map.shortName == "howlingAbyss" then
			howlingAbyssMap = true
		else
			howlingAbyssMap = false
		end
		
		if gameState.map.shortName == "twistedTreeline" then
			twistedTreeLineMap = true
		else
			twistedTreeLineMap = false
		end
	else
		summonersRiftMap = true
	end
end


-----[[ AutoPotions ]]------
function LoadTables()
	Slots = 
	{
		6,
		7,
		8,
		9,
		10,
		11
	}
	
	Items = 
	{
		Pots = 
		{
			regenerationpotion = 
			{
				Name = "regenerationpotion",
				CastType = "Self"
			},

			flaskofcrystalwater = 
			{
				Name = "flaskofcrystalwater",
				CastType = "Self"
			},

			itemcrystalflask = 
			{
				Name = "itemcrystalflask",
				CastType = "Self"
			}
		},
	}
end

function PotReady(_c)
	for ac, bc in pairs(Slots) do
		if Items.Pots[myHero:GetSpellData(bc).name:lower()] and Items.Pots[myHero:GetSpellData(bc).name:lower()].Name == _c then
			if myHero:CanUseSpell(bc) == 0 then
				return true
			else
				return false
			end
		end
	end
end

function CastPots(_c)
	for ac, bc in pairs(Slots) do
		if Items.Pots[myHero:GetSpellData(bc).name:lower()] and Items.Pots[myHero:GetSpellData(bc).name:lower()].Name == _c and myHero:CanUseSpell(bc) == 0 then
			CastSpell(bc)
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

function Consumables()
	if not iARAM.autoPots.useAutoPots then
		return
	end
	
	if not recalling and not InFountain() and not usingMixedPot then
		local _c = myHero.health / myHero.maxHealth * 100
		local ac = myHero.mana / myHero.maxMana * 100
		if _c <= iARAM.autoPots.minHealthPercent and not usingHealthPot and PotReady("regenerationpotion") then
			if PotReady("regenerationpotion") then
				CastPots("regenerationpotion")
			end
		elseif _c <= iARAM.autoPots.minHealthFlaskPercent and iARAM.autoPots.useFlask and PotReady("itemcrystalflask") and not usingHealthPot then
			CastPots("itemcrystalflask")
		elseif ac <= iARAM.autoPots.minManaPercent and iARAM.autoPots.useManaPots and PotReady("flaskofcrystalwater") and not usingManaPot then
			CastPots("flaskofcrystalwater")
		elseif ac <= iARAM.autoPots.minManaFlaskPercent and iARAM.autoPots.useFlask and PotReady("itemcrystalflask") and not usingManaPot then
			CastPots("itemcrystalflask")
		end
	end
end

function OnApplyBuff(_c, ac, bc)
	if not ac then
		return
	end
	if ac and ac.isMe then
		if bc.name == "ItemCrystalFlask" or bc.name == "ItemMiniRegenPotion" then
			usingMixedPot = true
		elseif bc.name == "RegenerationPotion" then
			usingHealthPot = true
		elseif bc.name == "FlaskOfCrystalWater" then
			usingManaPot = true
		end
	end
end

function OnRemoveBuff(_c, ac)
	if not _c then
		return
	end
	if _c and _c.isMe and (ac.name == "ItemCrystalFlask" or ac.name == "ItemMiniRegenPotion") then
		usingMixedPot = false
	end
	
	if _c and _c.isMe and ac.name == "RegenerationPotion" then
		usingHealthPot = false
	end
	
	if _c and _c.isMe and ac.name == "FlaskOfCrystalWater" then
		usingManaPot = false
	end
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
		--_AutoupdaterMsg("<font color=\"#81BEF7\">AutoLevelSpell loaded!</font>")
   -- else
     --   _AutoupdaterMsg(" >> AutoLevel Error")
     --   OnTick = function() end
    --    return
   -- end
end)

class 'AutoLevel'
function AutoLevel:__init(table)

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

end

function AutoLevel:LevelSpell(id)

	local offsets = {
		[_Q] = {0x7D, 0x07},
		[_W] = {0x12, 0x06},
		[_E] = {0x76, 0x05},
		[_R] = {0x9C, 0x04},
	}
	local p = CLoLPacket(0x00A2)
	p.vTable = 0xF72190
	p:EncodeF(myHero.networkID)
	p:Encode1(offsets[id][1])
	p:Encode4(0xA4A4A4A4)
	p:Encode4(0x4C4C4C4C)
	p:Encode1(0xE2)
	p:Encode4(0x48484848)
	p:Encode1(offsets[id][2])
	p:Encode4(0x00000000)
	SendPacket(p)

end


--[[ PrintFloatText Function ]]--
function FloatTextStance()
	if not myHero.dead then
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



function TowerFocusPlayer()
	print("Tower focus: Player")
		if myHero.team == TEAM_BLUE then
			myHero:MoveTo(myHero.x*-3,myHero.z*-3)
		else
			myHero:MoveTo(myHero.x*3,myHero.z*3)
		end
end
