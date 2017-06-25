stock GetRandomPlayer(team) { 
    new clients[MaxClients + 1], clientCount; 
     
    for (new i = 1; i <= MaxClients; i++) 
        if (IsClientInGame(i) && GetClientTeam(i) == team) 
            clients[clientCount++] = i; 
     
    if (clientCount < 2) 
        return -1; 
     
    return clients[GetRandomInt(0, clientCount - 1)]; 
}  

/*Team List
3 - Red / T
2 - Blue / CT
1 - Spectator
0 - No Team
*/
