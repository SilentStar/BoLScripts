if myHero.charName ~= "LeeSin" then return end

local version = "3.0"
local AUTOUPDATE = true


local SCRIPT_NAME = "MasterOfInsec"
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
ScriptName = "MasterOfInsec"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()


local qRange, qDelay, qSpeed, qWidth = 1000, 0.25, 1800, 60
local sRange = 600

local allyMinions = {}
local lastTime, lastTimeQ, bonusDmg = 0, 0, 0
local qDmgs = {50, 80, 110, 140, 170}
local useSight, lastWard, targetObj, friendlyObj = nil, nil, nil, nil
local VP, ts = nil, nil

local Prodict
local ProdictQ, ProdictQCol

local Ranges = { AA = 125 }
local skills = {
    SkillQ = { ready = false, name = myHero:GetSpellData(_Q).name, range = 1000, delay = 0.25, speed = 1800, width = 60 },
	SkillW = { ready = false, name = myHero:GetSpellData(_W).name, range = 700, delay = 0.25, speed = 1000, width = 100 },
	SkillE = { ready = false, name = myHero:GetSpellData(_E).name, range = 500, delay = 0.25, speed = 1300, width = 90 },
	SkillR = { ready = false, range = 375}
}

local Passive = {ready = false, stacks = 0}

local lastSkin = 0

if myHero:GetSpellData(SUMMONER_1).name:find("SummonerFlash") then 
		flash = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerFlash") then 
		flash = SUMMONER_2
	else 
		flash = nil
	end

function OnLoad()

	UpdateWeb(true, ScriptName, id, HWID)

	Config = scriptConfig("Master of Insec", "LeeSinCombo")
	
	Config:addParam("scriptActive", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Config:addParam("starActive", "Star Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	Config:addParam("insecMake", "Insec", SCRIPT_PARAM_ONKEYDOWN, false, 84)
	Config:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, 71)
	Config:addParam("wardJump", "Ward Jump", SCRIPT_PARAM_ONKEYDOWN, false, 67)
	
	Config:addSubMenu("Combo Settings", "csettings")
	Config.csettings:addParam("qslider", "Set Q Range", SCRIPT_PARAM_SLICE, 1000, 50, 1100, 0)
	Config.csettings:addParam("qusage", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
	Config.csettings:addParam("wusage", "Use W in combo", SCRIPT_PARAM_ONOFF, false)
	Config.csettings:addParam("autowusage", "Use W if low hp", SCRIPT_PARAM_ONOFF, false)
	Config.csettings:addParam("eusage", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
	Config.csettings:addParam("rusage", "Use R to finish the enemy", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Draw Settings", "DrawSettings")
	Config.DrawSettings:addParam("drawInsec", "Draw InSec Line", SCRIPT_PARAM_ONOFF, true)
	Config.DrawSettings:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	Config.DrawSettings:addParam("DrawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
	Config.DrawSettings:addParam("DrawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
	Config.DrawSettings:addParam("DrawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Misc Settings", "miscs")
	Config.miscs:addParam("wardJumpmax", "Ward Jump on max range if mouse too far", SCRIPT_PARAM_ONOFF, true)
	Config.miscs:addParam("predInSec", "Use prediction for InSec", SCRIPT_PARAM_ONOFF, false)
	Config.miscs:addParam("following", "Follow while combo", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Insec Settings", "insettings")
	Config.insettings:addParam("insecMode", "Insec Mode", SCRIPT_PARAM_LIST, 1, {"Nearest Ally", "Selected Ally"})
	Config.insettings:addParam("igCol","Ignore collision for insec", SCRIPT_PARAM_ONOFF, true)
	Config.insettings:addParam("wjump","Ward Jump Insec", SCRIPT_PARAM_ONOFF, true)
	Config.insettings:addParam("wflash","Use Flash if W on CD", SCRIPT_PARAM_ONOFF, true)
	Config.insettings:addParam("pflash","Prioritize flash over ward jump", SCRIPT_PARAM_ONOFF, false)
	
	Config:addSubMenu("Ultimate Settings", "useUlt")
	
	Config:addSubMenu("Laneclear", "Laneclear")
	Config.Laneclear:addParam("lclr", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("M"))
	Config.Laneclear:addParam("useClearQ", "Use Q in Laneclear", SCRIPT_PARAM_ONOFF, true)
	Config.Laneclear:addParam("useClearW", "Use W in Laneclear", SCRIPT_PARAM_ONOFF, false)
	Config.Laneclear:addParam("useClearE", "Use E in Laneclear", SCRIPT_PARAM_ONOFF, true)

	Config:addSubMenu("Jungleclear", "Jungleclear")
	Config.Jungleclear:addParam("jclr", "Jungleclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("M"))
	Config.Jungleclear:addParam("useClearQ", "Use Q in Jungleclear", SCRIPT_PARAM_ONOFF, true)
	Config.Jungleclear:addParam("useClearW", "Use W in Jungleclear", SCRIPT_PARAM_ONOFF, true)
	Config.Jungleclear:addParam("useClearE", "Use E in Jungleclear", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Additionals", "Ads")
	Config.Ads:addSubMenu("Skin Changer (VIP)", "VIP")
	Config.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
	Config.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 7)
	Config.Ads:addParam("prodiction", "Use Prodiction", SCRIPT_PARAM_ONOFF, false)
	
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
		if enemy.team ~= myHero.team then
			Config.useUlt:addParam("ult"..enemy.charName, "Use ultimate on "..enemy.charName, SCRIPT_PARAM_ONOFF, true)
		end
	end
	
	if Config.Ads.VIP.skin and VIP_USER then
		GenModelPacket("LeeSin", Config.Ads.VIP.skin1)
		lastSkin = Config.Ads.VIP.skin1
	end
	
	ts = TargetSelector(TARGET_NEAR_MOUSE, 1000, DAMAGE_PHYSICAL)
	ts.name = "Lee Sin"
	Config:addTS(ts)
	
	VP = VPrediction()
	
	Orbwalker = SOW(VP)
	
	Config:permaShow("scriptActive")
	Config:permaShow("starActive")
	Config:permaShow("insecMake")
	Config:permaShow("harass")
	Config:permaShow("wardJump")
	
	
	Config:addSubMenu("Orbwalker", "SOWorb")
	Orbwalker:LoadToMenu(Config.SOWorb)
	
	targetMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)
	jungleMinions = minionManager(MINION_JUNGLE, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)
	allyMinions = minionManager(MINION_ALLY, 1000, myHero, MINION_SORT_HEALTH_ASC)
	
		if VIP_USER then
		require 'Prodiction'
		require 'Collision'
		Prodict = ProdictManager.GetInstance()
		ProdictQ = Prodict:AddProdictionObject(_Q, skills.SkillQ.range, skills.SkillQ.speed, skills.SkillQ.delay, skills.SkillQ.width)
		ProdictQCol = Collision(skills.SkillQ.range, skills.SkillQ.speed, skills.SkillQ.delay, skills.SkillQ.width)

	end
	
	FREADY = (flash ~= nil and myHero:CanUseSpell(flash) == READY)
	
	PrintChat("<font color = \"#33CCCC\">[Lee Sin] Master of Insec</font> <font color = \"#fff8e7\">SilentStar v"..version.."</font>")
end

function OnTick()
	targetMinions:update()
	jungleMinions:update()
	CDHandler()

	skills.SkillQ.range = Config.csettings.qslider
	
	if myHero.dead then
		return
	end
	
	if not canAutoMove() then
		return
	end
	
	useSight = wardSlot()

	bonusDmg = myHero.addDamage * 0.90
	
	local target = GetTarget()
	if target ~= nil then
		if string.find(target.type, "Hero") and target.team ~= myHero.team then
			targetObj = target
		elseif Config.insettings.insecMode == 2 and target.team == myHero.team then
			friendlyObj = target
		end
	end
	
	if Config.insecMake and Config.insettings.wjump and not Config.insettings.pflash then
		if insec() then return end
	end
	
	if Config.insecMake and Config.insettings.wflash and not Config.insettings.pflash then
		if winsec() then return end
	end
	
	if Config.insecMake and Config.insettings.pflash then
		if pinsec() then return end
	end
	
	if Config.insecMake and Config.insettings.pflash and Config.insettings.wjump and not FREADY then
		if insec() then return end
	end
	
	if Config.scriptActive and not Config.wflash and not Config.pflash and not Config.wjump then
		local inseca = nil
		if not Config.insecMake then inseca = targetObj end
		normalcombo()
		return
	end
	
	if Config.scriptActive or Config.insecMake then
		local inseca = nil
		if Config.insecMake then inseca = targetObj end
		combo(inseca)
		return
	end
	
	if Config.starActive then
		if starcombo() then return end
	end
	
	if Config.wardJump then
		moveToCursor()
		wardJump()
		return
	end
	
	if Config.harass then
		if harass() then return end
	end
	
	if Config.Laneclear.lclr then
		LaneClear()
	end

	if Config.Jungleclear.jclr then
		JungleClear()
	end
	
	if Config.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("LeeSin", Config.Ads.VIP.skin1)
		lastSkin = Config.Ads.VIP.skin1
	end
end

function wardSlot()
	local jumpTable = {3340,3350,3205,3207,2049,2045,2044,3361,3154,3362,3160,2043}
	for i, v in ipairs(jumpTable) do
		local slot = GetInventorySlotItem(v)
		if slot ~= nil and (myHero:CanUseSpell(slot) == READY) then
			return slot
		end	
	end
end

function CDHandler()
	-- Spells
	skills.SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	skills.SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	skills.SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	skills.SkillR.ready = (myHero:CanUseSpell(_R) == READY)
	Ranges.AA = myHero.range
end

function moveToCursor()
		if GetDistance(mousePos) then
			local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
				myHero:MoveTo(moveToPos.x, moveToPos.z)
		end		
	end

function harass()
	moveToCursor()
	for i=1, heroManager.iCount do
		local target = heroManager:GetHero(i)
		if ValidTarget(target, 1000) then
			if myHero:CanUseSpell(_Q) == READY then
				if myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
					if VIP_USER and Config.Ads.prodiction then
								local pos, info = Prodiction.GetPrediction(target, skills.SkillQ.range, skills.SkillQ.speed, skills.SkillQ.delay, skills.SkillQ.width)
								if info.hitchance >= 2 and GetDistance(pos) <= 1000 then
								ProdictQ:GetPredictionCallBack(target, CastQ)
								else
								CastQ(focusEnemy)
					end
				else
					local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, true)
					if HitChance >= 2 then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
						return
					end
				end
				elseif targetHasQ(target) then
					if myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name == "BlindMonkWOne" and enemiesAround(1500) == 1 and myHero.mana >= 80 and (myHero.health / myHero.maxHealth) > 0.5 then
						allyMinions:update()
						for i, minion in pairs(allyMinions.objects) do
							if minion ~= nil and minion.valid then
								local distMinionTarget = GetDistance(target, minion)
								if distMinionTarget > 450 and distMinionTarget < 650 then
									CastSpell(_Q)
									return
								end
							end
						end
					end
				end
			end
			
			if myHero:CanUseSpell(_Q) ~= READY and myHero:CanUseSpell(_E) == READY and myHero:GetSpellData(_E).name == "BlindMonkEOne" and enemiesAround(375) >= 1 and myHero.mana >= 100 then
				CastSpell(_E)
				return
			end
			
			if myHero:CanUseSpell(_Q) ~= READY and myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name == "BlindMonkWOne" and enemiesAround(300) >= 1 then
				allyMinions:update()
				local maxDist = 0
				local miniona = nil
				for i, minion in pairs(allyMinions.objects) do
					if minion ~= nil and minion.valid then
						local distMinionTarget = GetDistance(target, minion)
						if distMinionTarget > 450 and distMinionTarget < 650 and distMinionTarget > maxDist then
							miniona = minion
							maxDist = distMinionTarget
						end
					end
				end
				
				if miniona ~= nil then
					CastSpell(_W, miniona)
				end
			end
		end
	end
end

function enemiesAround(range)
	local playersCount = 0
	for i=1, heroManager.iCount do
		local target = heroManager:GetHero(i)
		if ValidTarget(target, range) then
			playersCount = playersCount + 1
		end
	end
	return playersCount
end

function wardJump()
	if myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
		if lastTime > (GetTickCount() - 1000) then
			if (GetTickCount() - lastTime) >= 10 then
				CastSpell(_W, lastWard)
			end
		elseif useSight ~= nil then
			local wardX = mousePos.x
			local wardZ = mousePos.z
			if Config.miscs.wardJumpmax then
				local distanceMouse = GetDistance(myHero, mousePos)
				if distanceMouse > 600 then
					wardX = myHero.x + (600 / distanceMouse) * (mousePos.x - myHero.x)
					wardZ = myHero.z + (600 / distanceMouse) * (mousePos.z - myHero.z)
				end
			end
			
			CastSpell(useSight, wardX, wardZ)
		end
	end
end

function OnCreateObj(object)
	if myHero.dead then return end
	
	if Config.wardJump or Config.insecMake or Config.insettings.wjump or Config.insettings.wflash or Config.insettings.pflash  then
		if object ~= nil and object.valid and (object.name == "VisionWard" or object.name == "SightWard") then
			lastWard = object
			lastTime = GetTickCount()
		end
	end
end


local lastWardInsec = 0

function insec()
	if Config.insettings.insecMode == 2 then
		if myHero:CanUseSpell(_R) == READY and friendlyObj ~= nil and targetObj ~= nil and friendlyObj.valid and targetObj.valid and ValidTarget(targetObj) then
			if myHero:GetDistance(targetObj) < 375 then
				local dPredict = GetDistance(targetObj, myHero)
			
				local xE = myHero.x + ((dPredict + 500) / dPredict) * (targetObj.x - myHero.x)
				local zE = myHero.z + ((dPredict + 500) / dPredict) * (targetObj.z - myHero.z)
			
				local positiona = {}
				positiona.x = xE
				positiona.z = zE
			
				local newDistance = GetDistance(friendlyObj, targetObj) - GetDistance(friendlyObj, positiona)
				if newDistance > 0 and (newDistance / 500) > 0.7 then
					CastSpell(_R, targetObj)
					return true
				end
			end
		
			if myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
				if lastTime > (GetTickCount() - 1000) then
					if (GetTickCount() - lastTime) >= 10 then
						CastSpell(_W, lastWard)
						lastWardInsec = os.clock() + 0.5
						return true
					end
				elseif useSight ~= nil then
					local targetObj2 = nil
					if Config.miscs.predInSec then
						targetObj2, HitChance = VP:GetPredictedPos(targetObj, 0.25, 2000, myHero)
					else
					targetObj2 = targetObj
					end
					
					local wardDistance = 300
					local dPredict = GetDistance(targetObj2, friendlyObj)
					local xE = friendlyObj.x + ((dPredict + wardDistance) / dPredict) * (targetObj2.x - friendlyObj.x)
					local zE = friendlyObj.z + ((dPredict + wardDistance) / dPredict) * (targetObj2.z - friendlyObj.z)
					
					local positiona = {}
					positiona.x = xE
					positiona.z = zE
					if GetDistance(myHero, positiona) < 600 then
						CastSpell(useSight, xE, zE)
						return true
					end
				end
			end
		end
	end

	if Config.insettings.insecMode == 1 then
		if myHero:CanUseSpell(_R) == READY and targetObj ~= nil and targetObj.valid and ValidTarget(targetObj) then
			if myHero:GetDistance(targetObj) < 375 then
				local dPredict = GetDistance(targetObj, myHero)
			
				local xE = myHero.x + ((dPredict + 500) / dPredict) * (targetObj.x - myHero.x)
				local zE = myHero.z + ((dPredict + 500) / dPredict) * (targetObj.z - myHero.z)
				
				local positiona = {}
				positiona.x = xE
				positiona.z = zE
			
				local newDistance = GetDistance(FindNearestAlly(), targetObj) - GetDistance(FindNearestAlly(), positiona)
				if newDistance > 0 and (newDistance / 500) > 0.7 then
					CastSpell(_R, targetObj)
					return true
				end
			end

			if myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name == "BlindMonkWOne" and Config.insettings.insecMode == 1 then
				if lastTime > (GetTickCount() - 1000) then
					if (GetTickCount() - lastTime) >= 10 then
						CastSpell(_W, lastWard)
						lastWardInsec = os.clock() + 0.5
						return true
					end
				elseif useSight ~= nil then
					local targetObj2 = nil
					if Config.miscs.predInSec then
						targetObj2, HitChance = VP:GetPredictedPos(targetObj, 0.25, 2000, myHero)
					else
						targetObj2 = targetObj
					end
				
					local wardDistance = 300
					local dPredict = GetDistance(targetObj2, FindNearestAlly())
					local xE = FindNearestAlly().x + ((dPredict + wardDistance) / dPredict) * (targetObj2.x - FindNearestAlly().x)
					local zE = FindNearestAlly().z + ((dPredict + wardDistance) / dPredict) * (targetObj2.z - FindNearestAlly().z)
					
					local positiona = {}
					positiona.x = xE
					positiona.z = zE
					if GetDistance(myHero, positiona) < 600 then
						CastSpell(useSight, xE, zE)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function pinsec()
	if Config.insettings.insecMode == 2 then
		if myHero:CanUseSpell(_R) == READY and friendlyObj ~= nil and targetObj ~= nil and friendlyObj.valid and targetObj.valid and ValidTarget(targetObj) then
			if myHero:GetDistance(targetObj) < 375 then
				local dPredict = GetDistance(targetObj, myHero)
				
				local xE = myHero.x + ((dPredict + 500) / dPredict) * (targetObj.x - myHero.x)
				local zE = myHero.z + ((dPredict + 500) / dPredict) * (targetObj.z - myHero.z)
			
				local positiona = {}
				positiona.x = xE
				positiona.z = zE
			
				local newDistance = GetDistance(friendlyObj, targetObj) - GetDistance(friendlyObj, positiona)
				if newDistance > 0 and (newDistance / 500) > 0.7 then
					CastSpell(_R, targetObj)
					return true
				end
			end
		
			if FREADY then
				if lastTime > (GetTickCount() - 1000) then
					if (GetTickCount() - lastTime) >= 10 then
						--CastSpell(_W, lastWard)
						lastWardInsec = os.clock() + 0.5
						return true
					end
				elseif flash ~= nil then
					local targetObj2 = nil
					if Config.miscs.predInSec then
						targetObj2, HitChance = VP:GetPredictedPos(targetObj, 0.25, 2000, myHero)
					else
						targetObj2 = targetObj
					end
				
					local wardDistance = 400
					local dPredict = GetDistance(targetObj2, friendlyObj)
					local xE = friendlyObj.x + ((dPredict + wardDistance) / dPredict) * (targetObj2.x - friendlyObj.x)
					local zE = friendlyObj.z + ((dPredict + wardDistance) / dPredict) * (targetObj2.z - friendlyObj.z)
				
					local positiona = {}
					positiona.x = xE
					positiona.z = zE
					if GetDistance(myHero, positiona) < 600 then
						CastSpell(flash, xE, zE)
						return true
					end
				end
			end
		end
	end

	if Config.insettings.insecMode == 1 then
		if myHero:CanUseSpell(_R) == READY and targetObj ~= nil and targetObj.valid and ValidTarget(targetObj) then
			if myHero:GetDistance(targetObj) < 375 then
				local dPredict = GetDistance(targetObj, myHero)
				
				local xE = myHero.x + ((dPredict + 500) / dPredict) * (targetObj.x - myHero.x)
				local zE = myHero.z + ((dPredict + 500) / dPredict) * (targetObj.z - myHero.z)
			
				local positiona = {}
				positiona.x = xE
				positiona.z = zE
			
				local newDistance = GetDistance(FindNearestAlly(), targetObj) - GetDistance(FindNearestAlly(), positiona)
				if newDistance > 0 and (newDistance / 500) > 0.7 then
					CastSpell(_R, targetObj)
					return true
				end
			end

			if FREADY then
				if lastTime > (GetTickCount() - 1000) then
					if (GetTickCount() - lastTime) >= 10 then
						--CastSpell(_W, lastWard)
						lastWardInsec = os.clock() + 0.5
						return true
					end
				elseif flash ~= nil then
					local targetObj2 = nil
					if Config.miscs.predInSec then
						targetObj2, HitChance = VP:GetPredictedPos(targetObj, 0.25, 2000, myHero)
					else
						targetObj2 = targetObj
					end
				
					local wardDistance = 400
					local dPredict = GetDistance(targetObj2, FindNearestAlly())
					local xE = FindNearestAlly().x + ((dPredict + wardDistance) / dPredict) * (targetObj2.x - FindNearestAlly().x)
					local zE = FindNearestAlly().z + ((dPredict + wardDistance) / dPredict) * (targetObj2.z - FindNearestAlly().z)
				
					local positiona = {}
					positiona.x = xE
					positiona.z = zE
					if GetDistance(myHero, positiona) < 600 then
						CastSpell(flash, xE, zE)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function winsec()
	if Config.insettings.insecMode == 2 then
		if myHero:CanUseSpell(_R) == READY and friendlyObj ~= nil and targetObj ~= nil and friendlyObj.valid and targetObj.valid and ValidTarget(targetObj) then
			if myHero:GetDistance(targetObj) < 375 then
				local dPredict = GetDistance(targetObj, myHero)
				
				local xE = myHero.x + ((dPredict + 500) / dPredict) * (targetObj.x - myHero.x)
				local zE = myHero.z + ((dPredict + 500) / dPredict) * (targetObj.z - myHero.z)
			
				local positiona = {}
				positiona.x = xE
				positiona.z = zE
			
				local newDistance = GetDistance(friendlyObj, targetObj) - GetDistance(friendlyObj, positiona)
				if newDistance > 0 and (newDistance / 500) > 0.7 then
					CastSpell(_R, targetObj)
					return true
				end
			end
		
			if FREADY then
				if lastTime > (GetTickCount() - 1000) then
					if (GetTickCount() - lastTime) >= 10 then
						--CastSpell(_W, lastWard)
						lastWardInsec = os.clock() + 0.5
						return true
					end
				elseif flash ~= nil then
					local targetObj2 = nil
					if Config.miscs.predInSec then
						targetObj2, HitChance = VP:GetPredictedPos(targetObj, 0.25, 2000, myHero)
					else
						targetObj2 = targetObj
					end
				
					local wardDistance = 400
					local dPredict = GetDistance(targetObj2, friendlyObj)
					local xE = friendlyObj.x + ((dPredict + wardDistance) / dPredict) * (targetObj2.x - friendlyObj.x)
					local zE = friendlyObj.z + ((dPredict + wardDistance) / dPredict) * (targetObj2.z - friendlyObj.z)
				
					local positiona = {}
					positiona.x = xE
					positiona.z = zE
					if GetDistance(myHero, positiona) < 600 then
						CastSpell(flash, xE, zE)
						return true
					end
				end
			end
		end
	end

	if Config.insettings.insecMode == 1 then
		if myHero:CanUseSpell(_R) == READY and targetObj ~= nil and targetObj.valid and ValidTarget(targetObj) then
			if myHero:GetDistance(targetObj) < 375 then
				local dPredict = GetDistance(targetObj, myHero)
				
				local xE = myHero.x + ((dPredict + 500) / dPredict) * (targetObj.x - myHero.x)
				local zE = myHero.z + ((dPredict + 500) / dPredict) * (targetObj.z - myHero.z)
			
				local positiona = {}
				positiona.x = xE
				positiona.z = zE
			
				local newDistance = GetDistance(FindNearestAlly(), targetObj) - GetDistance(FindNearestAlly(), positiona)
				if newDistance > 0 and (newDistance / 500) > 0.7 then
					CastSpell(_R, targetObj)
					return true
				end
			end

			if FREADY then
				if lastTime > (GetTickCount() - 1000) then
					if (GetTickCount() - lastTime) >= 10 then
						--CastSpell(_W, lastWard)
						lastWardInsec = os.clock() + 0.5
						return true
					end
				elseif flash ~= nil then
					local targetObj2 = nil
					if Config.miscs.predInSec then
						targetObj2, HitChance = VP:GetPredictedPos(targetObj, 0.25, 2000, myHero)
					else
						targetObj2 = targetObj
					end
				
					local wardDistance = 400
					local dPredict = GetDistance(targetObj2, FindNearestAlly())
					local xE = FindNearestAlly().x + ((dPredict + wardDistance) / dPredict) * (targetObj2.x - FindNearestAlly().x)
					local zE = FindNearestAlly().z + ((dPredict + wardDistance) / dPredict) * (targetObj2.z - FindNearestAlly().z)
				
					local positiona = {}
					positiona.x = xE
					positiona.z = zE
					if GetDistance(myHero, positiona) < 600 then
						CastSpell(flash, xE, zE)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function OnProcessSpell(obj, unit, spell)
	if unit.name == myHero.name then
		if spell.name == "BlindMonkQOne" then
			lastTimeQ = GetTickCount()
		end
	end
	if obj.isMe and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then Qtime = os.clock() end
	if obj.isMe and myHero:GetSpellData(_W).name == "BlindMonkWOne" then Wtime = os.clock() end
	if obj.isMe and myHero:GetSpellData(_E).name == "BlindMonkEOne" then Etime = os.clock() end
end

function starjump()
		if myHero:CanUseSpell(_W) == READY and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
			if lastTime > (GetTickCount() - 1000) then
				if (GetTickCount() - lastTime) >= 10 then
					CastSpell(_W, lastWard)
				end
	elseif useSight ~= nil then
					if ValidTarget(ts.target, sRange) and (TargetHaveBuff("blindmonkpassive_cosmetic", myHero) or TargetHaveBuff("BlindMonkQOne", myHero)) and myHero:CanUseSpell(_R) == READY then
                           CastSpell(useSight, ts.target.x, ts.target.z)
					end
			end
		end
end

function combo(inseca)
        local QREADY = (myHero:CanUseSpell(_Q) == READY)
        local WREADY = (myHero:CanUseSpell(_W) == READY)
        local EREADY = (myHero:CanUseSpell(_E) == READY)
        local RREADY = (myHero:CanUseSpell(_R) == READY)
       
        local TIAMATSlot = GetInventorySlotItem(3077)
        local TIAMATREADY = (TIAMATSlot ~= nil and myHero:CanUseSpell(TIAMATSlot) == READY)
        local HYDRASlot = GetInventorySlotItem(3074)
        local HYDRAREADY = (HYDRASlot ~= nil and myHero:CanUseSpell(HYDRASlot) == READY)
        local BLADESLot = GetInventorySlotItem(3153)
        local BLADEREADY = (BLADESLot ~= nil and myHero:CanUseSpell(BLADESLot) == READY)
        local BILGESlot = GetInventorySlotItem(3144)
        local BILGEREADY = (BILGESlot ~= nil and myHero:CanUseSpell(BILGESlot) == READY)
        local RANDSlot = GetInventorySlotItem(3143)
        local RANDREADY = (RANDSlot ~= nil and myHero:CanUseSpell(RANDSlot) == READY)
        local bladeaSlot = GetInventorySlotItem(3142)
        local bladeaaREADY = (bladeaSlot ~= nil and myHero:CanUseSpell(bladeaSlot) == READY)
 
        local focusEnemy = nil
        local minimumHit = -1
        local lowPriority = false
       
        local rangeFocus = 400
        if QREADY then
                rangeFocus = 1000
        end
       
        local insecOk = false
        if inseca ~= nil and inseca.valid and ValidTarget(inseca) then
                focusEnemy = inseca
                insecOk = true
        else
                ts:update()
                focusEnemy = ts.target
        end
       
        if focusEnemy ~= nil then
                if QREADY then
                        if myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
							if VIP_USER and Config.Ads.prodiction then
								local pos, info = Prodiction.GetPrediction(focusEnemy, skills.SkillQ.range, skills.SkillQ.speed, skills.SkillQ.delay, skills.SkillQ.width)
								if info.hitchance >= 2 and GetDistance(pos) <= 1000 and not Config.insettings.igCol then 
								ProdictQ:GetPredictionCallBack(focusEnemy, CastQ)
								elseif info.hitchance >= 2 and GetDistance(pos) <= 1000 and Config.insettings.igCol then 
								CastSpell(_Q, pos.x, pos.z)
								elseif info.hitchance >= 2 and GetDistance(pos) <= 1000 and Config.insettings.igCol or not Config.insettings.igCol then
								CastQ(focusEnemy)
								end
							else
                                local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(focusEnemy, qDelay, qWidth, qRange, qSpeed, myHero, true)
                                if HitChance >= 2 then
                                        CastSpell(_Q, CastPosition.x, CastPosition.z)
                                        return
                                end
							end
                        elseif targetHasQ(focusEnemy) and (myHero:GetDistance(focusEnemy) > 500 or insecOk or (getQDmg(focusEnemy, 0) + getDmg("AD", focusEnemy, myHero)) > focusEnemy.health or (GetTickCount() - lastTimeQ) > 2500) then
                                if insecOk then
                                        lastWardInsec = os.clock() + 1
                                end
                               
                                CastSpell(_Q)
                                return
                        end
                end
               
                if BILGEREADY and myHero:GetDistance(focusEnemy) < 450 then
                        CastSpell(BILGESlot, focusEnemy)
                        return
                end
               
                if BLADEREADY and myHero:GetDistance(focusEnemy) < 450 then
                        CastSpell(BLADESLot, focusEnemy)
                        return
                end
               
                if TIAMATREADY and enemiesAround(350) >= 1 then
                        CastSpell(TIAMATSlot)
                        return
                end
               
                if HYDRAREADY and (enemiesAround(350) >= 2 or (getDmg("AD", focusEnemy, myHero) < focusEnemy.health and enemiesAround(350) == 1)) then
                        CastSpell(HYDRASlot)
                        return
                end
               
                if RANDREADY and enemiesAround(450) >= 1 then
                        CastSpell(RANDSlot)
                        return
                end
               
                if canAutoMove() then
                        myHero:Attack(focusEnemy)
                        return
                end
        end
       
        if Config.miscs.following then
                myHero:MoveTo(mousePos.x, mousePos.z)
        end
end

function normalcombo()
        local QREADY = (myHero:CanUseSpell(_Q) == READY)
        local WREADY = (myHero:CanUseSpell(_W) == READY)
        local EREADY = (myHero:CanUseSpell(_E) == READY)
        local RREADY = (myHero:CanUseSpell(_R) == READY)
       
        local TIAMATSlot = GetInventorySlotItem(3077)
        local TIAMATREADY = (TIAMATSlot ~= nil and myHero:CanUseSpell(TIAMATSlot) == READY)
        local HYDRASlot = GetInventorySlotItem(3074)
        local HYDRAREADY = (HYDRASlot ~= nil and myHero:CanUseSpell(HYDRASlot) == READY)
        local BLADESLot = GetInventorySlotItem(3153)
        local BLADEREADY = (BLADESLot ~= nil and myHero:CanUseSpell(BLADESLot) == READY)
        local BILGESlot = GetInventorySlotItem(3144)
        local BILGEREADY = (BILGESlot ~= nil and myHero:CanUseSpell(BILGESlot) == READY)
        local RANDSlot = GetInventorySlotItem(3143)
        local RANDREADY = (RANDSlot ~= nil and myHero:CanUseSpell(RANDSlot) == READY)
        local bladeaSlot = GetInventorySlotItem(3142)
        local bladeaaREADY = (bladeaSlot ~= nil and myHero:CanUseSpell(bladeaSlot) == READY)
 
        local focusEnemy = nil
        local minimumHit = -1
        local lowPriority = false
       
        local rangeFocus = 400
        if QREADY then
                rangeFocus = 1000
        end
       
                ts:update()
                focusEnemy = ts.target
       
       if focusEnemy ~= nil then
                if QREADY and Config.csettings.qusage then
                        if myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
							if VIP_USER and Config.Ads.prodiction then
								local pos, info = Prodiction.GetPrediction(focusEnemy, skills.SkillQ.range, skills.SkillQ.speed, skills.SkillQ.delay, skills.SkillQ.width)
								if info.hitchance >= 2 and GetDistance(pos) <= 1000 then 
								ProdictQ:GetPredictionCallBack(focusEnemy, CastQ)
								else
								CastQ(focusEnemy)
								end
							else
                                local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(focusEnemy, qDelay, qWidth, qRange, qSpeed, myHero, true)
                                if HitChance >= 2 then
                                        CastSpell(_Q, CastPosition.x, CastPosition.z)
                                        return
                                end
							end
                        elseif targetHasQ(focusEnemy) and (myHero:GetDistance(focusEnemy) > 500 or (getQDmg(focusEnemy, 0) + getDmg("AD", focusEnemy, myHero)) > focusEnemy.health or (GetTickCount() - lastTimeQ) > 2500) then
                                lastWardInsec = os.clock() + 1
                               
                                CastSpell(_Q)
                                return
                        end
                end
               
                if EREADY and Config.csettings.eusage and (not RREADY or os.clock() > lastWardInsec) then
                        if myHero:GetSpellData(_E).name == "BlindMonkEOne" and enemiesAround(300) >= 1 then
                                CastSpell(_E)
                                return
                        elseif enemiesAround(450) >= 1 and myHero:GetSpellData(_E).name ~= "BlindMonkEOne" then
                                CastSpell(_E)
                                return
                        end
                end
               
                if RREADY and Config.csettings.rusage and Config.useUlt["ult"..focusEnemy.charName] and myHero:GetDistance(focusEnemy) <= 375 then
                        local prociR = getDmg("R", focusEnemy, myHero) / focusEnemy.health
                        local healthLeft = focusEnemy.health - getDmg("R", focusEnemy, myHero)
                       
                        if (prociR > 1 and prociR < 2.5) or (getQDmg(focusEnemy, healthLeft) > healthLeft and targetHasQ(focusEnemy) and QREADY) then
                                CastSpell(_R, focusEnemy)
                                return
                        end
                end
               
                if WREADY and Config.csettings.autowusage then
                        if enemiesAround(300) >= 1 and (myHero.health / myHero.maxHealth) < 0.6 then
                                CastSpell(_W)
                                return
                        end
                end
				
				if WREADY and Config.csettings.wusage then
                         if enemiesAround(300) >= 1 then
                                CastSpell(_W)
                                return
                        end
                end
               
                if BILGEREADY and myHero:GetDistance(focusEnemy) < 450 then
                        CastSpell(BILGESlot, focusEnemy)
                        return
                end
               
                if BLADEREADY and myHero:GetDistance(focusEnemy) < 450 then
                        CastSpell(BLADESLot, focusEnemy)
                        return
                end
               
                if TIAMATREADY and enemiesAround(350) >= 1 then
                        CastSpell(TIAMATSlot)
                        return
                end
               
                if HYDRAREADY and (enemiesAround(350) >= 2 or (getDmg("AD", focusEnemy, myHero) < focusEnemy.health and enemiesAround(350) == 1)) then
                        CastSpell(HYDRASlot)
                        return
                end
               
                if RANDREADY and enemiesAround(450) >= 1 then
                        CastSpell(RANDSlot)
                        return
                end
               
                if canAutoMove() then
                        myHero:Attack(focusEnemy)
                        return
                end
        end
       
        if Config.miscs.following then
                myHero:MoveTo(mousePos.x, mousePos.z)
        end
end

function starcombo()
        local QREADY = (myHero:CanUseSpell(_Q) == READY)
        local WREADY = (myHero:CanUseSpell(_W) == READY)
        local EREADY = (myHero:CanUseSpell(_E) == READY)
        local RREADY = (myHero:CanUseSpell(_R) == READY)
       
        local TIAMATSlot = GetInventorySlotItem(3077)
        local TIAMATREADY = (TIAMATSlot ~= nil and myHero:CanUseSpell(TIAMATSlot) == READY)
        local HYDRASlot = GetInventorySlotItem(3074)
        local HYDRAREADY = (HYDRASlot ~= nil and myHero:CanUseSpell(HYDRASlot) == READY)
        local BLADESLot = GetInventorySlotItem(3153)
        local BLADEREADY = (BLADESLot ~= nil and myHero:CanUseSpell(BLADESLot) == READY)
        local BILGESlot = GetInventorySlotItem(3144)
        local BILGEREADY = (BILGESlot ~= nil and myHero:CanUseSpell(BILGESlot) == READY)
        local RANDSlot = GetInventorySlotItem(3143)
        local RANDREADY = (RANDSlot ~= nil and myHero:CanUseSpell(RANDSlot) == READY)
        local bladeaSlot = GetInventorySlotItem(3142)
        local bladeaaREADY = (bladeaSlot ~= nil and myHero:CanUseSpell(bladeaSlot) == READY)
 
        local focusEnemy = nil
        local minimumHit = -1
        local lowPriority = false
       
        local rangeFocus = 400
        if QREADY then
                rangeFocus = 1000
        end
       
                ts:update()
                focusEnemy = ts.target
       
       if focusEnemy ~= nil then
                if QREADY then
                        if myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
							if VIP_USER and Config.Ads.prodiction then
								local pos, info = Prodiction.GetPrediction(focusEnemy, skills.SkillQ.range, skills.SkillQ.speed, skills.SkillQ.delay, skills.SkillQ.width)
								if info.hitchance >= 2 and GetDistance(pos) <= 1100 then 
								ProdictQ:GetPredictionCallBack(focusEnemy, CastQ)
								else
								CastSpell(_Q, pos.x, pos.z)
								end
							else
                                local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(focusEnemy, qDelay, qWidth, qRange, qSpeed, myHero, true)
                                if HitChance >= 2 then
                                        CastSpell(_Q, CastPosition.x, CastPosition.z)
                                        return
                                end
							end
                        
							if targetHasQ(focusEnemy) and (myHero:GetDistance(focusEnemy) > 500 or (getQDmg(focusEnemy, 0) + getDmg("AD", focusEnemy, myHero)) > focusEnemy.health or (GetTickCount() - lastTimeQ) > 2500) then
                                lastWardInsec = os.clock() + 1
								starjump()
							end
						end
                end
				
               
                if RREADY and myHero:GetDistance(focusEnemy) <= 375 then
                                CastSpell(_R, focusEnemy)
                                return
                end
				
				if starjump() ~= true and not RREADY then
					if targetHasQ(focusEnemy) and (myHero:GetDistance(focusEnemy) > 500 or (getQDmg(focusEnemy, 0) + getDmg("AD", focusEnemy, myHero)) > focusEnemy.health or (GetTickCount() - lastTimeQ) > 2500) then
                                lastWardInsec = os.clock() + 1
                               
                                CastSpell(_Q)
                                return
                        end
					end
				
				if EREADY and (not RREADY or os.clock() > lastWardInsec) then
                        if myHero:GetSpellData(_E).name == "BlindMonkEOne" and enemiesAround(300) >= 1 then
                                CastSpell(_E)
                                return
                        elseif enemiesAround(450) >= 1 and myHero:GetSpellData(_E).name ~= "BlindMonkEOne" then
                                CastSpell(_E)
                                return
                        end
                end
               
                if BILGEREADY and myHero:GetDistance(focusEnemy) < 450 then
                        CastSpell(BILGESlot, focusEnemy)
                        return
                end
               
                if BLADEREADY and myHero:GetDistance(focusEnemy) < 450 then
                        CastSpell(BLADESLot, focusEnemy)
                        return
                end
               
                if TIAMATREADY and enemiesAround(350) >= 1 then
                        CastSpell(TIAMATSlot)
                        return
                end
               
                if HYDRAREADY and (enemiesAround(350) >= 2 or (getDmg("AD", focusEnemy, myHero) < focusEnemy.health and enemiesAround(350) == 1)) then
                        CastSpell(HYDRASlot)
                        return
                end
               
                if RANDREADY and enemiesAround(450) >= 1 then
                        CastSpell(RANDSlot)
                        return
                end
               
                if canAutoMove() then
                        myHero:Attack(focusEnemy)
                        return
                end
        end
       
        if Config.miscs.following then
                myHero:MoveTo(mousePos.x, mousePos.z)
        end
end
 
function targetHasQ(target)
		local dd = false
		if TargetHaveBuff("blindmonkpassive_cosmetic", myHero) or TargetHaveBuff("BlindMonkQOne", myHero) and (buff.endT - GetGameTimer()) >= 0.3 then
			dd = true
		end
        return dd
end

function getQDmg(target, health)
        local dmg = 0
        local qDMG = 0
        if myHero:CanUseSpell(_Q) == READY then
                local spellQ = myHero:GetSpellData(_Q)
                if spellQ.name == "BlindMonkQOne" then
                        qDMG = qDmgs[spellQ.level] + bonusDmg
                else
                        local dmgHealth = (target.maxHealth - target.health) * 0.08
                        if health > 0 then
                                dmgHealth = (target.maxHealth - health) * 0.08
                        end
                        qDMG = qDmgs[spellQ.level] + bonusDmg + dmgHealth
                end
        end
       
        if qDMG > 0 then
                dmg = myHero:CalcDamage(target, qDMG)
        end
       
        return dmg
end
 
function canAutoMove()
        local linea = nil
        local file = io.open(SCRIPT_PATH.."movementblock.txt", "r")
        if file ~= nil then
                for line in file:lines() do linea = line break end
                file:close()
        end
       
        if linea == "1" then
                return false
        else
                return true
        end
end
 
function DrawLine3Dcustom(x1, y1, z1, x2, y2, z2, width, color)
    local p = WorldToScreen(D3DXVECTOR3(x1, y1, z1))
    local px, py = p.x, p.y
    local c = WorldToScreen(D3DXVECTOR3(x2, y2, z2))
    local cx, cy = c.x, c.y
    DrawLine(cx, cy, px, py, width or 1, color or 4294967295)
end

function OnDraw()
       
        local QREADY = (myHero:CanUseSpell(_Q) == READY)
        local WREADY = (myHero:CanUseSpell(_W) == READY)
        local EREADY = (myHero:CanUseSpell(_E) == READY)
        local RREADY = (myHero:CanUseSpell(_R) == READY)
		local FREADY = (flash ~= nil and myHero:CanUseSpell(flash) == READY)
        local spellQ = myHero:GetSpellData(_Q)

    if Config.DrawSettings.DrawQ and QREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, 0xFF008000)
	elseif Config.DrawSettings.DrawQ and not QREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, 0xFFFF0000)
	end

	if Config.DrawSettings.DrawW and WREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, 0xFF008000)
	elseif Config.DrawSettings.DrawW and not WREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, 0xFFFF0000)
	end

	if Config.DrawSettings.DrawE and EREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, 0xFF008000)
	elseif Config.DrawSettings.DrawE and not EREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, 0xFFFF0000)
	end

	if Config.DrawSettings.DrawR and RREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, 0xFF008000)
	elseif Config.DrawSettings.DrawR and not RREADY and not myHero.dead then
		DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, 0xFFFF0000)
	end
       
        if RREADY and WREADY and Config.insettings.insecMode == 2 then
                if useSight ~= nil then
                        local validTargets = 0
                        if targetObj ~= nil and targetObj.valid and ValidTarget(targetObj) then
                                DrawCircle(targetObj.x, targetObj.y, targetObj.z, 70, 0x00CC00)
                                validTargets = validTargets + 1
                        end
                       
                        if friendlyObj ~= nil and friendlyObj.valid then
                                DrawCircle(friendlyObj.x, friendlyObj.y, friendlyObj.z, 70, 0x00CC00)
                                validTargets = validTargets + 1
                        end
                       
                        if validTargets == 2 and Config.DrawSettings.drawInsec then
                                local dPredict = GetDistance(targetObj, friendlyObj)
                                local rangeR = 300
                                if myHero:GetDistance(targetObj) <= 1000 then
                                        rangeR = 800
                                end
                                local xQ = targetObj.x + (rangeR / dPredict) * (friendlyObj.x - targetObj.x)
                                local zQ = targetObj.z + (rangeR / dPredict) * (friendlyObj.z - targetObj.z)
                               
                                local positiona = {}
                                positiona.x = xQ
                                positiona.z = zQ
                               
                                DrawLine3Dcustom(targetObj.x, targetObj.y, targetObj.z, positiona.x, targetObj.y, positiona.z, 2)
                        end
                end
        elseif RREADY and WREADY and Config.insettings.insecMode == 1 then
                if useSight ~= nil then
                        local validTargets = 0
                        if targetObj ~= nil and targetObj.valid and ValidTarget(targetObj) then
                                DrawCircle(targetObj.x, targetObj.y, targetObj.z, 70, 0x00CC00)
                                validTargets = validTargets + 1
                        end
                       
                        if FindNearestAlly() ~= nil and FindNearestAlly().valid then
                                DrawCircle(FindNearestAlly().x, FindNearestAlly().y, FindNearestAlly().z, 70, 0x00CC00)
                                validTargets = validTargets + 1
                        end
                       
                        if validTargets == 2 and Config.DrawSettings.drawInsec then
                                local dPredict = GetDistance(targetObj, FindNearestAlly())
                                local rangeR = 300
                                if myHero:GetDistance(targetObj) <= 1000 then
                                        rangeR = 800
                                end
                                local xQ = targetObj.x + (rangeR / dPredict) * (FindNearestAlly().x - targetObj.x)
                                local zQ = targetObj.z + (rangeR / dPredict) * (FindNearestAlly().z - targetObj.z)
                               
                                local positiona = {}
                                positiona.x = xQ
                                positiona.z = zQ
                               
                                DrawLine3Dcustom(targetObj.x, targetObj.y, targetObj.z, positiona.x, targetObj.y, positiona.z, 2)
                        end
                end
        end
		
		if RREADY and FREADY and not WREADY and Config.insettings.insecMode == 2 then
                if useSight ~= nil then
                        local validTargets = 0
                        if targetObj ~= nil and targetObj.valid and ValidTarget(targetObj) then
                                DrawCircle(targetObj.x, targetObj.y, targetObj.z, 70, 0x00CC00)
                                validTargets = validTargets + 1
                        end
                       
                        if friendlyObj ~= nil and friendlyObj.valid then
                                DrawCircle(friendlyObj.x, friendlyObj.y, friendlyObj.z, 70, 0x00CC00)
                                validTargets = validTargets + 1
                        end
                       
                        if validTargets == 2 and Config.DrawSettings.drawInsec then
                                local dPredict = GetDistance(targetObj, friendlyObj)
                                local rangeR = 300
                                if myHero:GetDistance(targetObj) <= 1000 then
                                        rangeR = 800
                                end
                                local xQ = targetObj.x + (rangeR / dPredict) * (friendlyObj.x - targetObj.x)
                                local zQ = targetObj.z + (rangeR / dPredict) * (friendlyObj.z - targetObj.z)
                               
                                local positiona = {}
                                positiona.x = xQ
                                positiona.z = zQ
                               
                                DrawLine3Dcustom(targetObj.x, targetObj.y, targetObj.z, positiona.x, targetObj.y, positiona.z, 2)
                        end
                end
        elseif RREADY and FREADY and not WREADY and Config.insettings.insecMode == 1 then
                if useSight ~= nil then
                        local validTargets = 0
                        if targetObj ~= nil and targetObj.valid and ValidTarget(targetObj) then
                                DrawCircle(targetObj.x, targetObj.y, targetObj.z, 70, 0x00CC00)
                                validTargets = validTargets + 1
                        end
                       
                        if FindNearestAlly() ~= nil and FindNearestAlly().valid then
                                DrawCircle(FindNearestAlly().x, FindNearestAlly().y, FindNearestAlly().z, 70, 0x00CC00)
                                validTargets = validTargets + 1
                        end
                       
                        if validTargets == 2 and Config.DrawSettings.drawInsec then
                                local dPredict = GetDistance(targetObj, FindNearestAlly())
                                local rangeR = 300
                                if myHero:GetDistance(targetObj) <= 1000 then
                                        rangeR = 800
                                end
                                local xQ = targetObj.x + (rangeR / dPredict) * (FindNearestAlly().x - targetObj.x)
                                local zQ = targetObj.z + (rangeR / dPredict) * (FindNearestAlly().z - targetObj.z)
                               
                                local positiona = {}
                                positiona.x = xQ
                                positiona.z = zQ
                               
                                DrawLine3Dcustom(targetObj.x, targetObj.y, targetObj.z, positiona.x, targetObj.y, positiona.z, 2)
                        end
                end
        end
       
        local TIAMATSlot = GetInventorySlotItem(3077)
        local TIAMATREADY = (TIAMATSlot ~= nil and myHero:CanUseSpell(TIAMATSlot) == READY)
        local HYDRASlot = GetInventorySlotItem(3074)
        local HYDRAREADY = (HYDRASlot ~= nil and myHero:CanUseSpell(HYDRASlot) == READY)
       
        for i=1, heroManager.iCount do
                local enemy = heroManager:GetHero(i)
                if ValidTarget(enemy) then
                        local tempHealth = enemy.health - getDmg("AD", enemy, myHero)
                       
                        if QREADY then
                                tempHealth = tempHealth - myHero:CalcDamage(enemy, (qDmgs[spellQ.level] + bonusDmg))
                        end
                       
                        if RREADY and Config.useUlt["ult"..enemy.charName] then
                                tempHealth = tempHealth - getDmg("R", enemy, myHero)
                        end
                       
                        if EREADY then
                                tempHealth = tempHealth - getDmg("E", enemy, myHero)
                        end
                       
                        if QREADY then
                                tempHealth = tempHealth - myHero:CalcDamage(enemy, (qDmgs[spellQ.level] + bonusDmg + ((enemy.maxHealth - tempHealth) * 0.08)))
                        end
                       
                        if tempHealth < 0 then
                                DrawText3D(tostring("Kill him"), enemy.x, enemy.y, enemy.z, 20, RGB(222, 245, 15), true)
                        end
                end
        end
end

-- Change skin function, made by Shalzuth
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

function skinChanged()
	return Config.Ads.VIP.skin1 ~= lastSkin
end

function LaneClear()
	for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then
			if myHero:GetSpellData(_Q).name == "BlindMonkQOne" and Config.Laneclear.useClearQ and skills.SkillQ.ready and ValidTarget(targetMinion, skills.SkillQ.range) and GetDistance(targetMinion, myHero) <= 1000 then
				if  Passive.ready == false then
				CastSpell(_Q, targetMinion.x, targetMinion.z)
				end
			elseif TargetHaveBuff("BlindMonkQOne", myHero) or TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and GetDistance(targetMinion) < 500 then
				CastSpell(_Q)
			end
			if myHero:GetSpellData(_E).name == "BlindMonkEOne" and Config.Laneclear.useClearE and skills.SkillE.ready and ValidTarget(targetMinion, Ranges.AA) then
				if  Passive.ready == false then
				CastSpell(_E, targetMinion)
				end
			elseif TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and GetDistance(targetMinion) < 500 then
				CastSpell(_E)
			end
			if myHero:GetSpellData(_W).name == "BlindMonkWOne" and Config.Laneclear.useClearW and skills.SkillW.ready then
				if  Passive.ready == false then
				CastSpell(_W)
				end
			elseif GetDistance(targetMinion) < 200 then
				CastSpell(_W)
			end
		end
	end
end

function JungleClear()
	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil then
			if myHero:GetSpellData(_Q).name == "BlindMonkQOne" and Config.Laneclear.useClearQ and skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) and GetDistance(jungleMinion, myHero) <= 1000 then
				if  Passive.ready == false then
				CastSpell(_Q, jungleMinion.x, jungleMinion.z)
				end
			elseif TargetHaveBuff("BlindMonkQOne", myHero) or TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and GetDistance(jungleMinion) < 500 then
				CastSpell(_Q)
			end
			if myHero:GetSpellData(_E).name == "BlindMonkEOne" and Config.Laneclear.useClearE and skills.SkillE.ready and ValidTarget(jungleMinion, Ranges.AA) then
				if  Passive.ready == false then
				CastSpell(_E, jungleMinion)
				end
			elseif TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and GetDistance(jungleMinion) < 500 then
				CastSpell(_E)
			end
			if myHero:GetSpellData(_W).name == "BlindMonkWOne" and Config.Laneclear.useClearW and skills.SkillW.ready then
				if  Passive.ready == false then
				CastSpell(_W)
				end
			elseif GetDistance(jungleMinion) < 200 then
				CastSpell(_W)
			end
		end
	end
end

function CastQ(unit, focusEnemy, spell)
		ts:update()
		focusEnemy = ts.target
        if GetDistance(focusEnemy) - getHitBoxRadius(unit)/2 < skills.SkillQ.range then
            local willCollide = ProdictQCol:GetMinionCollision(focusEnemy, myHero)
            if not willCollide then CastSpell(_Q, focusEnemy.x, focusEnemy.z) end
		end
end

function OnGainBuff(unit, buff)
	if unit == nil or buff == nil or buff.name == nil then return end

	if unit.isMe and buff.name == "blindmonkpassive_cosmetic" then
		Passive.ready = true
		Passive.stacks = buff.stack
	end

	if buff.source and buff.source.isMe and buff.name:lower():find("blindmonkqone") then
		qTarget = unit
	end
end

function OnUpdateBuff(unit, buff)
	if unit == nil or buff == nil or buff.name == nil then return end

	if unit.isMe and buff.name == "blindmonkpassive_cosmetic" then
		Passive.stacks = buff.stack
	end
end

function OnLoseBuff(unit, buff)
	if unit == nil or buff == nil or buff.name == nil then return end

	if unit.isMe and buff.name == "blindmonkpassive_cosmetic" then
		Passive.ready = false
		Passive.stacks = 0
	end

	if buff.source and buff.source.isMe and buff.name:lower():find("blindmonkqone") then
		qTarget = nil
	end
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
