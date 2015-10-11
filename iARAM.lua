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
			-LunarBlue
]]--

--[[
	   SOON:
	    -Debug Option
	    -Drawcircles allies
		-Remake Menu Function.
		-Auto Barrier, health and clarity.
]]--
--[[
	   Problems:
	   No to follow champs infountain
	   pairs withs Relics
		──|> AutoLevel with ROff doesnt work.
]]--

--[[ SETTINGS ]]--
local HotKey = 115 --F4 = 115, F6 = 117 default
local AutomaticChat = true --If is in true mode, then it will say "gl and hf" when the game starts.
local AUTOUPDATE = true --change to false to disable auto update
local SummonerName = myHero.charName

--[[ GLOBALS [Do Not Change] ]]--

function _AutoupdaterMsg(msg) print("<font color=\"#9bbcfe\"><b>i<font color=\"#6699ff\">ARAM:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end

-----[[ Auto Download Required LIBS ]]------

function OnLoad()
	CheckLib()
	--DelayAction(function() _OnLoad() end, 2)  
	_OnLoad()
end
--if not FileExist(LIB_PATH.."VPrediction.lua") then return _AutoupdaterMsg("Please download VPrediction before running this script, thank you. Make sure it is in your common folder.") end
function CheckLib()
local SOURCELIB_URL = "https://raw.githubusercontent.com/SidaBoL/Scripts/master/Common/VPrediction.lua"
local SOURCELIB_PATH = LIB_PATH.."VPrediction.lua"
local DownloadSourceLib = false
	if FileExist(SOURCELIB_PATH) then
		require("VPrediction")
	else
		DownloadSourceLib = true
		DownloadFile(SOURCELIB_URL, SOURCELIB_PATH, function() _AutoupdaterMsg("VPrediction downloaded, please reload (F9)") end)
	end
	if DownloadSourceLib then _AutoupdaterMsg("Downloading required libraries, please wait...") return end
end


-----[[ Delay ]]------
local LastTick = nil
local LastFollowChamp = nil
local LastAttack = nil

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
nextbuyIndex = 1
lastBuy = 0
lastBoughtItem = nil
UP_TO_DATE = true
buyDelay = 100 --default 100
local buyIndex = 1
local lastGold = 0
local lastBuy = -501

-----[[ Auto ward Globals ]]------
local drawWardSpots = false
local wardSlot = nil

-----[[ Tower Globals ]]------
local allyTurretColor = RGB(73,210,59)	 		-- Green color
local enemyTurretColor = RGB(255,0,0) 		-- Red color
local visibilityTurretColor = RGB(130,0,0) 	-- Dark Red color
local drawTurrets = {}
local FollowTurrets = {}
local ChampionBusy = false


---[[Globals]]--
local status = "Normal"
local mdraw = {x=5940, z=6040}
local edraw = {x=0, z=0}
local Qready, Wready, Rready, Eready = false
local DistanceTower = {AllyTower,EnemyTower}
underT = {
AllyTower = false,
EnemyTower = false
}
local comboDmg = 0
local tabclosed = {} -- get closed enemy
local tabget = {} -- get all enemys
local onbase = false
local safe = true
local player = myHero
local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
local range = myHero.range


-----[[ Auto Update Globals ]]------
local version = 5.94
local UPDATE_CHANGE_LOG = "Fixing AutoZhonyas and Shaco"
local UPDATE_HOST = "raw.githubusercontent.com"
local UPDATE_PATH = "/Husmeador12/Bol_Script/master/iARAM.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH


-----[[ Auto Update Function ]]------

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

--[[ CheckLoLVersion Function ]]--
function CheckLoLVersion()
	LoLVersion = GetGameVersion()
	--print(""..GetGameVersion().."")
	if string.match(LoLVersion, "5.19.0.295") then
		LoLVersionWorking = true
		 --_AutoupdaterMsg("Script Updated for this LoL version")
	else
		LoLVersionWorking = false
		 _AutoupdaterMsg("Script Outdated for this LoL version")
	end
end




-----[[ Build and defining Champion Class ]]------
do
	myHero = GetMyHero()
	Target = nil
	spawnpos  = { x = myHero.x, z = myHero.z}
	ranged = 0
	assassins = {"Akali","Diana","Evelynn","Fizz","Katarina","Nidalee"}
	adtanks = {"Braum","DrMundo","Garen","Gnar","Hecarim","JarvanIV","Nasus","Skarner","TahmKench","Thresh","Volibear","Yorick"}
	adcs = {"Ashe","Caitlyn","Corki","Draven","Ezreal","Gangplank","Graves","Jinx","Kalista","KogMaw","Lucian","MissFortune","Quinn","Sivir","Tristana","Tryndamere","Twitch","Urgot","Varus","Vayne"}
	aptanks = {"Alistar","Amumu","Blitzcrank","Chogath","Leona","Malphite","Maokai","Nautilus","Rammus","Sejuani","Shen","Singed","Zac"}
	mages = {"Ahri","Anivia","Annie","Azir","Bard","Brand","Cassiopeia","Ekko","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","LeBlanc","Lissandra","Lulu","Lux","Malzahar","Morgana","Nami","Nunu","Orianna","Ryze","Shaco","Sona","Soraka","Swain","Syndra","Taric","TwistedFate","Veigar","Velkoz","Viktor","Xerath","Ziggs","Zilean","Zyra"}
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
										[3340]=0,--trinket
                                        [3352]=865,--Nomad's Medallion
										[1001]=325,--Boots
										[1298]=450,--Dagger
										[1293]=875,--Pickaxe
										[3024]=950,--Glacial Shroud
                                        [3801]=600,--Crystalline Bracer
										[1282]=850,--Blasting Wand
										[3364]=820,--Fiendish Codex
                                        [1287]=750,--Chain Vest
										[3028]=900,--ºChalice of Harmony
										[1313]=850,--Negatron Cloak
                                        [3339]=300,--Warmog's Armor
										[1309]=800,--Vampiric Scepter
										[1011]=1000,--ºGiant's Belt
                                        [3190]=2800,--ºLocket of the Iron Solari
                                        [3331]=2100,--Thornmail
                                        [3068]=2600,--Sunfire Cape
                                        [3328]=1950,--Bloodthirster
                                        [3069]=1235,--ºTalisman of Ascension
                                        [1294]=1550,--B.F. Sword
                                        [3031]=2250,--ºInfinity Edge
                                        [3395]=2150,--Mercurial Scimitar
                                        [3507]=1650,--Essence Reaver
                                        [3411]=1450,--Hexdrinker
                                        [3412]=1750,--Maw of Malmortius
                                        [3338]=1050,--Warden's Mail
                                        [3366]=1400,--Frozen Heart
                                        [3211]=1200,--Spectre's Cowl
                                        [3065]=1550,--ºSpirit Visage
                                        [3358]=1550,--Banshee's Veil
                                        [1314]=1600,--Needlessly Large Rod
                                        [3345]=1700,--Rabadon's Deathcap
                                        [3413]=1700,--Zhonya's Hourglass
                                        [3285]=1500,--Luden's Echo
                                        [3001]=2440,--ºAbyssal Scepter
                                        [3357]=1250,--Stinger
                                        [3371]=1670,--Nashor's Tooth
                                        [3392]=1485,--Haunting Guise
                                        [3407]=1415,--Liandry's Torment
										[3057]=1200,--ºSheen
                                        [3356]=3000,--Lich Bane
                                        [3044]=1325,--ºPhage
                                        [3071]=3000,--ºThe Black Cleaver       
                                        [3165]=2300,--ºMorellonomicon
										[3006]=1000,--Berserker's Greaves
										[3342]=1100,--Zeal
										[3400]=1400,--Bilgewater Cutlass
										[3409]=3200,--Blade of the Ruined King
										[3181]=2275,--Sanguine Blade
										[3035]=2300,--ºLast Whisper
										[3026]=2800,--Guardian Angel
										[3047]=1000,--ºNinja Tabi
										[3390]=1337,--The Brutalizer
										[3025]=2900,--Iceborn Gauntlet
										[3367]=1200,--Mercury's Treads
										[3372]=3000,--Rylai's Crystal Scepter
										[1299]=1100,--Recurve Bow
										[3020]=1100,--ºSorcerer's Shoes
										[3347]=2600,--Wit's End
										[3408]=2500,--Will of the Ancients
										[3330]=3300,--Ravenous Hydra 
										[3391]=2500,--Void Staff
										[3401]=1200,--Hextech Revolver
										[3334]=3703,--Trinity Force
										[3174]=2700,--Athene's Unholy Grail
										[3343]=2500,--Statikk Shiv
										[3399]=2850,--Randuin's Omen
										[3005]=2250,--Atma's Impaler
										[3380]=2590,--Guinsoo's Rageblade
										[3046]=2800,--ºPhantom Dancer
										[3402]=3400,--Hextech Gunblade
										[3333]=1900--Tiamat
                                }
       
        if heroType == 1 then --ADC
			--shopList = {3006,3342,3343,3400,3409,1294,3181,1293,3035,3026,0}
			shopList = {1001,3006,3342,3343,3400,3409,1294,3181,1293,3035,3026,0}
		end
		if heroType == 2 then --ADTANK
			--shopList = {3047,1011,3390,3068,3024,3025,3071,3338,3399,3005,0}
			shopList = {1001,3047,1011,3390,3068,3024,3025,3071,3338,3399,3005,0}
		end
		if heroType == 3 then --APTANK
			--shopList = {3367,1287,3068,1313,3372,1282,3001,3338,3366,3358,0}
			shopList = {1001,3367,1287,3068,1313,3372,1282,3001,3338,3366,3358,0}
		end
		if heroType == 4 then --HYBRID
			--shopList = {3364,3371,3020,1282,3392,3345,1299,3347,3407,3372}
			shopList = {1001,3364,3371,3020,1282,3392,3345,1299,3347,3407,3372}
		end
		if heroType == 5 then --BRUISER
			--shopList = {1001,3367,3390,1294,3181,3411,3071,1309,3333,3330,3412,3190}
			shopList = {1001,3367,3390,1294,3181,3411,3071,1309,3333,3330,3412,3190}
		end
		if heroType == 6 then --ASSASSIN
			--shopList = {3020,3057,3356,1282,3345,3392,3407,1314,3413,3391,0}
			shopList = {1001,3057,3356,1282,3345,3392,3407,1314,3413,3391,0}
		end
		if heroType == 7 then --MAGE
			shopList = {1001,3392,1314,3345,3174,3407,1282,3001,3391,0}
		end
		if heroType == 8 then --APC
			shopList = {1001,3401,3020,3408,1282,3372,1314,3345,1282,3001,3413}
		end
		if heroType == 9 or heroType == 10 then --FIGHTER and OTHERS
			shopList = {1001,3401,3020,3408,1282,3372,1314,3345,1282,3001,3413}
		end
        startTime = GetTickCount()
	--item ids can be found at many websites, ie: http://www.lolking.net/items/1004

end


--[[ On Draw Function ]]--
function OnDraw()
		AirText()
		RangeCircles()
		--|>Autoward
		AutoWarderDraw()
		DebugCursorPos()
		--|>NameDrawer
		DrawFakeNames()
		DrawTowerRange()
		ChampionesDraw()
		_MyHeroText()
		DrawNotificationLib()
end


--[[ On Load Function ]]--
 function _OnLoad()
		startingTime = GetTickCount()
		CheckLoLVersion()
		Menu()
		if LoLVersionWorking then
		NotificationLib:AddTile("WelCome To iARAM", "Improving AutoPlay Function. Version: "..version.."", 10)
		gete()
		enemyMinion = minionManager(MINION_ENEMY, 800, player, MINION_SORT_HEALTH_ASC)
		allyMinion = minionManager(MINION_ALLY, 800, player, MINION_SORT_HEALTH_ASC)
		OnProcessSpell()
		timeToShoot()
		heroCanMove()
		OnWndMsg()
		OnWndMsgNotificationLib()
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
		LoadMapVariables()
	end
end


--[[ On Unload Function ]]--
function OnUnload()
	print ("<font color=\"#9bbcfe\"><b>i<font color=\"#6699ff\">ARAM:</b></font> <font color=\"#FFFFFF\">disabled.</font>")
end


--[[ OnTick Function ]]--
function OnTick()
	startingTime = GetTickCount()
	if LoLVersionWorking then
	--	AutoBuy()
		LFC()
		--|> Poro Shouter
		PoroCheck()
		--|>Autopotions
		AutoPotions()
		--|>Mode Alone
		--FollowMinionAlly()
		HealthAlly()
		TowerRangers()
		--TowerFollowing()
		FunctionAutoZhonya()
		Allie = followHero()
		EnemyTabFunction()
		getsafe()
		ts:update()
		CheckStatus()
		enemyMinion:update()
		allyMinion:update()
		Cooldowncheck()
		mqnt()
		CheckTower()
		if ts.target then
			ts.targetSelected = true
		end
		EnemyCount()
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


function EnemyTabFunction()
local champ = player.charName
if champ == "Aatrox" then           eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Ahri" then         eTab = GetEnemiesInRange(800, myHero) tabclosed = GetEnemiesInRange(800, myHero)
    elseif champ == "Akali" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Alistar" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Amumu" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Anivia" then       eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Annie" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Ashe" then         eTab = GetEnemiesInRange(900, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(1000, myHero) else tabclosed = GetEnemiesInRange(500, myHero) end
	elseif champ == "Azir" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Blitzcrank" then   eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Brand" then        eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Bard" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
	elseif champ == "Braum" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Caitlyn" then      eTab = GetEnemiesInRange(1030, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(1000, myHero) else tabclosed = GetEnemiesInRange(500, myHero) end
    elseif champ == "Cassiopeia" then   eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Chogath" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Corki" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Darius" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Diana" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "DrMundo" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Draven" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
	elseif champ == "Ekko" then      	eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Elise" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Evelynn" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Ezreal" then       eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "FiddleSticks" then eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Fiora" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Fizz" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Galio" then        eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Gangplank" then    eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Garen" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Gragas" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Graves" then       eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
	elseif champ == "Gnar" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Hecarim" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Heimerdinger" then eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Irelia" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Janna" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "JarvanIV" then     eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Jax" then          eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Jayce" then        eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
	elseif champ == "Jinx" then         eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
	elseif champ == "Kalista" then      eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Karma" then        eTab = GetEnemiesInRange(1030, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Karthus" then      eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Kassadin" then     eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Katarina" then     eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Kayle" then        eTab = GetEnemiesInRange(830, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Kennen" then       eTab = GetEnemiesInRange(800, myHero) tabclosed = GetEnemiesInRange(800, myHero)
    elseif champ == "Khazix" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "KogMaw" then       eTab = GetEnemiesInRange(800, myHero) tabclosed = GetEnemiesInRange(800, myHero)
    elseif champ == "Leblanc" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "LeeSin" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Leona" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Lissandra" then    eTab = GetEnemiesInRange(800, myHero) tabclosed = GetEnemiesInRange(800, myHero)
    elseif champ == "Lucian" then       eTab = GetEnemiesInRange(800, myHero) tabclosed = GetEnemiesInRange(800, myHero)
    elseif champ == "Lulu" then         eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Lux" then          eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Malphite" then     eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Malzahar" then     eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Maokai" then       eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "MasterYi" then     eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "MissFortune" then  eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "MonkeyKing" then   eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Mordekaiser" then  eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Morgana" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Nami" then         eTab = GetEnemiesInRange(800, myHero) tabclosed = GetEnemiesInRange(800, myHero)
    elseif champ == "Nasus" then        eTab = GetEnemiesInRange(400, myHero) tabclosed = GetEnemiesInRange(400, myHero)
    elseif champ == "Nautilus" then     eTab = GetEnemiesInRange(800, myHero) tabclosed = GetEnemiesInRange(800, myHero)
    elseif champ == "Nidalee" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Nocturne" then     eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Nunu" then         eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Olaf" then         eTab = GetEnemiesInRange(830, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(400, myHero) end 
    elseif champ == "Orianna" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Pantheon" then     eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Poppy" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Quinn" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Rammus" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
	elseif champ == "RekSai" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Renekton" then     eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Rengar" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Riven" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Rumble" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Ryze" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Sejuani" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Shaco" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Shen" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Shyvana" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Singed" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Sion" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Sivir" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Skarner" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Sona" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Soraka" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Swain" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Syndra" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
	elseif champ == "TahmKench" then   	eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Talon" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Taric" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Teemo" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Thresh" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Tristana" then     eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Trundle" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Tryndamere" then   eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "TwistedFate" then  eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Twitch" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Udyr" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Urgot" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Varus" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Vayne" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Veigar" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
	elseif champ == "Velkoz" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Vi" then           eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Viktor" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Vladimir" then     eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Volibear" then     eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Warwick" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Xerath" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "XinZhao" then      eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Yorick" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
	elseif champ == "Yasuo" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Zac" then          eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Zed" then          eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Ziggs" then        eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Zilean" then       eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    elseif champ == "Zyra" then         eTab = GetEnemiesInRange(630, myHero) if enemiescount == true then tabclosed = GetEnemiesInRange(850, myHero) else tabclosed = GetEnemiesInRange(100, myHero) end 
    else eTab = GetEnemiesInRange(630, myHero)
		 tabclosed = GetEnemiesInRange(800, myHero)
		 _AutoupdaterMsg(string.format(" >> Get Range Enemies disabled for %s", champ))
    end
end

function ChampionesDraw()
	if iARAM.misc.misc2 then
		if player.dead or GetGame().isOver then return end
			for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("W", minion, myHero) then
				DrawCircle3D(minion.x, minion.y, minion.z, 30, 1, RGB(255,0,255), 100)
				--DrawLine3D(myHero.x, myHero.y, myHero.z, minion.x, minion.y, minion.z, 1, 0x7FFF00)
			end
		end
		-- Draw Enemy
		for _, str in pairs(tabget) do
			if myHero:GetDistance(tabget[_]) < 800 and not tabget[_].dead and tabget[_] ~= nil and tabget[_].valid and tabget[_].visible and tabget[_].health > 1 then
				DrawLine3D(myHero.x, myHero.y, myHero.z, tabget[_].x, tabget[_].y, tabget[_].z, 1, RGB(255,255,255))
				DrawCircle3D(tabget[_].x, tabget[_].y, tabget[_].z, 100, 1, RGB(255,255,255), 100)
			end
		end
		-- Target Draw
		if ts.target then
			hp = ((ts.target.health * 100) / ts.target.maxHealth) * 2
			DrawText(ts.target.charName, 20, 15, 150, RGB(255,255,255))
			DrawLine(15, 200, 200 + 15, 200, 10, RGB(255,105,105))
			if ts.target.health < ts.target.maxHealth /2 then
				DrawLine(15, 200, hp + 15, 200, 10, RGB(255,255,215))
			elseif ts.target.health > ts.target.maxHealth /2 then
				DrawLine(15, 200, hp + 15, 200, 10, RGB(255,0,255))
			elseif ts.target.health < comboDmg then
				DrawLine(15, 200, hp + 15, 200, 10, RGB(255,255,95))
			end
		end		
	end
end


function CheckStatus() 
	eTurret = GetCloseTower(player, TEAM_ENEMY)
	aTurret = GetCloseTower(player, player.team)
	if iARAM.follow then
		if safe == false then
			status = "Not Safe"
		elseif myHero.health < myHero.maxHealth/4 and summonersRiftMap then -- Back to Base
			status = "LowHP"
			lowHP()
		elseif myHero.health < myHero.maxHealth/4 then -- HP
			status = "Loking for Relic"
			TakingRelic()
		elseif onbase == true then 
			status = "On Base"
			if myHero.health == myHero.maxHealth then
				onbase = false
			end
		elseif #eTab > 0 and ts.target ~= nil and ts.target.valid and not ts.target.dead and ts.target.visible then
			status = "Fight"
			Fight()
		elseif #allyMinion.objects > 1 and #enemyMinion.objects >= 1 then -- Farming
			status = "Farming"
			FarmMode()
		elseif Allies() >= 2 and not InFountain() then
			status = "TF Mode"
			TFMode()
		elseif GetDistance(eTurret, player) > 1000 and #allyMinion.objects <= 1 and #enemyMinion.objects <= 1 then
			status = "Moving"
			DelayAction(function() MoveMode() end, 2)
		elseif #allyMinion.objects <= 1 and GetDistance(aTurret, player) >= 1500 then -- Alone
			status = "Alone"
			AloneMode()
		else
			status = "Normal"
			NormalMode()
		end
	end
end

function Fight()
local champ = player.charName
	if ts.target then
	if champ == "Aatrox" then           harass(ts.target)
		elseif champ == "Ahri" then         AhriCombo() harass(ts.target)
		elseif champ == "Akali" then        ComboFull() harass(ts.target)
		elseif champ == "Alistar" then      ComboFull() harass(ts.target)
		elseif champ == "Amumu" then        ComboFull() harass(ts.target)
		elseif champ == "Anivia" then       ComboFull() harass(ts.target)
		elseif champ == "Annie" then        ComboFull() harass(ts.target)
		elseif champ == "Ashe" then         AsheCombo() harass(ts.target)
		elseif champ == "Azir" then         ComboFull() harass(ts.target)
		elseif champ == "Blitzcrank" then   ComboFull() harass(ts.target)
		elseif champ == "Brand" then        ComboFull() harass(ts.target)
		elseif champ == "Bard" then         ComboFull() harass(ts.target)
		elseif champ == "Braum" then        ComboFull() harass(ts.target)
		elseif champ == "Caitlyn" then      CaitlynCombo() harass(ts.target)
		elseif champ == "Cassiopeia" then   ComboFull() harass(ts.target)
		elseif champ == "Chogath" then      ComboFull()
		elseif champ == "Corki" then        ComboFull() harass(ts.target)
		elseif champ == "Darius" then       ComboFull()
		elseif champ == "Diana" then        ComboFull() harass(ts.target)
		elseif champ == "DrMundo" then      ComboFull() harass(ts.target)
		elseif champ == "Draven" then       ComboFull() harass(ts.target)
		elseif champ == "Ekko" then      	ComboFull() harass(ts.target)
		elseif champ == "Elise" then        ComboFull() harass(ts.target)
		elseif champ == "Evelynn" then      ComboFull() harass(ts.target)
		elseif champ == "Ezreal" then       ComboFull() harass(ts.target)
		elseif champ == "FiddleSticks" then ComboFull() harass(ts.target)
		elseif champ == "Fiora" then        ComboFull() harass(ts.target)
		elseif champ == "Fizz" then         ComboFull() harass(ts.target)
		elseif champ == "Galio" then        ComboFull() harass(ts.target)
		elseif champ == "Gangplank" then    ComboFull() harass(ts.target)
		elseif champ == "Garen" then        ComboFull()
		elseif champ == "Gragas" then       ComboFull() harass(ts.target)
		elseif champ == "Graves" then       ComboFull() harass(ts.target)
		elseif champ == "Gnar" then         ComboFull() harass(ts.target)
		elseif champ == "Hecarim" then      ComboFull() harass(ts.target)
		elseif champ == "Heimerdinger" then ComboFull() harass(ts.target)
		elseif champ == "Irelia" then       ComboFull() harass(ts.target)
		elseif champ == "Janna" then        ComboFull() harass(ts.target)
		elseif champ == "JarvanIV" then     ComboFull() harass(ts.target)
		elseif champ == "Jax" then          ComboFull() harass(ts.target)
		elseif champ == "Jayce" then        ComboFull() harass(ts.target)
		elseif champ == "Jinx" then         ComboFull() harass(ts.target)
		elseif champ == "Kalista" then      ComboFull() harass(ts.target)
		elseif champ == "Karma" then        KarmaCombo() harass(ts.target)
		elseif champ == "Karthus" then      ComboFull() harass(ts.target)
		elseif champ == "Kassadin" then     ComboFull() harass(ts.target)
		elseif champ == "Katarina" then     ComboFull() harass(ts.target)
		elseif champ == "Kayle" then        KayleCombo() harass(ts.target)
		elseif champ == "Kennen" then       ComboFull() harass(ts.target)
		elseif champ == "Khazix" then       ComboFull() harass(ts.target)
		elseif champ == "KogMaw" then       ComboFull() harass(ts.target)
		elseif champ == "Leblanc" then      ComboFull() harass(ts.target)
		elseif champ == "LeeSin" then       ComboFull() harass(ts.target)
		elseif champ == "Leona" then       	ComboFull()
		elseif champ == "Lissandra" then    ComboFull() harass(ts.target)
		elseif champ == "Lucian" then       ComboFull() harass(ts.target)
		elseif champ == "Lulu" then         ComboFull() harass(ts.target)
		elseif champ == "Lux" then          LuxCombo() harass(ts.target)
		elseif champ == "Malphite" then     ComboFull() harass(ts.target)
		elseif champ == "Malzahar" then     ComboFull() harass(ts.target)
		elseif champ == "Maokai" then       ComboFull() harass(ts.target)
		elseif champ == "MasterYi" then     ComboFull() harass(ts.target)
		elseif champ == "MissFortune" then  ComboFull() harass(ts.target)
		elseif champ == "MonkeyKing" then   ComboFull() harass(ts.target)
		elseif champ == "Mordekaiser" then  ComboFull() harass(ts.target)
		elseif champ == "Morgana" then      MorganaCombo() harass(ts.target)
		elseif champ == "Nami" then         ComboFull() harass(ts.target)
		elseif champ == "Nasus" then        ComboFull() harass(ts.target)
		elseif champ == "Nautilus" then     ComboFull() harass(ts.target)
		elseif champ == "Nidalee" then      NidaleeCombo() harass(ts.target)
		elseif champ == "Nocturne" then     ComboFull() harass(ts.target)
		elseif champ == "Nunu" then         NunuCombo()
		elseif champ == "Olaf" then         ComboFull() harass(ts.target)
		elseif champ == "Orianna" then      ComboFull() harass(ts.target)
		elseif champ == "Pantheon" then     ComboFull() harass(ts.target)
		elseif champ == "Poppy" then        ComboFull() harass(ts.target)
		elseif champ == "Quinn" then        ComboFull() harass(ts.target)
		elseif champ == "Rammus" then       ComboFull() harass(ts.target)
		elseif champ == "RekSai" then       ComboFull() harass(ts.target)
		elseif champ == "Renekton" then     ComboFull() harass(ts.target)
		elseif champ == "Rengar" then       ComboFull() harass(ts.target)
		elseif champ == "Riven" then        ComboFull() harass(ts.target)
		elseif champ == "Rumble" then       ComboFull() harass(ts.target)
		elseif champ == "Ryze" then         ComboFull() harass(ts.target)
		elseif champ == "Sejuani" then      ComboFull() harass(ts.target)
		elseif champ == "Shaco" then        ComboFull() harass(ts.target)
		elseif champ == "Shen" then         ComboFull() harass(ts.target)
		elseif champ == "Shyvana" then      ComboFull() harass(ts.target)
		elseif champ == "Singed" then       ComboFull() harass(ts.target)
		elseif champ == "Sion" then         ComboFull() harass(ts.target)
		elseif champ == "Sivir" then        ComboFull() harass(ts.target)
		elseif champ == "Skarner" then      ComboFull() harass(ts.target)
		elseif champ == "Sona" then         ComboFull() harass(ts.target)
		elseif champ == "Soraka" then       ComboFull() harass(ts.target)
		elseif champ == "Swain" then        ComboFull() harass(ts.target)
		elseif champ == "Syndra" then       ComboFull() harass(ts.target)
		elseif champ == "TahmKench" then   	ComboFull() harass(ts.target)
		elseif champ == "Talon" then        ComboFull() harass(ts.target)
		elseif champ == "Taric" then        ComboFull() harass(ts.target)
		elseif champ == "Teemo" then        ComboFull() harass(ts.target)
		elseif champ == "Thresh" then       ComboFull() harass(ts.target)
		elseif champ == "Tristana" then     ComboFull() harass(ts.target)
		elseif champ == "Trundle" then      ComboFull() harass(ts.target)
		elseif champ == "Tryndamere" then   ComboFull() harass(ts.target)
		elseif champ == "TwistedFate" then  ComboFull() harass(ts.target)
		elseif champ == "Twitch" then       ComboFull() harass(ts.target)
		elseif champ == "Udyr" then         ComboFull() harass(ts.target)
		elseif champ == "Urgot" then        ComboFull() harass(ts.target)
		elseif champ == "Varus" then        ComboFull() harass(ts.target)
		elseif champ == "Vayne" then        ComboFull() harass(ts.target)
		elseif champ == "Veigar" then       ComboFull() harass(ts.target)
		elseif champ == "Velkoz" then       ComboFull() harass(ts.target)
		elseif champ == "Vi" then           ComboFull() harass(ts.target)
		elseif champ == "Viktor" then       ComboFull() harass(ts.target)
		elseif champ == "Vladimir" then     ComboFull() harass(ts.target)
		elseif champ == "Volibear" then     ComboFull() harass(ts.target)
		elseif champ == "Warwick" then      WarwickCombo()
		elseif champ == "Xerath" then       ComboFull() harass(ts.target)
		elseif champ == "XinZhao" then      ComboFull() harass(ts.target)
		elseif champ == "Yorick" then       ComboFull() harass(ts.target)
		elseif champ == "Yasuo" then        ComboFull() harass(ts.target)
		elseif champ == "Zac" then          ComboFull() harass(ts.target)
		elseif champ == "Zed" then          ComboFull() harass(ts.target)
		elseif champ == "Ziggs" then        ComboFull() harass(ts.target)
		elseif champ == "Zilean" then       ComboFull() harass(ts.target)
		elseif champ == "Zyra" then         ComboFull() harass(ts.target)
		else harass(ts.target)
			ComboFull()
			comboDmg = getDmg("Q", ts.target, myHero) + getDmg("W", ts.target, myHero) + getDmg("R", ts.target, myHero)
			RDmg = getDmg("R", ts.target, myHero)
			ts.targetSelected = true
			if RDmg > ts.target.health and Rready then
				CastSpell(_R, ts.target.x, ts.target.z)
			elseif comboDmg >= ts.target.health then
				Combo(ts.target)
			end
			 _AutoupdaterMsg(string.format(" >> No mode Fight for %s", champ))
		end
	end
end


function getsafe()
	local q = {}
	for i, str in pairs(tabclosed) do
		if str.valid and str.team ~= myHero.team and not str.dead and str.visible then
			table.insert(q, str.charName)
		end
	end
		if #q > 0 and iARAM.follow then
			safe = false
			ts.targetSelected = false
			if myHero.team == TEAM_BLUE then
				myHero:MoveTo(myHero.x-800,myHero.z-800)
			else
				myHero:MoveTo(myHero.x+800,myHero.z+800)
			end	
		else
			safe = true
		end	
end

function InRange(unit, range, from)
	if (not range) then
		return false
	end
	from = from or myHero
	return (GetDistance(unit, from) <= range)
end

function GetEnemiesInRange(range, from)
	from = from or myHero
	local enemies = { }
	for _, enemy in ipairs(GetEnemyHeroes()) do
		if (InRange(enemy, range, from)) then
			table.insert(enemies, enemy)
		end
	end
	return enemies	
end

function lowHP()
	local myTurret = GetCloseTower(player, player.team)
	if underT.AllyTower and myHero:GetDistance(myTurret) < 300 then
		--CastSpell(RECALL)
		if InFountain() then
			onbase = true
		end
	else if myHero.team == TEAM_BLUE then
				myHero:MoveTo(400,400)
			else
				myHero:MoveTo(14300,myTurret.z+14300)
			end
	end
end

function TakingRelic()
	if not myHero.dead then
		if myHero.team == TEAM_BLUE then
			--myHero:MoveTo(5900,5200)
			myHero:MoveTo(4790,3950)
		else
			myHero:MoveTo(8890,7900)
		end
	end
end

function MoveMode()
	local Turret = GetCloseTower(player, TEAM_ENEMY)
	local aTurret = GetCloseTower(player, player.team)
	local LastTickerone = nil
	local LastMoveInMoveMode = 1

	if (LastTickerone and (GetInGameTimer() < LastTickerone + 1)) then return end
		LastTickerone = GetInGameTimer()
		LastMoveInMoveMode = LastMoveInMoveMode * -1
	if myHero.team == TEAM_BLUE then
		--myHero:HoldPosition()
		myHero:MoveTo(myHero.x+800, myHero.z+800)
	else
			--myHero:HoldPosition()
		myHero:MoveTo(myHero.x-800, myHero.z-800)
	end
end

function AloneMode()
	local myTurret = GetCloseTower(player, player.team)
	local EnemyTurret = GetCloseTower(player, TEAM_ENEMY)
	local LastTickore = nil
	local LastMoveInAloneMode = 1
	
	if myHero.team == TEAM_BLUE then
		if (LastTickore and (GetInGameTimer() < LastTickore + 1)) then return end
		LastTickore = GetInGameTimer()
		LastMoveInAloneMode = LastMoveInAloneMode * -1
		myHero:HoldPosition()
		--myHero:MoveTo(myHero.x-800, myHero.z-800)
	else
		if (LastTickore and (GetInGameTimer() < LastTickore + 1)) then return end
		LastTickore = GetInGameTimer()
		LastMoveInAloneMode = LastMoveInAloneMode * -1
		myHero:HoldPosition()
		--myHero:MoveTo(myHero.x+800, myHero.z+800)
	end
end

function FarmMode()
if player.dead or GetGame().isOver then return end


AhriFarm()
AsheFarm()
CaitlynFarm()
KarmaFarm()
KayleFarm()
LuxFarm()
MorganaFarm()
NidaleeFarm()
WarwickFarm()

	-- moveLastFollowingMinion
	if heroType == 1 then --adc
		if(GetDistance(Vector(mdraw.x, mdraw.z), player) > 400) then
			myHero:MoveTo(mdraw.x+100,mdraw.z+100) 
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end
	elseif heroType == 2 then --tank
		if(GetDistance(Vector(edraw.x, edraw.z), player) >= 400) then
			myHero:MoveTo(edraw.x+100,edraw.z+100) 
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end
	elseif heroType == 3 then --tank
		if(GetDistance(Vector(edraw.x, edraw.z), player) >= 400) then
			myHero:MoveTo(edraw.x+100,edraw.z+100) 
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end

	elseif heroType == 4 then --Fighter
		if(GetDistance(Vector(edraw.x, edraw.z), player) >= 400) then
			myHero:MoveTo(edraw.x+100,edraw.z+100) 
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end
	elseif heroType == 5 then --Fighter
		if(GetDistance(Vector(edraw.x, edraw.z), player) >= 400) then
			myHero:MoveTo(edraw.x+100,edraw.z+100) 
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end	
	elseif heroType == 6 then --Fighter
		if(GetDistance(Vector(mdraw.x, mdraw.z), player) >= 400) then
			myHero:MoveTo(mdraw.x+100,mdraw.z+100) 
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end
	elseif heroType == 7 then --Mage
		if(GetDistance(Vector(mdraw.x, mdraw.z), player) > 400) then
			myHero:MoveTo(mdraw.x+190,mdraw.z+190)
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end	
	elseif heroType == 8 then --Fighter
		if(GetDistance(Vector(edraw.x, edraw.z), player) >= 400) then
			myHero:MoveTo(edraw.x+100,edraw.z+100) 
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end
	elseif heroType == 9 then --Fighter
		if(GetDistance(Vector(edraw.x, edraw.z), player) >= 400) then
			myHero:MoveTo(edraw.x-100,edraw.z-100) 
		else if underT.e == true then
			myHero:MoveTo(mdraw.x,mdraw.z)
		end
		end
	end
	-- Farm AA
		range = myHero.range + myHero.boundingRadius - 3
		ts.range = range
		ts:update()
		enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
		enemyMinions:update()
		local player = GetMyHero()
		local ticking = 0
		local delaying = 400
		local myTarget = ts.target
		if not iARAM.misc.farm then return end
			for index, minion in pairs(enemyMinions.objects) do
			  if GetDistance(minion, myHero) <= (myHero.range + 75) and GetTickCount() > ticking + delaying then
				local dmg = getDmg("AD", minion, myHero)
					if dmg > minion.health and timeToShoot() then
					  myHero:Attack(minion)
					  ticking = GetTickCount()
					  else if heroCanMove() then
					  --myHero:MoveTo(mdraw.x+3,mdraw.z+3)					  
					end
				end
			end
		end
end


function NormalMode()
	if myHero.x >= 2880 and myHero.z >= 2880 then
	local LastTickaro = nil
	local LastMoveInNormalMode = 1
	if (LastTickaro and (GetInGameTimer() < LastTickaro + 1)) then return end
	LastTickaro = GetInGameTimer()
	LastMoveInNormalMode = LastMoveInNormalMode * -1
		if heroType == 1 then --adc
				if GetDistance(Vector(mdraw.x, mdraw.z), player) < 80 then
					--if not timeToShoot() then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+190,mdraw.z+190)
						else
							myHero:MoveTo(mdraw.x-190,mdraw.z-190)
						end
				end	
		elseif heroType == 2 then --tank
				if GetDistance(Vector(mdraw.x, mdraw.z), player) < 100 then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+190,mdraw.z+190)
						else
							myHero:MoveTo(mdraw.x-190,mdraw.z-190)
						end
				end	
		elseif heroType == 3 then --tank
				if GetDistance(Vector(mdraw.x, mdraw.z), player) < 100 then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+190,mdraw.z+190)
						else
							myHero:MoveTo(mdraw.x-190,mdraw.z-190)
						end
				end	
		elseif heroType == 4 then 
				if GetDistance(Vector(mdraw.x, mdraw.z), player) >= 100 then
					--if not timeToShoot() then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+190,mdraw.z+190)
						else
							myHero:MoveTo(mdraw.x-190,mdraw.z-190)
						end
				end	
		elseif heroType==5 then
				if GetDistance(Vector(mdraw.x, mdraw.z), player) < 100 then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+800,mdraw.z+800)
						else
							myHero:MoveTo(mdraw.x-800,mdraw.z-800)
						end
				end	
		elseif heroType == 6 then 
				if GetDistance(Vector(mdraw.x, mdraw.z), player) < 100 then
					--if not timeToShoot() then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+190,mdraw.z+190)
						else
							myHero:MoveTo(mdraw.x-190,mdraw.z-190)
						end
				end	
		elseif heroType == 7 then --mage
				if GetDistance(Vector(mdraw.x, mdraw.z), player) >= 100 then
					--if not timeToShoot() then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+190,mdraw.z+190)
						else
							myHero:MoveTo(mdraw.x-190,mdraw.z-190)
						end
				end	
		elseif heroType == 8 then 
				if GetDistance(Vector(mdraw.x, mdraw.z), player) < 100 then
					--if not timeToShoot() then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+190,mdraw.z+190)
						else
							myHero:MoveTo(mdraw.x-190,mdraw.z-190)
						end
				end	
		elseif heroType == 9 then --fighter
				if GetDistance(Vector(mdraw.x, mdraw.z), player) >= 100 then
					--if not timeToShoot() then
						if myHero.team == TEAM_BLUE then
							myHero:MoveTo(mdraw.x+800,mdraw.z+800)
						else
							myHero:MoveTo(mdraw.x-800,mdraw.z-800)
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

function Combo(unit) -- This function handles our combo
	if Qready and Wready and Rready and Eready then
		CastSpell(_E)
        CastSpell(_Q, unit) 
        CastSpell(_W, unit.x, unit.z)
        CastSpell(_R, unit.x, unit.z)
	end
end

function harass(unit)
	local myTarget = ts.target
	if myTarget ~=	nil then		
		if timeToShoot() then
			myHero:Attack(myTarget)
		elseif heroCanMove() then
			myHero:MoveTo(myHero.x-3,myHero.z-3)
		end
	end
end

function gete() -- Get Enemy Heroes
	for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= player.team then
            table.insert(tabget, hero)
        end
    end	
end

function GetCloseTower(hero, team)
	local towers = GetTowers(team)
	if #towers > 0 then
		local candidate = towers[1]
		for i=2, #towers, 1 do
			if (towers[i].health/towers[i].maxHealth > 0.1) and  hero:GetDistance(candidate) > hero:GetDistance(towers[i]) then candidate = towers[i] end
		end
		return candidate
	else
		return false
	end
end

function GetTowers(team)
	local towers = {}
	for i=1, objManager.maxObjects, 1 do
		local tower = objManager:getObject(i)
		if tower ~= nil and tower.valid and tower.type == "obj_AI_Turret" and tower.visible and tower.team == team then
			table.insert(towers,tower)
		end
	end
	if #towers > 0 then
		return towers
	else
		return false
	end
end

function mqnt() -- Quantidade de minions per to
	md = {x=0, z=0} 
	em = {x=0, z=0}
	if player.dead or GetGame().isOver then return end 
	for n, m in pairs(allyMinion.objects) do
		md.x = md.x + allyMinion.objects[n].x
		md.z = md.z + allyMinion.objects[n].z
	end
	for e, ee in pairs(enemyMinion.objects) do
		em.x = em.x + enemyMinion.objects[e].x
		em.z = em.z + enemyMinion.objects[e].z
	end
	

	mdraw.x = (md.x  / #allyMinion.objects) - 100
	mdraw.z = (md.z  / #allyMinion.objects) - 100

	edraw.x = (em.x  / #enemyMinion.objects)
	edraw.z = (em.z  / #enemyMinion.objects)
end

function Cooldowncheck() -- Checks for your Cooldowns
	Qready = (myHero:CanUseSpell(_Q) == READY)
	Wready = (myHero:CanUseSpell(_W) == READY)
	Rready = (myHero:CanUseSpell(_R) == READY)
	Eready = (myHero:CanUseSpell(_E) == READY)
end

function CheckTower()
	DistanceTower.EnemyTower = GetCloseTower(player, TEAM_ENEMY)
	DistanceTower.AllyTower = GetCloseTower(player, player.team)
	-- Ally tower
	if GetDistance(DistanceTower.AllyTower, player) <= 1000 then
		underT.AllyTower = true
	else
		underT.AllyTower = false
	end
	-- Enemy tower
	if GetDistance(DistanceTower.EnemyTower, player) <= 1000 then
		underT.EnemyTower = true
	else
		underT.EnemyTower = false
	end
end

function TowerFocusPlayer()
	print("Tower focus: Player")
		if myHero.team == TEAM_BLUE then
			myHero:MoveTo(myHero.x*-3,myHero.z*-3)
		else
			myHero:MoveTo(myHero.x*3,myHero.z*3)
		end
end

--[[ ComboFull Function ]]--
function ComboFull()
	if not myHero.dead then
		--|>Attacks Champs
		if Target ~= nil then
				myHero:Attack(Target)
				attacksuccess = 0
				if GetDistance(Target) < 1000 and myHero:CanUseSpell(_W) == READY then
				 if iARAM.misc.misc2 then CastW(str) end
					CastSpell(_W, Target)
					attacksuccess =1
				end
				if GetDistance(Target) < 1000 and myHero:CanUseSpell(_Q) == READY then
				--if iARAM.misc.misc2 then _AutoupdaterMsg("CastSpell Q") end
					CastSpell(_Q, Target)
					attacksuccess =1 
				end
				if GetDistance(Target) < 1000 and myHero:CanUseSpell(_E) == READY then
				--if iARAM.misc.misc2 then _AutoupdaterMsg("CastSpell E") end
					CastSpell(_E, Target)
					attacksuccess = 1
				end
				if GetDistance(Target) < 1000 and myHero:CanUseSpell(_R) == READY then
				--if iARAM.misc.misc2 then _AutoupdaterMsg("CastSpell R") end
					CastSpell(_R, Target)
					attacksuccess =1
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

function EnemyCount() 
	for i = 5, heroManager.iCount do
		local MyEnemy = heroManager:getHero(i)	
		if MyEnemy.team ~= myHero.team and not MyEnemy.dead and MyEnemy.visible and GetDistance(MyEnemy, myHero) < 1050 then
			enemiescount = true
			--print("2 enemies")
			--print(MyEnemy.name)
		else
			--print("1 enemies")
			enemiescount = false
		end
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
			iARAM.drawing:addParam("drawtower", "Draw Tower Ranges", SCRIPT_PARAM_ONOFF, false)
			iARAM.drawing:addParam("LfcDraw", "Use Lagfree Circles (Requires Reload!)", SCRIPT_PARAM_ONOFF, true)
		
		--[[ PoroShoter menu ]]--
		ARAM = ARAMSlot()
		vPred = VPrediction()
		TargetSelector = TargetSelector(TARGET_CLOSEST, 2500, DAMAGE_PHYSICAL)
		iARAM:addSubMenu("PoroShotter Settings", "PoroShot")
			iARAM.PoroShot:addParam("comboKey", "Auto Poro Shoot", SCRIPT_PARAM_ONOFF, true) 
			iARAM.PoroShot:addParam("range", "Poro Cast Range", SCRIPT_PARAM_SLICE, 1400, 800, 2500, 0) 
			iARAM.PoroShot:addTS(TargetSelector)
		--[[ ItemSettings menu ]]--	
		iARAM:addSubMenu("Item Settings", "item")
			iARAM.item:addParam("enableautozhonya", "Auto Zhonya", SCRIPT_PARAM_ONOFF, true)
			iARAM.item:addParam("autozhonya", "Zhonya if Health under -> %", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
		
		--[[ Misc menu ]]--
		iARAM:addSubMenu("Miscelaneus Settings", "misc")
			iARAM.misc:addParam("misc2", "Debug Mode", SCRIPT_PARAM_ONOFF, false)
			iARAM.misc:addParam("permanshow", "See Permashow", SCRIPT_PARAM_ONOFF, true)
			iARAM.misc:addParam("farm", "Last Hit Farm", SCRIPT_PARAM_ONOFF, true)	
			iARAM.misc:addParam("attackchamps", "Auto Attack champs", SCRIPT_PARAM_ONOFF, true)
			iARAM.misc:addParam("autobuy", "Auto Buy Items", SCRIPT_PARAM_ONOFF, true)
			iARAM.misc:addParam("useAutoPots", "Auto Potions", SCRIPT_PARAM_ONOFF, true)
			--Ignite
			ignite = IgniteCheck()

		----[[ Main Script menu ]]--
		iARAM:addParam("follow", "Enable bot", SCRIPT_PARAM_ONKEYTOGGLE, true, HotKey)
		
		----[[ PermaShow Menu ]]----
		if iARAM.misc.permanshow then
			iARAM:permaShow("follow")
			iARAM.misc:permaShow("autobuy")
		end

		-----------------------------------------------------------------------------------------------------
		iARAM:addParam("info", "edited by ", SCRIPT_PARAM_INFO, "Husmeador12") 
		iARAM:addParam("info2", "iARAM Version : ", SCRIPT_PARAM_INFO, version)
		
end


--[[ Lagfree Circles by barasia, vadash and viseversa ]]---
function RangeCircles()
	if iARAM.drawing.drawcircles and not myHero.dead then
		DrawCircle(myHero.x,myHero.y,myHero.z,getTrueRange(),RGB(0,255,0))
		DrawCircle(myHero.x,myHero.y,myHero.z,400,RGB(55,64,60))	
		-- DrawMinions
		DrawCircle(edraw.x, myHero.y, edraw.z, 400, RGB(73,210,59))
		DrawCircle(mdraw.x, myHero.y, mdraw.z, 400, RGB(255,0,0))
		DrawCircle(mdraw.x, myHero.y, mdraw.z, 100, RGB(255,0,59))
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
		
		-- Info Draw
		DrawText(status, 15, 10, 500, 0xFFFFFF00)
		if underT.AllyTower then
			DrawText("Under ally tower: true ", 15, 10, 520, 0xFFFFFF00)
		else
			DrawText("Under ally tower: false", 15, 10, 520, 0xFFFFFF00)
		end
		if underT.EnemyTower then
			DrawText("Under enemy tower: true", 15, 10, 540, 0xFFFFFF00)
		else
			DrawText("Under enemy tower: false", 15, 10, 540, 0xFFFFFF00)
		end
		
		--DrawText("Combo: "..tostring(comboDmg), 15, 10, 560, 0xFFFFFF00)
		local Height = 500
		for _, str in pairs(tabclosed) do
			if str.dead then return end
			 DrawText(tostring(str.charName), 15, 200, Height, 0xFFFFFF00)
			 Height = Height + 20
		end
	end
end


--[[ Perfect Ward, originally by Husky ]]--     
local wardSpots = {
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

---------[[ Auto Zhonya ]]---------
function FunctionAutoZhonya()
  if iARAM.item.enableautozhonya then
    if myHero.health <= (myHero.maxHealth * iARAM.item.autozhonya / 100) then CastItem(3157) 
    end
  end
end

---------[[ Auto Ignite ]]---------
function FunctionAutoIgnite()
	if iARAM.misc.autoIgnite then
		if myHero:CanUseSpell(ignite) == READY then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if myHero:CanUseSpell(ignite) ~= READY then return end
				if ValidTarget(enemy) and GetDistance(enemy) < 600 then
					local dmg = getDmg("ignite",enemy,myHero)
					if dmg >= target.health then
						CastSpell(ignite, enemy)
					end
				end
			end
		end
	end
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
			iARAM.misc:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
			iARAM.misc:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	end
end


---------[[ Auto Good luck and have fun ]]---------
function AutoChat()
local Text1 = {"Good luck and have fun", "gl hf", "gl hf", "Good luck have fun", "Good luck and have fun guys", "gl hf guys", "gl and have fun", "good luck and hf" } 
local Phrases2 = {"c´mon guys", "we can do it", "This is my winner team", "It doesnt matter", "let´s go", "team work is OP" }
	if GetTickCount() - startingTime > 2000 then
		SendChat(Text1[math.random(#Text1)])
	end
	
	if GetTickCount() - startingTime > 5000 then
		if iARAM.misc.miscelaneus then _AutoupdaterMsg("Moving") end
		distance1 = math.random(250,300)
		distance2 = math.random(250,300)
		neg1 = 1 
		neg2 = 1
		
		if myHero.team == TEAM_BLUE then
			DelayAction(function() myHero:MoveTo(myHero.x*5+distance1*neg1,myHero.z*5+distance2*neg2) end, 10)
		else
			DelayAction(function() myHero:MoveTo(myHero.x*-5+distance1*neg1,myHero.z*-5+distance2*neg2) end, 10)
			
		end
	end	
	--[[
	if GetInGameTimer() < 333 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 333-GetInGameTimer()) --5:35
	end
	
	 if GetInGameTimer() < 360 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 360-GetInGameTimer()) --6:02
	end 
	
	if GetInGameTimer() < 460 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 460-GetInGameTimer()) --7:40
	end
	]]
	if GetGame().isOver then 
        SendChat("gg wp")
		os.exit(0)
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
	if iARAM.misc.misc2 then _AutoupdaterMsg("Map: "..gameState.map.shortName.."") end
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
	end
end


-----[[ AutoPotions ]]------
function AutoPotions()
	if not iARAM.misc.useAutoPots then
		return
	end
	for SLOT = ITEM_1, ITEM_6 do
		--if iARAM.misc.misc2 then _AutoupdaterMsg("ITEM : "..myHero:GetSpellData(SLOT).name.."") end
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
			if myHero:CanUseSpell(SLOT) == READY and myHero.health / myHero.maxHealth < 50 then
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
    elseif champ == "Karma" then        AutoLevel({ 1, 2, 3, 2, 3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 2, 2, 2, 2, }) rOff = -1
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
	if LoLVersionWorking then
		local offsets = { 
		[_Q] = 0x29,
		[_W] = 0x49,
		[_E] = 0x21,
		[_R] = 0x41,
		  }
		  local p = CLoLPacket(0x114)
		  p.vTable = 0xF0D574
		  p:EncodeF(myHero.networkID)
		  for i = 1, 4 do p:Encode1(0x2B) end
		  p:Encode1(offsets[id])
		  for i = 1, 4 do p:Encode1(0xE1) end
		  for i = 1, 4 do p:Encode1(0x42) end
		  p:Encode1(0x62)
		  p:Encode1(0x01)
		  for i = 1, 3 do p:Encode1(0x00) end
		  SendPacket(p)
	end
end


--[[ PrintFloatText Function ]]--
function _MyHeroText() 
	if iARAM.follow and not myHero.dead then
		local barPos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
		DrawText(status, 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))
	end
end


--[[ Drawing Names Function ]]--
function DrawFakeNames()
	if myHero.visible == true and not myHero.dead then
		framePos = GetAbilityFramePos(myHero)
    	DrawOverheadHUD(myHero, framePos, ""..SummonerName.."")
	end
end

function DrawOverheadHUD(unit, framePos, str, isAlly)
    local barPos = Point(framePos.x, framePos.y)
    textWidth = (GetTextArea(str, 18).x / 2)
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
  end
  return Point(barPos.x - 69 + barOffset.x * 150, barPos.y + barOffset.y * 50 + 12.5)
end


--[[ Print Function ]]--
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
				if iARAM.misc.misc2 then _AutoupdaterMsg("Moving") end
				if myHero.team == TEAM_BLUE then
					myHero:MoveTo(myHero.x*5,myHero.z*5)
					ChampionBusy = true
				else
					myHero:MoveTo(myHero.x*5,myHero.z*5)
					ChampionBusy = true
				end
				end, 15-GetInGameTimer())
			end
			allyMinions = minionManager(MINION_ALLY, 3000, player, MINION_SORT_HEALTH_DEC)
			allyMinions:update()
			local player = GetMyHero()
				for index, allyminion in pairs(allyMinions.objects) do
					if GetDistance(allyminion, myHero) <= 1600 then
						distance1 = math.random(130,250)
						distance2 = math.random(130,250)
						neg1 = -1 
						neg2 = -1 	
						if (LastTick and (GetInGameTimer() < LastTick + 2)) then return end
							LastTick = GetInGameTimer()	
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
		if howlingAbyssMap == true then
		--Following minions
			allyMinions = minionManager(MINION_ALLY, 3000, player, MINION_SORT_HEALTH_DEC)
			allyMinions:update()
			local player = GetMyHero()
			for index, allyminion in pairs(allyMinions.objects) do
				if GetDistance(allyminion, myHero) <= 3000 then
					if iARAM.misc.misc2 then howling1(str) end
					distance1 = math.random(130,250)
					distance2 = math.random(130,250)
					if ranged == 1 then
						neg1 = -1 
						neg2 = -1 
					else
						neg1 = 1 
						neg2 = 1 
					end
					if (LastTick and (GetInGameTimer() < LastTick + 2)) then return end
						LastTick = GetInGameTimer()						
					if myHero.team == TEAM_BLUE then
						myHero:MoveTo(allyminion.x+distance1*neg1,allyminion.z+distance2*neg2)
						tick = GetTickCount()
						ChampionBusy = true
					else
						myHero:MoveTo(allyminion.x-distance1*neg1,allyminion.z-distance2*neg2)
						tick = GetTickCount()
						ChampionBusy = true
					end
				end
			end
			--Attack enemy minions
			enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
			enemyMinions:update()
			local player = GetMyHero()
			local tick = 0
			local delay = 400
			local myTarget = ts.target
			for index, minion in pairs(enemyMinions.objects) do
			  if GetDistance(minion, myHero) <= (myHero.range + 75) and GetTickCount() > tick + delay then
				local dmg = getDmg("AD", minion, myHero)
				if dmg > minion.health then
				  myHero:Attack(minion)
				  tick = GetTickCount()
				end
			  end
			end

		end			
	end
end

function TowerFollowing()
	FollowTurrets = {}
	if ChampionBusy then return end
	for name, Towers in pairs(GetTurrets()) do
		if Towers ~= nil then
			local enemyTurret = Towers.team ~= player.team
			if GetDistance(Towers) < 100 then
				table.insert(FollowTurrets, {x = Towers.x, y = Towers.y, z = Towers.z, range = Towers.range, color = (enemyTurret and allyTurretColor), visibilityRange = Towers.visibilityRange})
				myHero:MoveTo(Towers.x,Towers.z)
				if iARAM.misc.misc2 then _AutoupdaterMsg("Moving to Tower") end
				
			end
		end
	end
end

function HealthAlly()
	if iARAM.follow and not myHero.dead then
	local champ = player.charName
	local ally = GetPlayer(myHero.team, false, false, myHero, 450, "health")
		if ally ~= nil and ally.health <= ally.maxHealth * (50 / 100) then
			if champ == "Soraka" then
				if myHero:CanUseSpell(_W) == READY then
					if iARAM.misc.misc2 then _AutoupdaterMsg("Healing Ally") end
					CastSpell(_W, ally)
				end
			elseif champ == "Taric" then
					if myHero:CanUseSpell(_Q) == READY then
						if iARAM.misc.misc2 then _AutoupdaterMsg("Healing Ally") end
						CastSpell(_Q, ally)
					end
			elseif champ == "Nami" then 
					if myHero:CanUseSpell(_W) == READY then
						if iARAM.misc.misc2 then _AutoupdaterMsg("Healing Ally") end			
						CastSpell(_W, ally)
					end
					if myHero:CanUseSpell(_E) == READY then
						if iARAM.misc.misc2 then _AutoupdaterMsg("Casting E to Ally") end			
						CastSpell(_E, ally)
					end
			elseif champ == "Sona" then
					if myHero:CanUseSpell(_W) == READY then			
						if iARAM.misc.misc2 then _AutoupdaterMsg("Healing Ally") end
						CastSpell(_W, ally)
					end
					if myHero:CanUseSpell(_E) == READY then			
						if iARAM.misc.misc2 then _AutoupdaterMsg("Casting E to Ally") end
						CastSpell(_E, ally)
					end
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

--[[ TowerRangers Function ]]--

function DrawTowerRange()
	if iARAM.drawing.drawtower and not myHero.dead then
		for i, turret in pairs(drawTurrets) do
			DrawCircle(turret.x, turret.y, turret.z, turret.range, turret.color)
			DrawCircle(turret.x, turret.y, turret.z, turret.visibilityRange, visibilityTurretColor)
		end
	end
end
function TowerRangers()
	drawTurrets = {}
	for name, turret in pairs(GetTurrets()) do
		if turret ~= nil then
			local enemyTurret = turret.team ~= player.team
			if GetDistance(turret) < 2000 then
				table.insert(drawTurrets, {x = turret.x, y = turret.y, z = turret.z, range = turret.range, color = (enemyTurret and enemyTurretColor or allyTurretColor), visibilityRange = turret.visibilityRange})
			end
		end
	end
end

function OnGainTurretFocus(turret, unit)
	if turret and unit and unit.team and unit.team ~= myHero.team and unit.type and unit.type == myHero.type and ValidTarget(unit) and UnderTurret(unit, true) then
		if GetDistanceSqr(unit) <= 1000 then	
		 	if myHero:CanUseSpell(_E) == READY and myHero.charName:lower() ~= "xerath" then
		 		CastE(unit)
		 	end
		end
	end
end

function TFMode()

	KarmaTF()
	KayleTF()
	LuxTF()
	WarwickTF()
	
	champ = player.charName
	Allie = followHero()
	allytofollow = followHero()
	LastTickerless = nil
	LastMoveInTFMode = 1
	if (LastTickerless and (GetInGameTimer() < LastTickerless + 1)) then return end
	LastTickerless = GetInGameTimer()
	LastMoveInTFMode = LastMoveInTFMode * -1	
	if allytofollow ~= nil and GetDistance(allytofollow,myHero) >= 350 then
		--if heroType == 1 then --adc
			distance1 = math.random(250,300)
			distance2 = math.random(250,300)
			neg1 = -1 
			neg2 = -1 				
		if myHero.team == TEAM_BLUE then
			myHero:MoveTo(allytofollow.x-distance1*neg1,allytofollow.z-distance2*neg2)
			--myHero:MoveTo(allytofollow.x,allytofollow.z)
		else
			myHero:MoveTo(allytofollow.x+distance1*neg1,allytofollow.z+distance2*neg2)
			--myHero:MoveTo(allytofollow.x,allytofollow.z)
	end
	end
end

---[[Ahri]]---
function AhriFarm()
local champ = player.charName
	if champ == "Ahri" then
		-- Farm Q 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("Q", minion, myHero) then
					if myHero:CanUseSpell(_Q) == READY then
						CastSpell(_Q, minion)
					end
				end
			end
		end	
	end
end

function AhriCombo()
	if ts.target.visible == true then
		if myHero:CanUseSpell(_E) == READY then CastSpell(_E, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_W) == READY then CastSpell(_W) end
	end
end

---[[Ashe]]---
function AsheFarm()
local champ = player.charName
	if champ == "Ashe" then
		-- Farm W 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
			--myHero:Attack(minion)
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("W", minion, myHero) then
					if myHero:CanUseSpell(_W) == READY then
						--myHero:HoldPosition()
						CastSpell(_W, minion)
					end
				end
			end
		end	
	end
end

function AsheCombo()
local champ = player.charName
	if champ == "Ashe" then
		if ts.target.visible == true then
			if myHero:CanUseSpell(_R) == READY then CastSpell(_R, ts.target.x, ts.target.z) end
			if myHero:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target.x, ts.target.z) end
			if myHero:CanUseSpell(_W) == READY then CastSpell(_W, ts.target.x, ts.target.z) end
		end
	end
end


---[[Caitlyn]]---
function CaitlynFarm()
local champ = player.charName
	if champ == "Caitlyn" then
		-- Farm Q 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
			--myHero:Attack(minion)
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("Q", minion, myHero) then
					if myHero:CanUseSpell(_Q) == READY then
						--myHero:HoldPosition()
						CastSpell(_Q, minion)
					end
				end
			end
		end	
	end
end

function CaitlynCombo()
	if ts.target.visible == true then
		if myHero:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_W) == READY then CastSpell(_W) end
	end
end

---[[Karma]]---
function KarmaFarm()
local champ = player.charName
	if champ == "Karma" then
		-- Farm Q 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
			--myHero:Attack(minion)
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("Q", minion, myHero) then
					if myHero:CanUseSpell(_Q) == READY then
						--myHero:HoldPosition()
						CastSpell(_Q, minion)
					end
				end
			end
		end	
	end
end

function KarmaCombo()
local champ = player.charName
	if champ == "Karma" then
		if ts.target.visible == true then
			if myHero:CanUseSpell(_R) == READY then CastSpell(_R) end
			if myHero:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target.x, ts.target.z) end
			if myHero:CanUseSpell(_W) == READY then CastSpell(_W, ts.target.x, ts.target.z) end
		end
	end
end

function KarmaTF()
local champ = player.charName
local ally = GetPlayer(myHero.team, false, false, myHero, 450, "health")
	if champ == "Karma" then
		if ally ~= nil and ally.health <= ally.maxHealth * (50 / 100) then
			if myHero:CanUseSpell(_E) == READY then			
				if iARAM.misc.misc2 then _AutoupdaterMsg("Casting E to Ally") end
				CastSpell(_E, ally)
			end
		end
	end
end


---[[Kayle]]---
function KayleFarm()
local champ = player.charName
	if champ == "Kayle" then
		-- Farm Q 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("Q", minion, myHero) then
					if myHero:CanUseSpell(_Q) == READY then
						CastSpell(_Q, minion)
					end
				end
			end
		end	
	end
end

function KayleCombo()
	if ts.target.visible == true then
		if myHero:CanUseSpell(_E) == READY then CastSpell(_E) end
		if myHero:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_W) == READY then CastSpell(_W) end
	end
end

function KayleTF()
local champ = player.charName
local ally = GetPlayer(myHero.team, false, false, myHero, 450, "health")
	if champ == "Kayle" then
		if ally ~= nil and ally.health <= ally.maxHealth * (80 / 100) then
			if myHero:CanUseSpell(_W) == READY then			
				if iARAM.misc.misc2 then _AutoupdaterMsg("Casting W to Ally") end
				CastSpell(_W, ally)
			end
		end
		if ally ~= nil and ally.health <= ally.maxHealth * (30 / 100) then
			if myHero:CanUseSpell(_R) == READY then			
				if iARAM.misc.misc2 then _AutoupdaterMsg("Casting R to Ally") end
				CastSpell(_R, ally)
			end
		end
	end
end


---[[Lux]]---
function LuxFarm()
local champ = player.charName
	if champ == "Lux" then
		-- Farm E 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
			--myHero:Attack(minion)
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("E", minion, myHero) then
					if myHero:CanUseSpell(_E) == READY then
						--myHero:HoldPosition()
						CastSpell(_E, minion)
					end
				end
			end
		end	
	end
end

function LuxCombo()
	SkillR = { name = "Final Spark", range = 3340, delay = 1.0, speed = math.huge, width = 190, ready = false }
	rDmg = getDmg("R", ts.target, myHero)
	if ts.target.visible == true then
		if myHero:CanUseSpell(_E) == READY then CastSpell(_E, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_W) == READY and myHero.Health < myHero.Health * (50 / 100) then CastSpell(_W) end
		if myHero:CanUseSpell(_R) == READY	and ts.target.health < rDmg and GetDistance(ts.target) <= SkillR.range then CastSpell(_R, ts.target.x, ts.target.z) end
	end
end

function LuxTF()
local champ = player.charName
local ally = GetPlayer(myHero.team, false, false, myHero, 450, "health")
	if champ == "Lux" then
		if ally ~= nil and ally.health <= ally.maxHealth * (50 / 100) then
			if myHero:CanUseSpell(_E) == READY then			
				if iARAM.misc.misc2 then _AutoupdaterMsg("Casting E to Ally") end
				CastSpell(_E, ally)
			end
		end
	end
end


---[[Morgana]]---
function MorganaFarm()
local champ = player.charName
	if champ == "Morgana" then
		-- Farm W 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
			--myHero:Attack(minion)
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health >= getDmg("W", minion, myHero) then
					if myHero:CanUseSpell(_W) == READY then
						--myHero:HoldPosition()
						CastSpell(_W, minion)
					end
				end
			end
		end	
	end
end

function MorganaCombo()
	if ts.target.visible == true then
		if myHero:CanUseSpell(_E) == READY then CastSpell(_W, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_W) == READY then CastSpell(_E) end
	end
end


---[[Nidalee]]---
function NidaleeFarm()
local champ = player.charName
	if champ == "Nidalee" then
		-- Farm Q 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
			--myHero:Attack(minion)
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("Q", minion, myHero) then
					if myHero:CanUseSpell(_Q) == READY then
						--myHero:HoldPosition()
						CastSpell(_Q, minion)
					end
				end
			end
		end	
	end
end

function NidaleeCombo()
	if ts.target.visible == true then
		if myHero:CanUseSpell(_E) == READY then CastSpell(_E, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_Q) == READY then CastSpell(_Q, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_W) == READY then CastSpell(_W) end
	end
end

function NidaleeTF()
local champ = player.charName
local ally = GetPlayer(myHero.team, false, false, myHero, 450, "health")
	if champ == "Nidalee" then
		if ally ~= nil and ally.health <= ally.maxHealth * (50 / 100) then
			if myHero:CanUseSpell(_E) == READY then			
				if iARAM.misc.misc2 then _AutoupdaterMsg("Casting E to Ally") end
				CastSpell(_E, ally)
			end
		end
	end
end


function NunuCombo()
	if myHero:CanUseSpell(_W) == READY then		
		CastSpell(_W, ts.target)
	end
end

---[[Warwick]]---
function WarwickFarm()
local champ = player.charName
	if champ == "Warwick" then
		-- Farm Q 
		for index,minion in pairs(enemyMinion.objects) do
			if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible then
			--myHero:Attack(minion)
				if minion ~= nil and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health <= getDmg("Q", minion, myHero) then
					if myHero:CanUseSpell(_Q) == READY then
						--myHero:HoldPosition()
						CastSpell(_Q, minion)
					end
				end
			end
		end	
	end
end

function WarwickCombo()
	rDmg = getDmg("R", ts.target, myHero)
	if ts.target.visible == true then
		if myHero:CanUseSpell(_E) == READY then CastSpell(_E, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_Q) == READY and GetDistance(ts.target) <= 100 then CastSpell(_Q, ts.target.x, ts.target.z) end
		if myHero:CanUseSpell(_W) == READY then CastSpell(_W) end
		if myHero:CanUseSpell(_R) == READY	and ts.target.health < rDmg and GetDistance(ts.target) <= 600 then CastSpell(_R, ts.target.x, ts.target.z) end
	end
end

function WarwickTF()
local champ = player.charName
local ally = GetPlayer(myHero.team, false, false, myHero, 450, "health")
	if champ == "Warwick" then
		if ally ~= nil then
			if myHero:CanUseSpell(_W) == READY then			
				if iARAM.misc.misc2 then _AutoupdaterMsg("Casting W") end
				CastSpell(_W)
			end
		end
	end
end



--[[ NotificationLib Function ]]--
class "NotificationLib"
local Length = 276;
local Thickness = 66;
--local Position = {(WINDOW_W*0.995), (WINDOW_H*0.1)}
local Position = {(WINDOW_W*0.58), (WINDOW_H*0.2)}
local Tiles = {}

function DrawNotificationLib()
    local time = 0.5;
    local gameTime = GetGameTimer();

    if tablelength(Tiles) > GetMaxTileCount()
    then
        table.remove(Tiles, 1)
    end

    for i ,v in pairs(Tiles) do

        if v[3] + v[4] + time <= gameTime
        then
            table.remove(Tiles, i)
        end

        v[5] = Position[1];
        v[6] = Position[2] + (Thickness + 6) * (i - 1);

        if time + v[4] >= gameTime
        then
            local percent = ((v[4] + time) - gameTime)/time
            v[5] = Position[1] + Length * percent;
        end

        if v[3] + v[4] <= gameTime and v[3] + v[4] + time > gameTime
        then
            local percent = (gameTime - (v[4]+v[3]))/time;
            v[5] = Position[1] + Length * percent;
        end

        DrawTile(v[5], v[6], v[1], v[2]);
    end
end

function OnWndMsgNotificationLib(msg,wParam)
        if msg ~= 513
        then
            return;
        end

        for i ,v in pairs(Tiles) do
            if CursorisOverBox(v[5], v[6])
            then
                v[3] = GetGameTimer() - v[4];
            end
        end
end

function NotificationLib:AddTile(Header, Text, Duration)
    Tiles[tablelength(Tiles) +1] = {Header, Text, Duration, GetGameTimer(), Position[1], Position[2]}
end

function DrawTile(x, y, header, text)
            local lenghtHeader = GetTextArea(header, 25).x - 240;
            local lenghtContext = GetTextArea(text, 20).x - 250;
            local extraLenght = lenghtHeader > lenghtContext and lenghtHeader or lenghtContext;
            local tileLenght = CursorIsOverTile(x, y) and Length + (extraLenght > 0 and extraLenght or 0) or Length;

	        --Border
            local borderColor = CursorIsOverTile(x, y) and ARGB(255,93,86,58) or ARGB(255*0.5,93,86,58);
            local borderThickness = 4;
            local borderYOffset = (Thickness * 0.5);
            DrawLine(x - tileLenght, y - borderYOffset, x, y - borderYOffset, borderThickness, borderColor);
            DrawLine(x - tileLenght, y + borderYOffset, x, y + borderYOffset, borderThickness, borderColor);
            DrawLine(x - tileLenght + (borderThickness * 0.5), y - borderYOffset + (borderThickness * 0.5), x - tileLenght + (borderThickness * 0.5), y + borderYOffset - (borderThickness * 0.5), borderThickness, borderColor);
            DrawLine(x - (borderThickness * 0.5), y - borderYOffset + (borderThickness * 0.5), x - (borderThickness * 0.5), y + borderYOffset - (borderThickness * 0.5), borderThickness, borderColor);

            --Main
            local mainColor = CursorIsOverTile(x, y) and ARGB(255,12,19,18) or ARGB(255*0.5,12,19,18);
            local mainBorderOffset = (borderThickness*0.5);
            DrawLine(x - tileLenght + borderThickness, y, x - borderThickness, y, Thickness - borderThickness, mainColor);

            --CloseBox
            local boxColor = ARGB(255, 35,65,63);
            local boxHeight = 24;
            local boxWidth = 24;
            local boxYOffset = (Thickness*0.5-boxHeight*0.5);
            if CursorisOverBox(x, y)
            then
                DrawLine(x - boxWidth - borderThickness, y - boxYOffset + mainBorderOffset, x - borderThickness, y - boxYOffset + mainBorderOffset, boxHeight, boxColor);
            end

            --Header
            local headerYOffset = 30;
            local fixedHeader = (not CursorIsOverTile(x, y) and GetTextArea(header, 25).x > 240) and header:sub(1, 20).." ..." or header;
            DrawText(fixedHeader, 25, x - tileLenght + borderThickness*2, y - headerYOffset, ARGB(255, 127, 255, 212));

            --Context
            local contextYOffsetLine1 = 5;
            local fixedContext = (not CursorIsOverTile(x, y) and GetTextArea(text, 20).x > 250) and text:sub(1, 25).." ..." or text;
            DrawText(fixedContext, 20, x - tileLenght + borderThickness*2, y + contextYOffsetLine1, ARGB(255, 250, 235, 215));

            --BoxX
            DrawText("x",33,x - boxWidth, y -boxYOffset*2 +5,ARGB(255,143,188,143))
end

function CursorIsOverTile(posX, posY)
	        local cursor = GetCursorPos();
            local x = posX - cursor.x;
            local y = posY - cursor.y;
            return (x < Length and x > 0) and (y < 30 and y > -45);
end

function CursorisOverBox(posX, posY)
            local cursor = GetCursorPos();
            local x = posX - cursor.x;
            local y = posY - cursor.y;
            return (x < 28 and x > 0) and (y < 24 and y > -10);
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function GetMaxTileCount()
    return round((WINDOW_H / 108), 0)
end