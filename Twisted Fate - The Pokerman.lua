if myHero.charName ~= "TwistedFate" then return end

local version = "2.1"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/SilentStar/BoLScripts/master/Twisted Fate - The Pokerman.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.._ENV.FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#66cc00\">Twisted Fate - The Pokerman.lua:</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/SilentStar/BoLScripts/master/VersionFiles/Twisted Fate - The Pokerman.version")
if ServerData then
ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
if ServerVersion then
if tonumber(version) < ServerVersion then
AutoupdaterMsg("New version available: v"..ServerVersion)
AutoupdaterMsg("Updating, please don't press F9")
DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
else
--
end
end
else
AutoupdaterMsg("Error downloading version info.")
end
end

if _G.Reborn_Loaded then
	return PrintChat("<font color = \"#FFFFFF\">[Twisted Fate] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Please do not use this script with SAC:R, it cancels autoattacks.</font> </font>")
end

--ScriptStatus
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLLRNOLJS") 
--ScriptStatus

local VP = nil

local Ranges = { AA = 525 }
local Skills = {
	SkillQ = {range = 1200, speed = 1500, delay = 0.25, width = 80, HitChance = 2},
	SkillW = {range = 525, speed = math.huge, delay = 0.25, width = 200},
	SkillR = {range = 5500}
}

-- Minions --
targetMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)
jungleMinions = minionManager(MINION_JUNGLE, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)

local CastingUltimate = false

-- Spell damages --

local QDamage = {60, 110, 160, 210, 260}
local QScaling = 0.65
local QAngle = 28 * math.pi / 180
local WDamage = {15, 22.5, 30, 37.5, 45}
local WScaling = 0.5
local EDamage = { 55, 80, 105, 130, 155}
local EScaling = 0.5
local DFG, SHEEN, LICH = nil, nil, nil
local ignite = nil

-- Killable texts and alerts --

local DamageToHeros = {}
local LastAlert = 0
local lastrefresh = 0

-- Card Locking --

local selected = "goldcardlock"
local lastUse = 0
local lastUse2 = 0

function GetCustomTarget()
	ts:update()
	if _G.MMA_GameFileNotification ~= nil and ValidTarget(_G.MMA_Target) then return _G.MMA_ConsideredTarget(1200) end
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then _G.AutoCarry.Crosshair:SetSkillCrosshairRange(1200) return _G.AutoCarry.Crosshair:GetTarget() end
	if _G.MMA_GameFileNotification == nil and not _G.Reborn_Loaded then return ts.target end
	return ts.target
end

function OnLoad()
	print("<font color = \"#FFFFFF\">[Twisted Fate] </font><font color = \"#FF0000\">The Pokerman</font> <font color = \"#fff8e7\">by SilentStar v"..version.."</font>")
	if _G.MMA_GameFileNotification == nil and not _G.Reborn_Loaded then require 'SxOrbWalk' end
	require 'VPrediction'

	TPMConfig = scriptConfig("The Pokerman", "Pokerman")

	TPMConfig:addSubMenu("[TPM] Key Bindings", "KeyBindings")
	TPMConfig.KeyBindings:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	TPMConfig.KeyBindings:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
	TPMConfig.KeyBindings:addParam("PickGold", "Pick Gold Card", SCRIPT_PARAM_ONKEYDOWN, false, 112)
	TPMConfig.KeyBindings:addParam("PickRed", "Pick Red Card", SCRIPT_PARAM_ONKEYDOWN, false, 113)
	TPMConfig.KeyBindings:addParam("PickBlue", "Pick Blue Card", SCRIPT_PARAM_ONKEYDOWN, false, 114)

	TPMConfig:addSubMenu("[TPM] Combo Settings", "ComboSettings")
	TPMConfig.ComboSettings:addParam("QSlider", "Use Q Range", SCRIPT_PARAM_SLICE, 1200, 1000, 1500, 0)
	TPMConfig.ComboSettings:addParam("UseQ", "Use Q in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.ComboSettings:addParam("HitChanceQ", "Use Q if:", SCRIPT_PARAM_LIST, Skills.SkillQ.HitChance, {"Low HitChance", "High HitChance"})
	TPMConfig.ComboSettings:addParam("UseW", "Use W in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.ComboSettings:addParam("SelectCard", "Select card to use in 'Combo'", SCRIPT_PARAM_LIST, 1, {"Smart", "Gold", "Red", "Blue"})
	TPMConfig.ComboSettings:addParam("ManaManager", "Mana Manager (Blue Card) under", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
	TPMConfig.ComboSettings:addParam("UseDFG", "Use DFG in 'Combo'", SCRIPT_PARAM_ONOFF, true)

	TPMConfig:addSubMenu("[TPM] Harass Settings", "HarassSettings")
	TPMConfig.HarassSettings:addParam("UseQ", "Use Q to 'Harass'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.HarassSettings:addParam("UseW", "Use W to 'Harass'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.HarassSettings:addParam("HarassOnly", "Harass with", SCRIPT_PARAM_LIST, 3, {"Gold Card", "Red Card", "Blue Card"})
	TPMConfig.HarassSettings:addParam("AutoHarass", "Auto Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("J"))
	TPMConfig.HarassSettings:addParam("AutoQ", "Auto Q 'Harass'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.HarassSettings:addParam("AutoW", "Auto W 'Harass'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.HarassSettings:addParam("AutoWselect", "Auto Harass with", SCRIPT_PARAM_LIST, 3, {"Gold Card", "Red Card", "Blue Card"})

	TPMConfig:addSubMenu("[TPM] Laneclear Settings", "LaneSettings")
	TPMConfig.LaneSettings:addParam("Laneclear", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
	TPMConfig.LaneSettings:addParam("UseQ", "Use Q in 'Laneclear'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.LaneSettings:addParam("UseW", "Use W in 'Laneclear'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.LaneSettings:addParam("SelectCard", "Select card to use in 'Laneclear'", SCRIPT_PARAM_LIST, 1, {"Smart", "Only Red", "Only Blue"})
	TPMConfig.LaneSettings:addParam("ManaManager", "Mana Manager (Blue Card) under", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
	TPMConfig.LaneSettings:addParam("ManaManager2", "Do not use (Wild Cards) under", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)

	TPMConfig:addSubMenu("[TPM] Jungleclear Settings", "JungleSettings")
	TPMConfig.JungleSettings:addParam("Jungleclear", "Jungleclear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
	TPMConfig.JungleSettings:addParam("UseQ", "Use Q in 'Jungleclear'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.JungleSettings:addParam("UseW", "Use W in 'Jungleclear'", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.JungleSettings:addParam("SelectCard", "Select card to use in 'Jungleclear'", SCRIPT_PARAM_LIST, 1, {"Smart", "Only Red", "Only Blue"})
	TPMConfig.JungleSettings:addParam("ManaManager", "Mana Manager (Blue Card) under", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)
	TPMConfig.JungleSettings:addParam("ManaManager2", "Do not use (Wild Cards) under", SCRIPT_PARAM_SLICE, 40, 0, 100, 0)

	--TPMConfig:addSubMenu("[TPM] Special Settings", "SPSettings")
	--TPMConfig.SPSettings:addParam("PingKillable", "Ping killable enemies", SCRIPT_PARAM_ONOFF, true)
	--TPMConfig.SPSettings:addParam("KillableRange", "Ping range", SCRIPT_PARAM_SLICE, 9000, 2000, 10000, 0)

	TPMConfig:addSubMenu("[TPM] Ultimate Settings", "UltSettings")
	TPMConfig.UltSettings:addParam("AutoSelect", "Auto Pick Card when casting ultimate", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.UltSettings:addParam("SelectCard", "Select Card", SCRIPT_PARAM_LIST, 1, {"Gold", "Red", "Blue"})

	TPMConfig:addSubMenu("[TPM] Killsteal Settings", "KSSettings")
	TPMConfig.KSSettings:addParam("KSIgnite", "Killsteal with Ignite", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.KSSettings:addParam("KSQ", "Killsteal with Q", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.KSSettings:addParam("KSDFG", "Killsteal with DFG", SCRIPT_PARAM_ONOFF, true)

	TPMConfig:addSubMenu("[TPM] Draw Settings", "DrawSettings")
	TPMConfig.DrawSettings:addParam("DrawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.DrawSettings:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.DrawSettings:addParam("DrawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.DrawSettings:addParam("DrawRmap", "Draw R Range on Minimap", SCRIPT_PARAM_ONOFF, true)

	TPMConfig:addSubMenu("[TPM] Permashow Settings", "PSSettings")
	TPMConfig.PSSettings:addParam("permashow", "Enable/Disable ALL", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.PSSettings:addParam("permashow1", "Combo (Permashow)", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.PSSettings:addParam("permashow2", "Harass (Permashow)", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.PSSettings:addParam("permashow3", "Auto Harass Toggle (Permashow)", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.PSSettings:addParam("permashow4", "Pick Gold Card (Permashow)", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.PSSettings:addParam("permashow5", "Pick Red Card (Permashow)", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.PSSettings:addParam("permashow6", "Pick Blue Card (Permashow)", SCRIPT_PARAM_ONOFF, true)
	--TPMConfig.PSSettings:addParam("permashow7", "Ping Killable Enemies (Permashow)", SCRIPT_PARAM_ONOFF, true)
	--TPMConfig.PSSettings:addParam("permashow8", "Ping Killable Enemies Range (Permashow)", SCRIPT_PARAM_ONOFF, true)
	TPMConfig.PSSettings:addParam("WarningSpace", "-------------------------------------------------------------------", 5, "")
	TPMConfig.PSSettings:addParam("Warning", "Warning: All changes requires 'Reload'", 5, "")

	TPMConfig:addSubMenu("[TPM] Target Selector", "TSet")

	TPMConfig:addParam("Space","", 5, "")
	TPMConfig:addParam("Author","Author: SilentStar", 5, "")
	TPMConfig:addParam("Version","Version: "..version.."", 5, "")

	VP = VPrediction()

    -- Target Selector Part --
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1200, DAMAGE_PHYSICAL)
    ts.name = "Focus"
	TPMConfig.TSet:addTS(ts)

    -- Orbwalker Check
	if _G.MMA_GameFileNotification ~= nil then
		PrintChat("<font color = \"#FFFFFF\">[Twisted Fate] </font><font color = \"#FF0000\">MMA Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
	elseif _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Twisted Fate] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
	else
		PrintChat("<font color = \"#FFFFFF\">[Twisted Fate] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		TPMConfig:addSubMenu("[TPM] Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(TPMConfig.SxOrb)
	end

	-- Ignite Check --

	IgniteCheck()
	
	-- Permashow Part --
	if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow1 then TPMConfig.KeyBindings:permaShow("Combo") end
	if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow2 then TPMConfig.KeyBindings:permaShow("Harass") end
	if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow3 then TPMConfig.HarassSettings:permaShow("AutoHarass") end
	if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow4 then TPMConfig.KeyBindings:permaShow("PickGold") end
	if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow5 then TPMConfig.KeyBindings:permaShow("PickRed") end
	if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow6 then TPMConfig.KeyBindings:permaShow("PickBlue") end
	--if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow7 then TPMConfig.SPSettings:permaShow("PingKillable") end
	--if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow8 then TPMConfig.SPSettings:permaShow("KillableRange") end

	--if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow11 then TPMConfig.SPSettings:permaShow("GapCloser") end
	--if TPMConfig.PSSettings.permashow and TPMConfig.PSSettings.permashow12 then TPMConfig.SPSettings:permaShow("Interrupt") end



end

function OnTick()
	Target = GetCustomTarget()

	DFG, SHEEN, LICH = GetInventorySlotItem(3128) and GetInventorySlotItem(3128) or 0, GetInventorySlotItem(3057) and GetInventorySlotItem(3057) or 0, GetInventorySlotItem(3100) and GetInventorySlotItem(3100) or 0
	
	targetMinions:update()
	jungleMinions:update()

	Skills.SkillQ.range = TPMConfig.ComboSettings.QSlider

	--Spells--

	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	Ranges.AA = myHero.range

	if TPMConfig.LaneSettings.Laneclear then
		Laneclear()
	end

	if TPMConfig.JungleSettings.Jungleclear then
		Jungleclear()
	end

	if TPMConfig.KeyBindings.Combo then
		if WREADY and ValidTarget(Target) then
			if TPMConfig.ComboSettings.SelectCard == 1 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
				local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(Target, 0, 80, 600, 2000, myHero)
				if nTargets >= 2 then
					selected = "redcardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				elseif (myHero.mana / myHero.maxMana > TPMConfig.ComboSettings.ManaManager /100) then
					selected = "goldcardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				elseif (myHero.mana / myHero.maxMana < TPMConfig.ComboSettings.ManaManager /100) then
					selected = "bluecardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				end
			elseif TPMConfig.ComboSettings.SelectCard == 2 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
				selected = "goldcardlock"
				if GetDistance(Target, myHero) <= 800 then
					CastSpell(_W)
				end
				lastUse = GetTickCount()
			elseif TPMConfig.ComboSettings.SelectCard == 3 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
				selected = "redcardlock"
				if GetDistance(Target, myHero) <= 800 then
					CastSpell(_W)
				end
				lastUse = GetTickCount()
			elseif TPMConfig.ComboSettings.SelectCard == 4 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
				selected = "bluecardlock"
				if GetDistance(Target, myHero) <= 800 then
					CastSpell(_W)
				end
				lastUse = GetTickCount()
			end

			if selected then
				if Target ~= nil then
					if (DFG ~= 0) and (myHero:CanUseSpell(DFG)==READY) and TPMConfig.ComboSettings.UseDFG then
						CastSpell(DFG, Target)
					end
				end
			end
		end

		if QREADY and ValidTarget(Target) and GetDistance(Target, myHero) and TargetHaveBuff("stun", Target) then
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(Target, 0, 80, 600, 2000, myHero)
			if nTargets >= 1 then
				if GetDistance(Target, myHero) <= Skills.SkillQ.range then
					CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
				end
			end
		elseif QREADY and ValidTarget(Target) and GetDistance(Target, myHero) then
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(Target, 0, 80, 600, 2000, myHero)
			if nTargets >= 1 and MainTargetHitChance >= 3 then
				if GetDistance(Target, myHero) <= Skills.SkillQ.range then
					CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
				end
			end
		end
	end

		if TPMConfig.KeyBindings.Harass then
			if QREADY and TPMConfig.HarassSettings.UseQ then
				if ValidTarget(Target) and GetDistance(Target, myHero) then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(Target, 0, 80, 600, 2000, myHero)
					if nTargets >= 1 and MainTargetHitChance >= 2 then
						if GetDistance(Target, myHero) <= Skills.SkillQ.range then
							CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
						end
					end
				end
			end

			if WREADY and TPMConfig.HarassSettings.UseW and ValidTarget(Target) then
				if TPMConfig.HarassSettings.HarassOnly == 1 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "goldcardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				elseif TPMConfig.HarassSettings.HarassOnly == 2 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "redcardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				elseif TPMConfig.HarassSettings.HarassOnly == 3 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "bluecardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				end
			end
		end

		if TPMConfig.HarassSettings.AutoHarass then
			if QREADY and TPMConfig.HarassSettings.AutoQ and ValidTarget(Target) then
				if GetDistance(Target, myHero) then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(Target, 0, 80, 600, 2000, myHero)
					if nTargets >= 1 and MainTargetHitChance >= 2 then
						if GetDistance(Target, myHero) <= Skills.SkillQ.range then
							CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
						end
					end
				end
			end

			if WREADY and TPMConfig.HarassSettings.AutoW and ValidTarget(Target) then
				if TPMConfig.HarassSettings.AutoWselect == 1 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "goldcardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				elseif TPMConfig.HarassSettings.AutoWselect == 2 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "redcardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				elseif TPMConfig.HarassSettings.AutoWselect == 3 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "bluecardlock"
					if GetDistance(Target, myHero) <= 800 then
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				end
			end
		end

		-- Usages --
		if ValidTarget(Target) then
			if TPMConfig.KSSettings.KSIgnite then
				AutoIgnite(Target)
			end
		end

		if ValidTarget(Target) then
			if TPMConfig.KSSettings.KSQ then
				AutoQKS(Target)
			end
		end

		if ValidTarget(Target) then
			if TPMConfig.KSSettings.KSDFG then
				AutoDFGKS(Target)
			end
		end


	--[[if TPMConfig.SPSettings.PingKillable then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) and GetDistance(enemy, myHero) <= TPMConfig.SPSettings.KillableRange then
				if (enemy.health < ComboDamage(enemy)) and ((GetTickCount() - LastAlert) > 30000) and myHero.level >= 6 and RREADY then
					PrintAlert(""..enemy.charName.." is killable", 3, 255, 0, 0, nil)
					LastAlert = GetTickCount()
					for i = 1, 3 do
						DelayAction(RecPing,  1000 * 0.3 * i/1000, {enemy.x, enemy.z})
					end
				end
			end
		end
	end--]]

	WREADY = (myHero:CanUseSpell(_W) == READY)
	if WREADY and GetTickCount()-lastUse <= 2300 then
		if myHero:GetSpellData(_W).name == selected then CastSpell(_W) end
	end

	if WREADY and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then 
		if TPMConfig.KeyBindings.PickGold then selected = "goldcardlock"
		elseif TPMConfig.KeyBindings.PickBlue then selected = "bluecardlock"
		elseif TPMConfig.KeyBindings.PickRed then selected = "redcardlock"
		else return end	
		CastSpellEx(_W)
		lastUse = GetTickCount()
	end
end

function OnDraw()
	if TPMConfig.DrawSettings.DrawQ and QREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillQ.range, 0xFF008000)
	elseif TPMConfig.DrawSettings.DrawQ and not QREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillQ.range, 0xFFFF0000)
	end

	if TPMConfig.DrawSettings.DrawAA and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.AA, 0xFF008000)
	end

	if TPMConfig.DrawSettings.DrawR and RREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillR.range, 0xFF008000)
	end

	if TPMConfig.DrawSettings.DrawRmap and RREADY and not myHero.dead then
		DrawCircleMinimap(myHero.x, myHero.y, myHero.z, Skills.SkillR.range)
	end
end

function ComboDamage(target)
	local magicdamage = 0
	local phdamage = 0
	local truedamage = 0
	if DFG ~= 0 and (myHero:CanUseSpell(DFG)==READY) then
		m = 1.2
		truedamage = truedamage + myHero:CalcMagicDamage(target, target.maxHealth *0.15)
	else
		m = 1
	end
	if SHEEN ~= 0 then
		phdamage = phdamage + myHero.totalDamage - myHero.addDamage
	end
	
	if LICH ~= 0 then
		magicdamage  = magicdamage + 0.75 * (myHero.totalDamage - myHero.addDamage) + 0.5 * myHero.ap
	end
	
	if (myHero:GetSpellData(_Q).level ~= 0)  and myHero:CanUseSpell(_Q) == READY  then
		magicdamage = magicdamage + QDamage[myHero:GetSpellData(_Q).level]  + QScaling * myHero.ap
	end
	
	if (myHero:GetSpellData(_W).level ~= 0) and myHero:CanUseSpell(_W) == READY then
		magicdamage = magicdamage + WDamage[myHero:GetSpellData(_W).level]  + WScaling * myHero.ap + myHero.totalDamage
	end
	
	if (myHero:GetSpellData(_E).level ~= 0)  then
		magicdamage = magicdamage + EDamage[myHero:GetSpellData(_E).level]  + EScaling * myHero.ap
	end
	phdamage = myHero.totalDamage
	
	if (ignite ~= nil) and myHero:CanUseSpell(ignite) == READY then
		truedamage = truedamage + 50 + 20 * myHero.level
	end
	
	return m * myHero:CalcMagicDamage(target, magicdamage) + myHero:CalcDamage(target, phdamage) + truedamage
end

function AutoIgnite(Target)
	if Target.health <= getDmg("IGNITE", Target, myHero) and GetDistance(Target) <= 600 and ignite ~= nil then
		if IREADY then 
			CastSpell(ignite, Target)
		end
	end
end

function AutoQKS(Target)
	if Target.health <= getDmg("Q", Target, myHero) and GetDistance(Target) <= Skills.SkillQ.range then
		if QREADY then 
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(Target, 0, 80, 600, 2000, myHero)
			if nTargets >= 1 and MainTargetHitChance >= 2 then
				if GetDistance(Target, myHero) <= Skills.SkillQ.range then
					CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
				end
			end
		end
	end
end

function AutoDFGKS(Target)
	if Target.health <= getDmg("DFG", Target, myHero) then
		if (DFG ~= 0) and (myHero:CanUseSpell(DFG)==READY) then
			CastSpell(DFG, Target)
		end
	end
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
			ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
			ignite = SUMMONER_2
	end
end

function Laneclear()
	for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then
			if TPMConfig.LaneSettings.UseQ and QREADY then
				local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(targetMinion, 0, 80, 600, 2000, myHero)
				if nTargets >= 1 and (myHero.mana / myHero.maxMana > TPMConfig.LaneSettings.ManaManager2 /100) then
					if GetDistance(targetMinion, myHero) <= Skills.SkillQ.range then
						CastSpell(_Q, targetMinion.x, targetMinion.z)
					end
				end
			end

    		if TPMConfig.LaneSettings.UseW and WREADY then
    			if TPMConfig.LaneSettings.SelectCard == 1 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(targetMinion, 0, 80, 600, 2000, myHero)
					if nTargets >= 1 and (myHero.mana / myHero.maxMana > TPMConfig.LaneSettings.ManaManager /100) then
						selected = "redcardlock"
						if GetDistance(targetMinion, myHero) <= 800 then
							CastSpell(_W, targetMinion.x, targetMinion.z)
						end
						lastUse = GetTickCount()
					elseif (myHero.mana / myHero.maxMana < TPMConfig.LaneSettings.ManaManager /100) then
						selected = "bluecardlock"
						if GetDistance(targetMinion, myHero) <= 800 then
							CastSpell(_W, targetMinion.x, targetMinion.z)
						end
						lastUse = GetTickCount()
					end
				elseif TPMConfig.LaneSettings.SelectCard == 2 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "redcardlock"
					if GetDistance(targetMinion, myHero) <= 800 then
						CastSpell(_W, targetMinion.x, targetMinion.z)
					end
					lastUse = GetTickCount()
				elseif TPMConfig.LaneSettings.SelectCard == 3 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "bluecardlock"
					if GetDistance(targetMinion, myHero) <= 800 then
						CastSpell(_W, targetMinion.x, targetMinion.z)
					end
					lastUse = GetTickCount()
				end
			end
    	end
    end
end

function Jungleclear()
	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil then
			if TPMConfig.JungleSettings.UseQ then
				local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(jungleMinion, 0, 80, 600, 2000, myHero)
				if nTargets >= 1 and (myHero.mana / myHero.maxMana > TPMConfig.JungleSettings.ManaManager2 /100) then
					if GetDistance(jungleMinion, myHero) <= Skills.SkillQ.range then
						CastSpell(_Q, jungleMinion.x, jungleMinion.z)
					end
				end
			end

			if TPMConfig.JungleSettings.UseW and WREADY then
				if TPMConfig.JungleSettings.SelectCard == 1 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(jungleMinion, 0, 80, 600, 2000, myHero)
					if nTargets >= 1 and (myHero.mana / myHero.maxMana > TPMConfig.JungleSettings.ManaManager /100) then
						selected = "redcardlock"
						if GetDistance(jungleMinion, myHero) <= 800 then
							CastSpell(_W, jungleMinion.x, jungleMinion.z)
						end
						lastUse = GetTickCount()
					elseif (myHero.mana / myHero.maxMana < TPMConfig.LaneSettings.ManaManager /100) then
						selected = "bluecardlock"
						if GetDistance(jungleMinion, myHero) <= 800 then
							CastSpell(_W, jungleMinion.x, jungleMinion.z)
						end
						lastUse = GetTickCount()
					end
				elseif TPMConfig.JungleSettings.SelectCard == 2 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "redcardlock"
					if GetDistance(jungleMinion, myHero) <= 800 then
						CastSpell(_W, jungleMinion.x, jungleMinion.z)
					end
					lastUse = GetTickCount()
				elseif TPMConfig.JungleSettings.SelectCard == 3 and myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					selected = "bluecardlock"
					if GetDistance(jungleMinion, myHero) <= 800 then
						CastSpell(_W, jungleMinion.x, jungleMinion.z)
					end
					lastUse = GetTickCount()
				end
			end
		end
	end
end

function OnProcessSpell(unit, spell)
	if unit.isMe then
		if spell.name == "destiny" then
			CastingUltimate = true
		elseif spell.name == "gate" then 
			CastingUltimate = false
			if WREADY and TPMConfig.UltSettings.AutoSelect then
				if myHero:GetSpellData(_W).name == "PickACard" and GetTickCount()-lastUse2 >= 2400 and GetTickCount()-lastUse >= 500 then
					if TPMConfig.UltSettings.SelectCard == 1 then
						selected = "goldcardlock"
						CastSpell(_W)
					elseif TPMConfig.UltSettings.SelectCard == 2 then
						selected = "redcardlock"
						CastSpell(_W)
					elseif TPMConfig.UltSettings.SelectCard == 3 then
						selected = "bluecardlock"
						CastSpell(_W)
					end
					lastUse = GetTickCount()
				end
			end
		end
	end
end
