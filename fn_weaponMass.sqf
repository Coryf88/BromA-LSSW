params [
	["_weapon", ""],
	["_muzzle", ""],
	["_flashlight", ""],
	["_optics", ""],
	["_primaryMuzzleMagazine", []],
	["_secondaryMuzzleMagazine", []],
	["_bipod", ""]
];
_primaryMuzzleMagazine params [["_primaryMagazine", ""], ["_ammo", 0]];
_secondaryMuzzleMagazine params [["_secondaryMagazine", ""], ["_ammo", 0]];

if (_weapon == "") exitWith { 0 };

private _mass = getNumber (configFile >> "CfgWeapons" >> _weapon >> "WeaponSlotsInfo" >> "mass");

{
	if (_x != "") then {
		_mass = _mass + getNumber (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "mass");
	};
} foreach [_muzzle, _flashlight, _optics, _bipod];

{
	if (_x != "") then {
		_mass = _mass + getNumber (configFile >> "CfgMagazines" >> _x >> "mass");
	};
} forEach [_primaryMagazine, _secondaryMagazine];

_mass
