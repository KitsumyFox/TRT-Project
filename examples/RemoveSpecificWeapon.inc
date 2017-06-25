#include <sourcemod>
#include <sdktools>
#include <tf2_stocks>

new const DEFIDX_ATOMIZER = 450;
new const DEFIDX_CAPPER = 30666;

public OnPluginStart()
{
    HookEvent("post_inventory_application", OnPostInventoryApplication);
}

public OnPostInventoryApplication(Handle:hEvent, const String:szName[], bool:bDontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(hEvent, "userid"));
    new weaponMelee = GetPlayerWeaponSlot(client, TFWeaponSlot_Melee);
    new weaponSecondary = GetPlayerWeaponSlot(client, TFWeaponSlot_Secondary);
                     
    if (weaponMelee != INVALID_ENT_REFERENCE && GetEntProp(weaponMelee, Prop_Send, "m_iItemDefinitionIndex") == DEFIDX_ATOMIZER)
    {
        TF2_RemoveWeaponSlot(client, TFWeaponSlot_Melee);
        PrintToChat(client, "The Atomizer is blocked on this server.");
    }
    else if (weaponSecondary != INVALID_ENT_REFERENCE && GetEntProp(weaponMelee, Prop_Send, "m_iItemDefinitionIndex") == DEFIDX_CAPPER)
    {
    	TF2_RemoveWeaponSlot(client, TFWeaponSlot_Secondary)
    	PrintToChat(client, "The C.A.P.P.E.R is blocked on this server")
    }
}
