﻿-------------------------------------------------
--
-- ElvUI Microbar by Darth Predator and Allaidia
-- Дартпредатор - Свежеватель Душ (Soulflyer) RU
-- Allaidia - Cenarion Circle US
--
-------------------------------------------------
--
-- Thanks to / Благодарности:
-- Elv and ElvUI community
-- Slipslop for scale option
-- Blazeflack for helping with option storage and profile changing
--
-------------------------------------------------
--
-- Usage / Использование:
-- Just install and configure for yourself
-- Устанавливаем, настраиваем и получаем профит
--
-------------------------------------------------

local E, L, P, G = unpack(ElvUI); --Engine, Locales, Profile, Global
local MB = E:NewModule('Microbar', 'AceHook-3.0', 'AceEvent-3.0');
local AB = E:GetModule('ActionBars'); --Added as your menu creation method uses it.

--Setting all variables as locals to avoid possible conflicts with other addons
local microbar
local microbarcontrol
local CharB
local SpellB
local TalentB
local AchievB
local QuestB
local GuildB
local PVPB
local LFDB
local RaidB
local EJB
local MenuB
local HelpB

--A table of names. Used for buttons creating.
local microbuttons = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"QuestLogMicroButton",
	"PVPMicroButton",
	"GuildMicroButton",
	"LFDMicroButton",
	"EJMicroButton",
	"RaidMicroButton",
	"HelpMicroButton",
	"MainMenuMicroButton",
	"AchievementMicroButton"
}

--Setting loacle shortnames and on update script for mouseover/alpha (can't get rid of using it at the moment)
function MB:SetNames()
	microbar = CreateFrame('Frame', "MicroParent", E.UIParent); --Setting a main frame for Menu
	microbarcontrol = CreateFrame('Frame', "MicroControl", E.UIParent); --Setting Control Fraqme to handle events
	
	CharB = CharacterMicroButton
	SpellB = SpellbookMicroButton
	TalentB = TalentMicroButton
	AchievB = AchievementMicroButton
	QuestB = QuestLogMicroButton
	GuildB = GuildMicroButton
	PVPB = PVPMicroButton
	LFDB = LFDMicroButton
	RaidB = RaidMicroButton
	EJB = EJMicroButton
	MenuB = MainMenuMicroButton
	HelpB = HelpMicroButton
	
	--On update functions
	microbarcontrol:SetScript("OnUpdate", function(self,event,...)
		MB:Mouseover()
	end)
end

--Creating buttons
function AB:CreateMicroBar()
	microbar:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
	microbar:Hide()
	
	--Backdrop creation
	microbar:CreateBackdrop('Default');
	microbar.backdrop:SetFrameStrata("BACKGROUND") --Without this backdrop causes a significant visual taint
	microbar.backdrop:SetAllPoints();
	microbar.backdrop:Point("BOTTOMLEFT", microbar, "BOTTOMLEFT", 0,  -1);
	
	microbarcontrol:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
	
	MicroParent.shown = false
	microbar:SetScript("OnUpdate", CheckFade)
	
	for i, button in pairs(microbuttons) do
		local m = _G[button]
		local pushed = m:GetPushedTexture()
		local normal = m:GetNormalTexture()
		local disabled = m:GetDisabledTexture()
		
		m:SetParent(MicroParent)
		m.SetParent = E.noop
		_G[button.."Flash"]:SetTexture("")
		m:SetHighlightTexture("")
		m.SetHighlightTexture = E.noop

		local f = CreateFrame("Frame", nil, m)
		f:SetFrameLevel(1)
		f:SetFrameStrata("BACKGROUND")
		f:SetPoint("BOTTOMLEFT", m, "BOTTOMLEFT", 2, 0)
		f:SetPoint("TOPRIGHT", m, "TOPRIGHT", -2, -28)
		f:SetTemplate("Default", true)
		m.frame = f
		
		pushed:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		pushed:ClearAllPoints()
		pushed:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
		pushed:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		
		normal:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		normal:ClearAllPoints()
		normal:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
		normal:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		
		if disabled then
			disabled:SetTexCoord(0.17, 0.87, 0.5, 0.908)
			disabled:ClearAllPoints()
			disabled:Point("TOPLEFT", m.frame, "TOPLEFT", 2, -2)
			disabled:Point("BOTTOMRIGHT", m.frame, "BOTTOMRIGHT", -2, 2)
		end
			

		m.mouseover = false
		m:HookScript("OnEnter", function(self) 
			self.frame:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor)) 
			self.mouseover = true 
		end)
		m:HookScript("OnLeave", function(self) 
			local color = RAID_CLASS_COLORS[E.myclass] 
			self.frame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			self.mouseover = false 
		end)
	end
	
	local x = CreateFrame("Frame", "MicroPlaceHolder", MicroParent)
	x:SetPoint("TOPLEFT", CharacterMicroButton.frame, "TOPLEFT")
	x:SetPoint("BOTTOMRIGHT", HelpMicroButton.frame, "BOTTOMRIGHT")
	x:EnableMouse(true)
	x.mouseover = false
	x:CreateShadow("Default")
	x:SetScript("OnEnter", function(self) self.mouseover = true end)
	x:SetScript("OnLeave", function(self) self.mouseover = false end)
	
	--Fix/Create textures for buttons
	do
		MicroButtonPortrait:ClearAllPoints()
		MicroButtonPortrait:Point("TOPLEFT", CharacterMicroButton.frame, "TOPLEFT", 2, -2)
		MicroButtonPortrait:Point("BOTTOMRIGHT", CharacterMicroButton.frame, "BOTTOMRIGHT", -2, 2)
		
		GuildMicroButtonTabard:ClearAllPoints()
		GuildMicroButtonTabard:SetPoint("TOP", GuildMicroButton.frame, "TOP", 0, 25)
		GuildMicroButtonTabard.SetPoint = E.noop
		GuildMicroButtonTabard.ClearAllPoints = E.noop
	end
	
	MicroParent:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 4, -4) --Default microbar position

	MicroParent:SetWidth(((CharacterMicroButton:GetWidth() + 4) * 9) + 12)
	MicroParent:SetHeight(CharacterMicroButton:GetHeight() - 28)

	CharacterMicroButton:ClearAllPoints()
	CharacterMicroButton:SetPoint("TOPLEFT", MicroParent, "TOPLEFT", 1,  25)
	CharacterMicroButton.SetPoint = E.noop
	CharacterMicroButton.ClearAllPoints = E.noop

	MB:UpdateMicroSettings()
end

--Backdrop show/hide
function MB:Backdrop()
	if E.db.microbar.backdrop then
		microbar.backdrop:Show();
	else
		microbar.backdrop:Hide();
	end
end

--Mouseover and Alpha function
function MB:Mouseover()
	if E.db.microbar.mouse then
		if (MouseIsOver(MicroParent)) then
			MicroParent:SetAlpha(E.db.microbar.alpha)
		else	
			MicroParent:SetAlpha(0)
		end
	else
		MicroParent:SetAlpha(E.db.microbar.alpha)
	end
end

--Set Scale
function MB:Scale()
	microbar:SetScale(E.db.microbar.scale)
end

--Show/Hide in combat
function MB:EnterCombat()
	if E.db.microbar.combat then
		microbar:Hide()
	else
		microbar:Show()
	end	
end

--Show after leaving combat
function MB:LeaveCombat()
	microbar:Show()
end

--Sets mover size based on the frame layout
function MB:MicroMoverSize()
	microbar.mover:SetWidth(E.db.microbar.scale * MicroParent:GetWidth())
	microbar.mover:SetHeight(E.db.microbar.scale * MicroParent:GetHeight() + 1);
end

--Positioning of buttons
function MB:MicroButtonsPositioning()
	if E.db.microbar.layout == "Micro_Hor" then --Horizontal
		CharB:SetPoint("BOTTOMLEFT", microbar, "BOTTOMLEFT", 1, 1)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25,  0)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25,  0)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 25,  0)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25,  0)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_Ver" then --Vertical
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 0, -33)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 0, -33)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 0, -33)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 0, -33)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 0, -33)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 0, -33)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 0, -33)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 0, -33)
	elseif E.db.microbar.layout == "Micro_26" then --2 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25, 0)
		TalentB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25, 0)
		QuestB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 0, -33)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25, 0)
		PVPB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25, 0)
		RaidB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25, 0)
		MenuB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 0, -33)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25, 0)
	elseif E.db.microbar.layout == "Micro_34" then --3 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  20)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25,  0)
		AchievB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25,  0)
		PVPB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 0, -33)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25,  0)
		EJB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 0, -33)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_43" then --4 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 1,  20)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25,  0)
		QuestB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25,  0)
		PVPB:SetPoint("TOPLEFT", GuildB, "TOPLEFT", 25,  0)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25,  0)
		RaidB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 0, -33)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25,  0)
	elseif E.db.microbar.layout == "Micro_62" then --6 in a row
		CharB:SetPoint("TOPLEFT", microbar, "TOPLEFT", 0,  21)
		SpellB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 25,  0)
		TalentB:SetPoint("TOPLEFT", SpellB, "TOPLEFT", 25,  0)
		AchievB:SetPoint("TOPLEFT", TalentB, "TOPLEFT", 25,  0)
		QuestB:SetPoint("TOPLEFT", AchievB, "TOPLEFT", 25,  0)
		GuildB:SetPoint("TOPLEFT", QuestB, "TOPLEFT", 25,  0)
		PVPB:SetPoint("TOPLEFT", CharB, "TOPLEFT", 0, -33)
		LFDB:SetPoint("TOPLEFT", PVPB, "TOPLEFT", 25,  0)
		RaidB:SetPoint("TOPLEFT", LFDB, "TOPLEFT", 25,  0)
		EJB:SetPoint("TOPLEFT", RaidB, "TOPLEFT", 25,  0)
		MenuB:SetPoint("TOPLEFT", EJB, "TOPLEFT", 25,  0)
		HelpB:SetPoint("TOPLEFT", MenuB, "TOPLEFT", 25,  0)
	end
	
end

--Setting frame size to change view of backdrop
function MB:MicroFrameSize()
	if E.db.microbar.layout == "Micro_Hor" then
		microbar:Size(305, 36)
	elseif E.db.microbar.layout == "Micro_Ver" then
		microbar:Size(30, 399)
	elseif E.db.microbar.layout == "Micro_26" then
		microbar:Size(55, 201)
	elseif E.db.microbar.layout == "Micro_34" then
		microbar:Size(80, 135)
	elseif E.db.microbar.layout == "Micro_43" then
		microbar:Size(105, 101)
	elseif E.db.microbar.layout == "Micro_62" then
		microbar:Size(155, 69)
	else
		microbar:Size(305, 36)
	end
end

--Buttons points clear
function MB:ButtonsSetup()
	CharB:ClearAllPoints()
	SpellB:ClearAllPoints()	
	TalentB:ClearAllPoints()	
	AchievB:ClearAllPoints()
	QuestB:ClearAllPoints()
	GuildB:ClearAllPoints()
	PVPB:ClearAllPoints()
	LFDB:ClearAllPoints()
	RaidB:ClearAllPoints()
	EJB:ClearAllPoints()
	MenuB:ClearAllPoints()
	HelpB:ClearAllPoints()
end

--Forcing buttons to show up even when thet shouldn't e.g. in vehicles
function MB:ShowMicroButtons()
	CharB:Show()
	SpellB:Show()
	TalentB:Show()
	QuestB:Show()
	PVPB:Show()
	GuildB:Show()
	LFDB:Show()
	EJB:Show()
	RaidB:Show()
	HelpB:Show()
	MenuB:Show()
	AchievB:Show()
end

--For recreate after portals and so on
function MB:MenuShow()
	microbar:Show();
	MB:ButtonsSetup();
	MB:MicroButtonsPositioning();
	MB:ShowMicroButtons();
end

--Hooking to Elv's UpdateAll function. Thanks to Blazeflack for making it smaller and other stuff
E.UpdateAllMicro = E.UpdateAll
function E:UpdateAll()
    E.UpdateAllMicro(self)
   	MB:UpdateMicroSettings()
	MB:MicroMoverSize()
end

--Update settings after profile change
function MB:UpdateMicroSettings()
    MB:Backdrop();
    MB:Scale();
    MB:MicroButtonsPositioning();
    MB:MicroFrameSize();
end

--Too old version popup
StaticPopupDialogs["VERSION_MISMATCH"] = {
	text = L["Your version of ElvUI is older than recommended to use with Microbar addon. Please, download the latest version from tukui.org."],
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3,
}

--Initialization
function MB:Initialize()
	--Showing warning message about too old versions of ElvUI
	if tonumber(E.version) < 3.6 then
		StaticPopup_Show("VERSION_MISMATCH")
	end
	MB:SetNames()
	AB:CreateMicroBar()
	MB:Backdrop();
	MB:MicroFrameSize();
	MB:Scale();
	E:CreateMover(microbar, "MicroMover", L['Microbar'])
	MB:MicroMoverSize()
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "MenuShow");
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "MenuShow");	
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "MenuShow");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "LeaveCombat");
end

E:RegisterModule(MB:GetName())