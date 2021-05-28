BRM_LSSW_handler_take = player addEventHandler ["Take", {
	params ["_unit", "_container", "_item"];

	if (secondaryWeapon player != "" && !isNull BRM_LSSW_wpnHolderLeft) then {
		// Player has a secondary weapon and left shoulder weapon, drop the left shoulder weapon.
		private _weapon = weaponsItemsCargo BRM_LSSW_wpnHolderLeft select 0;

		private _inventoryOpen = !isNull findDisplay 602;

		detach BRM_LSSW_wpnHolderLeft;
		deleteVehicle BRM_LSSW_wpnHolderLeft; // This sometimes closes the inventory
		BRM_LSSW_wpnHolderLeft = objNull;
		if (_inventoryOpen) then {
			// Reopen the inventory. Timeout in-case the above is fixed.
			[{ isNull findDisplay 602 }, { player action ["Gear", _this]; }, _container, 0.5] call CBA_fnc_waitUntilAndExecute;
		};

		_container addWeaponWithAttachmentsCargoGlobal [_weapon, 1];
		call BRM_LSSW_fnc_updateInventory;
	}
}];

BRM_LSSW_handler_invOpened = player addEventHandler ["InventoryOpened", {
	if (!isNull BRM_LSSW_wpnHolderLeft) then {
		if (secondaryWeapon player == "") then {
			[{ !isNull findDisplay 602 }, {
				call BRM_LSSW_fnc_updateInventory;
			}, []] call CBA_fnc_waitUntilAndExecute;
		} else {
			// Player has a secondary weapon and left shoulder weapon, drop the secondary weapon.
			player action ["DropWeapon", "GroundWeaponHolder" createVehicle position player, secondaryWeapon player];
			call BRM_LSSW_fnc_updateInventory;
		};
	};
}];

BRM_LSSW_handler_killed = player addEventHandler ["Killed", {
	if (!isNil "BRM_LSSW_handler_take") then { player removeEventHandler ["Take", BRM_LSSW_handler_take]; };
	if (!isNil "BRM_LSSW_handler_invOpened") then { player removeEventHandler ["InventoryOpened", BRM_LSSW_handler_invOpened]; };
	if (!isNil "BRM_LSSW_handler_killed") then { player removeEventHandler ["Killed", BRM_LSSW_handler_killed]; };

	if (!isNull BRM_LSSW_wpnHolderLeft) then {
		private _weapon = weaponsItemsCargo BRM_LSSW_wpnHolderLeft select 0;

		detach BRM_LSSW_wpnHolderLeft;
		deleteVehicle BRM_LSSW_wpnHolderLeft;
		BRM_LSSW_wpnHolderLeft = objNull;

		[{
			params ["_position", "_weapon"];
			!(_position nearEntities ["WeaponHolderSimulated", 2] isEqualTo [])
		}, {
			params ["_position", "_weapon"];

			private _container = _position nearEntities ["WeaponHolderSimulated", 2] select 0;
			_container addWeaponWithAttachmentsCargoGlobal [_weapon, 1];
		}, [position player select [0, 2], _weapon], 2, {
			params ["_position", "_weapon"];

			private _container = "WeaponHolderSimulated" createVehicle _position;
			_container addWeaponWithAttachmentsCargoGlobal [_weapon, 1];
		}] call CBA_fnc_waitUntilAndExecute;
	};
}];
