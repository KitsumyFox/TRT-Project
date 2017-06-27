GetRandomPlayer(team) 
{ 
    new clients[MaxClients+1], clientCount; 
    for (new i = 1; i <= MaxClients; i++) 
        if (IsClientInGame(i) && GetClientTeam(i) == team) 
            clients[clientCount++] = i; 
    return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount-1)]; 
}

/*Team List
3 - Blue / CT
2 - Red / T
1 - Spectator
0 - No Team
*/
