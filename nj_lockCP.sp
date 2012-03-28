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

#define PLUGIN_VERSION "0.0.3"

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
		PrintToChatAll("[nj] disable all capture point");
		PrintToServer("[nj] disable all capture point");
	}
	else
	{
		PrintToChatAll("[nj] enable all capture point");
		PrintToServer("[nj] enable all capture point");
	}
	// https://forums.alliedmods.net/showpost.php?p=1227321&postcount=4
	// http://forums.alliedmods.net/showthread.php?t=76080
	// thanks nice sourcecode
	// AcceptEntityInput Flag Document
	// https://developer.valvesoftware.com/wiki/Trigger_capture_area
	new i = -1;
	while ((i = FindEntityByClassname(i, "trigger_capture_area")) != -1)
	{
		if (capState) {
			SetVariantString("2 0");
			AcceptEntityInput(i, "SetTeamCanCap"); 
			SetVariantString("3 0");
			AcceptEntityInput(i, "SetTeamCanCap");
		}
		else
		{
			SetVariantString("2 1");
			AcceptEntityInput(i, "SetTeamCanCap");
			SetVariantString("3 1");
			AcceptEntityInput(i, "SetTeamCanCap");
		
		}
	}
}