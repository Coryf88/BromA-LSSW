if (secondaryWeapon player != "" || BRM_LSSW_switchingWeapon) exitWith {};

BRM_LSSW_switchingWeapon = true;
private _leftWeapon = if (isNull BRM_LSSW_wpnHolderLeft) then { nil } else { weaponsItemsCargo BRM_LSSW_wpnHolderLeft select 0 };
private _state = [[2, 1], [0, -1]] select isNil "_leftWeapon" select (primaryWeapon player == ""); // [[Switch, Take], [Put, Exit]]

if (_state == -1) exitWith { BRM_LSSW_switchingWeapon = false; };

private _primaryWeapon = nil;
if (primaryWeapon player != "") then {
	{
		if (_x select 0 == primaryWeapon player) then {
			_primaryWeapon = _x
		}
	} forEach (weaponsItems player);
};

private _animSpeed = getAnimSpeedCoef player;

if (_state != 1 && currentMuzzle player != "") then { // Put || Switch
	player action ["switchWeapon", player, player, -1];
	sleep (2.266 / _animSpeed);
};

if (_state != 1 && { primaryWeapon player isNotEqualTo _primaryWeapon#0 }) exitWith { // Put || Switch
	BRM_LSSW_switchingWeapon = false;
};

private _oldLoad = load player;

if (_state != 0) then { // Take || Switch
	detach BRM_LSSW_wpnHolderLeft;
	deleteVehicle BRM_LSSW_wpnHolderLeft;
	BRM_LSSW_wpnHolderLeft = objNull;
};

if (_state == 0) then { // Put
	player removeWeaponGlobal primaryWeapon player;
};

if (_state != 1) then { // Put || Switch
	BRM_LSSW_wpnHolderLeft = "Weapon_Empty" createVehicle [0, 0, 0];
	BRM_LSSW_wpnHolderLeft attachTo [player, [0, 0.02, 0.025], "launcher", true];
	BRM_LSSW_wpnHolderLeft setVectorDirAndUp [[0.981852, 0.0870364, -0.168495], [-0.17341, 0.052336, -0.983458]];
	BRM_LSSW_wpnHolderLeft addWeaponWithAttachmentsCargoGlobal [_primaryWeapon, 1];
	BRM_LSSW_wpnHolderLeft setDamage 1;

	// Cancel opening, in-case the player does manage to open it.
	// Note: If a container (Specifically a "B_CargoNet_01_ammo_F", others untested) is opened and 
	//   the player walks away, without closing the inventory; it results in the BRM_LSSW_wpnHolderLeft being opened without a ContainerOpened event.
	//   This is a minor issue, since it seems to not be possible to add or remove items in that situation.
	BRM_LSSW_wpnHolderLeft addEventHandler ["ContainerOpened", {
		params ["_container", "_unit"];

		[{ !isNull findDisplay 602 }, {
			(findDisplay 602) closeDisplay 0;
		}, []] call CBA_fnc_waitUntilAndExecute;
	}];
};

call BRM_LSSW_fnc_updateInventory;

private _leftWeaponState = player getVariable "BRM_LSSW_leftWeaponState";
player setVariable ["BRM_LSSW_leftWeaponState", if (_state != 1) then { BRM_LSSW_primaryWeaponState } else { nil }]; // Put || Switch else Take

if (_state != 0) then { // Take || Switch
	player addWeapon (_leftWeapon select 0);
	removeAllPrimaryWeaponItems player;
	private _weaponsItems = weaponsItems player;
	for "_i" from 0 to ((count _weaponsItems) - 1) do {
		if (_weaponsItems select _i select 0 == primaryWeapon player) exitWith {
			// _weapon, _muzzle, _flashlight, _optics, _primaryMuzzleMagazine, _secondaryMuzzleMagazine, _bipod
			_weaponsItems select _i params ["", "", "", "", "_primaryMuzzleMagazine", "_secondaryMuzzleMagazine", ""];
			if !(_primaryMuzzleMagazine isEqualTo []) then {
				player removePrimaryWeaponItem (_primaryMuzzleMagazine select 0);
				player addMagazine _primaryMuzzleMagazine;
			};
			if !(_secondaryMuzzleMagazine isEqualTo []) then {
				player removePrimaryWeaponItem (_secondaryMuzzleMagazine select 0);
				player addMagazine _secondaryMuzzleMagazine;
			};
		};
	};
	for "_i" from 1 to (count _leftWeapon) - 1 do {
		player addWeaponItem [_leftWeapon select 0, _leftWeapon select _i];
	};

	player selectWeapon primaryWeapon player;

	if (!isNil "_leftWeaponState") then {
		private _weaponState = _leftWeaponState select [0, 3]; // weapon, muzzle, firemode
		for "_i" from 0 to 99 do {
			player action ["SwitchWeapon", player, player, _i];

			if (weaponState player select [0, 3] isEqualTo _weaponState) exitWith {};
		};

		/*
		// https://feedback.bistudio.com/T81321
		if (_leftWeaponState select 3) then { // flashlightOn
			player action ["GunLightOn", player];
		};
		if (_leftWeaponState select 4) then { // laserOn
			player action ["IRLaserOn", player];
		};
		*/
	};
};

/*
if (_state != 0) then { // Take || Switch
	//private _mass = player getVariable ["BRM_LSSW_leftWeaponMass", 0];
	//player setUnitTrait ["loadCoef", (player getUnitTrait "loadCoef") - _mass];
	if (!isNil "ace_movement_fnc_addLoadToUnitContainer") then {
		[player, player, -(_leftWeapon call BRM_LSSW_fnc_weaponMass)] call ace_movement_fnc_addLoadToUnitContainer;
	};
};

if (_state != 1) then { // Put || Switch
	_leftWeapon = if (isNull BRM_LSSW_wpnHolderLeft) then { nil } else { weaponsItemsCargo BRM_LSSW_wpnHolderLeft select 0 };
	//private _newLoad = load player;
	//private _mass = if (_newLoad > 0) then { (_oldLoad - _newLoad) / _newLoad } else { 0 };
	//player setVariable ["BRM_LSSW_leftWeaponMass", _mass];
	//private _newLoadCoef = (player getUnitTrait "loadCoef") + _mass;
	//systemChat format ["Load: %1 to %2; mass: %3; LoadCoef: %4 to %5", _oldLoad, _newLoad, _mass, player getUnitTrait "loadCoef", _newLoadCoef];
	//player setUnitTrait ["loadCoef", _newLoadCoef];
	//[{player setUnitTrait ["loadCoef", _this];}, _newLoadCoef] call CBA_fnc_execNextFrame;
	if (!isNil "ace_movement_fnc_addLoadToUnitContainer") then {
		[player, player, _leftWeapon call BRM_LSSW_fnc_weaponMass] call ace_movement_fnc_addLoadToUnitContainer;
	};
};
*/

sleep ((switch (_state) do {
	case 0: { 0.852 }; // Put
	case 1: { 2.266 }; // Take
	case 2: { 2.333 }; // Switch
}) / _animSpeed);

BRM_LSSW_switchingWeapon = false;
