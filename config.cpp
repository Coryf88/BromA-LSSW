class CfgPatches {
	class BRM_LSSW {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = { "ace_interact_menu", "cba_keybinding" };
		author[] = { "BromA" };
	};
};

class CfgFunctions {
	class BRM_LSSW {
		class functions {
			file = "BRM_LSSW";
			class postInit { postInit = 1; };
			class init {};
			class addVolatileEH {};
			class leftWeapon {};
			class updateInventory {};
			//class weaponMass {};
		};
	};
};
