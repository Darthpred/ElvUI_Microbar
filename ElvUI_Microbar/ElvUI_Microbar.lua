﻿-------------------------------------------------
--
-- ElvUI Microbar by Darth Predator
-- Дартпредатор - Свежеватель Душ (Soulflyer) RU
--
-------------------------------------------------
-- Thanks to / Благодарности: --
-- Elv and ElvUI community
-- Slipslop for scale option
-- Blazeflack for helping with option storage
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

--Setting loacle shortnames and on update script for mouseover/alpha (can't get rid of using it at the moment)
function MB:SetNames()
	f = CreateFrame('Frame', "MicroParent", E.UIParent); --Setting a main frame for Menu
	cf = CreateFrame('Frame', "MicroControl", E.UIParent); --Setting Control Fraqme to handle events
	
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
	cf:SetScript("OnUpdate", function(self,event,...)
		MB:Mouseover()
	end)
end

--Setting default positioning for menu frame
function MB:CreateMenu()
	f:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
	f:Hide()
	--Backdrop creation
	f:CreateBackdrop('Default');
	f.backdrop:SetAllPoints();
	f.backdrop:Point("BOTTOMLEFT", f, "BOTTOMLEFT", 0,  -1);
	
	cf:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -2);
end

--Backdrop show/hide
function MB:Backdrop()
	if E.db.microbar.backdrop then
		f.backdrop:Show();
	else
		f.backdrop:Hide();
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
	f:SetScale(E.db.microbar.scale)
end

--Show/Hide in combat
function MB:EnterCombat()
	if E.db.microbar.combat then
		f:Hide()
	else
		f:Show()
	end	
end

--Show after leaving combat
function MB:LeaveCombat()
	f:Show()
end

--Sets mover size based on the frame layout
function MB:MicroMoverSize()
	f.mover:SetWidth(E.db.microbar.scale * MicroParent:GetWidth())
	f.mover:SetHeight(E.db.microbar.scale * MicroParent:GetHeight() + 1);
end

--Positionin of buttons
function MB:MicroButtonsPositioning()
	if E.db.microbar.layout == "Micro_Hor" then --Horizontal
		CharB:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  21)
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
		CharB:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  21)
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
		CharB:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  21)
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
		CharB:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  20)
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
		CharB:SetPoint("TOPLEFT", f, "TOPLEFT", 1,  20)
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
		CharB:SetPoint("TOPLEFT", f, "TOPLEFT", 0,  21)
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
		f:Size(305, 37)
	elseif E.db.microbar.layout == "Micro_Ver" then
		f:Size(29, 400)
	elseif E.db.microbar.layout == "Micro_26" then
		f:Size(55, 202)
	elseif E.db.microbar.layout == "Micro_34" then
		f:Size(80, 137)
	elseif E.db.microbar.layout == "Micro_43" then
		f:Size(105, 104)
	elseif E.db.microbar.layout == "Micro_62" then
		f:Size(154, 70)
	else
		f:Size(305, 37)
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
	UpdateMicroButtonsParent(f)
	f:Show();
	MB:ButtonsSetup();
	MB:MicroButtonsPositioning();
	MB:ShowMicroButtons();
end

--Initialization
function MB:Initialize()
	MB:SetNames()
	MB:CreateMenu();
	MB:Backdrop();
	MB:MicroFrameSize();
	MB:Scale();
	E:CreateMover(f, "MicroMover", L['Microbar'])
	MB:MicroMoverSize();
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "MenuShow");
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "MenuShow");	
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "MenuShow");
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnterCombat");
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "LeaveCombat");
end

E:RegisterModule(MB:GetName())