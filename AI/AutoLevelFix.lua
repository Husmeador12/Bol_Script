local abilitySequence
local ini=false
local _autoLevel = { spellsSlots = { SPELL_1, SPELL_2, SPELL_3, SPELL_4 }, levelSequence = {}, nextUpdate = 0, tickUpdate = 5 }
local __autoLevel__OnTick
local rOFF=0



function OnTick()
		if ini then
			AutoLevel()
		end
end



function AutoLevel()
	autoLevelSetSequenceCustom(abilitySequence)
end

 function CarryRon()
    local sequence1, sequence2 = Menu.sequenceSpells, Menu.sequenceSpells2
		  ini = true
if sequence1 == 1 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
                           
elseif sequence1 == 2 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
                           
elseif sequence1 == 3 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
                           
elseif sequence1 == 4 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
                           
elseif sequence1 == 5 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
                           
elseif sequence1 == 6 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 5 then abilitySequence = { 3, 2, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
end
end

 function CarryRoff()
    local sequence1, sequence2 = Menu.sequenceSpells, Menu.sequenceSpells2
		  ini = true
 if sequence1 == 1 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
elseif sequence1 == 1 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
                           
elseif sequence1 == 2 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
elseif sequence1 == 2 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
                           
elseif sequence1 == 3 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
elseif sequence1 == 3 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
                           
elseif sequence1 == 4 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
elseif sequence1 == 4 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
                           
elseif sequence1 == 5 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 5 then abilitySequence = { 3, 2, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
elseif sequence1 == 5 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
                           
elseif sequence1 == 6 and sequence2 == 1 then abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 2 then abilitySequence = { 1, 3, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 3 then abilitySequence = { 2, 1, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 4 then abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 5 then abilitySequence = { 3, 2, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
elseif sequence1 == 6 and sequence2 == 6 then abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
end
end

local function autoLevel__OnLoad()
    if not __autoLevel__OnTick then
        function __autoLevel__OnTick()
            local tick = os.clock()
            if _autoLevel.nextUpdate > tick then return end
            _autoLevel.nextUpdate = tick + Menu.DelayTime
            local realLevel = rOFF + GetHeroLeveled()
            if player.level > realLevel and _autoLevel.levelSequence[realLevel + 1] ~= nil then
                local splell = _autoLevel.levelSequence[realLevel + 1]
                if splell == 0 and type(_autoLevel.onChoiceFunction) == "function" then splell = _autoLevel.onChoiceFunction() end
                if type(splell) == "number" and splell >= 1 and splell <= 4 then LevelSpell(_autoLevel.spellsSlots[splell]) end
            end
        end

        AddTickCallback(__autoLevel__OnTick)
    end
end

function autoLevelSetSequenceCustom(sequence1, sequence2)
    assert(sequence1, sequence2 == nil or type(sequence1, sequence2) == "table", "autoLevelSetSequence : wrong argument types (<table> or nil expected)")
    autoLevel__OnLoad()
    local sequence1, sequence2 = sequence1, sequence2 or {}
    for i = 1, 18 do
        local spell = sequence1[i], sequence2[i]
        if type(spell) == "number" and spell >= 0 and spell <= 4 then
            _autoLevel.levelSequence[i] = spell
        end
    end
end

function RLoad()
	if player.charName == "Jayce" 
	or player.charName == "Elise" 
	or player.charName == "Karma" 
	or player.charName == "Nidalee" then
		rOFF=-1
	else
		rOFF=0
	end
end

function OnLoad()
	
	Menu = scriptConfig("["..myHero.charName.." - AutoLevel]", player.charName.."AutoLevel")
	Menu:addParam("sep1", "1 - Change for Humanizer "..myHero.charName, SCRIPT_PARAM_INFO, "")
	Menu:addParam("DelayTime", "Humanizer Time", SCRIPT_PARAM_SLICE, 1, 1, 60, 0)
	Menu:addParam("sep2", "2 - Define Sequence for "..myHero.charName, SCRIPT_PARAM_INFO, "")
	Menu:addParam("sequenceSpells2", "First 3", SCRIPT_PARAM_LIST, 1, { 'Q-W-E', 'Q-E-W', 'W-Q-E', 'W-E-Q', 'E-W-Q', 'E-Q-W' })
	Menu:addParam("sequenceSpells", "Sequence Spells", SCRIPT_PARAM_LIST, 1, { 'R-Q-W-E', 'R-Q-E-W', 'R-W-Q-E', 'R-W-E-Q', 'R-E-W-Q', 'R-E-Q-W' })
	Menu:addParam("sep3", "3 - for load Script... ", SCRIPT_PARAM_INFO, "")
	Menu:addParam("start", "Just Press Key ", SCRIPT_PARAM_ONKEYDOWN, false, 76)
	
	RLoad()
	
end

_G.LevelSpell = function(id)
  local offsets = { 
    [_Q] = 0xB8,
    [_W] = 0xBA,
    [_E] = 0x79,
    [_R] = 0x7B,
  }
  local p = CLoLPacket(0x0050)
  p.vTable = 0xF38DAC
  p:EncodeF(myHero.networkID)
  p:Encode1(offsets[id])
  p:Encode1(0x3C)
  for i = 1, 4 do p:Encode1(0xF6) end
  for i = 1, 4 do p:Encode1(0x5E) end
  for i = 1, 4 do p:Encode1(0xE0) end
  p:Encode1(0x24)
  p:Encode1(0xF1)
  p:Encode1(0x27)
  p:Encode1(0x00)
  SendPacket(p)
end
