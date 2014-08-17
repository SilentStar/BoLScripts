if myHero.charName ~= "Amumu" then return end

if not VIP_USER then return PrintChat("Amumu - Master of Sadness > You're not a VIP USER.") end

local version = "1.1"
local AUTOUPDATE = true


local SCRIPT_NAME = "MasterOfSadness"
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
RequireI:Add("vPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireI:Add("SOW", "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
if VIP_USER then
	RequireI:Add("Prodiction", "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/ec830facccefb3b52212dba5696c08697c3c2854/Test/Prodiction/Prodiction.lua")
	RequireI:Add("Collision", "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/b891699e739f77f77fd428e74dec00b2a692fdef/Common/Collision.lua")
end

RequireI:Check()

if RequireI.downloadNeeded == true then return end

ScriptName = SCRIPT_NAME

-- These variables need to be near the top of your script so you can call them in your callbacks.
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 225

-- CHANGE ME. Make this the exact same name as the script you added into the site!
ScriptName = "MasterOfSadness"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()

-- [Prodiction and Collision Support]


local function getHitBoxRadius(target)
	return GetDistance(target, target.minBBox)
end

local Prodict
local ProdictQ
local ProdictQCol

-- [Skin Changer Thing] --

local LastSkin = 0

-- [Skill Information] --

local Skills = {
	SkillQ = {range = 1000, speed = 2000, delay = 0.25, width = 80},
	SkillW = {range = 300},
	SkillE = {range = 350},
	SkillR = {range = 525}
}

-- [TargetSelector Information]

VP = VPrediction()
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, Skills.SkillQ.range, DAMAGE_MAGIC)
ts.name = "Amumu Target"
JungleMinions = minionManager(MINION_JUNGLE, Skills.SkillQ.range, myHero)
EnemyMinions = minionManager(MINION_ENEMY, Skills.SkillQ.range, myHero, MINION_SORT_HEALTH_ASC)

-- [OnLoad Section] --

function OnLoad()

	UpdateWeb(true, ScriptName, id, HWID)

	MOSConfig = scriptConfig("Master of Sadness", "MOSAMUMU")

	MOSConfig:addSubMenu("[MOS] Combo Settings", "ComboSettings")
	MOSConfig.ComboSettings:addParam("Combo", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	MOSConfig.ComboSettings:addParam("UseQ", "Use Q in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.ComboSettings:addParam("UseW", "Use Auto W", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.ComboSettings:addParam("UseE", "Use E in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.ComboSettings:addParam("UseR", "Use Ultimate in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.ComboSettings:addParam("RMode", "Use Ultimate enemy count:", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)

	MOSConfig:addSubMenu("[MOS] Special Settings", "SpecialSettings")
	MOSConfig.SpecialSettings:addParam("SM","Settings For Q", 5, "")
	MOSConfig.SpecialSettings:addParam("QSlider", "Set Q Range", SCRIPT_PARAM_SLICE, 1050, 50, 1100, 0)
	MOSConfig.SpecialSettings:addParam("DashMode", "Dash Feature", SCRIPT_PARAM_LIST, 2, {"On Dash", "After Dash"})
	MOSConfig.SpecialSettings:addParam("ImmobileMode", "Immobile Feature", SCRIPT_PARAM_LIST, 2, {"On Immobile", "After Immobile"})
	MOSConfig.SpecialSettings:addParam("TMM","", 5, "")
	MOSConfig.SpecialSettings:addParam("WMM","Mana Management", 5, "")
	MOSConfig.SpecialSettings:addParam("ManaManager", "Do not use W (Despair) under %",SCRIPT_PARAM_SLICE, 40, 0, 100, 0)

	MOSConfig:addSubMenu("[MOS] Auto Ultimate Settings", "UltSettings")
	MOSConfig.UltSettings:addParam("AutoUltMode", "Auto Ultimate", SCRIPT_PARAM_LIST, 4, {"Never", "Enemy Count", "Only Killable", "Both"})
	MOSConfig.UltSettings:addParam("AutoEnemyRange", "Auto ultimate if in range: ", SCRIPT_PARAM_SLICE, 4, 1, 5, 0)
	MOSConfig.UltSettings:addParam("AutoKillable", "Auto ultimate if killable: ", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)

	MOSConfig:addSubMenu("[MOS] Ultimate Cast Control", "UltCast")
	MOSConfig.UltCast:addParam("UCC","Use ultimate on:", 5, "")
	for _, enemy in ipairs(GetEnemyHeroes()) do
		MOSConfig.UltCast:addParam(enemy.charName, enemy.charName, SCRIPT_PARAM_ONOFF, true)
	end

	MOSConfig:addSubMenu("[MOS] Prediction Settings", "PredSettings")
	MOSConfig.PredSettings:addParam("SelectPrediction", "Select Prediction", SCRIPT_PARAM_LIST, 1, {"Prodiction", "VPrediction"})

	MOSConfig:addSubMenu("[MOS] Laneclear Settings", "LaneSettings")
	MOSConfig.LaneSettings:addParam("Laneclear", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("M"))
	MOSConfig.LaneSettings:addParam("UseQ", "Use Q in 'Laneclear'", SCRIPT_PARAM_ONOFF, false)
	MOSConfig.LaneSettings:addParam("UseW", "Auto W in 'Laneclear'", SCRIPT_PARAM_ONOFF, false)
	MOSConfig.LaneSettings:addParam("UseE", "Use E in 'Laneclear'", SCRIPT_PARAM_ONOFF, true)

	MOSConfig:addSubMenu("[MOS] Jungleclear Settings", "JungleSettings")
	MOSConfig.JungleSettings:addParam("Jungleclear", "Jungleclear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("M"))
	MOSConfig.JungleSettings:addParam("UseQ", "Use Q in 'Jungleclear'", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.JungleSettings:addParam("UseW", "Auto W in 'Jungleclear'", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.JungleSettings:addParam("UseE", "Use E in 'Jungleclear'", SCRIPT_PARAM_ONOFF, true)
	
	MOSConfig:addSubMenu("[MOS] Draw Settings", "DrawSettings")
	MOSConfig.DrawSettings:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.DrawSettings:addParam("DrawE", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.DrawSettings:addParam("DrawW", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.DrawSettings:addParam("DrawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)

	MOSConfig:addSubMenu("[MOS] Skin Changer", "SkinChanger")
	MOSConfig.SkinChanger:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, true)
	MOSConfig.SkinChanger:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 8, 1, 8)

	-- Orbwalker Part --

	Orbwalker = SOW(VP)
	MOSConfig:addSubMenu("[MOS] Orbwalker", "SOWorb")
	Orbwalker:LoadToMenu(MOSConfig.SOWorb)

	-- TargetSelector Part --
	MOSConfig:addSubMenu("[MOS] TargetSelector", "TSelector")
	MOSConfig.TSelector:addTS(ts)

	-- Made by SilentStar --

	MOSConfig:addParam("Space","", 5, "")
	MOSConfig:addParam("Author","Author: SilentStar", 5, "")
	MOSConfig:addParam("Version","Version: "..version.."", 5, "")

	-- Prodiction Settings and Callbacks --

	if MOSConfig.PredSettings.SelectPrediction == 1 then

		Prodict = ProdictManager.GetInstance()
		ProdictQ = Prodict:AddProdictionObject(_Q, Skills.SkillQ.range, Skills.SkillQ.speed, Skills.SkillQ.delay, Skills.SkillQ.width)
		ProdictQCol = Collision(Skills.SkillQ.range, Skills.SkillQ.speed, Skills.SkillQ.delay, Skills.SkillQ.width)
		QPos = nil

			for i = 1, heroManager.iCount do
				local hero = heroManager:GetHero(i)
				if hero.team ~= myHero.team then
					ProdictQ:GetPredictionOnDash(hero, OnDashFunc)
					ProdictQ:GetPredictionAfterDash(hero, AfterDashFunc)
					ProdictQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
					ProdictQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
				end
			end
	end

	-- Skin Changer Part --

	if MOSConfig.SkinChanger.skin then
		GenModelPacket("Amumu", MOSConfig.SkinChanger.skin1)
		LastSkin = MOSConfig.SkinChanger.skin1
	end

	MOSConfig.ComboSettings:permaShow("Combo")
	MOSConfig.UltSettings:permaShow("AutoUltMode")
	MOSConfig.UltSettings:permaShow("AutoEnemyRange")
	MOSConfig.UltSettings:permaShow("AutoKillable")

	PrintChat("<font color = \"#33CCCC\">[Amumu] Master of Sadness</font> <font color = \"#ff9100\">SilentStar</font> <font color = \"#33CCCC\">v"..version.."</font>")
end

--Auto ultimate sorununu çöz(done), despair otomatik açılma kapanmayı ayarla(done), dash ayarlarını yap, lag free circle ekle, killable ult falan ayarla.

function OnTick()
	ts:update()
	JungleMinions:update()
	EnemyMinions:update()
	Target = ts.target
	CheckEnemyInRange()
	CheckEnemyKillable()
	CheckCallback()

	Skills.SkillQ.range = MOSConfig.SpecialSettings.QSlider

	if MOSConfig.ComboSettings.UseW then
		WControl()
	end

	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)

	if MOSConfig.ComboSettings.Combo and Target then
		if MOSConfig.ComboSettings.UseQ then
			if QREADY and ValidTarget(Target) and MOSConfig.PredSettings.SelectPrediction == 1 then
				ProdictQ:GetPredictionCallBack(Target, CastQ)
			elseif QREADY and MOSConfig.PredSettings.SelectPrediction == 2 then
				VPCastQ(Target)
			end
		end

		--if MOSConfig.ComboSettings.UseW and GetDistance(Target) < Skills.SkillW.range then WControl() end
		if EREADY and MOSConfig.ComboSettings.UseE and GetDistance(Target) < Skills.SkillE.range then CastSpell(_E) end
		if RREADY and MOSConfig.ComboSettings.UseR and AreaEnemyCount(myHero, 550) >= MOSConfig.ComboSettings.RMode then CastSpell(_R) end
	end

	if MOSConfig.JungleSettings.Jungleclear then
	 	for i, minion in pairs(JungleMinions.objects) do
			if minion and minion.valid and not minion.dead and GetDistance(minion) < 300 then
				--if MOSConfig.JungleSettings.UseW and GetDistance(Target) < Skills.SkillW.range then WControl() end
				if EREADY and MOSConfig.JungleSettings.UseE and GetDistance(minion) < Skills.SkillE.range then CastSpell(_E) end
				if QREADY and MOSConfig.JungleSettings.UseQ and GetDistance(minion) < Skills.SkillQ.range then CastSpell(_Q, minion.x, minion.z) end
			end
		end
	end
	
	if MOSConfig.LaneSettings.Laneclear then
	 	for i, minion in pairs(EnemyMinions.objects) do
			if minion and minion.valid and not minion.dead and GetDistance(minion) < 300 then
				--if MOSConfig.LaneSettings.UseW and GetDistance(Target) < Skills.SkillW.range then WControl() end
				if EREADY and MOSConfig.LaneSettings.UseE and GetDistance(minion) < Skills.SkillE.range then CastSpell(_E) end
				if QREADY and MOSConfig.LaneSettings.UseQ and GetDistance(minion) < Skills.SkillQ.range then CastSpell(_Q, minion.x, minion.z) end
			end
		end
	end
	
	if MOSConfig.SkinChanger.skin and SkinChanged() then
		GenModelPacket("Amumu", MOSConfig.SkinChanger.skin1)
		LastSkin = MOSConfig.SkinChanger.skin1
	end
end

function OnDraw()
	if MOSConfig.DrawSettings.DrawQ and QREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillQ.range, 0xFF008000)
	elseif MOSConfig.DrawSettings.DrawQ and not QREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillQ.range, 0xFFFF0000)
	end

	if MOSConfig.DrawSettings.DrawW and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillW.range, 0xFF008000)
	end

	if MOSConfig.DrawSettings.DrawE and EREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillE.range, 0xFF008000)
	elseif MOSConfig.DrawSettings.DrawE and not EREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillE.range, 0xFFFF0000)
	end

	if MOSConfig.DrawSettings.DrawR and RREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillR.range, 0xFF008000)
	elseif MOSConfig.DrawSettings.DrawR and not RREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillR.range, 0xFFFF0000)
	end
end

function OnGainBuff(unit, buff)
	if unit.name == myHero.name and buff ~= nil then
		if buff.name == "AuraofDespair" then Despair = true end
	end
end

function OnLoseBuff(unit, buff)
	if unit.name == myHero.name and buff ~= nil then
		if buff.name == "AuraofDespair" then Despair = false end
	end
end

function CastQ(unit, Target)
    if GetDistance(Target) < Skills.SkillQ.range and myHero:CanUseSpell(_Q) == READY then
        local ProdictQCol = Collision(Skills.SkillQ.range, Skills.SkillQ.speed, Skills.SkillQ.delay, Skills.SkillQ.width)
            if not ProdictQCol:GetMinionCollision(Target, myHero) then
                CastSpell(_Q, Target.x, Target.z)
            end
    end
end

function VPCastQ(Target)
	for i, Target in pairs(GetEnemyHeroes()) do
		if ValidTarget(Target) then
			if MOSConfig.PredSettings.SelectPrediction == 2 then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero, true)
            	if HitChance >= 2 and GetDistance(CastPosition) < Skills.SkillQ.range then
					if QREADY and GetDistance(CastPosition, myHero) < Skills.SkillQ.range and ValidTarget(Target, Skills.SkillQ.range) then
                    		CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	end
end

function WControl()
	if (GetTickCount() - (Tick or 0) < 1000) or not WREADY or (myHero.mana / myHero.maxMana < MOSConfig.SpecialSettings.ManaManager /100) and not inRecall then return end
	Tick = GetTickCount()
	InRange = false
	
		if MOSConfig.ComboSettings.UseW then
			for i, enemy in ipairs(GetEnemyHeroes()) do
				if enemy and ValidTarget(enemy) and not enemy.dead and GetDistance(enemy) < Skills.SkillW.range then
						if not Despair then CastSpell(_W) end
						InRange = true
						return
				end
			end
		end

		if MOSConfig.LaneSettings.UseW then
			for i, minion in pairs(EnemyMinions.objects) do
				if minion and minion.valid and not minion.dead and GetDistance(minion) < Skills.SkillW.range then
						if not Despair then CastSpell(_W) end
						InRange = true
						return
				end
			end
		end
		
		if MOSConfig.JungleSettings.UseW then
			for i, minion in pairs(JungleMinions.objects) do
				if minion and minion.valid and not minion.dead and GetDistance(minion) < Skills.SkillW.range then
						if not Despair then CastSpell(_W) end
						InRange = true
						return
				end
			end
		end

	if not InRange and Despair then
		CastSpell(_W)
		return
	end
end

function AreaEnemyCount(Spot)
	local count = 0
		for _, enemy in pairs(GetEnemyHeroes()) do
			if enemy and not enemy.dead and enemy.visible and GetDistance(Spot, enemy) < Skills.SkillR.range then
				count = count + 1
			end
		end              
	return count
end

-- Change skin function, made by Shalzuth --

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
	p:Encode1(1)--hardcode 1 bitfield
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
		return MOSConfig.SkinChanger.skin1 ~= LastSkin
end

function CheckEnemyInRange()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy and ValidTarget(enemy, Skills.SkillR.range) and MOSConfig.UltCast[enemy.charName] and AreaEnemyCount(enemy, 500) >= MOSConfig.UltSettings.AutoEnemyRange and enemy.visible and (MOSConfig.UltSettings.AutoUltMode == 2 or 4) then
			CastSpell(_R)
		end
	end
end

function CheckEnemyKillable()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy and ValidTarget(enemy, Skills.SkillR.range) and MOSConfig.UltCast[enemy.charName] and AreaEnemyCount(enemy, 500) >= MOSConfig.UltSettings.AutoKillable and enemy.visible and (MOSConfig.UltSettings.AutoUltMode == 3 or 4) then
			if enemy.health <= getDmg("R", enemy, myHero) then
					CastSpell(_R, enemy)
				return
			end
		end
	end
end

-- Dash Features --

function CheckCallback()
	if MOSConfig.PredSettings.SelectPrediction == 1 then
		if ValidTarget(Target) then
        	ProdictQ:GetPredictionCallBack(Target, GetQPos)
    	else
        	QPos = nil
    	end

		for i = 1, heroManager.iCount do
			local hero = heroManager:GetHero(i)
			if hero.team ~= myHero.team then
				if MOSConfig.SpecialSettings.DashMode == 1 then
					ProdictQ:GetPredictionOnDash(hero, OnDashFunc)
            	else
					ProdictQ:GetPredictionOnDash(hero, OnDashFunc, false)
				end
            
				if MOSConfig.SpecialSettings.DashMode == 2 then
					ProdictQ:GetPredictionAfterDash(hero, AfterDashFunc)
				else
					ProdictQ:GetPredictionAfterDash(hero, AfterDashFunc, false)
				end

				if MOSConfig.SpecialSettings.ImmobileMode == 1 then
					ProdictQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
				else
					ProdictQ:GetPredictionOnImmobile(hero, OnImmobileFunc, false)
				end
            
				if MOSConfig.SpecialSettings.ImmobileMode == 2 then
					ProdictQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
				else
					ProdictQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc, false)
				end
			end
		end
	end
    OnDashPos = nil
    AfterDashPos = nil
    AfterImmobilePos = nil
    OnImmobilePos = nil
end

function OnDashFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < Skills.SkillQ.range) and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local ProdictQCol = Collision(Skills.SkillQ.range, Skills.SkillQ.speed, Skills.SkillQ.delay, Skills.SkillQ.width)
            if not ProdictQCol:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function AfterDashFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < Skills.SkillQ.range) and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local ProdictQCol = Collision(Skills.SkillQ.range, Skills.SkillQ.speed, Skills.SkillQ.delay, Skills.SkillQ.width)
            if not ProdictQCol:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end

end

function AfterImmobileFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < Skills.SkillQ.range) and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local ProdictQCol = Collision(Skills.SkillQ.range, Skills.SkillQ.speed, Skills.SkillQ.delay, Skills.SkillQ.width)
            if not ProdictQCol:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function OnImmobileFunc(unit, pos, spell)

    if (QREADY) and (GetDistance(pos) - getHitBoxRadius(unit)/2 < Skills.SkillQ.range) and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local ProdictQCol = Collision(Skills.SkillQ.range, Skills.SkillQ.speed, Skills.SkillQ.delay, Skills.SkillQ.width)
            if not ProdictQCol:GetMinionCollision(pos, myHero) then
                CastSpell(_Q, pos.x, pos.z)
            end
    end
end

function GetQPos(unit, pos)
        QPos = pos
end

function OnBugsplat()
	UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
	UpdateWeb(false, ScriptName, id, HWID)
end

-- Here is one I added to my OnTick to detect the end of the game
if GetGame().isOver then
	UpdateWeb(false, ScriptName, id, HWID)
	-- This is a var where I stop executing what is in my OnTick()
	startUp = false;
end
