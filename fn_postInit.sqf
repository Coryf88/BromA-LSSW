if (isServer) then {
	[{ time > 0 }, {
		{ 
			publicVariable _x;
		} forEach [
			"BRM_LSSW_fnc_updateInventory",
			"BRM_LSSW_fnc_leftWeapon",
			"BRM_LSSW_fnc_addVolatileEH",
			"BRM_LSSW_fnc_init"
		];

		0 remoteExecCall ["BRM_LSSW_fnc_init", [0, -2] select isDedicated, true];
	}] call CBA_fnc_waitUntilAndExecute;
};
