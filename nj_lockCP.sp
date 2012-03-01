/**
* vim: set ts=4 
* Author: withgod <noname@withgod.jp>
* GPL 2.0
*
**/

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>

#define PLUGIN_VERSION "0.0.1"

new Handle:g_njLockCP = INVALID_HANDLE;
new bool:isFirst      = true;

public Plugin:myinfo = 
{
	name = "nj_lockCP",
	author = "withgod",
	description = "capture lock plugin",
	version = PLUGIN_VERSION,
	url = "http://github.com/withgod/sm-nj_lockCP"
};

public OnPluginStart()
{
	PrintToServer("plugin start");
	CreateConVar("nj_lockcp_version", PLUGIN_VERSION, "nj lock the capture", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	g_njLockCP = CreateConVar("nj_lockcp", "1", "lock the capture Enable/Disable (0 = disabled | 1 = enabled)", 0, true, 0.0, true, 1.0);
	
	HookEvent("teamplay_round_start", LockTheCapture);
	HookConVarChange(g_njLockCP, HandleLockTheCapture);
}

public HandleLockTheCapture(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	PrintToServer("call handle lock the capture");
	DisableControlPoints(GetConVarBool(g_njLockCP));
}

public LockTheCapture(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (isFirst)
	{
		isFirst = false;
	}
	else
	{
		DisableControlPoints(GetConVarBool(g_njLockCP));
	}
}

public DisableControlPoints(bool:capState)
{
	if (capState) 
	{
		PrintToChatAll("[notice] disable all capture point");
	}
	else
	{
		PrintToChatAll("[notice] enable all capture point");
	}
	// https://forums.alliedmods.net/showpost.php?p=1227321&postcount=4
	// thanks nice sourcecode
	new i = -1;
	new CP = 0;
	for (new n = 0; n <= 32; n++)
	{
		CP = FindEntityByClassname(i, "trigger_capture_area");
		if (IsValidEntity(CP))
		{
			if (capState) {
				AcceptEntityInput(CP, "Disable");
			}
			else
			{
				AcceptEntityInput(CP, "Enable");
			}
			i = CP;
		} 
		else
		{
			break;
		}
	}
}