if myHero.charName ~= "Thresh" then return end

if not VIP_USER then return PrintChat("Thresh - Master of Hook - You're not a VIP USER.") end

local version = "1.2"
local AUTOUPDATE = true


local SCRIPT_NAME = "MasterOfHook"
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

-- [Bol Tracker] --

-- These variables need to be near the top of your script so you can call them in your callbacks.
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 225

-- CHANGE ME. Make this the exact same name as the script you added into the site!
ScriptName = "MasterOfHook"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()


-- Auto Updater --

--- BoL Script Status Connector --- 
local ScriptKey = "OBEAICEHAEA" -- Your script auth key
local ScriptVersion = "https://raw.githubusercontent.com/SilentStar/BoLScripts/master/VersionFiles/MasterOfHook.version" -- Leave blank if version url is not registred

-- Thanks to Bilbao for his socket help & encryption
assert(load(Base64Decode("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"), nil, "bt", _ENV))() BolBoost( ScriptKey, ScriptVersion )
-----------------------------------


-- [GapCloser and Interrupt Settings] --

GapCloserList = {
       	['Ahri']        = {true, spell = 'AhriTumble'},
        ['Aatrox']      = {true, spell = 'AatroxQ'},
        ['Akali']       = {true, spell = 'AkaliShadowDance'}, -- Targeted ability
        ['Alistar']     = {true, spell = 'Headbutt'}, -- Targeted ability
        ['Corki']     	= {true, spell = 'CarpetBomb'},
        ['Diana']       = {true, spell = 'DianaTeleport'}, -- Targeted ability
        ['Elise']     	= {true, spell = 'EliseSpiderQCast'}, -- Targeted ability
        ['Fiora']     	= {true, spell = 'FioraQ'}, -- Targeted ability
        ['Fizz']     	= {true, spell = 'FizzPiercingStrike'}, -- Targeted ability
        ['Gnar']		= {true, spell = 'GnarE'},
        ['Gragas']      = {true, spell = 'GragasE'},
        ['Graves']      = {true, spell = 'GravesMove'},
        ['Hecarim']     = {true, spell = 'HecarimUlt'},
        ['Irelia']      = {true, spell = 'IreliaGatotsu'}, -- Targeted ability
        ['JarvanIV']    = {true, spell = 'jarvanAddition'}, -- Skillshot/Targeted ability
        ['Jax']         = {true, spell = 'JaxLeapStrike'}, -- Targeted ability
        ['Jayce']       = {true, spell = 'JayceToTheSkies'}, -- Targeted ability
        ['Kassadin']    = {true, spell = 'RiftWalk'},
        ['Khazix']      = {true, spell = 'KhazixW'},
        ['Leblanc']     = {true, spell = 'LeblancSlide'},
        ['LeeSin']      = {true, spell = 'blindmonkqtwo'},
        ['Leona']       = {true, spell = 'LeonaZenithBlade', range = 900,      projSpeed = 2000},
        ['Lucian']      = {true, spell = 'LucianE'},
        ['Malphite']    = {true, spell = 'UFSlash'},
        ['Maokai']      = {true, spell = 'MaokaiTrunkLine',}, -- Targeted ability 
		['MasterYi']  	= {true, spell = 'AlphaStrike',}, -- Targeted ability
        ['MonkeyKing']  = {true, spell = 'MonkeyKingNimbus'}, -- Targeted ability
        ['Nidalee']    	= {true, spell = 'Pounce'},
        ['Pantheon']    = {true, spell = 'PantheonW'}, -- Targeted ability
        ['Pantheon']    = {true, spell = 'PantheonRJump'},
        ['Pantheon']    = {true, spell = 'PantheonRFall'},
        ['Poppy']       = {true, spell = 'PoppyHeroicCharge'}, -- Targeted ability
      --['Quinn']       = {true, spell = 'QuinnE',                  range = 725,   projSpeed = 2000, }, -- Targeted ability
      	['Rammus']    	= {true, spell = 'PowerBall'},
        ['Renekton']    = {true, spell = 'RenektonSliceAndDice'},
        ['Riven']    	= {true, spell = 'RivenFeint'},
        ['Sejuani']     = {true, spell = 'SejuaniArcticAssault'},
        ['Shyvana']     = {true, spell = 'ShyvanaTransformCast'},
        ['Shen']        = {true, spell = 'ShenShadowDash'},
        ['Talon']       = {true, spell = 'TalonCutthroat'},
        ['Tristana']    = {true, spell = 'RocketJump'},
        ['Tryndamere']  = {true, spell = 'Slash'},
        ['Vi']  		= {true, spell = 'ViQ'},
        ['XinZhao']     = {true, spell = 'XenZhaoSweep'}, -- Targeted ability
        ['Yasuo']     	= {true, spell = 'YasuoDashWrapper'} -- Targeted ability
}

InterruptList = {
                { charName = "Katarina",        spellName = "KatarinaR" ,             menuName = "Katarina (R)",        	important = 0},
                { charName = "Galio",           spellName = "GalioIdolOfDurand" ,     menuName = "Galio (R)",        		important = 0},
                { charName = "FiddleSticks",    spellName = "Crowstorm" ,             menuName = "Fiddlesticks (R)",        important = 1},
                { charName = "FiddleSticks",    spellName = "Drain" ,                 menuName = "Fiddlesticks (W)", 		important = 1},
                { charName = "Nunu",            spellName = "AbsoluteZero" ,          menuName = "Nunu (R)",        		important = 0},
                { charName = "Shen",            spellName = "ShenStandUnited" ,       menuName = "Shen (R)",        		important = 0},
                { charName = "Urgot",           spellName = "UrgotSwap2" ,            menuName = "Urgot (R)",       		important = 0},
                { charName = "Malzahar",        spellName = "AlZaharNetherGrasp" ,    menuName = "Malzahar (R)",        	important = 0},
                { charName = "Karthus",         spellName = "FallenOne" ,             menuName = "Karthus (R)",        		important = 0},
                { charName = "Pantheon",        spellName = "PantheonRJump" ,         menuName = "Pantheon (R Cast)",       important = 0},
                { charName = "Pantheon",        spellName = "PantheonRFall",          menuName = "Pantheon (R Fall)",       important = 0},
                { charName = "Varus",           spellName = "VarusQ" ,                menuName = "Varus (Q)",        		important = 1},
                { charName = "Caitlyn",         spellName = "CaitlynAceintheHole" ,   menuName = "Caitlyn (R)",        		important = 1},
                { charName = "MissFortune",     spellName = "MissFortuneBulletTime" , menuName = "Miss Fortune (R)",     	important = 1},
                { charName = "Velkoz",     		spellName = "VelkozR" ,      		  menuName = "Vel'Koz (R)",   			important = 1},
                { charName = "Warwick",         spellName = "InfiniteDuress" ,        menuName = "Warwick (R)",     		important = 0}
}

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

local Ranges = { AA = 450 }
local Skills = {
	SkillQ = {range = 1050, speed = 1500, delay = 0, width = 95, HitChance = 2},
	SkillW = {range = 950, speed = math.huge, delay = 0.5, width = 200},
	SkillE = {range = 500, speed = math.huge, delay = 0.3, width = 60, HitChance = 1},
	SkillR = {range = 400, speed = math.huge, delay = 0.5, width = 50}
}

local targetObj, friendlyObj = nil, nil

-- [OnLoad Section] --

function OnLoad()

	UpdateWeb(true, ScriptName, id, HWID)

	MOHConfig = scriptConfig("Master of Hook", "MOHTHRESH")

	MOHConfig:addSubMenu("[MOH] Prediction Settings", "PredSettings")
	MOHConfig.PredSettings:addParam("SelectPrediction", "Select Prediction", SCRIPT_PARAM_LIST, 1, {"Prodiction", "VPrediction"})

	MOHConfig:addSubMenu("[MOH] Key Bindings", "KeyBindings")
	MOHConfig.KeyBindings:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	MOHConfig.KeyBindings:addParam("CastQ", "Cast Only Q", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
	MOHConfig.KeyBindings:addParam("CastLantern", "Throw Lantern To Ally", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("G"))
	MOHConfig.KeyBindings:addParam("PullE", "Pull with Tray", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("Z"))
	MOHConfig.KeyBindings:addParam("PushE", "Push with Tray", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("X"))

	MOHConfig:addSubMenu("[MOH] Combo Settings", "ComboSettings")
	MOHConfig.ComboSettings:addSubMenu("Q Special Settings", "QSpecial")
	MOHConfig.ComboSettings.QSpecial:addParam("QSlider", "Set Q Range", SCRIPT_PARAM_SLICE, 1050, 50, 1100, 0)
	--MOHConfig.ComboSettings.QSpecial:addParam("AutoQDash", "Auto Q Target Dashing", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("J")) --NOT WORKING
	--MOHConfig.ComboSettings.QSpecial:addParam("AutoQImmobile", "Auto Q Target Immobilized", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("K")) --NOT WORKING
	MOHConfig.ComboSettings.QSpecial:addParam("DashMode", "Dash Feature", SCRIPT_PARAM_LIST, 2, {"On Dash", "After Dash"})
	MOHConfig.ComboSettings.QSpecial:addParam("ImmobileMode", "Immobile Feature", SCRIPT_PARAM_LIST, 2, {"On Immobile", "After Immobile"})
	MOHConfig.ComboSettings:addParam("UseQ", "Use Q in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.ComboSettings:addParam("UseQ2", "Use Q2 in 'Combo'", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("T"))
	MOHConfig.ComboSettings:addParam("QMode", "Use Q Mode ", SCRIPT_PARAM_LIST, 1, {"Target Selector", "Selected Target"})
	MOHConfig.ComboSettings:addParam("UseW", "Use Lantern in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.ComboSettings:addParam("ThrowLantern", "Throw lantern to: ", SCRIPT_PARAM_LIST, 2, {"Selected Ally", "Nearest Ally"})
	MOHConfig.ComboSettings:addParam("UseE", "Use E in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.ComboSettings:addParam("EMode", "Use E Mode", SCRIPT_PARAM_LIST, 1, {"Pull", "Push"})
	MOHConfig.ComboSettings:addParam("UseR", "Use Box in 'Combo'", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.ComboSettings:addParam("UseRcount", "Use Box if enemies inside:", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)

	MOHConfig:addSubMenu("[MOH] Lantern Settings", "LanternSettings")
	MOHConfig.LanternSettings:addParam("SaveAlly", "Save ally with lantern", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.LanternSettings:addParam("SaveAllyCount", "Save ally if enemies near: ", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	MOHConfig.LanternSettings:addParam("CCAlly", "Auto lantern CCed allies", SCRIPT_PARAM_ONOFF, false) --WORKING BUT BUGGY

	MOHConfig:addSubMenu("[MOH] Auto Box Settings", "ABSettings")
	MOHConfig.ABSettings:addParam("AutoBox", "Auto Box Usage", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.ABSettings:addParam("AutoEnemyRange", "Auto box if in range: ", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)

	MOHConfig:addSubMenu("[MOH] HitChance Settings", "HCSettings")
	MOHConfig.HCSettings:addParam("HitChanceQ", "Cast Q if:", SCRIPT_PARAM_LIST, Skills.SkillQ.HitChance, {"Low HitChance", "High HitChance"})
	MOHConfig.HCSettings:addParam("HitChanceE", "Cast E if:", SCRIPT_PARAM_LIST, Skills.SkillE.HitChance, {"Low HitChance", "High HitChance"})

	MOHConfig:addSubMenu("[MOH] Special Settings", "SPSettings")
	--MOHConfig.SPSettings:addSubMenu("Gapcloser Settings", "GCSettings")
	MOHConfig.SPSettings:addParam("GapCloser", "Push away gap closers", SCRIPT_PARAM_ONOFF, true)
	--MOHConfig.SPSettings.GCSettings:addParam("GCList","Gapcloser list:", 5, "")
		--LIST
	--MOHConfig.SPSettings:addSubMenu("Interrupt Settings", "INTSettings")
	MOHConfig.SPSettings:addParam("Interrupt", "Interrupt channeling spells", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.SPSettings:addParam("InterruptMode", "Interrupt spells with:", SCRIPT_PARAM_LIST, 3, {"Only Q", "Only E", "Both"})
	--MOHConfig.SPSettings.INTSettings:addParam("INTList","Interrupt list:", 5, "")
	--for i, interrupt in ipairs(InterruptList) do
	--	MOHConfig.SPSettings.INTSettings:addParam(interrupt.spellName, interrupt.menuName, SCRIPT_PARAM_ONOFF, true)
	--end


	MOHConfig:addSubMenu("[MOH] Skin Changer", "SkinChanger")
	MOHConfig.SkinChanger:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
	MOHConfig.SkinChanger:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 3)

	MOHConfig:addSubMenu("[MOH] Draw Settings", "DrawSettings")
	MOHConfig.DrawSettings:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.DrawSettings:addParam("DrawLine", "Draw Hook Line", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.DrawSettings:addParam("DrawText", "Draw Selected Text", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.DrawSettings:addParam("DrawTarget", "Draw Selected Target", SCRIPT_PARAM_ONOFF, true)
	MOHConfig.DrawSettings:addParam("DrawAlly", "Draw Selected Ally", SCRIPT_PARAM_ONOFF, true)

	MOHConfig:addParam("Space","", 5, "")
	MOHConfig:addParam("Author","Author: SilentStar", 5, "")
	MOHConfig:addParam("Version","Version: "..version.."", 5, "")

	-- Prodiction CallBacks --
 	if MOHConfig.PredSettings.SelectPrediction == 1 then

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
	if MOHConfig.SkinChanger.skin then
		GenModelPacket("Thresh", MOHConfig.SkinChanger.skin1)
		LastSkin = MOHConfig.SkinChanger.skin1
	end

	-- Target Selector Part --
	ts = TargetSelector(TARGET_NEAR_MOUSE, 1200, DAMAGE_PHYSICAL)
	ts.name = "Thresh"
	MOHConfig:addTS(ts)
	target = ts.target
	
	-- VPrediction Part --
	VP = VPrediction()
	
	-- Orbwalker Part --
	Orbwalker = SOW(VP)
	MOHConfig:addSubMenu("[MOH] Orbwalker", "SOWorb")
	Orbwalker:LoadToMenu(MOHConfig.SOWorb)
	
	-- Permashow Part --
	MOHConfig.KeyBindings:permaShow("Combo")
	MOHConfig.ComboSettings:permaShow("UseQ2")
	MOHConfig.ComboSettings:permaShow("UseW")
	MOHConfig.ComboSettings:permaShow("UseR")
	MOHConfig.ComboSettings:permaShow("UseRcount")
	MOHConfig.LanternSettings:permaShow("SaveAlly")
	MOHConfig.LanternSettings:permaShow("SaveAllyCount")
	MOHConfig.LanternSettings:permaShow("CCAlly")
	MOHConfig.ABSettings:permaShow("AutoBox")
	MOHConfig.ABSettings:permaShow("AutoEnemyRange")
	MOHConfig.SPSettings:permaShow("GapCloser")
	MOHConfig.SPSettings:permaShow("Interrupt")

	PrintChat("<font color = \"#FFFFFF\">[Thresh] </font><font color = \"#FF0000\">Master of Hook by </font><font color = \"#FFFFFF\">SilentStar</font>")
	PrintChat("<font color = \"#FFFFFF\">[Thresh] </font><font color = \"#FF0000\">Version: </font><font color = \"#FFFFFF\">"..version.."</font> </font>")
	PrintChat("<font color = \"#FFFFFF\">[Thresh] </font><font color = \"#FF0000\">Successfully loaded.</font> </font>")

end

-- Interrupt ve GapCloser ekle.

function OnTick()
	CDHandler()
	ts:update()
	Orbwalker:EnableAttacks()
	Target = ts.target

	Skills.SkillQ.range = MOHConfig.ComboSettings.QSpecial.QSlider

	if MOHConfig.ABSettings.AutoBox then
		CheckEnemyInRange()
	end

	if MOHConfig.ComboSettings.ThrowLantern == 1 then
		local target = GetTarget()
		if target ~= nil then
			if string.find(target.type, "Hero") and target.team == myHero.team then
				friendlyObj = target
			end
		end
	end

	if MOHConfig.ComboSettings.QMode == 2 then
		local target = GetTarget()
		if target ~= nil then
			if string.find(target.type, "Hero") and target.team ~= myHero.team then
				targetObj = target
			end
		end
	end

	
	-- Lantern Features --

	SaveAlly()
	CCAlly()

	-- Spells (Ready or not) --

	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	Ranges.AA = myHero.range

	Skills.SkillQ.name = myHero:GetSpellData(_Q).name
	Skills.SkillW.name = myHero:GetSpellData(_W).name
	Skills.SkillE.name = myHero:GetSpellData(_E).name
	Skills.SkillR.name = myHero:GetSpellData(_R).name

 if MOHConfig.PredSettings.SelectPrediction == 1 then
		if ValidTarget(Target) then
        	ProdictQ:GetPredictionCallBack(Target, GetQPos)
    	else
        	QPos = nil
    	end

    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team ~= myHero.team then
            if MOHConfig.ComboSettings.QSpecial.DashFeature == 1 then
                ProdictQ:GetPredictionOnDash(hero, OnDashFunc)
            else
                ProdictQ:GetPredictionOnDash(hero, OnDashFunc, false)
            end
            
            if MOHConfig.ComboSettings.QSpecial.DashFeature == 2 then
                ProdictQ:GetPredictionAfterDash(hero, AfterDashFunc)
            else
                ProdictQ:GetPredictionAfterDash(hero, AfterDashFunc, false)
            end

            if MOHConfig.ComboSettings.QSpecial.ImmobileFeature == 1 then
                ProdictQ:GetPredictionOnImmobile(hero, OnImmobileFunc)
            else
                ProdictQ:GetPredictionOnImmobile(hero, OnImmobileFunc, false)
            end
            
            if MOHConfig.ComboSettings.QSpecial.ImmobileFeature == 2 then
                ProdictQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
            else
                ProdictQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc, false)
            end

        end
    end
    OnDashPos = nil
    AfterDashPos = nil
    AfterImmobilePos = nil
    OnImmobilePos = nil
 end

	--if (MOHConfig.ComboSettings.QSpecial.SelectionType == 2 or 1) or (MOHConfig.LanternSettings.ThrowLantern == 3 or 2 or 1) then
	--	target = GetTarget()
	--else
	--	target = ts.target
	--end

	if myHero.dead then
		return
	end

	if MOHConfig.KeyBindings.Combo then
		
		if EREADY and MOHConfig.ComboSettings.UseE and ValidTarget(Target) and MOHConfig.ComboSettings.EMode == 1 then
			CastE(Target)
		elseif EREADY and MOHConfig.ComboSettings.UseE and ValidTarget(Target) and MOHConfig.ComboSettings.EMode == 2 then
			CastE2(Target)
		end

		if MOHConfig.ComboSettings.UseR then
			if RREADY and AreaEnemyCount(myHero, 550) >= MOHConfig.ComboSettings.UseRcount then
				CastSpell(_R)
			end
		end

		if MOHConfig.ComboSettings.UseW and WREADY then
			if MOHConfig.ComboSettings.ThrowLantern == 1 then
				CastW(target)
			elseif MOHConfig.ComboSettings.ThrowLantern == 2 then
				CastW2(target)
			--elseif MOHConfig.ComboSettings.ThrowLantern == 3 then
				--CastW3(target)
			end
		end

		if MOHConfig.ComboSettings.UseQ and MOHConfig.ComboSettings.QMode == 1 then
			if QREADY and ValidTarget(Target) and MOHConfig.PredSettings.SelectPrediction == 1 then
				ProdictQ:GetPredictionCallBack(Target, CastQ)
			elseif QREADY and MOHConfig.PredSettings.SelectPrediction == 2 then
				VPCastQ(target)
			end

			if MOHConfig.ComboSettings.UseQ2 then
				CastQ2()
			end
		end

		if MOHConfig.ComboSettings.UseQ and MOHConfig.ComboSettings.QMode == 2 then
			if QREADY and ValidTarget(targetObj) and MOHConfig.PredSettings.SelectPrediction == 1 then
				ProdictQ:GetPredictionCallBack(targetObj, CastQ)
			elseif QREADY and MOHConfig.PredSettings.SelectPrediction == 2 then
				VPCastQ2(target)
			end

			if MOHConfig.ComboSettings.UseQ2 then
				CastQ2()
			end
		end
	end

	if MOHConfig.KeyBindings.PushE then
		if EREADY and MOHConfig.ComboSettings.UseE and ValidTarget(Target) then
			CastE2(Target)
		end
	end

	if MOHConfig.KeyBindings.PullE then
		if EREADY and MOHConfig.ComboSettings.UseE and ValidTarget(Target) then
			CastE(Target)
		end
	end

	if MOHConfig.KeyBindings.CastQ and MOHConfig.PredSettings.SelectPrediction == 1 then
		ProdictQ:GetPredictionCallBack(Target, CastQ)
	elseif MOHConfig.KeyBindings.CastQ and MOHConfig.PredSettings.SelectPrediction == 2 then
		VPCastQ(target)
	end

	if MOHConfig.KeyBindings.CastLantern then
		myHero:MoveTo(mousePos.x, mousePos.z)
		CastLantern(target)
	end

	if MOHConfig.SkinChanger.skin and SkinChanged() then
		GenModelPacket("Thresh", MOHConfig.SkinChanger.skin1)
		LastSkin = MOHConfig.SkinChanger.skin1
	end
end

function OnDraw()
	if MOHConfig.DrawSettings.DrawQ and QREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillQ.range, 0xFF008000)
	elseif MOHConfig.DrawSettings.DrawQ and not QREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, Skills.SkillQ.range, 0xFFFF0000)
	end

	local validTargets = 0
	if MOHConfig.DrawSettings.DrawTarget and targetObj ~= nil and targetObj.valid and ValidTarget(targetObj) and MOHConfig.ComboSettings.QMode == 2 then
		DrawCircle(targetObj.x, targetObj.y, targetObj.z, 100, 0x00CC00)
			if MOHConfig.DrawSettings.DrawText then
				DrawText("Selected Target: " ..targetObj.charName, 18, 100, 150, 0xFFFFFF00)
			end
		validTargets = validTargets + 1
	end
                       
	if MOHConfig.DrawSettings.DrawAlly and friendlyObj ~= nil and friendlyObj.valid and MOHConfig.ComboSettings.ThrowLantern == 1 then
		DrawCircle(friendlyObj.x, friendlyObj.y, friendlyObj.z, 100, 0x00CC00)
			if MOHConfig.DrawSettings.DrawText then
				DrawText("Selected Ally: " ..friendlyObj.charName, 18, 100, 100, 0xFFFFFF00)
			end
		validTargets = validTargets + 1
	end

	if MOHConfig.DrawSettings.DrawLine and ValidTarget(Target, Skills.SkillQ.range) and QREADY and not myHero.dead and MOHConfig.ComboSettings.QMode == 1 then
		local EnemyPosition = Target
		if EnemyPosition ~= nil then
			DrawLine3DGreen(myHero.x, myHero.y, myHero.z, EnemyPosition.x, EnemyPosition.y, EnemyPosition.z, 3)
		end
	elseif MOHConfig.DrawSettings.DrawLine and ValidTarget(Target, Skills.SkillQ.range) and not QREADY and not myHero.dead and MOHConfig.ComboSettings.QMode == 1 then
		local EnemyPosition = Target
		if EnemyPosition ~= nil then
			DrawLine3DRed(myHero.x, myHero.y, myHero.z, EnemyPosition.x, EnemyPosition.y, EnemyPosition.z, 3)
		end
    end

    if MOHConfig.DrawSettings.DrawLine and ValidTarget(targetObj, Skills.SkillQ.range) and QREADY and not myHero.dead and MOHConfig.ComboSettings.QMode == 2 then
		if targetObj ~= nil then
			DrawLine3DGreen(myHero.x, myHero.y, myHero.z, targetObj.x, targetObj.y, targetObj.z, 3)
		end
	elseif MOHConfig.DrawSettings.DrawLine and ValidTarget(targetObj, Skills.SkillQ.range) and not QREADY and not myHero.dead and MOHConfig.ComboSettings.QMode == 2 then
		if targetObj ~= nil then
			DrawLine3DRed(myHero.x, myHero.y, myHero.z, targetObj.x, targetObj.y, targetObj.z, 3)
		end
    end
end

function DrawLine3DGreen(x1, y1, z1, x2, y2, z2, width, color)
    local p = WorldToScreen(D3DXVECTOR3(x1, y1, z1))
	local px, py = p.x, p.y
	local c = WorldToScreen(D3DXVECTOR3(x2, y2, z2))
	local cx, cy = c.x, c.y
			DrawLine(cx, cy, px, py, 3, 0xFF00FF00)
end

function DrawLine3DRed(x1, y1, z1, x2, y2, z2, width, color)
    local p = WorldToScreen(D3DXVECTOR3(x1, y1, z1))
	local px, py = p.x, p.y
	local c = WorldToScreen(D3DXVECTOR3(x2, y2, z2))
	local cx, cy = c.x, c.y
			DrawLine(cx, cy, px, py, 3, 0xFFFF0000)
end

function CDHandler()
	-- Spells
	Skills.SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	Skills.SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	Skills.SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	Skills.SkillR.ready = (myHero:CanUseSpell(_R) == READY)
	Ranges.AA = myHero.range
end

function VPCastQ(target)
	for i, target in pairs(GetEnemyHeroes()) do
		if ValidTarget(target) then
			if MOHConfig.PredSettings.SelectPrediction == 2 then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero, true)
            	if HitChance >= MOHConfig.HCSettings.HitChanceQ and GetDistance(CastPosition) < 1050 then
					if QREADY and GetDistance(CastPosition, myHero) < 1050 and myHero:GetSpellData(_Q).name == "ThreshQ" and ValidTarget(Target, Skills.SkillQ.range) then
                    		CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	end
end

function VPCastQ2(target)
	for i, target in pairs(targetObj) do
		if ValidTarget(target) then
			if MOHConfig.PredSettings.SelectPrediction == 2 then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero, true)
            	if HitChance >= MOHConfig.HCSettings.HitChanceQ and GetDistance(CastPosition) < 1050 then
					if QREADY and GetDistance(CastPosition, myHero) < 1050 and myHero:GetSpellData(_Q).name == "ThreshQ" and ValidTarget(Target, Skills.SkillQ.range) then
                    		CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	end
end

function CastQ(unit, pos)
    if GetDistance(pos) < Skills.SkillQ.range and myHero:CanUseSpell(_Q) == READY and myHero:GetSpellData(_Q).name == "ThreshQ" then
        local pos, info = Prodiction.GetPrediction(unit, Skills.SkillQ.range, Skills.SkillQ.speed, Skills.SkillQ.delay, Skills.SkillQ.width)
    	if pos and not info.mCollision() then
			CastSpell(_Q, pos.x, pos.z)
    	end
    end
end

function CastQ2()
	if myHero:GetSpellData(_Q).name == "threshqleap" then
		CastSpell(_Q)
	end
end

function CastE(target)
	local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, Skills.SkillE.delay, Skills.SkillE.width, Skills.SkillE.range, Skills.SkillE.speed, myHero)
	PosX = myHero.x + (myHero.x - CastPosition.x)
	PosZ = myHero.z + (myHero.z - CastPosition.z)
	for i, target in pairs(GetEnemyHeroes()) do
		if ValidTarget(target) then
			if HitChance >= MOHConfig.HCSettings.HitChanceE and GetDistance(CastPosition) < 450 and ValidTarget(ts.target, Skills.SkillE.range) then
				CastSpell(_E, PosX, PosZ)
			end
		end
	end
end

function CastE2(target)
	for i, target in pairs(GetEnemyHeroes()) do
		if ValidTarget(target) then
            	CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, Skills.SkillE.delay, Skills.SkillE.width, Skills.SkillE.range, Skills.SkillE.speed, myHero)
			if HitChance >= MOHConfig.HCSettings.HitChanceE and GetDistance(CastPosition) < 450 and ValidTarget(ts.target, eRange) then
                CastSpell(_E, CastPosition.x, CastPosition.z)
            end
    	end
	end
end

function CastW(target)
    if friendlyObj ~= nil and friendlyObj.valid and GetDistance(friendlyObj) < Skills.SkillW.range and WREADY and myHero:GetSpellData(_Q).name == "threshqleap" then
    	CastSpell(_W, friendlyObj.x, friendlyObj.z)
    end
end

function CastW2(target)
    if FindNearestAlly() and GetDistance(FindNearestAlly()) < Skills.SkillW.range and WREADY and myHero:GetSpellData(_Q).name == "threshqleap" then
        CastSpell(_W, FindNearestAlly().x, FindNearestAlly().z)
    end
end

--function CastW3(target)
--    if FindFarthestAlly() and GetDistance(FindFarthestAlly()) >= Skills.SkillW.range and WREADY and myHero:GetSpellData(_Q).name == "threshqleap" then
--        CastSpell(_W, FindFarthestAlly().x, FindFarthestAlly().z)
--    end
--end

function CastLantern(target)
	if GetDistance(friendlyObj) < Skills.SkillW.range and WREADY then
        CastSpell(_W, friendlyObj.x, friendlyObj.z)
    elseif FindNearestAlly() and GetDistance(FindNearestAlly()) < Skills.SkillW.range and WREADY then
    	CastSpell(_W, FindNearestAlly().x, FindNearestAlly().z)
    --elseif FindFarthestAlly() and GetDistance(FindFarthestAlly()) < Skills.SkillW.range and WREADY then
    --	CastSpell(_W, FindFarthestAlly().x, FindFarthestAlly().z)
    end
end

function SaveAlly()
	if MOHConfig.LanternSettings.SaveAlly then
		if WREADY and CountEnemies(950) >= MOHConfig.LanternSettings.SaveAllyCount then
            for k, ally in pairs(GetAllyHeroes()) do
				if GetDistance(ally) < Skills.SkillW.range then
					CastSpell(_W, FindLowestAlly().x, FindLowestAlly().z)
				end
			end
		end
	end
end

function CCAlly()
	if MOHConfig.LanternSettings.CCAlly then
	      for k, ally in pairs(GetAllyHeroes()) do
            local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(ally, Skills.SkillW.delay, 150, Skills.SkillW.range)
            if HitChance >= 4 and GetDistance(ally) < Skills.SkillW.range then
                CastSpell(_W, ally.x, ally.z)
            end
        end
    end
end

function FindLowestAlly()
		LowestAlly = nil
		for a = 1, heroManager.iCount do
			Ally = heroManager:GetHero(a)
			if Ally.team == myHero.team and not Ally.dead and GetDistance(myHero, Ally) <= Skills.SkillW.range then
				if LowestAlly == nil then
					LowestAlly = Ally
				elseif not LowestAlly.dead and (Ally.health/Ally.maxHealth) < (LowestAlly.health/LowestAlly.maxHealth) then
					LowestAlly = Ally
				end
			end
		end
	return LowestAlly
end

function FindNearestAlly()
		local Ally = nil
        local NearestAlly = nil
        for i=1, heroManager.iCount do
                Ally = heroManager:GetHero(i)
                if Ally.team == myHero.team and not Ally.dead and Ally.charName ~= myHero.charName then
                        if NearestAlly == nil then
                                NearestAlly = Ally
                        elseif GetDistance(Ally) < GetDistance(NearestAlly) then
                                NearestAlly = Ally
                        end
                end
        end
	return NearestAlly
end

--function FindFarthestAlly()
--		local Ally = nil
--		local FarthestAlly = nil
--		for i=1, heroManager.iCount do
--			Ally = heroManager:GetHero(i)
--			if Ally.team == myHero.team and not Ally.dead and Ally.charName ~= myHero.charName then
--				if FarthestAlly == nil then
--						FarthestAlly = Ally
--				elseif GetDistance(Ally) < GetDistance(FarthestAlly) then
--						FarthestAlly = Ally
--				end
--			end
--		end
--end

function CheckEnemyInRange()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy and ValidTarget(enemy, Skills.SkillR.range) and AreaEnemyCount(enemy, 500) >= MOHConfig.ABSettings.AutoEnemyRange and enemy.visible then
			CastSpell(_R)
		end
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

function CountEnemies(range, unit)
    local Enemies = 0
    for _, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and GetDistance(enemy, unit) < (range or math.huge) then
            Enemies = Enemies + 1
        end
    end
    return Enemies
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
	return MOHConfig.SkinChanger.skin1 ~= LastSkin
end

-- Dash Features --
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

function OnProcessSpell(unit, spell)
  if MOHConfig.SPSettings.GapCloser and EREADY then
    if unit.team ~= myHero.team then
      local spellName = spell.name
      if GapCloserList[unit.charName] and spellName == GapCloserList[unit.charName].spell and GetDistance(unit) < 2000 then
        if spell.target ~= nil and spell.target.name == myHero.name or GapCloserList[unit.charName].spell == 'blindmonkqtwo' then
          local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Skills.SkillE.delay, Skills.SkillE.width, Skills.SkillE.range, Skills.SkillE.speed, myHero) 
          CastSpell(_E, CastPosition.x, CastPosition.z)
        elseif GapCloserList[unit.charName].spell == 'LeonaZenithBlade' then
          local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Skills.SkillE.delay, Skills.SkillE.width, Skills.SkillE.range, Skills.SkillE.speed, myHero) 
          	if myHero:GetSpellData(_E).name == "ThreshE" then Etime = os.clock() end
          	Etime = os.clock() + 2
          	CastSpell(_E, CastPosition.x, CastPosition.z)
        end
      end
    end
  end
  if MOHConfig.SPSettings.Interrupt and EREADY and MOHConfig.SPSettings.InterruptMode == 2 or 3 then
    if unit.team ~= myHero.team and GetDistance(unit) < Skills.SkillE.range then
      local spellName = spell.name
      for i = 1, #InterruptList do
        if unit.charName == InterruptList[i].charName and spellName == InterruptList[i].spellName then
          local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Skills.SkillE.delay, Skills.SkillE.width, Skills.SkillE.range, Skills.SkillE.speed, myHero) 
          CastSpell(_E, CastPosition.x, CastPosition.z)
        end
      end
    end
  end
  if MOHConfig.SPSettings.Interrupt and QREADY and MOHConfig.SPSettings.InterruptMode == 1 or 3 then
  	if unit.team ~= myHero.team and GetDistance(unit) < Skills.SkillQ.range then
      local spellName = spell.name
      for i = 1, #InterruptList do
        if unit.charName == InterruptList[i].charName and spellName == InterruptList[i].spellName then
          local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Skills.SkillQ.delay, Skills.SkillQ.width, Skills.SkillQ.range, Skills.SkillQ.speed, myHero) 
          CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
      end
    end 
  end 
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
