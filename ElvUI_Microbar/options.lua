﻿--------------------------------------------------------
-- Options and defaults
--------------------------------------------------------
local E, L, V, P, G =  unpack(ElvUI);
local MB = E:GetModule('Microbar', 'AceEvent-3.0');

--Defaults
P['microbar'] = {
	['mouse'] = false, --Mouseover
    ['backdrop'] = true, --Backdrop
	['combat'] = false, --Hide in combat
	['alpha'] = 1, --Transparency
	['scale'] = 1, --Scale
	['layout'] = "Micro_Hor", --Button layuot format
	['xoffset'] = 0,
	['yoffset'] = 0,
}

--Options
E.Options.args.microbar = {
	type = "group",
    name = L["Microbar"],
    get = function(info) return E.db.microbar[ info[#info] ] end,
    set = function(info, value) E.db.microbar[ info[#info] ] = value; end, 
	order = 50,
   	args = {
		intro = {
			order = 1,
			type = "description",
			name = L['Module for adding micromenu to ElvUI.'],
		},
		visibility = {
			order = 2,
			type = "group",
			name = L["Visibility"],
			guiInline = true,
			args = {
				mouse = {
					order = 1,
					type = "toggle",
					name = L['On Mouse Over'],
					desc = L['Hide microbar unless you mouse over it.'],
					set = function(info, value) E.db.microbar.mouse = value; end,
				},
				backdrop = {
					order = 2,
					type = "toggle",
					name = L['Backdrop'],
					desc = L['Show backdrop for micromenu'],
					set = function(info, value) E.db.microbar.backdrop = value; MB:Backdrop(); end,
				},
				combat = {
					order = 3,
					type = "toggle",
					name = L['Hide in Combat'],
					desc = L['Hide Microbar in combat.'],
					set = function(info, value) E.db.microbar.combat = value; end,
				},
				alpha = {
					order = 4,
					type = "range",
					name = L['Set Alpha'],
					desc = L['Sets alpha of the microbar'],
					min = 0.2, max = 1, step = 0.01,
					set = function(info, value) E.db.microbar.alpha = value; end,
				},
				scale = {
					order = 5,
					type = "range",
					name = L['Set Scale'],
					desc = L['Sets Scale of the microbar'],
					isPercent = true,
					min = 0.3, max = 2, step = 0.01,
					set = function(info, value) E.db.microbar.scale = value; MB:Scale(); MB:MicroMoverSize(); end,
				},
				symbolic = {
					order = 6,
					type = 'toggle',
					name = L["As Letters"],
					desc = L["Replace icons with just letters.\n|cffFF0000Warning:|r this will disable original Blizzard's tooltips for microbar."],
					set = function(info, value) E.db.microbar.symbolic = value; MB:MenuShow(); end,
				},
			}
		},
		positioning = {
			order = 3,
			type = "group",
			name = L["Positioning"],
			guiInline = true,
			args = {
				layout = {
					order = 1,
					type = "select",
					name = L["Microbar Layout"],
					desc = L["Change the positioning of buttons on Microbar."],
					set = function(info, value) E.db.microbar.layout = value; MB:MicroButtonsPositioning(); MB:MicroFrameSize(); end,
					values = {
						['Micro_Hor'] = L["Horizontal"],
						['Micro_Ver'] = L["Vertical"],
						['Micro_62'] = L["2 rows"],
						['Micro_43'] = L["3 rows"],
						['Micro_34'] = L["4 rows"],
						['Micro_26'] = L["6 rows"],
					},
				},
				xoffset = {
					order = 2,
					type = "range",
					name = L["X Offset"],
					desc = L["Sets X offset for microbar buttons"],
					min = 0, max = 10, step = 1,
					set = function(info, value) E.db.microbar.xoffset = value; MB:MicroButtonsPositioning(); MB:MicroFrameSize(); MB:MicroMoverSize(); end,
				},
				yoffset = {
					order = 3,
					type = "range",
					name = L["Y Offset"],
					desc = L["Sets Y offset for microbar buttons"],
					min = 0, max = 10, step = 1,
					set = function(info, value) E.db.microbar.yoffset = value; MB:MicroButtonsPositioning(); MB:MicroFrameSize(); MB:MicroMoverSize(); end,
				},
			}
		}	
	}
}