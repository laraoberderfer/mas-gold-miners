// leader agent
/*
 * By Joao Leite
 * Based on implementation developed by Rafael Bordini, Jomi Hubner and Maicon Zatelli
 * Alterado em Maio de 2021 
 * por Lara Popov Zambiasi Bazzi Oberderfer
 */

winning(none,0).
/*
score(miner1,0).
score(miner2,0).
score(miner3,0).
score(miner4,0).
 */
score("pink",0).
score("orange",0).
score("red",0).
score("green",0).
 
//the start goal only works after execise j)
//!start.
//+!start <- tweet("a new mining is starting! (posted by jason agent)").

      
+dropped(T)[source(A)] : score(T,S) & winning(L,SL) & S+1>SL
   <- -score(T,S);
      +score(T,S+1);
      -dropped(T)[source(A)];
      -+winning(T,S+1);
      .print("Time ",T," esta vencendo com ",S+1," pecas de ouro");
      .broadcast(tell,winning(T,S+1)).
      
/* dos times */
+dropped(T)[source(A)] : score(T,S) & winning(L,SL) & S+1=SL
   <- -score(T,S);
      +score(T,S+1);
      -dropped(T)[source(A)];
      -+winning(T,S+1);
      .print("Time: ",T," e Time: ", L, " empatados com ", S+1," pecas de ouro.");
      .broadcast(tell,winning(T,S+1)).
      
+dropped(T)[source(A)] : score(T,S)
   <- -score(T,S);
      +score(T,S+1);
      -dropped(T)[source(A)];
      .print("Time ",A," entregou ",S+1," ouro").
      
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }