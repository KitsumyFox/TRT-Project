stock Outline(client, bool add = true)
{
	if(add)
	{
		SetEntProp(client, Prop_Send, "m_bGlowEnabled", 1);
		isOutLined[client] = true;
	}
	else
	{
		SetEntProp(client, Prop_Send, "m_bGlowEnabled", 0);
		isOutLined[client] = false;
	}
}
