local FolderOfSprites = { }
local updated = false



-- Made by Nebelwolfi to make classes local and not global
function Class(name)
    _ENV[name] = { }
    _ENV[name].__index = _ENV[name]
    local mt = { __call = function(self, ...) local b = { } setmetatable(b, _ENV[name]) b:__init(...) return b end }
    setmetatable(_ENV[name], mt)
end

DelayAction( function() if not _G.iARAMLoaded then iARAM() end end, 0.05)

class "iARAM"
function iARAM:__init(cfg)
    if _G.iARAMLoaded then return end
    _G.givenConfig = cfg
    _G.iARAMLoaded = true
    self:ActualOnLoad()
    AddMsgCallback( function(a, b) self:WndMsg(a, b) end)
    AddDrawCallback( function() self:Draw() end)
    AddUnloadCallback( function() self:Unload() end)
end


function iARAM:ActualOnLoad()
    _Tech:LoadSprites()
    _Tech:LoadMenu()
end


function iARAM:Draw()
    if not _Tech.Conf then return end
    if updated == false then return end
    if _Tech.Conf.TimeSettings.TimeOn then _Draw:Time() end --timer in the left top
end

function iARAM:WndMsg(a, b)
    if not _Tech.Conf then return end
    if _Tech.Conf.SpriteSettings.UpdateSprites and updated == true then
        _Tech:AddPrint("Loaded sprites.")
        _Tech:ReloadSprites()
        _Tech.Conf.SpriteSettings.UpdateSprites = false
    end
end

function iARAM:Unload()
    for i = 1, #FolderOfSprites do
        FolderOfSprites[i]:Release();
    end
end


Class("_Tech")
function _Tech:LoadMenu()
    self.Conf = givenConfig or scriptConfig("Loqueseve", "AwarenessMenu")

    self.Conf:addSubMenu("> Time/Date", "TimeSettings")
    self.Conf.TimeSettings:addParam("TimeOn", "Show real time and date", SCRIPT_PARAM_ONOFF, false)
    self.Conf.TimeSettings:addParam("WidthPos", "Horizontal position", SCRIPT_PARAM_SLICE, 10, 1,(WINDOW_W - 250), 0)
    self.Conf.TimeSettings:addParam("HeighthPos", "Vertical position", SCRIPT_PARAM_SLICE, 10, 1, WINDOW_H, 0)
    self.Conf.TimeSettings:addParam("textSize", "Text size", SCRIPT_PARAM_SLICE, 16, 1, 30, 0)
	
    self.Conf:addSubMenu("> Sprites", "SpriteSettings")
    self.Conf.SpriteSettings:addParam("UpdateSprites", "Reload sprites", SCRIPT_PARAM_ONOFF, false)


end

function _Tech:AddPrint(msg)
    print("<font color = \"#0078FF\">iARAM </font><font color = \"#FFFFFF\">" .. msg .. "</font>")
end

function _Tech:RenameSums(str)
    local summoners = {
        ["summonerhaste"] = 1,
        ["summonerflash"] = 2,
    }
    return summoners[str] or 1
end

function _Tech:LoadSprites()
    updated = false
	--Which folder we want to create.
    for _, k in pairs( { "", "Summoner_spells" }) do
        if not DirectoryExist(SPRITE_PATH .. "iARAM//" .. k) then
            CreateDirectory(SPRITE_PATH .. "iARAM//" .. k)
        end
    end
    self:LoadOtherSprites()
end

function _Tech:LoadOtherSprites()
    -- Load icons
    for i = 1, 2 do
        -- We have 2 sprites so we run it 2 times
        if FileExist(SPRITE_PATH .. "iARAM//Summoner_spells//" .. i .. ".png") then
            table.insert(FolderOfSprites, createSprite(SPRITE_PATH .. "\\iARAM\\Summoner_spells\\" .. i .. ".png"))
        else
            self:AddPrint("Downloading missing sprite in folder: Summoner_spells " .. i .. " / 2, DO NOT RELOAD THE SCRIPT!")
            DownloadFile("https://raw.githubusercontent.com/Husmeador12/Bol_Script/master/Sprites/" .. i .. ".png?no-cache=" .. math.random(1, 25000), SPRITE_PATH .. "iARAM//Summoner_spells//" .. i .. ".png", function() DelayAction( function() self:LoadOtherSprites() end, 0.15) end)
            FolderOfSprites = { }
            return;
        end
    end
    updated = true
end

function _Tech:ReloadSprites()
    if updated == false then return end
    for i = 1, #FolderOfSprites do
        FolderOfSprites[i]:Release();
    end
    FolderOfSprites = { }
    self:LoadSprites()
end


Class("_Draw")
function _Draw:Time()
    local currentDate = os.date("%c")
    DrawText("" .. currentDate, _Tech.Conf.TimeSettings.textSize, _Tech.Conf.TimeSettings.WidthPos, _Tech.Conf.TimeSettings.HeighthPos, 0xFFFFFFFF)
	FolderOfSprites[1]:Draw(900, 700, 255)
end

