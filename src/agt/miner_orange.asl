// miner agent

team("orange").

!start.
+!start : true
    <- ?team(T);
       .concat(T, "TeamMap", MapName);
        lookupArtifact(MapName, MapId);
        .print("MapName: ", MapName);
        .

{ include("miner.asl") }


