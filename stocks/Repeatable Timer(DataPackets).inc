// Thanks adma.

stock void CreateCountdown(int iClient, int iSeconds, const char[] sFormat)
{
	DataPack pack = CreateDataPack();
	WritePackCell(pack, GetClientUserId(iClient));
	WritePackCell(pack, iSeconds);
	WritePackString(pack, sFormat);
	ResetPack(pack);

	CreateTimer(0.0, Timer_Countdown, pack);
}

stock void CreateCountdownAll(int iSeconds, const char[] sFormat)
{
	DataPack pack = CreateDataPack();
	WritePackCell(pack, 0);
	WritePackCell(pack, iSeconds);
	WritePackString(pack, sFormat);
	ResetPack(pack);

	CreateTimer(0.0, Timer_Countdown, pack);
}

*/
public Action Timer_Countdown(Handle hTimer, DataPack pack)
{
	int iUserID = ReadPackCell(pack);
	int iClient;
	if(iUserID != 0)
	{
		iClient = GetClientOfUserId(iUserID);
		if(!iClient)
		{
			CloseHandle(pack);
			return Plugin_Stop;
		}
	}

	int iSeconds = ReadPackCell(pack);
	char sFormat[192];
	ReadPackString(pack, sFormat, sizeof(sFormat));

	if(iUserID != 0)
		PrintCenterText(iClient, "%t", sFormat, iSeconds);
	else
		PrintCenterTextAll("%t", sFormat, iSeconds);

	if(iSeconds != 1)
	{
		ResetPack(pack);
		ReadPackCell(pack);
		WritePackCell(pack, iSeconds-1);
		ResetPack(pack);

		CreateTimer(1.0, Timer_Countdown, pack);
	}
	else
		CloseHandle(pack);

	return Plugin_Stop;
}
/*
