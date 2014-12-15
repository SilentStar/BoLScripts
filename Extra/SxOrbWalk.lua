class "SxOrbWalk"
function SxOrbWalk:__init()
  self.Color = { Red = ARGB(0xFF,0xFF,0,0),Green = ARGB(0xFF,0,0xFF,0),Blue = ARGB(0xFF,0,0,0xFF), White = ARGB(0xFF,0xFF,0xFF,0xFF), Black = ARGB(0xFF, 0x00, 0x00, 0x00)}
	self.IsBasicAttack = {["VayneCondemnMissile"] = true,["frostarrow"] = true,["CaitlynHeadshotMissile"] = true,["QuinnWEnhanced"] = true,["TrundleQ"] = true,["XenZhaoThrust"] = true,["XenZhaoThrust2"] = true,["XenZhaoThrust3"] = true,["GarenSlash2"] = true,["RenektonExecute"] = true,["RenektonSuperExecute"] = true,["KennenMegaProc"] = true,}
	self.ResetSpells = {["PowerFist"]=true,["DariusNoxianTacticsONH"] = true,["Takedown"] = true,["Ricochet"] = true,["BlindingDart"] = false,["VayneTumble"] = true,["JaxEmpowerTwo"] = true,["MordekaiserMaceOfSpades"] = true,["SiphoningStrikeNew"] = true,["RengarQ"] = true,["YorickSpectral"] = true,["ViE"] = true,["GarenSlash3"] = true,["HecarimRamp"] = true,["XenZhaoComboTarget"] = true,["LeonaShieldOfDaybreak"] = true,["TalonNoxianDiplomacy"] = true,["TrundleTrollSmash"] = true,["VolibearQ"] = true,["PoppyDevastatingBlow"] = true,["LucianQ"] = true,["SivirW"] = true,["DetonatingShot"] = false, ["RivenTriCleave"] = true}
	self.HotKeys = { ["Fight"] = {}, ["Harass"] = {}, ["LaneClear"] = {}, ["LastHit"] = {}, }
	self.LastToggle = { ["Fight"] = false, ["Harass"] = false, ["LaneClear"] = false, ["LastHit"] = false, }
	self.MinionAttacks = {}
	self.EnemyMinionAttacks = {}
	self.MinionLastTargets = {}
	self.LaneClearWaitMinion = {}
	self.KillAbleMinion = {}
	self.BeforeAttackCallbacks = {}
	self.OnAttackCallbacks = {}
	self.AfterAttackCallbacks = {}
	self.Minions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	self.LaneClearMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_DEC)
	self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_MAXHEALTH_DEC)
	self.OtherMinions = minionManager(MINION_OTHER, 2000, myHero, MINION_SORT_HEALTH_ASC)
	self.MyRange = myHero.range + myHero.boundingRadius
	self.BaseWindUpTime = 3
	self.BaseAnimationTime = 0.65
	self.Version = 1.58
	print("<font color=\"#F0Ff8d\"><b>SxOrbWalk: </b></font> <font color=\"#FF0F0F\">Version "..self.Version.." loaded</b></font>")

	self.LuaSocket = require("socket")
	self.AutoUpdate = {["Host"] = "raw.githubusercontent.com", ["VersionLink"] = "/SilentStar/BoLScripts/blob/master/Extra/SxOrbWalk.version", ["ScriptLink"] = "/SilentStar/BoLScripts/blob/master/Extra/SxOrbWalk.lua"}
	AddTickCallback(function() self:CheckUpdate() end)

end

function SxOrbWalk:CheckUpdate()
	if not self.AutoUpdate["VersionSocket"] then
		self.AutoUpdate["VersionSocket"] = self.LuaSocket.connect("sx-bol.de", 80)
		self.AutoUpdate["VersionSocket"]:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.AutoUpdate["Host"]..self.AutoUpdate["VersionLink"].."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
	end

	if not self.AutoUpdate["ServerVersion"] and self.AutoUpdate["VersionSocket"] then
			self.AutoUpdate["VersionSocket"]:settimeout(0, 'b')
			self.AutoUpdate["VersionSocket"]:settimeout(99999999, 't')
			self.AutoUpdate["VersionReceive"], self.AutoUpdate["VersionStatus"] = self.AutoUpdate["VersionSocket"]:receive('*a')
	end

	if not self.AutoUpdate["ServerVersion"] and self.AutoUpdate["VersionSocket"] and self.AutoUpdate["VersionStatus"] ~= 'timeout' and self.AutoUpdate["VersionReceive"] ~= nil then
		self.AutoUpdate["ServerVersion"] = tonumber(string.sub(self.AutoUpdate["VersionReceive"], string.find(self.AutoUpdate["VersionReceive"], "<bols".."cript>")+11, string.find(self.AutoUpdate["VersionReceive"], "</bols".."cript>")-1))
	end

	if self.AutoUpdate["ServerVersion"] and type(self.AutoUpdate["ServerVersion"]) == "number" and self.AutoUpdate["ServerVersion"] > self.Version and not self.AutoUpdate["Finished"] then
		self.AutoUpdate["ScriptSocket"] = self.LuaSocket.connect("sx-bol.de", 80)
		self.AutoUpdate["ScriptSocket"]:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.AutoUpdate["Host"]..self.AutoUpdate["ScriptLink"].."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
		self.AutoUpdate["ScriptReceive"], self.AutoUpdate["ScriptStatus"] = self.AutoUpdate["ScriptSocket"]:receive('*a')
		self.AutoUpdate["ScriptRAW"] = string.sub(self.AutoUpdate["ScriptReceive"], string.find(self.AutoUpdate["ScriptReceive"], "<bols".."cript>")+11, string.find(self.AutoUpdate["ScriptReceive"], "</bols".."cript>")-1)
		ScriptFileOpen = io.open(LIB_PATH.."SxOrbWalk.lua", "w+")
		ScriptFileOpen:write(self.AutoUpdate["ScriptRAW"])
		ScriptFileOpen:close()
		self.AutoUpdate["Finished"] = true
		print("<font color=\"#F0Ff8d\"><b>SxOrbWalk:</b></font> <font color=\"#FF0F0F\">New Version("..self.AutoUpdate["ServerVersion"]..") downloaded, load it with F9!</font>")
	end
end

function SxOrbWalk:GetProjSpeed(unit)
	self.ProjSpeed = {["Velkoz"]= 2000,["TeemoMushroom"] = math.huge,["TestCubeRender"] = math.huge ,["Xerath"] = 2000.0000 ,["Kassadin"] = math.huge ,["Rengar"] = math.huge ,["Thresh"] = 1000.0000 ,["Ziggs"] = 1500.0000 ,["ZyraPassive"] = 1500.0000 ,["ZyraThornPlant"] = 1500.0000 ,["KogMaw"] = 1800.0000 ,["HeimerTBlue"] = 1599.3999 ,["EliseSpider"] = 500.0000 ,["Skarner"] = 500.0000 ,["ChaosNexus"] = 500.0000 ,["Katarina"] = 467.0000 ,["Riven"] = 347.79999 ,["SightWard"] = 347.79999 ,["HeimerTYellow"] = 1599.3999 ,["Ashe"] = 2000.0000 ,["VisionWard"] = 2000.0000 ,["TT_NGolem2"] = math.huge ,["ThreshLantern"] = math.huge ,["TT_Spiderboss"] = math.huge ,["OrderNexus"] = math.huge ,["Soraka"] = 1000.0000 ,["Jinx"] = 2750.0000 ,["TestCubeRenderwCollision"] = 2750.0000 ,["Red_Minion_Wizard"] = 650.0000 ,["JarvanIV"] = 20.0000 ,["Blue_Minion_Wizard"] = 650.0000 ,["TT_ChaosTurret2"] = 1200.0000 ,["TT_ChaosTurret3"] = 1200.0000 ,["TT_ChaosTurret1"] = 1200.0000 ,["ChaosTurretGiant"] = 1200.0000 ,["Dragon"] = 1200.0000 ,["LuluSnowman"] = 1200.0000 ,["Worm"] = 1200.0000 ,["ChaosTurretWorm"] = 1200.0000 ,["TT_ChaosInhibitor"] = 1200.0000 ,["ChaosTurretNormal"] = 1200.0000 ,["AncientGolem"] = 500.0000 ,["ZyraGraspingPlant"] = 500.0000 ,["HA_AP_OrderTurret3"] = 1200.0000 ,["HA_AP_OrderTurret2"] = 1200.0000 ,["Tryndamere"] = 347.79999 ,["OrderTurretNormal2"] = 1200.0000 ,["Singed"] = 700.0000 ,["OrderInhibitor"] = 700.0000 ,["Diana"] = 347.79999 ,["HA_FB_HealthRelic"] = 347.79999 ,["TT_OrderInhibitor"] = 347.79999 ,["GreatWraith"] = 750.0000 ,["Yasuo"] = 347.79999 ,["OrderTurretDragon"] = 1200.0000 ,["OrderTurretNormal"] = 1200.0000 ,["LizardElder"] = 500.0000 ,["HA_AP_ChaosTurret"] = 1200.0000 ,["Ahri"] = 1750.0000 ,["Lulu"] = 1450.0000 ,["ChaosInhibitor"] = 1450.0000 ,["HA_AP_ChaosTurret3"] = 1200.0000 ,["HA_AP_ChaosTurret2"] = 1200.0000 ,["ChaosTurretWorm2"] = 1200.0000 ,["TT_OrderTurret1"] = 1200.0000 ,["TT_OrderTurret2"] = 1200.0000 ,["TT_OrderTurret3"] = 1200.0000 ,["LuluFaerie"] = 1200.0000 ,["HA_AP_OrderTurret"] = 1200.0000 ,["OrderTurretAngel"] = 1200.0000 ,["YellowTrinketUpgrade"] = 1200.0000 ,["MasterYi"] = math.huge ,["Lissandra"] = 2000.0000 ,["ARAMOrderTurretNexus"] = 1200.0000 ,["Draven"] = 1700.0000 ,["FiddleSticks"] = 1750.0000 ,["SmallGolem"] = math.huge ,["ARAMOrderTurretFront"] = 1200.0000 ,["ChaosTurretTutorial"] = 1200.0000 ,["NasusUlt"] = 1200.0000 ,["Maokai"] = math.huge ,["Wraith"] = 750.0000 ,["Wolf"] = math.huge ,["Sivir"] = 1750.0000 ,["Corki"] = 2000.0000 ,["Janna"] = 1200.0000 ,["Nasus"] = math.huge ,["Golem"] = math.huge ,["ARAMChaosTurretFront"] = 1200.0000 ,["ARAMOrderTurretInhib"] = 1200.0000 ,["LeeSin"] = math.huge ,["HA_AP_ChaosTurretTutorial"] = 1200.0000 ,["GiantWolf"] = math.huge ,["HA_AP_OrderTurretTutorial"] = 1200.0000 ,["YoungLizard"] = 750.0000 ,["Jax"] = 400.0000 ,["LesserWraith"] = math.huge ,["Blitzcrank"] = math.huge ,["ARAMChaosTurretInhib"] = 1200.0000 ,["Shen"] = 400.0000 ,["Nocturne"] = math.huge ,["Sona"] = 1500.0000 ,["ARAMChaosTurretNexus"] = 1200.0000 ,["YellowTrinket"] = 1200.0000 ,["OrderTurretTutorial"] = 1200.0000 ,["Caitlyn"] = 2500.0000 ,["Trundle"] = 347.79999 ,["Malphite"] = 1000.0000 ,["Mordekaiser"] = math.huge ,["ZyraSeed"] = math.huge ,["Vi"] = 1000.0000 ,["Tutorial_Red_Minion_Wizard"] = 650.0000 ,["Renekton"] = math.huge ,["Anivia"] = 1400.0000 ,["Fizz"] = math.huge ,["Heimerdinger"] = 1500.0000 ,["Evelynn"] = 467.0000 ,["Rumble"] = 347.79999 ,["Leblanc"] = 1700.0000 ,["Darius"] = math.huge ,["OlafAxe"] = math.huge ,["Viktor"] = 2300.0000 ,["XinZhao"] = 20.0000 ,["Orianna"] = 1450.0000 ,["Vladimir"] = 1400.0000 ,["Nidalee"] = 1750.0000 ,["Tutorial_Red_Minion_Basic"] = math.huge ,["ZedShadow"] = 467.0000 ,["Syndra"] = 1800.0000 ,["Zac"] = 1000.0000 ,["Olaf"] = 347.79999 ,["Veigar"] = 1100.0000 ,["Twitch"] = 2500.0000 ,["Alistar"] = math.huge ,["Akali"] = 467.0000 ,["Urgot"] = 1300.0000 ,["Leona"] = 347.79999 ,["Talon"] = math.huge ,["Karma"] = 1500.0000 ,["Jayce"] = 347.79999 ,["Galio"] = 1000.0000 ,["Shaco"] = math.huge ,["Taric"] = math.huge ,["TwistedFate"] = 1500.0000 ,["Varus"] = 2000.0000 ,["Garen"] = 347.79999 ,["Swain"] = 1600.0000 ,["Vayne"] = 2000.0000 ,["Fiora"] = 467.0000 ,["Quinn"] = 2000.0000 ,["Kayle"] = math.huge ,["Blue_Minion_Basic"] = math.huge ,["Brand"] = 2000.0000 ,["Teemo"] = 1300.0000 ,["Amumu"] = 500.0000 ,["Annie"] = 1200.0000 ,["Odin_Blue_Minion_caster"] = 1200.0000 ,["Elise"] = 1600.0000 ,["Nami"] = 1500.0000 ,["Poppy"] = 500.0000 ,["AniviaEgg"] = 500.0000 ,["Tristana"] = 2250.0000 ,["Graves"] = 3000.0000 ,["Morgana"] = 1600.0000 ,["Gragas"] = math.huge ,["MissFortune"] = 2000.0000 ,["Warwick"] = math.huge ,["Cassiopeia"] = 1200.0000 ,["Tutorial_Blue_Minion_Wizard"] = 650.0000 ,["DrMundo"] = math.huge ,["Volibear"] = 467.0000 ,["Irelia"] = 467.0000 ,["Odin_Red_Minion_Caster"] = 650.0000 ,["Lucian"] = 2800.0000 ,["Yorick"] = math.huge ,["RammusPB"] = math.huge ,["Red_Minion_Basic"] = math.huge ,["Udyr"] = 467.0000 ,["MonkeyKing"] = 20.0000 ,["Tutorial_Blue_Minion_Basic"] = math.huge ,["Kennen"] = 1600.0000 ,["Nunu"] = 500.0000 ,["Ryze"] = 2400.0000 ,["Zed"] = 467.0000 ,["Nautilus"] = 1000.0000 ,["Gangplank"] = 1000.0000 ,["Lux"] = 1600.0000 ,["Sejuani"] = 500.0000 ,["Ezreal"] = 2000.0000 ,["OdinNeutralGuardian"] = 1800.0000 ,["Khazix"] = 500.0000 ,["Sion"] = math.huge ,["Aatrox"] = 347.79999 ,["Hecarim"] = 500.0000 ,["Pantheon"] = 20.0000 ,["Shyvana"] = 467.0000 ,["Zyra"] = 1700.0000 ,["Karthus"] = 1200.0000 ,["Rammus"] = math.huge ,["Zilean"] = 1200.0000 ,["Chogath"] = 500.0000 ,["Malzahar"] = 2000.0000 ,["YorickRavenousGhoul"] = 347.79999 ,["YorickSpectralGhoul"] = 347.79999 ,["JinxMine"] = 347.79999 ,["YorickDecayedGhoul"] = 347.79999 ,["XerathArcaneBarrageLauncher"] = 347.79999 ,["Odin_SOG_Order_Crystal"] = 347.79999 ,["TestCube"] = 347.79999 ,["ShyvanaDragon"] = math.huge ,["FizzBait"] = math.huge ,["Blue_Minion_MechMelee"] = math.huge ,["OdinQuestBuff"] = math.huge ,["TT_Buffplat_L"] = math.huge ,["TT_Buffplat_R"] = math.huge ,["KogMawDead"] = math.huge ,["TempMovableChar"] = math.huge ,["Lizard"] = 500.0000 ,["GolemOdin"] = math.huge ,["OdinOpeningBarrier"] = math.huge ,["TT_ChaosTurret4"] = 500.0000 ,["TT_Flytrap_A"] = 500.0000 ,["TT_NWolf"] = math.huge ,["OdinShieldRelic"] = math.huge ,["LuluSquill"] = math.huge ,["redDragon"] = math.huge ,["MonkeyKingClone"] = math.huge ,["Odin_skeleton"] = math.huge ,["OdinChaosTurretShrine"] = 500.0000 ,["Cassiopeia_Death"] = 500.0000 ,["OdinCenterRelic"] = 500.0000 ,["OdinRedSuperminion"] = math.huge ,["JarvanIVWall"] = math.huge ,["ARAMOrderNexus"] = math.huge ,["Red_Minion_MechCannon"] = 1200.0000 ,["OdinBlueSuperminion"] = math.huge ,["SyndraOrbs"] = math.huge ,["LuluKitty"] = math.huge ,["SwainNoBird"] = math.huge ,["LuluLadybug"] = math.huge ,["CaitlynTrap"] = math.huge ,["TT_Shroom_A"] = math.huge ,["ARAMChaosTurretShrine"] = 500.0000 ,["Odin_Windmill_Propellers"] = 500.0000 ,["TT_NWolf2"] = math.huge ,["OdinMinionGraveyardPortal"] = math.huge ,["SwainBeam"] = math.huge ,["Summoner_Rider_Order"] = math.huge ,["TT_Relic"] = math.huge ,["odin_lifts_crystal"] = math.huge ,["OdinOrderTurretShrine"] = 500.0000 ,["SpellBook1"] = 500.0000 ,["Blue_Minion_MechCannon"] = 1200.0000 ,["TT_ChaosInhibitor_D"] = 1200.0000 ,["Odin_SoG_Chaos"] = 1200.0000 ,["TrundleWall"] = 1200.0000 ,["HA_AP_HealthRelic"] = 1200.0000 ,["OrderTurretShrine"] = 500.0000 ,["OriannaBall"] = 500.0000 ,["ChaosTurretShrine"] = 500.0000 ,["LuluCupcake"] = 500.0000 ,["HA_AP_ChaosTurretShrine"] = 500.0000 ,["TT_NWraith2"] = 750.0000 ,["TT_Tree_A"] = 750.0000 ,["SummonerBeacon"] = 750.0000 ,["Odin_Drill"] = 750.0000 ,["TT_NGolem"] = math.huge ,["AramSpeedShrine"] = math.huge ,["OriannaNoBall"] = math.huge ,["Odin_Minecart"] = math.huge ,["Summoner_Rider_Chaos"] = math.huge ,["OdinSpeedShrine"] = math.huge ,["TT_SpeedShrine"] = math.huge ,["odin_lifts_buckets"] = math.huge ,["OdinRockSaw"] = math.huge ,["OdinMinionSpawnPortal"] = math.huge ,["SyndraSphere"] = math.huge ,["Red_Minion_MechMelee"] = math.huge ,["SwainRaven"] = math.huge ,["crystal_platform"] = math.huge ,["MaokaiSproutling"] = math.huge ,["Urf"] = math.huge ,["TestCubeRender10Vision"] = math.huge ,["MalzaharVoidling"] = 500.0000 ,["GhostWard"] = 500.0000 ,["MonkeyKingFlying"] = 500.0000 ,["LuluPig"] = 500.0000 ,["AniviaIceBlock"] = 500.0000 ,["TT_OrderInhibitor_D"] = 500.0000 ,["Odin_SoG_Order"] = 500.0000 ,["RammusDBC"] = 500.0000 ,["FizzShark"] = 500.0000 ,["LuluDragon"] = 500.0000 ,["OdinTestCubeRender"] = 500.0000 ,["TT_Tree1"] = 500.0000 ,["ARAMOrderTurretShrine"] = 500.0000 ,["Odin_Windmill_Gears"] = 500.0000 ,["ARAMChaosNexus"] = 500.0000 ,["TT_NWraith"] = 750.0000 ,["TT_OrderTurret4"] = 500.0000 ,["Odin_SOG_Chaos_Crystal"] = 500.0000 ,["OdinQuestIndicator"] = 500.0000 ,["JarvanIVStandard"] = 500.0000 ,["TT_DummyPusher"] = 500.0000 ,["OdinClaw"] = 500.0000 ,["EliseSpiderling"] = 2000.0000 ,["QuinnValor"] = math.huge ,["UdyrTigerUlt"] = math.huge ,["UdyrTurtleUlt"] = math.huge ,["UdyrUlt"] = math.huge ,["UdyrPhoenixUlt"] = math.huge ,["ShacoBox"] = 1500.0000 ,["HA_AP_Poro"] = 1500.0000 ,["AnnieTibbers"] = math.huge ,["UdyrPhoenix"] = math.huge ,["UdyrTurtle"] = math.huge ,["UdyrTiger"] = math.huge ,["HA_AP_OrderShrineTurret"] = 500.0000 ,["HA_AP_Chains_Long"] = 500.0000 ,["HA_AP_BridgeLaneStatue"] = 500.0000 ,["HA_AP_ChaosTurretRubble"] = 500.0000 ,["HA_AP_PoroSpawner"] = 500.0000 ,["HA_AP_Cutaway"] = 500.0000 ,["HA_AP_Chains"] = 500.0000 ,["ChaosInhibitor_D"] = 500.0000 ,["ZacRebirthBloblet"] = 500.0000 ,["OrderInhibitor_D"] = 500.0000 ,["Nidalee_Spear"] = 500.0000 ,["Nidalee_Cougar"] = 500.0000 ,["TT_Buffplat_Chain"] = 500.0000 ,["WriggleLantern"] = 500.0000 ,["TwistedLizardElder"] = 500.0000 ,["RabidWolf"] = math.huge ,["HeimerTGreen"] = 1599.3999 ,["HeimerTRed"] = 1599.3999 ,["ViktorFF"] = 1599.3999 ,["TwistedGolem"] = math.huge ,["TwistedSmallWolf"] = math.huge ,["TwistedGiantWolf"] = math.huge ,["TwistedTinyWraith"] = 750.0000 ,["TwistedBlueWraith"] = 750.0000 ,["TwistedYoungLizard"] = 750.0000 ,["Red_Minion_Melee"] = math.huge ,["Blue_Minion_Melee"] = math.huge ,["Blue_Minion_Healer"] = 1000.0000 ,["Ghast"] = 750.0000 ,["blueDragon"] = 800.0000 ,["Red_Minion_MechRange"] = 3000.0000, ["Braum"] = math.huge, ["Gnar"] = 1400.0000}
	return self.ProjSpeed[unit.charName]
end

function SxOrbWalk:LoadToMenu(MainMenu, NoMenuKeys)
	if MainMenu then
		self.SxOrbMenu = MainMenu
	else
		self.SxOrbMenu = scriptConfig("SxOrbWalk", "SxOrb")
	end
	self.SxOrbMenu:addSubMenu('General-Settings', 'General')
	self.SxOrbMenu.General:addParam("Enabled", "Orbwalker Enabled", SCRIPT_PARAM_ONOFF, true)
	self.SxOrbMenu.General:addParam("StopMove", "Stop Move when Mouse above Hero", SCRIPT_PARAM_ONOFF, false)
	self.SxOrbMenu.General:addParam("StopMoveSlider", "Range to Stop Move", SCRIPT_PARAM_SLICE, 100, 50, 500)
	if VIP_USER and FileExist(LIB_PATH.."Selector.lua") then
		self.SxOrbMenu.General:addParam("Selector", "Use VIP-Selector", SCRIPT_PARAM_ONOFF, false)
	end
	self.SxOrbMenu.General:addParam("Selected", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)

	if not NoMenuKeys then
		self.SxOrbMenu:addSubMenu('Key-Settings', 'Keys')
		self.SxOrbMenu.Keys:addParam("Fight", "FightMode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		self.SxOrbMenu.Keys:addParam("Harass", "HarassMode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		self.SxOrbMenu.Keys:addParam("LaneClear", "LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
		self.SxOrbMenu.Keys:addParam("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		self.SxOrbMenu.Keys:addSubMenu('Toggle-Settings', 'Toggle')
		self.SxOrbMenu.Keys.Toggle:addParam("Fight", "Make FightMode as Toggle", SCRIPT_PARAM_ONOFF, false)
		self.SxOrbMenu.Keys.Toggle:addParam("Harass", "Make HarassMode as Toggle", SCRIPT_PARAM_ONOFF, false)
		self.SxOrbMenu.Keys.Toggle:addParam("LaneClear", "Make LaneClear as Toggle", SCRIPT_PARAM_ONOFF, false)
		self.SxOrbMenu.Keys.Toggle:addParam("LastHit", "Make LastHit as Toggle", SCRIPT_PARAM_ONOFF, false)

	end
	if NoMenuKeys then self.NoMenuKeys = true end
	self.SxOrbMenu:addSubMenu('Farm-Settings', 'Farm')
	self.SxOrbMenu.Farm:addParam("FarmOverHarass", "Focus Farm over Harass", SCRIPT_PARAM_ONOFF, true)
--~ 	self.SxOrbMenu.Farm:addParam("SpellFarm", "Use Spells to Secure LastHits", SCRIPT_PARAM_ONOFF, true)

	self.SxOrbMenu:addSubMenu('Mastery-Settings', 'Mastery')
	self.SxOrbMenu.Mastery:addParam("Butcher", 'Mastery: Butcher', SCRIPT_PARAM_ONOFF, true)
	self.SxOrbMenu.Mastery:addParam("ArcaneBlade", 'Mastery: Arcane Blade', SCRIPT_PARAM_ONOFF, true)
	self.SxOrbMenu.Mastery:addParam("Havoc", 'Mastery: Havoc', SCRIPT_PARAM_ONOFF, true)
	self.SxOrbMenu.Mastery:addParam("DevastatingStrikes", "Mastery: Devastating Strikes", SCRIPT_PARAM_SLICE, 0, 0, 3)
	self.SxOrbMenu.Mastery.Butcher = false
	self.SxOrbMenu.Mastery.ArcaneBlade = false
	self.SxOrbMenu.Mastery.Havoc = false
	self.SxOrbMenu.Mastery.DevastatingStrikes = 0

	self.SxOrbMenu:addSubMenu('Draw-Settings', 'Draw')
	self.SxOrbMenu.Draw:addParam("OwnAARange", 'Draw Own AA Range', SCRIPT_PARAM_ONOFF, true)
	self.SxOrbMenu.Draw:addParam("EnemyAARange", 'Draw Enemy AA Range', SCRIPT_PARAM_ONOFF, true)
	self.SxOrbMenu.Draw:addParam("MinionCircle", 'Draw LastHit-Cirlce around Minions', SCRIPT_PARAM_ONOFF, true)
	self.SxOrbMenu.Draw:addParam("MinionLine", 'Draw LastHit-Line on Minions', SCRIPT_PARAM_ONOFF, true)
	if not _G.SxOrbMenu then
		_G.SxOrbMenu = self.SxOrbMenu
		_G.SxOrbMenu.Mode = {}
		AddTickCallback(function() self:Tick() end)
		AddTickCallback(function() self:UpdateRange() end)
		AddTickCallback(function() self:CalcKillableMinion() end)
		AddTickCallback(function() self:CleanMinionAttacks() end)
		AddTickCallback(function() self:HotKeyCallback() end)
		AddTickCallback(function() self.Minions:update() end)
		AddTickCallback(function() self.LaneClearMinions:update() end)
		AddTickCallback(function() self.JungleMinions:update() end)
		AddTickCallback(function() self.OtherMinions:update() end)
		AddTickCallback(function() self:SelectorCheck() end)
		AddTickCallback(function() self:CheckToggleMode() end)
		AddDrawCallback(function() self:Draw() end)
		AddProcessSpellCallback(function(unit, spell) self:OnMinionAttack(unit, spell) end)
		AddProcessSpellCallback(function(unit, spell) self:OnSelfAction(unit, spell) end)
		AddRecvPacketCallback(function(p) self:RecvAACancel(p) end)
		AddCreateObjCallback(function(obj) self:BonusDamageObj(obj) end)
		AddCreateObjCallback(function(obj) self:OnCreateObj(obj) end)
		AddDeleteObjCallback(function(obj) self:OnDeleteObj(obj) end)
		AddMsgCallback(function(msg,key) self:DoubleModeProtection(msg, key) end)
	end
	GetMasteries()
	self:WaitForMasteries()
end

function SxOrbWalk:CheckToggleMode()
	if not self.NoMenuKeys then
	   if self.SxOrbMenu.Keys.Toggle.Fight ~= self.LastToggle.Fight then
			if self.SxOrbMenu.Keys.Toggle.Fight then SetMode = SCRIPT_PARAM_ONKEYTOGGLE else SetMode = SCRIPT_PARAM_ONKEYDOWN end
			self.SxOrbMenu.Keys._param[1].pType = SetMode
			self.LastToggle.Fight = self.SxOrbMenu.Keys.Toggle.Fight
		end
		if self.SxOrbMenu.Keys.Toggle.Harass ~= self.LastToggle.Harass then
			if self.SxOrbMenu.Keys.Toggle.Harass then SetMode = SCRIPT_PARAM_ONKEYTOGGLE else SetMode = SCRIPT_PARAM_ONKEYDOWN end
			self.SxOrbMenu.Keys._param[2].pType = SetMode
			self.LastToggle.Harass = self.SxOrbMenu.Keys.Toggle.Harass
		end
		if self.SxOrbMenu.Keys.Toggle.LaneClear ~= self.LastToggle.LaneClear then
			if self.SxOrbMenu.Keys.Toggle.LaneClear then SetMode = SCRIPT_PARAM_ONKEYTOGGLE else SetMode = SCRIPT_PARAM_ONKEYDOWN end
			self.SxOrbMenu.Keys._param[3].pType = SetMode
			self.LastToggle.LaneClear = self.SxOrbMenu.Keys.Toggle.LaneClear
		end
		if self.SxOrbMenu.Keys.Toggle.LastHit ~= self.LastToggle.LastHit then
			if self.SxOrbMenu.Keys.Toggle.LastHit then SetMode = SCRIPT_PARAM_ONKEYTOGGLE else SetMode = SCRIPT_PARAM_ONKEYDOWN end
			self.SxOrbMenu.Keys._param[4].pType = SetMode
			self.LastToggle.LastHit = self.SxOrbMenu.Keys.Toggle.LastHit
		end
	end
end

function SxOrbWalk:DoubleModeProtection(msg, key)
	if not self.NoMenuKeys then
		if key == self.SxOrbMenu.Keys._param[1].key then -- Fight
			self.SxOrbMenu.Keys.Harass,self.SxOrbMenu.Keys.LaneClear,self.SxOrbMenu.Keys.LastHit = false,false,false
		end

		if key == self.SxOrbMenu.Keys._param[2].key then -- Harass
			self.SxOrbMenu.Keys.Fight,self.SxOrbMenu.Keys.LaneClear,self.SxOrbMenu.Keys.LastHit = false,false,false
		end

		if key == self.SxOrbMenu.Keys._param[3].key then -- LaneClear
			self.SxOrbMenu.Keys.Fight,self.SxOrbMenu.Keys.Harass,self.SxOrbMenu.Keys.LastHit = false,false,false
		end

		if key == self.SxOrbMenu.Keys._param[4].key then -- LastHit
			self.SxOrbMenu.Keys.Fight,self.SxOrbMenu.Keys.Harass,self.SxOrbMenu.Keys.LaneClear = false,false,false
		end
	end
end

function SxOrbWalk:WaitForMasteries()
	if _G.MasteriesDone then
		if  _G.Masteries and _G.Masteries[myHero.hash] then
			self.SxOrbMenu.Mastery.Butcher = _G.Masteries[myHero.hash][4114] and true or false
			self.SxOrbMenu.Mastery.ArcaneBlade = _G.Masteries[myHero.hash][4154] and true or false
			self.SxOrbMenu.Mastery.Havoc = _G.Masteries[myHero.hash][4162] and true or false
			self.SxOrbMenu.Mastery.DevastatingStrikes = _G.Masteries[myHero.hash][4152] and _G.Masteries[myHero.hash][4152] or 0
		end
	else
		DelayAction(function() self:WaitForMasteries() end)
	end
end

function SxOrbWalk:UpdateRange()
	self.MyRange = myHero.range + myHero.boundingRadius
end

function SxOrbWalk:SelectorCheck()
	if VIP_USER and not SelectorInit and self.SxOrbMenu.General.Selector then
		require("Selector")
		Selector.Instance()
		SelectorInit = true
	end
end

function SxOrbWalk:CleanMinionAttacks()
	for index, data in pairs(self.MinionAttacks) do
		local MinionData = data
		local MinionArriveTime = MinionData['StartTime'] + MinionData['WindUptime'] + self:GetFlyTicks(MinionData['Target'], MinionData['Source']) + (GetLatency()/1000)*2 + 0.15
		if data['ProjectileValid'] == 2 or os.clock() > MinionArriveTime then
			table.remove(self.MinionAttacks, index)
		end
	end
	for index, data in pairs(self.EnemyMinionAttacks) do
		local MinionData = data
		local MinionArriveTime = MinionData['StartTime'] + MinionData['WindUptime'] + self:GetFlyTicks(MinionData['Target'], MinionData['Source']) + (GetLatency()/1000)*2 + 0.15
		if data['ProjectileValid'] == 2 or os.clock() > MinionArriveTime then
			table.remove(self.EnemyMinionAttacks, index)
		end
	end

--~ 	for index, data in pairs(self.KillAbleMinion) do
--~ 		if data['minion'].health == 0 then
--~ 			table.remove(self.KillAbleMinion, index)
--~ 		end
--~ 	end

--~ 	for index, data in pairs(self.MinionLastTargets) do
--~ 		if data['SourceMinion']['health'] == 0 then
--~ 			table.remove(self.MinionLastTargets, index)
--~ 		else
--~ 			if data['TargetMinion']['health'] == 0 then
--~ 				local NewTarget = self:GetNextEnemyMinion(data['TargetMinion'])
--~ 				if NewTarget and NewTarget['valid'] then
--~ 					data['TargetMinion'] = NewTarget
--~ 				end
--~ 			end
--~ 		end
--~ 	end
end

function SxOrbWalk:Tick()
	if not self.SxOrbMenu.General.Enabled then return end

	if (self.SxOrbMenu.Keys and self.SxOrbMenu.Keys.Fight) or _G.SxOrbMenu.Mode.Fight then
		self:AttackSelectedTarget()
		self:FightMode()
		self:OrbWalk()
	elseif (self.SxOrbMenu.Keys and self.SxOrbMenu.Keys.Harass) or _G.SxOrbMenu.Mode.Harass then
		self:AttackSelectedTarget()
		self:HarassMode()
		self:OrbWalk()
	elseif (self.SxOrbMenu.Keys and self.SxOrbMenu.Keys.LaneClear) or _G.SxOrbMenu.Mode.LaneClear then
		self:AttackSelectedTarget()
		self:LastHit()
		self:LaneClear()
		self:FightMode()
		self:OrbWalk()
	elseif (self.SxOrbMenu.Keys and self.SxOrbMenu.Keys.LastHit) or _G.SxOrbMenu.Mode.LastHit then
		self:AttackSelectedTarget()
		self:LastHit()
		self:OrbWalk()
	else
		self.WaitForMinion = false
	end
end

function SxOrbWalk:Draw()
	if not self.SxOrbMenu.General.Enabled then return end

	if self.SxOrbMenu.Draw.OwnAARange then
		self:DrawCircle(myHero.x, myHero.y, myHero.z, self.MyRange + 20, self.Color.White)
	end

	if self.SxOrbMenu.Draw.MinionCircle then
		self:DrawKillAbleMinion()
		if self.WaitForMinion then
			self:DrawCircle(self.WaitForMinion.x, self.WaitForMinion.y, self.WaitForMinion.z, 130, self.Color.Red)
		end
	end

	if self.SxOrbMenu.Draw.MinionLine then
		self:DrawMinionHPBar()
	end

	if self.SxOrbMenu.Draw.EnemyAARange then
		for index, hero in pairs(GetEnemyHeroes()) do
			if hero.team ~= myHero.team and GetDistanceSqr(myHero,hero) < 2500*2500 and hero.visible and self:ValidTarget(hero) then
				self:DrawCircle(hero.x,hero.y,hero.z, hero.range + hero.boundingRadius + myHero.boundingRadius - 10, self.Color.White)
			end
		end
	end
end

function SxOrbWalk:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function SxOrbWalk:DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		self:DrawCircleNextLvl(x, y, z, radius, 1, color, 75)
	end
end

function SxOrbWalk:DrawCircle(x,y,z,radius, color)
	self:DrawCircle2(x, y, z, radius, color)
end

function SxOrbWalk:DrawKillAbleMinion()
    for index, data in ipairs(self.KillAbleMinion) do
		if self:ValidTarget(data.Minion) then
			self:DrawCircle(data.Minion.x, data.Minion.y, data.Minion.z, 150, self.Color.White)
		else
			table.remove(self.KillAbleMinion, index)
		end
    end
end

function SxOrbWalk:AttackSelectedTarget()
	if self.SxOrbMenu.General.Selected and self:CanAttack() then
		local SelectedTarget = GetTarget()
		if SelectedTarget and self:ValidTarget(SelectedTarget,self.OverRideRange or self.MyRange) then
			self:MyAttack(SelectedTarget)
		end
	end
end

function SxOrbWalk:FightMode()
	if self:CanAttack() then
		Target, damage = self:GetTarget()
		if Target and self:ValidTarget(Target) then
			self:MyAttack(Target)
		end
	end
end

function SxOrbWalk:HarassMode()
	if self.SxOrbMenu.Farm.FarmOverHarass then
		self:LastHit()
		self:FightMode()
	else
		self:FightMode()
		self:LastHit()
	end
end

function SxOrbWalk:LaneClear()
	if self.WaitForMinion and self:ValidTarget(self.WaitForMinion, self.MyRange) then
		--wait
	else
		self.WaitForMinion = false
	end
	if self:CanAttack() and not self.WaitForMinion then
		local AttackLaneClear = {}
		for index, minion in pairs(self.LaneClearMinions.objects) do
			if minion.team ~= myHero.team and self:ValidTarget(minion, self.MyRange) then
				local MyAADmg = self:GetAADmg(minion)
				local MyArriveTime = os.clock() + 0.4 + self:GetAnimationTime() + self:GetLatency() + self:GetFlyTicks(minion) + self:GetWindUpTime()
				local DmgToMinion = 0
				for i=1,#self.MinionLastTargets do
					if self.MinionLastTargets[i]['TargetMinion'] == minion then
						local StartClock = os.clock()
						local MinionData = self.MinionData[self.MinionLastTargets[i]['SourceMinion'].charName]
						local Distance = GetDistance(self.MinionLastTargets[i]['SourceMinion'],self.MinionLastTargets[i]['TargetMinion'])
						local FlyTime = (Distance / (MinionData.ProjSpeed))
						local Calctime = self.MinionLastTargets[i]['LastWindUpTime'] + FlyTime - self:GetLatency() + MinionData.Delay
						while true do
							local MinionArriveTime = StartClock + Calctime
							if MyArriveTime > MinionArriveTime then
								DmgToMinion = DmgToMinion + self.MinionLastTargets[i]['LastDmg']
								StartClock = StartClock + self.MinionLastTargets[i]['LastAnimationTime']
							else
								break
							end
						end
					end
				end
				if ((DmgToMinion*1.2) > minion.health) then -- Minion is Dead until next AA -> Wait
					self.WaitForMinion = minion
				end

				if not self.WaitForMinion and self.LastTarget and self.LastTarget == minion and (((DmgToMinion*1.2) + MyAADmg) < (minion.health)) then -- our lastattack, goo
					self.LastTargetAgain = true
					self:MyAttack(minion)
				end

				if not self.WaitForMinion and (((DmgToMinion*1.2) + MyAADmg) < (minion.health)) then-- Minion wont be dead if i hit it until next AA -> Attack
					table.insert(AttackLaneClear, minion)
				end
			end
		end

		if self:CanAttack() and not self.WaitForMinion and #AttackLaneClear > 0 and not self.LastTargetAgain then
			self:MyAttack(AttackLaneClear[#AttackLaneClear])
		end
		self.LastTargetAgain = false


		if self:CanAttack() then
			for index, minion in pairs(self.JungleMinions.objects) do
				if self:ValidTarget(minion, self.MyRange) then
					self:MyAttack(minion)
					self.WaitForMinion = false
					break
				end
			end
		end

		if self:CanAttack() then
			for index, minion in pairs(self.OtherMinions.objects) do
				if self:ValidTarget(minion, self.MyRange) then
					self:MyAttack(minion)
					self.WaitForMinion = false
					break
				end
			end
		end
	end
end

function SxOrbWalk:LastHit()
    for index, minion in pairs(self.Minions.objects) do
		if minion.team ~= myHero.team and self:ValidTarget(minion) then
			local MyAADmg = self:GetAADmg(minion)
			DmgToMinion, AttackCount = self:GetPredictDMG(minion)
			if (MyAADmg + DmgToMinion) > minion.health then
				local MinionFound = false
				for u=1,#self.KillAbleMinion do
					if self.KillAbleMinion[u]['Minion']['networkID'] == minion.networkID then
						MinionFound = true
						break
					end
				end
				if not MinionFound then
					table.insert(self.KillAbleMinion, {['Minion'] = minion, ['AttackCount'] = AttackCount})
				end
			end
		end
    end

    local unit, counts = nil, -1
    for i=1,#self.KillAbleMinion do
		if self:ValidTarget(self.KillAbleMinion[i]['Minion'], self.MyRange) then
			local IsCannon = self.KillAbleMinion[i]['Minion'].charName:lower():find('cannon') and true or false
			if IsCannon then
				unit = self.KillAbleMinion[i]['Minion']
				break
			else
				if self.KillAbleMinion[i]['AttackCount'] > counts then
					counts = self.KillAbleMinion[i]['AttackCount']
					unit = self.KillAbleMinion[i]['Minion']
				end
			end
		end
    end
	if self:CanAttack() and unit then
		self:MyAttack(unit)
	end
end

function SxOrbWalk:GetPredictDMG(minion)
	local AttackCount = 0
	local DmgToEnemyMinion = 0
	local DmgToOwnMinion = 0
	local MyAADmg = self:GetAADmg(minion)
	local MyArriveTime = os.clock() + self:GetWindUpTime() + GetLatency()/1000 + self:GetFlyTicks(minion)
	for i=1,#self.MinionAttacks do
		if self.MinionAttacks[i]['Target'] == minion then
			local OwnMinionData = self.MinionAttacks[i]
			local OwnMinionArriveTime = OwnMinionData['StartTime'] + OwnMinionData['WindUptime'] + self:GetFlyTicks(OwnMinionData['Target'], OwnMinionData['Source']) + (GetLatency()/1000)*2 + 0.07
			for z=1,#self.EnemyMinionAttacks do
				local EnemyMinionData = self.EnemyMinionAttacks[z]
				if EnemyMinionData['Target'] == OwnMinionData['Source'] then
					local EnemyMinionArriveTime = EnemyMinionData['StartTime'] + EnemyMinionData['WindUptime'] + self:GetFlyTicks(EnemyMinionData['Target'], EnemyMinionData['Source']) + (GetLatency()/1000)*2 + 0.15
					local ProjectileStatus = 0
					if EnemyMinionData['Source']['charName']:find('Wizard') or EnemyMinionData['Source']['charName']:find('Cannon') then
						ProjectileValid = EnemyMinionData['ProjectileValid']
					else
						ProjectileValid = 1
					end
					if OwnMinionArriveTime > EnemyMinionArriveTime and ProjectileValid == 1 and EnemyMinionArriveTime > os.clock() then
						DmgToOwnMinion = DmgToOwnMinion + EnemyMinionData['SpellDmg']
					end
				end
			end

			if DmgToOwnMinion < minion.health then
				local ProjectileValid = 0
				if OwnMinionData['Source']['charName']:find('Wizard') or OwnMinionData['Source']['charName']:find('Cannon') then
					ProjectileValid = OwnMinionData['ProjectileValid']
				else
					ProjectileValid = 1
				end
				AttackCount = AttackCount + 1
				if MyArriveTime > OwnMinionArriveTime and ProjectileValid == 1 and OwnMinionArriveTime > os.clock() then
					DmgToEnemyMinion = DmgToEnemyMinion + OwnMinionData['SpellDmg']
				end
			end
		end
	end
	return DmgToEnemyMinion, AttackCount
end

function SxOrbWalk:OrbWalk()
	if self:CanMove() then
		if self.SxOrbMenu.General.StopMove and GetDistanceSqr(mousePos) < (self.SxOrbMenu.General.StopMoveSlider * self.SxOrbMenu.General.StopMoveSlider) then
			myHero:MoveTo(mousePos.x, mousePos.z)
		else
			MouseMove = Vector(myHero) + (Vector(mousePos) - Vector(myHero)):normalized() * 500
			myHero:MoveTo(MouseMove.x, MouseMove.z)
		end
	end
end

function SxOrbWalk:GetNextEnemyMinion(Source)
	local Result = {Unit = nil, Distance = 5000*5000}
	for index, minion in pairs(self.Minions.objects) do
		if minion.team ~= myHero.team and self:ValidTarget(minion, 5000) then
			local Distance = GetDistanceSqr(Source,minion)
			if Distance < Result.Distance then
				Result.Unit = minion
				Result.Distance = Distance
			end
		end
	end
	return Result.Unit, Result.Distance
end

function SxOrbWalk:GetWindUpTime()
	return 1 / (myHero.attackSpeed * self.BaseWindUpTime)
end

function SxOrbWalk:GetAnimationTime()
	return 1 / (myHero.attackSpeed * self.BaseAnimationTime)
end

function SxOrbWalk:GetLatency()
	return GetLatency()/4000
end

function SxOrbWalk:CanMove()
	if os.clock() > ((self.LastAA or 0) + self:GetWindUpTime()) and not self.MoveDisabled and not _G.Evadeee_evading and not (_G.EzEvade and _G.EzEvade.Evading) then
		return true
	else
		return false
	end
end

function SxOrbWalk:CanAttack()
	if os.clock() > ((self.LastAA or 0) + self:GetAnimationTime() - 0.07 - self:GetLatency()*2) and not self.AttackDisabled and not _G.Evadeee_evading and not (_G.EzEvade and _G.EzEvade.Evading) then
		return true
	else
		return false
	end
end

function SxOrbWalk:BonusDamageObj(obj)
	if myHero.charName == 'Vayne' then
		if obj.name:lower():find("vayne_w_ring2.troy") and GetDistanceSqr(myHero,obj) < 1000*1000 then
			VayneWParticle = obj
		end
	elseif myHero.charName == 'Caitlyn' then
		if GetDistanceSqr(obj) < 100*100 and obj.name:lower():find("headshot_rdy_indicator") then
			HeadShotParticle = obj
		end
	elseif myHero.charName == 'TwistedFate' then
		if GetDistanceSqr(obj) < 100*100 then
			if obj.name == "Card_Blue.troy" then
				TFBlueCard = obj
			elseif obj.name == "Card_Red.troy" then
				TFRedCard = obj
			elseif obj.name == "Card_Yellow.troy" then
				TFYellowCard = obj
			end
		end
	elseif myHero.charName == 'Draven' then
		if GetDistanceSqr(obj) < 100*100 and obj.name:lower():find("_Q_buf.troy") then
			DravenQParticle = obj
		end
	elseif myHero.charName == 'Ziggs' then
		if GetDistanceSqr(obj) < 100*100 and obj.name:lower():find("ziggspassive") then
			ZiggsParticle = obj
		end
	elseif myHero.charName == 'KogMaw' then
		if GetDistanceSqr(obj) < 100*100 and obj.name:lower():find("kogmawbioarcanebarrage_buf") then
			KogMawWParticle = obj
		end
	end
end

function SxOrbWalk:RemoveBonusDamage()
	if myHero.charName == 'Caitlyn' and HeadShotParticle then
		self.KillAbleMinion = {}
		HeadShotParticle = nil
	elseif myHero.charName == 'TwistedFate' and (TFBlueCard or TFRedCard or TFYellowCard) then
		self.KillAbleMinion = {}
		TFBlueCard = nil
		TFRedCard = nil
		TFYellowCard = nil
	elseif myHero.charName == 'Draven' and DravenQParticle then
		self.KillAbleMinion = {}
		DravenQParticle = nil
	elseif myHero.charName == 'Ziggs' and ZiggsParticle then
		self.KillAbleMinion = {}
		ZiggsParticle = nil
	elseif myHero.charName == 'KogMaw' and KogMawWParticle then
		self.KillAbleMinion = {}
		KogMawWParticle = nil
	end
end

function SxOrbWalk:BonusDamage(minion)
	local AD = myHero:CalcDamage(minion, myHero.totalDamage)
	local BONUS = 0
	if myHero.charName == 'Vayne' then
		if myHero:GetSpellData(0).level > 0 and myHero:CanUseSpell(0) == 3 then
			BONUS = BONUS + myHero:CalcDamage(minion, ((0.05 * myHero:GetSpellData(0).level) + 0.25 ) * myHero.totalDamage)
		end
		if VayneWParticle and VayneWParticle.valid and GetDistanceSqr(minion,VayneWParticle) < 10*10 then
			BONUS = BONUS + 10 + 10 * myHero:GetSpellData(1).level + (0.03 + (0.01 * myHero:GetSpellData(1).level)) * minion.maxHealth
		end
	elseif myHero.charName == 'Teemo' and myHero:GetSpellData(2).level > 0 then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, (myHero:GetSpellData(2).level * 10) + (myHero.ap * 0.3) )
	elseif myHero.charName == 'Corki' then
		BONUS = BONUS + myHero.totalDamage/10
	elseif myHero.charName == 'MissFortune' and myHero:GetSpellData(1).level > 0 then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, (myHero.totalDamage*0.06))
	elseif myHero.charName == 'Varus' and myHero:GetSpellData(1).level > 0 then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, 6 + (myHero:GetSpellData(1).level * 4) + (myHero.ap * 0.25))
	elseif myHero.charName == 'Caitlyn' then
		if HeadShotParticle and HeadShotParticle.valid then
			BONUS = BONUS + myHero:CalcDamage(minion, myHero.totalDamage * 1.5)
		end
	elseif myHero.charName == 'Orianna' then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, 10 + (8 * (math.ceil(myHero.level / 3)-1)) + (myHero.ap * 0.15))
	elseif myHero.charName == 'TwistedFate' then
		if TFBlueCard and TFBlueCard.valid then
			BONUS = BONUS + myHero:CalcMagicDamage(minion, 20 + myHero:GetSpellData(2).level * 20 + myHero.totalDamage + (myHero.ap * 0.5))
		end
		if TFRedCard and TFRedCard.valid then
			BONUS = BONUS + myHero:CalcMagicDamage(minion, 15 + myHero:GetSpellData(2).level * 15 + myHero.totalDamage + (0.5 * myHero.ap))
		end
		if TFYellowCard and TFYellowCard.valid then
			BONUS = BONUS + myHero:CalcMagicDamage(minion, 7.5 + myHero:GetSpellData(2).level * 7.5 + myHero.totalDamage + (0.5 * myHero.ap))
		end
	elseif myHero.charName == 'Draven' then
			if DravenQParticle and DravenQParticle.valid then
				BONUS = BONUS + myHero:CalcDamage(minion, myHero.totalDamage + ((35 + myHero:GetSpellData(0).level * 10)/100)*myHero.totalDamage)
			end
	elseif myHero.charName == "Ziggs" then
		if ZiggsParticle and ZiggsParticle.valid then
			local base = {20, 24, 28, 32, 36, 40, 48, 56, 64, 72, 80, 88, 100, 112, 124, 136, 148, 160}
			local base2 = {0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.30, 0.30, 0.30, 0.30, 0.30, 0.30, 0.35, 0.35, 0.35, 0.35, 0.35, 0.35}
			BONUS = BONUS + myHero:CalcMagicDamage(minion, base[myHero.level] + (base2[myHero.level] * myHero.ap))
		end
	elseif myHero.charName == "KogMaw" then
		if KogMawWParticle and KogMawWParticle.valid then
			BONUS = BONUS + myHero:CalcMagicDamage(minion, minion.health * (0.01 + (myHero.level * 0.01) + (myHero.ap * 0.01)))
		end
	end
	return BONUS
end

function SxOrbWalk:GetAADmg(target)
	local Devastating = self.SxOrbMenu.Mastery.DevastatingStrikes * 0.02
	local ArmorPen = 1.00 - Devastating
	local Multiplier = 100 / (100 + (target.armor*ArmorPen))
	local RawDMG = myHero.totalDamage * Multiplier
	RawDMG = RawDMG + self:BonusDamage(target)
	if self.SxOrbMenu.Mastery.Butcher then
		RawDMG = RawDMG + 2
	end
	if self.SxOrbMenu.Mastery.ArcaneBlade then
		RawDMG = RawDMG + myHero:CalcMagicDamage(target, myHero.ap * 0.05)
	end
	if self.SxOrbMenu.Mastery.Havoc then
		RawDMG = RawDMG*1.03
	end
	return RawDMG
end

function SxOrbWalk:GetMinionAADmg(unit, target)
	local Multiplier = 100 / (100 + (target.armor))
	local RawDMG = unit.totalDamage * Multiplier
	return math.floor(RawDMG)
end

function SxOrbWalk:ValidTarget(target, validrange)
	if target and target.valid and GetDistance(target) < ((validrange or 2000) + (target.boundingRadius) - 20) and target.health > 0 and not target.dead and target.visible and target.bTargetable and target.team ~= myHero.team then
		return true
	else
		return false
	end
end

function SxOrbWalk:GetFlyTicks(target, source)
	source = source or myHero
	local Distance = GetDistance(source,target) or 0
	local Speed = self:GetProjSpeed(source) or math.huge
	return Distance / Speed
end

function SxOrbWalk:CalcKillableMinion()
    for index, minion in pairs(self.Minions.objects) do
		if minion.team ~= myHero.team and self:ValidTarget(minion) then
			local MyAADmg = self:GetAADmg(minion)
			DmgToMinion, AttackCount = self:GetPredictDMG(minion)
			if (MyAADmg + DmgToMinion) > minion.health then
				local MinionFound = false
				for u=1,#self.KillAbleMinion do
					if self.KillAbleMinion[u]['Minion']['networkID'] == minion.networkID then
						MinionFound = true
						break
					end
				end
				if not MinionFound then
					table.insert(self.KillAbleMinion, {['Minion'] = minion, ['AttackCount'] = AttackCount})
				end
			end
		end
    end

end

function SxOrbWalk:OnCreateObj(obj)
	DelayAction(function()
		for i=1,#self.MinionAttacks do
			if obj.networkID == self.MinionAttacks[i]['LastProjectileID'] then
				self.MinionAttacks[i]['ProjectileValid'] = 1
			end
		end
		for i=1,#self.EnemyMinionAttacks do
			if obj.networkID == self.EnemyMinionAttacks[i]['LastProjectileID'] then
				self.EnemyMinionAttacks[i]['ProjectileValid'] = 1
			end
		end
	end, 0.25)
end

function SxOrbWalk:OnDeleteObj(obj)
	for i=1,#self.MinionAttacks do
		if obj.networkID == self.MinionAttacks[i]['LastProjectileID'] then
			self.MinionAttacks[i]['ProjectileValid'] = 2
			break
		end
	end
	for i=1,#self.EnemyMinionAttacks do
		if obj.networkID == self.EnemyMinionAttacks[i]['LastProjectileID'] then
			self.EnemyMinionAttacks[i]['ProjectileValid'] = 2
			break
		end
	end
end

function SxOrbWalk:OnMinionAttack(unit, spell)
	if unit.type == "obj_AI_Minion" and spell and spell.target and spell.target.type == "obj_AI_Minion" and GetDistanceSqr(spell.target) < 2000*2000 then
		if unit.charName:find('Basic') then ExtraDelay = 0.12 else ExtraDelay = 0.07 end
		local Data = {
		['Source'] = unit,
		['Target'] = spell.target,
		['SpellDmg'] = self:GetMinionAADmg(unit, spell.target),
		['LastProjectileID'] = spell.projectileID,
		['ProjectileState'] = 0,
		['StartTime'] = os.clock() + ExtraDelay,
		['WindUptime'] = spell.windUpTime,
		['Animationtime'] = spell.animationTime,}
		if unit.team == myHero.team then
			for index, data in ipairs(self.MinionAttacks) do
				if data['Source'] == unit then
					table.remove(self.MinionAttacks, index)
					self.KillAbleMinion = {}
				end
			end
			table.insert(self.MinionAttacks, Data)
		else
			for index, data in ipairs(self.EnemyMinionAttacks) do
				if data['Source'] == unit then
					table.remove(self.EnemyMinionAttacks, index)
					self.KillAbleMinion = {}
				end
			end
			table.insert(self.EnemyMinionAttacks, Data)
		end
--~ 		table.insert(self.MinionLastTargets, {SourceMinion = unit, LastAttack = os.clock(), TargetMinion = spell.target, LastDmg = unit:CalcDamage(spell.target), LastAnimationTime = spell.animationTime, LastWindUpTime = spell.windUpTime})
	end
end

function SxOrbWalk:OnSelfAction(unit, spell)
	if unit.isMe then
		if (spell.name:lower():find("attack") or self.IsBasicAttack[spell.name]) then
			self.BaseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
			self.BaseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
			self:RemoveBonusDamage()
			self.IsForceAA = false
			self.LastAA = os.clock()
			if spell.target then self.LastTarget = spell.target end
			self:OnAttack(self.LastTarget)
			DelayAction(function() self:AfterAttack(self.LastTarget) end, self:GetWindUpTime())
		end

		if self.ResetSpells[spell.name] then
			DelayAction(function() self.LastAA = 0 end, spell.windUpTime - self:GetLatency()*2)
		end
	end
end

function SxOrbWalk:RecvAACancel(p)
	if p.header == 0x34 then
		p.pos = 1
		NetworkID = p:DecodeF()
		p.pos = 9
		Cancel = p:Decode1()
		if NetworkID == myHero.networkID and Cancel == 0x11 then
			self.LastAA = 0
		end
	end
end

function SxOrbWalk:MyAttack(target)
	self.IsForceAA = true
--~ 	self:ForceAA(target)
	myHero:Attack(target)
	self.LastAA = os.clock() + self:GetWindUpTime() + self:GetLatency()
	self:BeforeAttack(target)
end

function SxOrbWalk:ForceAA(target)
	if self.IsForceAA then
		if self:ValidTarget(target) then
			myHero:Attack(target)
			DelayAction(function() self:ForceAA(target) end)
		else
			self.IsForceAA = false
		end
	end
end

function SxOrbWalk:GetTarget() -- iUser99 ftw
	if self.ForceThisTarget and self:ValidTarget(self.ForceThisTarget) then
		return self.ForceThisTarget
	else
		self.ForceThisTarget = nil
		local SelectedTarget = GetTarget()
		if SelectedTarget and (SelectedTarget.type == myHero.type or SelectedTarget.type == 'obj_AI_Turret') and self:ValidTarget(SelectedTarget,self.OverRideRange or self.MyRange) then
			return SelectedTarget
		else
			if VIP_USER and self.SxOrbMenu.General.Selector and FileExist(LIB_PATH.."Selector.lua") then
				SelectorTarget = Selector.GetTarget(SelectorMenu.Get().mode, nil, {distance = self.OverRideRange or self.MyRange})
				if SelectorTarget and self:ValidTarget(SelectorTarget,self.OverRideRange or self.MyRange) then
					return SelectorTarget
				end
			else
				local best, damage = nil, 99

				for index, unit in pairs(GetEnemyHeroes()) do
					if unit.team ~= myHero.team and self:ValidTarget(unit, self.OverRideRange or self.MyRange) then
						local e = myHero:CalcDamage(unit, myHero.totalDamage)
						local d = unit.health / e
						if (best == nil) or d < damage then
							best = unit
							damage = d
						end
					end
				end

				return best, damage
			end
		end
	end
end

function SxOrbWalk:DrawMinionHPBar()
	for i,minion in pairs(self.Minions.objects) do
		if GetDistanceSqr(minion) < 1000*1000 then
			local MinionBarPos = GetUnitHPBarPos(minion)
			local MyDmgToMinion = self:GetAADmg(minion)
			local DrawDistance = math.floor(63 / (minion.maxHealth / MyDmgToMinion))
			local Points = {}
			Points[1] = D3DXVECTOR2(math.floor(MinionBarPos.x - 32 + DrawDistance), math.floor(MinionBarPos.y))
			Points[2] = D3DXVECTOR2(math.floor(MinionBarPos.x - 32 + DrawDistance + 1), math.floor(MinionBarPos.y))
			DrawLines2(Points, math.floor(4), self.Color.Black)
		end
	end
end

------------------
-- Global Funcs --
------------------
function SxOrbWalk:ForceTarget(unit)
	if unit and self:ValidTarget(unit) then
		self.ForceThisTarget = unit
	end
end

function SxOrbWalk:GetAACD()
	AACD = self.LastAA + self:GetAnimationTime() - self:GetLatency()*2 - os.clock()
	if AACD > 0 then
		return AACD
	else
		return 0
	end
end

function SxOrbWalk:ResetAA()
	self.LastAA = 0
end

function SxOrbWalk:GetHitBox(unit)
	return unit.boundingRadius
end

function SxOrbWalk:DisableAttacks()
	self.AttackDisabled = true
end

function SxOrbWalk:EnableAttacks()
	self.AttackDisabled = false
end

function SxOrbWalk:DisableMove()
	self.MoveDisabled = true
end

function SxOrbWalk:EnableMove()
	self.MoveDisabled = false
end

function SxOrbWalk:RegisterBeforeAttackCallback(f)
	table.insert(self.BeforeAttackCallbacks, f)
end

function SxOrbWalk:RegisterOnAttackCallback(f)
	table.insert(self.OnAttackCallbacks, f)
end

function SxOrbWalk:RegisterAfterAttackCallback(f)
	table.insert(self.AfterAttackCallbacks, f)
end

function SxOrbWalk:RegisterHotKey(Mode, MainMenu, SubMenu)
	if Mode:lower() == "fight" or Mode:lower() == "harass" or Mode:lower() == "laneclear" or Mode:lower() == "lasthit" then
		if Mode:lower() == "fight" then table.insert(self.HotKeys["Fight"], {MainMenu,SubMenu}) end
		if Mode:lower() == "harass" then table.insert(self.HotKeys["Harass"], {MainMenu,SubMenu}) end
		if Mode:lower() == "laneclear" then table.insert(self.HotKeys["LaneClear"], {MainMenu,SubMenu}) end
		if Mode:lower() == "lasthit" then table.insert(self.HotKeys["LastHit"], {MainMenu,SubMenu}) end
	else
		print("Error: Unknown Mode: "..Mode)
	end
end

function SxOrbWalk:ChangeRange(newrange)
	if newrange then
		self.OverRideRange = newrange
	end
end

function SxOrbWalk:IsWaitForAA()
	return false
end

---------------
-- Callbacks --
---------------
function SxOrbWalk:HotKeyCallback()
	for i=1,#self.HotKeys["Fight"] do
		if not self.HotKeys["Fight"][i][1][tostring(self.HotKeys["Fight"][i][2])] then
			_G.SxOrbMenu.Mode.Fight = false
			break
		else
			_G.SxOrbMenu.Mode.Fight = true
		end
	end
	for i=1,#self.HotKeys["Harass"] do
		if not self.HotKeys["Harass"][i][1][tostring(self.HotKeys["Harass"][i][2])] then
			_G.SxOrbMenu.Mode.Harass = false
			break
		else
			_G.SxOrbMenu.Mode.Harass = true
		end
	end
	for i=1,#self.HotKeys["LaneClear"] do
		if not self.HotKeys["LaneClear"][i][1][tostring(self.HotKeys["LaneClear"][i][2])] then
			_G.SxOrbMenu.Mode.LaneClear = false
			break
		else
			_G.SxOrbMenu.Mode.LaneClear = true
		end
	end
	for i=1,#self.HotKeys["LastHit"] do
		if not self.HotKeys["LastHit"][i][1][tostring(self.HotKeys["LastHit"][i][2])] then
			_G.SxOrbMenu.Mode.LastHit = false
			break
		else
			_G.SxOrbMenu.Mode.LastHit = true
		end
	end
end

function SxOrbWalk:BeforeAttack(target)
	local result = false
	for i, cb in ipairs(self.BeforeAttackCallbacks) do
		local ri = cb(target)
		if ri then
			result = true
		end
	end
	return result
end

function SxOrbWalk:OnAttack(target)
	for i, cb in ipairs(self.OnAttackCallbacks) do
		cb(target)
	end
end

function SxOrbWalk:AfterAttack(target)
	for i, cb in ipairs(self.AfterAttackCallbacks) do
		cb(target)
	end
end

class "GetMasteries"
function GetMasteries:__init(AllChamps)
	if not _G.Masteries then
		self.ChampTable = {}
		for z = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(z)
			if not hero.isAI then
				table.insert(self.ChampTable, hero)
			end
		end
		self.LuaSocket = require("socket")
		self.MasterySocket = self.LuaSocket.connect("www.sx-bol.eu", 80)
		self.RandomChamp = self.ChampTable[math.random(#self.ChampTable)]
		if AllChamps then self.AllChamps = '/1' else self.AllChamps = '/0' end
		self.MasterySocket:send("GET /BoL/GetMastery/"..GetRegion().."/"..self:url_encode(myHero.name).."/"..self:url_encode(self.RandomChamp.name)..self.AllChamps.." HTTP/1.0\r\n\r\n")
		self.MasterySocket:settimeout(0, 'b')
		self.MasterySocket:settimeout(99999999, 't')
		self.MasterySocket:setoption('keepalive', true)
		_G.Masteries = {}
		AddTickCallback(function() self:Collect() end)
	end
end

function GetMasteries:url_encode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
  return str
end

function GetMasteries:Collect()
	self.MasteryReceive, self.MasteryStatus = self.MasterySocket:receive('*a')
	if self.MasteryStatus ~= 'timeout' and self.MasteryReceive ~= nil and not _G.MasteriesDone then
		self.MasteryRaw = string.match(self.MasteryReceive, '<pre>(.*)</pre>')
		if self.MasteryRaw then
  		self.MasteriesRaw = JSON:decode(self.MasteryRaw)
  		if self.AllChamps == '/1' and #self.ChampTable > 1 then
  			for _,MasteryTable in pairs(self.MasteriesRaw) do
  				for z = 1, #self.ChampTable, 1 do
  					local hero = self.ChampTable[z]
  					if hero.name == MasteryTable['name'] then
  						_G.Masteries[hero.hash] = {}
  						for index, info in pairs(MasteryTable) do
  							if info.sli and info.r then
  								_G.Masteries[hero.hash][info.sli] = info.r
  							else
  								_G.Masteries[hero.hash][index] = info
  							end
  						end
  						break
  					end
  				end
  			end
  			_G.MasteriesDone = true
  		else
  			_G.Masteries[myHero.hash] = {}
  			for _,MasteryTable in pairs(self.MasteriesRaw) do
  					if MasteryTable.sli and MasteryTable.r then
  						_G.Masteries[myHero.hash][MasteryTable.sli] = MasteryTable.r
  					else
  						_G.Masteries[myHero.hash][_] = MasteryTable
  					end
  			end
  			_G.MasteriesDone = true
  		end
  	else
  	   _G.MasteriesDone = true
  	end
	end
end

SxOrb = SxOrbWalk()
