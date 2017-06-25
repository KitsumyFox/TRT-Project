stock TF2GetRandomPlayer(team) { 
    new clients[MaxClients + 1], clientCount; 
     
    for (new i = 1; i <= MaxClients; i++) 
        if (IsClientInGame(i) && TF2_GetClientTeam(i) == team) 
            clients[clientCount++] = i; 
     
    if (clientCount < 2) 
        return -1; 
     
    return clients[GetRandomInt(0, clientCount - 1)]; 
}  
