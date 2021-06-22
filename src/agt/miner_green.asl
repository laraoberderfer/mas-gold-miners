// miner agent

team("green").

!start.
+!start : true
    <- ?team(T);
       .concat(T, "TeamMap", MapName);      
        lookupArtifact(MapName, MapId);
        .print("MapName: ", MapName);
        focus(MapId);
        .

{ include("miner.asl") }


