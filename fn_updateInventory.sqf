disableSerialization;
private _display = findDisplay 602; // RscDisplayInventory

if (isNull _display) exitWith {};

private _ctrlSlotLeftBackground = _display displayCtrl 2000;
private _ctrlSlotLeft = _display displayCtrl 2001;

private _ctrlBackgroundSlotSecondary = _display displayCtrl 1247; // BackgroundSlotSecondary
private _ctrlSlotSecondary = _display displayCtrl 611; // SlotSecondary
if (isNull BRM_LSSW_wpnHolderLeft) exitWith {
	if (!isNull _ctrlSlotLeftBackground) then {
		_ctrlBackgroundSlotSecondary ctrlShow true;
		ctrlDelete _ctrlSlotLeftBackground;
	};
	if (!isNull _ctrlSlotLeft) then {
		_ctrlSlotSecondary ctrlShow true;
		ctrlDelete _ctrlSlotLeft;
	};
};

if (isNull _ctrlSlotLeftBackground) then {
	_ctrlBackgroundSlotSecondary ctrlShow false;

	_ctrlSlotLeftBackground = _display ctrlCreate ["RscPicture", 2000];
	_ctrlSlotLeftBackground ctrlSetText "#(rgb,8,8,3)color(0.6,0.6,0.6,0.1)";
	_ctrlSlotLeftBackground ctrlSetPosition ctrlPosition _ctrlSlotSecondary;
	_ctrlSlotLeftBackground ctrlCommit 0;
};

if (isNull _ctrlSlotLeft) then {
	_ctrlSlotSecondary ctrlShow false;

	_ctrlSlotLeft = _display ctrlCreate ["RscActivePictureKeepAspect", 2001];
	_ctrlSlotLeft ctrlSetPosition ctrlPosition _ctrlSlotSecondary;
	_ctrlSlotLeft ctrlCommit 0;
	_ctrlSlotLeft ctrlSetTextColor [1, 1, 1, 1];
	//_ctrlSlotLeft ctrlSetTooltip "Tooltip!"; // Tooltips not working in inventory...
};
_ctrlSlotLeft ctrlSetText (getText (configfile >> "CfgWeapons" >> weaponsItemsCargo BRM_LSSW_wpnHolderLeft select 0 select 0 >> "picture") select [1]);
