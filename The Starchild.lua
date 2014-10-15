--------------------------------------------------------------------------------------------------------------------------------------------------
--																																			  	--
--	___________.__               _________ __                       .__    .__.__       .___ 													--
--	\__    ___/|  |__   ____    /   _____//  |______ _______   ____ |  |__ |__|  |    __| _/													--
--	  |    |   |  |  \_/ __ \   \_____  \\   __\__  \\_  __ \_/ ___\|  |  \|  |  |   / __ | 													--
--	  |    |   |   Y  \  ___/   /        \|  |  / __ \|  | \/\  \___|   Y  \  |  |__/ /_/ | 													--
--	  |____|   |___|  /\___  > /_______  /|__| (____  /__|    \___  >___|  /__|____/\____ | 													--
--	                \/     \/          \/           \/            \/     \/              \/ 													--
--	___.             _________.__.__                 __   _________ __                      													--
--	\_ |__ ___.__.  /   _____/|__|  |   ____   _____/  |_/   _____//  |______ _______       													--
--	 | __ <   |  |  \_____  \ |  |  | _/ __ \ /    \   __\_____  \\   __\__  \\_  __ \      													--
--	 | \_\ \___  |  /        \|  |  |_\  ___/|   |  \  | /        \|  |  / __ \|  | \/      													--
--	 |___  / ____| /_______  /|__|____/\___  >___|  /__|/_______  /|__| (____  /__|         													--
--	     \/\/              \/              \/     \/            \/           \/             													--
--------------------------------------------------------------------------------------------------------------------------------------------------

if myHero.charName ~= "Soraka" then return end
local version = "1.5"
local AUTOUPDATE = true
local SCRIPT_NAME = "The Starchild"
local SOURCELIB_URL = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"
local SOURCELIB_PATH = LIB_PATH.."SourceLib.lua"
if FileExist(SOURCELIB_PATH) then
	require("SourceLib")
else
	DOWNLOADING_SOURCELIB = true
	DownloadFile(SOURCELIB_URL, SOURCELIB_PATH, function() print("Required libraries downloaded successfully, please reload") end)
end
if DOWNLOADING_SOURCELIB then print("Downloading required libraries, please wait...") return end
if AUTOUPDATE then
SourceUpdater(SCRIPT_NAME, version, "raw.github.com", "/SilentStar/BoLScripts/master/"..SCRIPT_NAME..".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/SilentStar/BoLScripts/master/VersionFiles/"..SCRIPT_NAME..".version"):CheckUpdate()
end
local RequireI = Require("SourceLib")
RequireI:Add("VPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireI:Add("SOW", "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
RequireI:Check()
if RequireI.downloadNeeded == true then return end

--------------------------------------------------------------------------------------------------------------------------------------------------

local Ranges = { AA = 550 }
local Skills = {
    
    SkillQ = {name = myHero:GetSpellData(_Q).name, range = 975, delay = 0.5, speed = 1500, width = 110},
	
	SkillW = {name = myHero:GetSpellData(_W).name, range = 450, delay = 0.5, speed = 1000, width = 0},
	
	SkillE = {name = myHero:GetSpellData(_E).name, range = 925, delay = 0.5, speed = 2000, width = 25},
	
	SkillR = {name = myHero:GetSpellData(_R).name, delay = 0.5}
}

--------------------------------------------------------------------------------------------------------------------------------------------------

local isSAC = false
local isMMA = false
local Target = nil
local LastSkin = 0

--------------------------------------------------------------------------------------------------------------------------------------------------

	function GetCustomTarget()
		ts:update()
		if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
		if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
		return ts.target
	end

	function OnLoad()
		UpdateWeb(true, ScriptName, id, HWID)
		if _G.ScriptLoaded then	return end
		_G.ScriptLoaded = true
		initComponents()
	end

	function initComponents()
		SCConfig = scriptConfig("The Starchild", "Soraka")

		SCConfig:addSubMenu("[SC] Key Bindings", "Keys")
			SCConfig.Keys:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			SCConfig.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))

		SCConfig:addSubMenu("[SC] Combo Settings", "CSet")
			SCConfig.CSet:addParam("UseQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
			SCConfig.CSet:addParam("UseE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)

		SCConfig:addSubMenu("[SC] Harass Settings", "HSet")
			SCConfig.HSet:addParam("UseQ", "Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
			SCConfig.HSet:addParam("UseE", "Use E in Harass", SCRIPT_PARAM_ONOFF, true)

		SCConfig:addSubMenu("[SC] Killsteal Settings", "KSSet")
			SCConfig.KSSet:addParam("KSQ", "Killsteal with Q", SCRIPT_PARAM_ONOFF, false)
			SCConfig.KSSet:addParam("KSE", "Killsteal with E", SCRIPT_PARAM_ONOFF, false)

		SCConfig:addSubMenu("[SC] Heal Settings", "HealSet")
			SCConfig.HealSet:addParam("UseHeal", "Auto Heal Allies", SCRIPT_PARAM_ONOFF, true)
			SCConfig.HealSet:addParam("HealManager", "Heal allies under", SCRIPT_PARAM_SLICE, 65, 0, 100, 0)
			SCConfig.HealSet:addParam("HPManager", "Don't heal under (my hp)", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

		SCConfig:addSubMenu("[SC] Ultimate Settings", "UltSet")
			SCConfig.UltSet:addParam("UseUlt", "Auto Ultimate Usage", SCRIPT_PARAM_ONOFF, true)
			SCConfig.UltSet:addParam("UltCast", "Auto Ultimate On: ", SCRIPT_PARAM_LIST, 3, {"Only Me", "Allies", "Both"})
			SCConfig.UltSet:addParam("UltMode", "Auto Ultimate Mode: ", SCRIPT_PARAM_LIST, 1, {"Global", "In Range"})
			SCConfig.UltSet:addParam("UltManager", "Ultimate allies under", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
			SCConfig.UltSet:addParam("UltManager2", "Ultimate me under", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)

		SCConfig:addSubMenu("[SC] Additional Settings", "Ads")
			SCConfig.Ads:addSubMenu("Skin Changer", "SkinChanger")
			SCConfig.Ads.SkinChanger:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
			SCConfig.Ads.SkinChanger:addParam("skin1", "Skin changer: ", SCRIPT_PARAM_LIST, 1, {"Dryad Soraka", "Divine Soraka", "Celestine Soraka", "No Skin"})
			SCConfig.Ads:addParam("Packets", "Packet Usage", SCRIPT_PARAM_ONOFF, true)

		SCConfig:addSubMenu("[SC] Draw Settings", "DSet")
			SCConfig.DSet:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
			SCConfig.DSet:addParam("DrawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
			SCConfig.DSet:addParam("DrawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)

		if SCConfig.Ads.SkinChanger.skin then
			GenModelPacket("Soraka", SCConfig.Ads.SkinChanger.skin1)
			LastSkin = SCConfig.Ads.SkinChanger.skin1
		end

		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1200)
		ts.name = "Focus"
		SCConfig:addTS(ts)
		VP = VPrediction()
		Orbwalker = SOW(VP)

		DelayAction(function()
			PrintChat("<font color = \"#FFFFFF\">[The Starchild] </font><font color = \"#FF0000\">Checking for external orbwalker: </font><font color = \"#FFFFFF\">Please wait...</font> </font>")
			end, 2.5)

		DelayAction(function()
			if _G.MMA_Loaded ~= nil then
				PrintChat("<font color = \"#FFFFFF\">[The Starchild] </font><font color = \"#FF0000\">MMA Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
				isMMA = true
			elseif _G.AutoCarry ~= nil then
				PrintChat("<font color = \"#FFFFFF\">[The Starchild] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
				isSAC = true
			elseif _G.AutoCarry == nil and _G.MMA_Loaded == nil then
				PrintChat("<font color = \"#FFFFFF\">[The Starchild] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SOW integrated.</font> </font>")
				SCConfig:addSubMenu("[SC] Orbwalker", "SOWorb")
				Orbwalker:LoadToMenu(SCConfig.SOWorb)

				PrintChat("<font color = \"#FFFFFF\">[The Starchild] </font><font color = \"#FF0000\">Successfully loaded.</font> </font>")
			end
		end, 10)
	end

--------------------------------------------------------------------------------------------------------------------------------------------------

	function OnTick()
		local Target = GetCustomTarget()

		Orbwalker:EnableAttacks()
		Orbwalker:ForceTarget(Target)

		QREADY = (myHero:CanUseSpell(_Q) == READY)
		WREADY = (myHero:CanUseSpell(_W) == READY)
		EREADY = (myHero:CanUseSpell(_E) == READY)
		RREADY = (myHero:CanUseSpell(_R) == READY)

		if SCConfig.Ads.SkinChanger.skin and SkinChanged() then
			GenModelPacket("Soraka", SCConfig.Ads.SkinChanger.skin1)
			LastSkin = SCConfig.Ads.SkinChanger.skin1
		end

		if SCConfig.Keys.Combo then
			if SCConfig.CSet.UseQ then
				if QREADY and ValidTarget(Target) and GetDistance(Target, myHero) then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(Target, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero)
					if nTargets >= 1 and MainTargetHitChance >= 2 then
						CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
					end
				end
			end

			if SCConfig.CSet.UseE then
				if EREADY and ValidTarget(Target) and GetDistance(Target, myHero) then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(Target, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero)
					if nTargets >= 1 and MainTargetHitChance >= 2 then
						CastSpell(_E, AOECastPosition.x, AOECastPosition.z)
					end
				end
			end
		end

		if SCConfig.Keys.Harass then
			if SCConfig.HSet.UseQ then
				if QREADY and ValidTarget(Target) and GetDistance(Target, myHero) then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(Target, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero)
					if nTargets >= 1 and MainTargetHitChance >= 2 then
						CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
					end
				end
			end
			
			if SCConfig.HSet.UseE then
				if EREADY and ValidTarget(Target) and GetDistance(Target, myHero) then
					local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(Target, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero)
					if nTargets >= 1 and MainTargetHitChance >= 2 then
						CastSpell(_E, AOECastPosition.x, AOECastPosition.z)
					end
				end
			end
		end

		if SCConfig.HealSet.UseHeal then
			AutoHeal()
		end

		if SCConfig.UltSet.UseUlt then
			AutoUltimate()
		end

		if ValidTarget(Target) then
			if SCConfig.KSSet.KSQ then
				AutoQKS(Target)
			end
		end

		if ValidTarget(Target) then
			if SCConfig.KSSet.KSE then
				AutoEKS(Target)
			end
		end
	end

--------------------------------------------------------------------------------------------------------------------------------------------------

	function OnDraw()
		if SCConfig.DSet.DrawQ and QREADY and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillQ.range, 0xFF008000)
		elseif SCConfig.DSet.DrawQ and not QREADY and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillQ.range, 0xFFFF0000)
		end

		if SCConfig.DSet.DrawE and EREADY and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillE.range, 0xFF008000)
		elseif SCConfig.DSet.DrawE and not EREADY and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillE.range, 0xFFFF0000)
		end

		if SCConfig.DSet.DrawW and WREADY and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillW.range, 0xFF008000)
		elseif SCConfig.DSet.DrawW and not QREADY and not myHero.dead then
			DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillW.range, 0xFFFF0000)
		end
	end

--------------------------------------------------------------------------------------------------------------------------------------------------

	function AutoHeal()
		for i, ally in ipairs(GetAllyHeroes()) do
			if WREADY and SCConfig.HealSet.UseHeal then
				if (ally.health / ally.maxHealth < SCConfig.HealSet.HealManager /100) and (myHero.health / myHero.maxHealth > SCConfig.HealSet.HPManager /100) then
					if GetDistance(ally, myHero) <= Skills.SkillW.range then
						if SCConfig.Ads.Packets then
							Packet("S_CAST", {spellId = _W, targetNetworkId = ally.networkID}):send()
							return
						end

						if not SCConfig.Ads.Packets then
							CastSpell(_W, ally)
						end
					end
				end
			end
		end
	end

	function AutoUltimate()
		for i, ally in ipairs(GetAllyHeroes()) do

			------------------------------
			if ally.dead then return end
			if myHero.dead then return end
			------------------------------

			if RREADY and SCConfig.UltSet.UseUlt then
				if SCConfig.UltSet.UltCast == 2 then
					if (ally.health / ally.maxHealth < SCConfig.UltSet.UltManager /100) then
						if SCConfig.UltSet.UltMode == 1 then
							if SCConfig.Ads.Packets then
								Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
							elseif not SCConfig.Ads.Packets then
								CastSpell(_R)
							end
						elseif SCConfig.UltSet.UltMode == 2 then
							if GetDistance(ally, myHero) <= 1500 then
								if SCConfig.Ads.Packets then
									Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
								elseif not SCConfig.Ads.Packets then
									CastSpell(_R)
								end
							end
						end
					end
				elseif SCConfig.UltSet.UltCast == 1 then
					if (myHero.health / myHero.maxHealth < SCConfig.UltSet.UltManager2 /100) then
						if SCConfig.Ads.Packets then
							Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
						elseif not SCConfig.Ads.Packets then
							CastSpell(_R)
						end
					end
				elseif SCConfig.UltSet.UltCast == 3 then
					if (ally.health / ally.maxHealth < SCConfig.UltSet.UltManager /100) or (myHero.health / myHero.maxHealth < SCConfig.UltSet.UltManager2 /100) then
						if SCConfig.UltSet.UltMode == 1 then
							if SCConfig.Ads.Packets then
								Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
							elseif not SCConfig.Ads.Packets then
								CastSpell(_R)
							end
						elseif SCConfig.UltSet.UltMode == 2 then
							if GetDistance(ally, myHero) <= 1500 then
								if SCConfig.Ads.Packets then
									Packet("S_CAST", {spellId = _R, targetNetworkId = myHero.networkID}):send()
								elseif not SCConfig.Ads.Packets then
									CastSpell(_R)
								end
							end
						end
					end
				end
			end
		end
	end

	function AutoQKS(Target)
		if Target.health <= getDmg("Q", Target, myHero) and GetDistance(Target) <= Skills.SkillQ.range then
			if QREADY then 
				local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(Target, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero)
				if nTargets >= 1 and MainTargetHitChance >= 2 then
					if GetDistance(Target, myHero) <= Skills.SkillQ.range then
						CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
					end
				end
			end
		end
	end

	function AutoEKS(Target)
		if Target.health <= getDmg("E", Target, myHero) and GetDistance(Target) <= Skills.SkillE.range then
			if QREADY then 
				local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(Target, Skills.SkillE.delay, Skills.SkillE.width, Skills.SkillE.range, Skills.SkillE.speed, myHero)
				if nTargets >= 1 and MainTargetHitChance >= 2 then
					if GetDistance(Target, myHero) <= Skills.SkillE.range then
						CastSpell(_E, AOECastPosition.x, AOECastPosition.z)
					end
				end
			end
		end
	end

--------------------------------------------------------------------------------------------------------------------------------------------------

	function GenModelPacket(champ, skinId)
		p = CLoLPacket(0x97)
		p:EncodeF(myHero.networkID)
		p.pos = 1
		t1 = p:Decode1()
		t2 = p:Decode1()
		t3 = p:Decode1()
		t4 = p:Decode1()
		p:Encode1(t1)
		p:Encode1(t2)
		p:Encode1(t3)
		p:Encode1(bit32.band(t4,0xB))
		p:Encode1(1)
		p:Encode4(skinId)
		for i = 1, #champ do
			p:Encode1(string.byte(champ:sub(i,i)))
		end
		for i = #champ + 1, 64 do
			p:Encode1(0)
		end
		p:Hide()
		RecvPacket(p)
	end

	function SkinChanged()
		return SCConfig.Ads.SkinChanger.skin1 ~= LastSkin
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------
