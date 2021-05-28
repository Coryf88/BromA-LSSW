if !(hasInterface && isNil "BRM_LSSW_wpnHolderLeft") exitWith {};

BRM_LSSW_wpnHolderLeft = objNull;
BRM_LSSW_switchingWeapon = false;

[{ !(isNull player || isNil "BRM_LSSW_fnc_addVolatileEH" || isNil "BRM_LSSW_fnc_updateInventory" || isNil "BRM_LSSW_fnc_leftWeapon") }, {
	[typeOf player, 1, ["ACE_SelfActions"], [
		"Take weapon on back",
		format [localize "str_action_weaponinhand", localize "str_weapon"],
		"\a3\ui_f\data\IGUI\cfg\Actions\reammo_ca.paa",
		{ 0 spawn BRM_LSSW_fnc_leftWeapon; },
		{ !BRM_LSSW_switchingWeapon && secondaryWeapon player isEqualTo "" && isNull objectParent player && !isNull BRM_LSSW_wpnHolderLeft }
	] call ace_interact_menu_fnc_createAction] call ace_interact_menu_fnc_addActionToClass;

	[typeOf player, 1, ["ACE_SelfActions"], [
		"Put weapon on back",
		format [localize "str_action_weapononback", localize "str_weapon"],
		"\a3\ui_f\data\IGUI\cfg\Actions\reammo_ca.paa",
		{ 0 spawn BRM_LSSW_fnc_leftWeapon; },
		{ !BRM_LSSW_switchingWeapon && primaryWeapon player != "" && secondaryWeapon player isEqualTo "" && isNull objectParent player && isNull BRM_LSSW_wpnHolderLeft && !isNil "BRM_LSSW_primaryWeaponState" }
	] call ace_interact_menu_fnc_createAction] call ace_interact_menu_fnc_addActionToClass;

	["BRM_LSSW", "Left Shoulder Scripted Weapon"] call CBA_fnc_registerKeybindModPrettyName;

	private _registry = profileNamespace getVariable "cba_keybinding_registry_v3";
	if (isNil "_registry" || { isNil { [_registry, "BRM_LSSW$BRM_LSSW_leftweapon"] call CBA_fnc_hashGet } }) then {
		systemChat "Warning: There isn't a default keybind for Left Shoulder Scripted Weapon, you'll need to set one to use it: Options > Controls > Configure Addons > Left Shoulder Scripted Weapon (This message will not be shown again)";
	};
	["BRM_LSSW", "BRM_LSSW_leftWeapon", "Switch Weapon", { [] spawn BRM_LSSW_fnc_leftWeapon; }, {}] call CBA_fnc_addKeybind;

	BRM_LSSW_weaponPEH = ["weapon", {
		params ["_unit", "_newWeapon", "_oldWeapon"];

		private _primaryWeapon = primaryWeapon _unit;
		if (_unit == player && _newWeapon == _primaryWeapon) then {
			BRM_LSSW_primaryWeaponState = (weaponState _unit select [0, 3]) + [_unit isFlashlightOn _primaryWeapon, _unit isIRLaserOn _primaryWeapon];
		};
	}, true] call CBA_fnc_addPlayerEventHandler;

	BRM_LSSW_muzzlePEH = ["muzzle", {
		private _unit = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
		params ["_newMuzzle", "_oldMuzzle"];

		private _primaryWeapon = primaryWeapon _unit;
		if (_unit == player && currentWeapon _unit == _primaryWeapon) then {
			BRM_LSSW_primaryWeaponState = (weaponState _unit select [0, 3]) + [_unit isFlashlightOn _primaryWeapon, _unit isIRLaserOn _primaryWeapon];
		};
	}, true] call CBA_fnc_addPlayerEventHandler;

	BRM_LSSW_weaponmodePEH = ["weaponmode", {
		params ["_unit", "_newWeaponMode", "_oldWeaponMode"];

		private _primaryWeapon = primaryWeapon _unit;
		if (_unit == player && currentWeapon _unit == _primaryWeapon) then {
			BRM_LSSW_primaryWeaponState = (weaponState _unit select [0, 3]) + [_unit isFlashlightOn _primaryWeapon, _unit isIRLaserOn _primaryWeapon];
		};
	}, true] call CBA_fnc_addPlayerEventHandler;

	call BRM_LSSW_fnc_addVolatileEH;
	BRM_LSSW_handler_respawn = player addEventHandler ["Respawn", BRM_LSSW_fnc_addVolatileEH];

	// Persistent handlers
	BRM_LSSW_handler_getin = player addEventHandler ["GetInMan", {
		if (!isNull BRM_LSSW_wpnHolderLeft) then {
			[BRM_LSSW_wpnHolderLeft, true] remoteExec ["hideObjectGlobal", 2, player call BIS_fnc_netId];
		};
	}];

	BRM_LSSW_handler_getout = player addEventHandler ["GetOutMan", {
		if (!isNull BRM_LSSW_wpnHolderLeft) then {
			[BRM_LSSW_wpnHolderLeft, false] remoteExec ["hideObjectGlobal", 2, player call BIS_fnc_netId];
		};
	}];
}] call CBA_fnc_waitUntilAndExecute;
