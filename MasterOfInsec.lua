if myHero.charName ~= "LeeSin" then return end

local version = "1.2"
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

RequireI:Check()

if RequireI.downloadNeeded == true then return end

ScriptName = SCRIPT_NAME

function analytics()
	UpdateWeb(true, ScriptName, id, HWID)
end

HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
id = 31


local qRange, qDelay, qSpeed, qWidth = 1050, 0.25, 1800, 60

local allyMinions = {}
local lastTime, lastTimeQ, bonusDmg = 0, 0, 0
local qDmgs = {50, 80, 110, 140, 170}
local useSight, lastWard, targetObj, friendlyObj = nil, nil, nil, nil
local VP, ts = nil, nil

local lastSkin = 0

function OnLoad()
	Config = scriptConfig("Master of Insec", "LeeSinCombo")
	
	Config:addParam("scriptActive", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Config:addParam("insecMake", "Insec", SCRIPT_PARAM_ONKEYDOWN, false, 84)
	Config:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, 71)
	Config:addParam("wardJump", "Ward Jump", SCRIPT_PARAM_ONKEYDOWN, false, 67)
	
	Config:addSubMenu("Draw Settings", "draws")
	Config.draws:addParam("drawInsec", "Draw InSec Line", SCRIPT_PARAM_ONOFF, true)
	Config.draws:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, false)
	Config:addSubMenu("Misc Settings", "miscs")
	Config.miscs:addParam("wardJumpmax", "Ward Jump on max range if mouse too far", SCRIPT_PARAM_ONOFF, true)
	Config.miscs:addParam("predInSec", "Use prediction for InSec", SCRIPT_PARAM_ONOFF, false)
	Config.miscs:addParam("following", "Follow while combo", SCRIPT_PARAM_ONOFF, true)
	Config:addSubMenu("Ultimate Settings", "useUlt")
	Config:addSubMenu("Additionals", "Ads")
	Config.Ads:addSubMenu("Skin Changer", "VIP")
	Config.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
	Config.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 7)
	
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
		if enemy.team ~= myHero.team then
			Config.useUlt:addParam("ult"..enemy.charName, "Use ultimate on "..enemy.charName, SCRIPT_PARAM_ONOFF, true)
		end
	end
	
	allyMinions = minionManager(MINION_ALLY, 1050, myHero, MINION_SORT_HEALTH_DES)
	
	if Config.Ads.VIP.skin then
		GenModelPacket("LeeSin", Config.Ads.VIP.skin1)
		lastSkin = Config.Ads.VIP.skin1
	end
	
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1050, DAMAGE_PHYSICAL)
	ts.name = "Lee Sin"
	Config:addTS(ts)
	
	VP = VPrediction()
	
	Orbwalker = SOW(VP)
	
	Config:permaShow("scriptActive")
	Config:permaShow("insecMake")
	Config:permaShow("harass")
	Config:permaShow("wardJump")
	
	Config:addSubMenu("[Orbwalker]", "SOWorb")
	Orbwalker:LoadToMenu(Config.SOWorb)
	
	PrintChat("<font color = \"#33CCCC\">[Lee Sin] Master of Insec</font> <font color = \"#fff8e7\">SilentStar v"..version.."</font>")
end

function OnTick()
	if myHero.dead then
		return
	end
	
	if not canAutoMove() then
		return
	end
	
	if Config.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("LeeSin", Config.Ads.VIP.skin1)
		lastSkin = Config.Ads.VIP.skin1
	end
	
	local SIGHTlot = GetInventorySlotItem(2049)
	local SIGHTREADY = (SIGHTlot ~= nil and myHero:CanUseSpell(SIGHTlot) == READY)
	local SIGHTlot2 = GetInventorySlotItem(2045)
	local SIGHTREADY2 = (SIGHTlot2 ~= nil and myHero:CanUseSpell(SIGHTlot2) == READY)
	local SIGHTlot3 = GetInventorySlotItem(3340)
	local SIGHTREADY3 = (SIGHTlot3 ~= nil and myHero:CanUseSpell(SIGHTlot3) == READY)
	local SIGHTlot4 = GetInventorySlotItem(2044)
	local SIGHTREADY4 = (SIGHTlot4 ~= nil and myHero:CanUseSpell(SIGHTlot4) == READY)
	local SIGHTlot5 = GetInventorySlotItem(3361)
	local SIGHTREADY5 = (SIGHTlot5 ~= nil and myHero:CanUseSpell(SIGHTlot5) == READY)
	local SIGHTlot6 = GetInventorySlotItem(3362)
	local SIGHTREADY6 = (SIGHTlot6 ~= nil and myHero:CanUseSpell(SIGHTlot6) == READY)
	local SIGHTlot7 = GetInventorySlotItem(3154)
	local SIGHTREADY7 = (SIGHTlot7 ~= nil and myHero:CanUseSpell(SIGHTlot7) == READY)
	local SIGHTlot8 = GetInventorySlotItem(3160)
	local SIGHTREADY8 = (SIGHTlot8 ~= nil and myHero:CanUseSpell(SIGHTlot8) == READY)
	
	useSight = nil
	if SIGHTREADY then
		useSight = SIGHTlot
	elseif SIGHTREADY2 then
		useSight = SIGHTlot2
	elseif SIGHTREADY7 then
		useSight = SIGHTlot7
	elseif SIGHTREADY8 then
		useSight = SIGHTlot8
	elseif SIGHTREADY3 then
		useSight = SIGHTlot3
	elseif SIGHTREADY5 then
		useSight = SIGHTlot5
	elseif SIGHTREADY6 then
		useSight = SIGHTlot6
	elseif SIGHTREADY4 then
		useSight = SIGHTlot4
	end
	
	bonusDmg = myHero.addDamage * 0.90
	
	local target = GetTarget()
	if target ~= nil then
		if string.find(target.type, "Hero") and target.team ~= myHero.team then
			targetObj = target
		elseif target.team == myHero.team then
			friendlyObj = target
		end
	end
	
	if Config.insecMake then
		if insec() then return end
	end
	
	if Config.scriptActive or Config.insecMake then
		local inseca = nil
		if Config.insecMake then inseca = targetObj end
		combo(inseca)
		return
	end
	
	if Config.wardJump then
		moveToCursor()
		wardJump()
		return
	end
	
	if Config.harass then
		harass()
	end
end

function moveToCursor()
		if GetDistance(mousePos) then
			local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
				myHero:MoveTo(moveToPos.x, moveToPos.z)
		end		
	end

function harass()
	for i=1, heroManager.iCount do
		local target = heroManager:GetHero(i)
		if ValidTarget(target, 1050) then
			if myHero:CanUseSpell(_Q) == READY then
				if myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
					local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, qDelay, qWidth, qRange, qSpeed, myHero, true)
					if HitChance >= 2 then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
						return
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
	
	if Config.wardJump or Config.insecMake then
		if object ~= nil and object.valid and (object.name == "VisionWard" or object.name == "SightWard") then
			lastWard = object
			lastTime = GetTickCount()
		end
	end
end


local lastWardInsec = 0

function insec()
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
	
	return false
end

function OnProcessSpell(unit, spell)
	if unit.name == myHero.name then
		if spell.name == "BlindMonkQOne" then
			lastTimeQ = GetTickCount()
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
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(focusEnemy, qDelay, qWidth, qRange, qSpeed, myHero, true)
				if HitChance >= 2 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
					return
				end
			elseif targetHasQ(focusEnemy) and (myHero:GetDistance(focusEnemy) > 500 or insecOk or (getQDmg(focusEnemy, 0) + getDmg("AD", focusEnemy, myHero)) > focusEnemy.health or (GetTickCount() - lastTimeQ) > 2500) then
				if insecOk then
					lastWardInsec = os.clock() + 1
				end
				
				CastSpell(_Q)
				return
			end
		end
		
		if EREADY and (not insecOk or not RREADY or os.clock() > lastWardInsec) then
			if myHero:GetSpellData(_E).name == "BlindMonkEOne" and enemiesAround(300) >= 1 then
				CastSpell(_E)
				return
			elseif enemiesAround(450) >= 1 and myHero:GetSpellData(_E).name ~= "BlindMonkEOne" then
				CastSpell(_E)
				return
			end
		end
		
		if RREADY and Config.useUlt["ult"..focusEnemy.charName] and myHero:GetDistance(focusEnemy) <= 375 then
			local prociR = getDmg("R", focusEnemy, myHero) / focusEnemy.health
			local healthLeft = focusEnemy.health - getDmg("R", focusEnemy, myHero)
			
			if (prociR > 1 and prociR < 2.5) or (getQDmg(focusEnemy, healthLeft) > healthLeft and targetHasQ(focusEnemy) and QREADY) then
				CastSpell(_R, focusEnemy)
				return
			end
		end
		
		if WREADY and not insecOk then
			if myHero:GetSpellData(_W).name ~= "BlindMonkWOne" and (myHero.health / myHero.maxHealth) < 0.6 then
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

function targetHasQ(target)
	local dd = false
	for b=1, target.buffCount do
		local buff = target:getBuff(b)
		if buff.valid and (buff.name == "BlindMonkQOne" or buff.name == "blindmonkqonechaos") and (buff.endT - GetGameTimer()) >= 0.3 then
			dd = true
			break
		end
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
	if Config.draws.drawQ then
		DrawCircle(myHero.x, myHero.y, myHero.z, 1050, 0x25de69)
	end
	
	local QREADY = (myHero:CanUseSpell(_Q) == READY)
	local WREADY = (myHero:CanUseSpell(_W) == READY)
	local EREADY = (myHero:CanUseSpell(_E) == READY)
	local RREADY = (myHero:CanUseSpell(_R) == READY)
	local spellQ = myHero:GetSpellData(_Q)
	
	if RREADY and WREADY then
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
			
			if validTargets == 2 and Config.draws.drawInsec then
				local dPredict = GetDistance(targetObj, friendlyObj)
				local rangeR = 300
				if myHero:GetDistance(targetObj) <= 1100 then
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
