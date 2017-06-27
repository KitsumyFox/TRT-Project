#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "BloodTiger"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

// Convars
ConVar g_cvJumpMax = null;
ConVar g_cvAllorTeam = null;
ConVar g_cvJumpBoost = null;
ConVar g_cvJumpEnable = null;
ConVar g_cvBlueorRed = null;

// Floats
float g_flBoost = 250.0;

// Bools
bool g_bDoubleJump;
bool g_bAllorTeam;
bool g_bBlueorRed;


// Ints
int g_iJumpMax;
int g_iLastButtons[MAXPLAYERS+1];
int g_iLastFlags[MAXPLAYERS+1];
int g_iJumps[MAXPLAYERS+1];

public Plugin myinfo = 
{
	name = "[TF2] Blue double-jump",
	author = PLUGIN_AUTHOR,
	description = "Adds double jumping for blues",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	CreateConVar("sm_doublejump_version", PLUGIN_VERSION, "Double jump version");
	g_cvJumpEnable = CreateConVar("sm_doublejump_enabled", "1", "Enables double jumping");
	g_cvJumpBoost = CreateConVar("sm_doublejump_boost", "250.0", "Vertical boost count");
	g_cvJumpMax = CreateConVar("sm_doublejump_max", "1", "Maximum numbers of double jumps");
	g_cvAllorTeam = CreateConVar("sm_doublejump_allorteam", "1", "Specifies whether you want doublejump only enabled on one team or on all teams");
	g_cvBlueorRed = CreateConVar("sm_doublejump_redorblue", "0", "Specifies which team to pick. Red = 1 Blue = 0");
	
	g_cvJumpEnable.AddChangeHook(convar_ChangeEnable);
	g_cvJumpBoost.AddChangeHook(convar_ChangeBoost);
	g_cvJumpMax.AddChangeHook(convar_ChangeMax);
	g_cvAllorTeam.AddChangeHook(convar_AllorTeam);
	g_cvBlueorRed.AddChangeHook(convar_BlueorRed);

	g_bBlueorRed = g_cvBlueorRed.BoolValue;
	g_bAllorTeam = g_cvAllorTeam.BoolValue;
	g_bDoubleJump = g_cvJumpEnable.BoolValue;
	g_flBoost = g_cvJumpBoost.FloatValue;
	g_iJumpMax = g_cvJumpMax.IntValue;
}

public int convar_ChangeBoost(Handle convar, const char[] oldVal, const char[] newVal)
{
	g_flBoost = StringToFloat(newVal);
}

public int convar_ChangeEnable(Handle convar, const char[] oldVal, const char[] newVal)
{
	if(StringToInt(newVal) >=1)
	{
		g_bDoubleJump = true;
	}
	else
	{
		g_bDoubleJump = false;
	}
}

public void convar_ChangeMax(Handle convar, const char[] oldVal, const char[] newVal)
{
	g_iJumpMax = StringToInt(newVal);
}

public void convar_AllorTeam(Handle convar, const char[] oldVal, const char[] newVal)
{
	if(StringToInt(newVal) >=1)
	{
		g_bAllorTeam = true;
	}
	else
	{
		g_bDoubleJump = false;
	}
}

public void convar_BlueorRed(Handle convar, const char[] oldVal, const char[] newVal)
{
	if(StringToInt(newVal) >=0)
	{
		g_bBlueorRed = true;
	}
	else
	{
		g_bBlueorRed = false;
	}
}

public void OnGrameFrame()
{
	if(g_bDoubleJump)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if(!g_bAllorTeam)
			{
				if(IsClientInGame(i) && IsPlayerAlive(i))
				{
					DoubleJump(i);
				}
			}
			else if(g_bAllorTeam)
			{
				if(!g_bBlueorRed)
				{
					if(IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 3)
					{
						DoubleJump(i);
					}
				}
				else if(g_bBlueorRed)
				{
					if(IsClientInGame(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
					{
						DoubleJump(i);
					}
				}
			}
		}		
	}
}

stock void DoubleJump(int client)
{
	int fCurFlags = GetEntityFlags(client);
	int fCurButtons = GetEntityFlags(client);
	
	if(g_iLastFlags[client] & FL_ONGROUND)
	{
		if(!(fCurFlags & FL_ONGROUND) && !(g_iLastButtons[client] & IN_JUMP) && (fCurButtons & IN_JUMP))
		{
			OriginalJump(client);
		}
	}
	else if(fCurFlags & FL_ONGROUND)
	{
		LandedClient(client);
	}
	else if(!(g_iLastButtons[client] & IN_JUMP) && (fCurButtons & IN_JUMP))
	{
		ReJump(client);
	}
	
	g_iLastFlags[client] = fCurFlags;
	g_iLastButtons[client] = fCurButtons;
}

stock void OriginalJump(int client) 
{
	g_iJumps[client]++;
}

stock void LandedClient(int client) 
{
	g_iJumps[client] = 0;
}

stock void ReJump(int client) 
{
	if ( 1 <= g_iJumps[client] <= g_iJumpMax) 
	{						
		g_iJumps[client]++;
		float vVel[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
		
		vVel[2] = g_flBoost;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
	}
}
