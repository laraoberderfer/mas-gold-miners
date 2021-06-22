// miner agent

{ include("$jacamoJar/templates/common-cartago.asl") }

/*
 * By Joao Leite
 * Based on implementation developed by Rafael Bordini, Jomi Hubner and Maicon Zatelli
 * 
 * Atualizado em Maio de 2021
 * por Lara Popov Zambiasi Bazzi Oberderfer
 */

/* beliefs */
last_dir(null). // the last movement I did
free.
score(0).
count(0).

/* rules */
/* this agent program doesn't have any rules */


/* Quando estão livres, os agentes ficam vagando. 
 * Isso é codificado com um plano que é executado quando os agentes se tornam livres 
 * (o que acontece inicialmente por causa da crença "livre" acima, mas também pode 
 * acontecer durante a execução do agente (como veremos a seguir).
 * O plano simplesmente obtém dois números aleatórios dentro do escopo do tamanho da grade 
 * (usando uma ação interna jia.random) e, em seguida, chama o subobjetivo go_near. 
 * Assim que o agente estiver próximo à posição desejada, se livre, ele deleta e 
 * adiciona o átomo livre à sua base de crença, o que acionará o plano para ir para um 
 * local aleatório novamente.
 */

/* exercicio a */
+free : gsize(_,W,H) & jia.random(RX,W-1) & jia.random(RY,H-1)
   <- .print("Estou proximo de [",RX,",",RY,"]");  
   !go_near(RX,RY).
+free  // gsize is unknown yet
   <- .wait(100); -+free.

/* Quando o agente passa a acreditar que está perto do local e ainda está livre, 
 * ele atualiza o átomo "livre" para que possa acionar o plano de ir para um 
 * local aleatório novamente.
 */
+near(X,Y) : free 
	<- .wait(100);
	-+free.

/* exercicio b */

/* novos planos para o evento +! próximo a (_, _) */ 

// Estou proximo de algum local se estiver perto dele 
+!near(X,Y) 
	: (pos(AgX,AgY) 
	& jia.neighbour(AgX,AgY,X,Y))
   <- .print ("Estou em ", "[", AgX, ",", AgY, "]", " que está próximo de [", X, ",", Y , "]"); 
      +near(X,Y).

/* Estou perto de algum local se a última ação foi pular 
 (significando que não há caminhos para lá) */
+!near(X,Y) 
	: pos(AgX,AgY) 
	& last_dir(skip)
   <- .print ("Estou em ", "[", AgX, ",", AgY, "]", " e não consigo chegar a '[", X, ",", Y, "]"); 
      +near(X,Y).

+!near(X,Y) 
	: not near(X,Y)
   <- !next_step(X,Y);
      !near(X,Y).
+!near(X,Y) 
	: true
   <- !near(X,Y).

/* Os planos a seguir codificam como um agente deve chegar perto de um local X, Y.
  * Como o local pode não ser alcançável, os planos foram bem-sucedidos
  * se o agente estiver próximo ao local, dado pela ação interna jia.neighbour,
  * ou se a última ação foi pular, o que acontece quando o destino não é
  * alcançável, fornecido pelo plano next_step como resultado da chamada para o
  * ação interna jia.get_direction.
  * Estes planos são utilizados apenas na exploração da rede, desde que alcance o
  * a localização exata não é muito importante.
 */

+!go_near(X,Y) : free
  <- -near(_,_);
     -last_dir(_);
     !near(X,Y).


+!near(X,Y) : (pos(AgX,AgY) & jia.neighbour(AgX,AgY,X,Y)) | last_dir(skip) // I am near to some location if I am near it or the last action was skip (meaning that there are no paths to there)
   <- +near(X,Y).
+!near(X,Y) : not near(X,Y)
   <- !next_step(X,Y);
      !near(X,Y).
+!near(X,Y) : true
   <- !near(X,Y).


/* Esses são os planos para que o agente execute uma etapa na direção de X, Y.
  * Eles são usados pelos planos go_near acima e pos abaixo. Usa o interno
  * action jia.get_direction que codifica um algoritmo de busca.
 */

+!next_step(X,Y) : pos(AgX,AgY) // I already know my position
   <- jia.get_direction(AgX, AgY, X, Y, D);
      -+last_dir(D);
      D.
+!next_step(X,Y) : not pos(_,_) // I still do not know my position
   <- !next_step(X,Y).
-!next_step(X,Y) : true  // failure handling -> start again!
   <- -+last_dir(null);
      !next_step(X,Y).

/* Os planos a seguir codificam como um agente deve ir para uma posição exata X, Y.
  * Ao contrário dos planos para chegar perto de uma posição, este assume que o
  * posição alcançável. Se a posição não for alcançável, ele fará um loop para sempre.
  */

+!pos(X,Y) : pos(X,Y)
   <- .print("Alcancei (",X,"x",Y,")!").
+!pos(X,Y) : not pos(X,Y)
   <- !next_step(X,Y);
      !pos(X,Y). 

/* Planos de busca de ouro */

/* O plano a seguir codifica como um agente deve lidar com uma peça recém-encontrada
  * de ouro, quando não está transportando ouro e é gratuito.
  * O primeiro passo muda a crença para que o agente não acredite mais que é livre.
  * Em seguida, acrescenta a crença de que há ouro na posição X, Y e
  * imprime uma mensagem. Finalmente, ele chama um plano para lidar com aquela peça de ouro.
  */

// ouro percebido é incluído como auto-crença 
// (para não ser removido uma vez que não seja mais visto)
+cell(X,Y,gold) <- +gold(X,Y).

// atomic: de modo a não lidar com outro evento até que o identificador de ouro seja inicializado
@pgold[atomic] 
+gold(X,Y)
  :  not carrying_gold & free
  <- -free;
     .print("Percebi ouro em: ",gold(X,Y));
     !init_handle(gold(X,Y)).

/* new plans for event +gold(_,_) */

@pcell[atomic]           // atomic: de modo a não lidar com outro evento até que o identificador de ouro seja inicializado
+gold(X,Y)
   :  not carrying_gold & free
   <- -free;
      .print("Percebi ouro em: ",gold(X,Y));
      !init_handle(gold(X,Y)).

/* se eu vejo ouro e não estou livre, mas também não carrego ouro ainda
 * (Provavelmente estou indo em direção a um), abortar o identificador (ouro)
 * e pegar este que está mais perto 
 */
@pcell2[atomic]
+gold(X,Y)
  :  not carrying_gold & not free &
     .desire(handle(gold(OldX,OldY))) &   // I desire to handle another gold which
     pos(AgX,AgY) &
     jia.dist(X,   Y,   AgX,AgY,DNewG) &
     jia.dist(OldX,OldY,AgX,AgY,DOldG) &
     DNewG < DOldG                        // is farther than the one just perceived
  <- .drop_desire(handle(gold(OldX,OldY)));
     .print("Desistindo do ouro atual ",gold(OldX,OldY)," para pegar ",gold(X,Y)," que estou vendo!");
     !init_handle(gold(X,Y)).


/*  Os próximos planos codificam como manusear uma peça de ouro.
  * O primeiro elimina o desejo de estar perto de algum local,
  * o que poderia ser verdade se o agente estivesse apenas se movendo 
  * aleatoriamente em busca de ouro.
  * O segundo simplesmente chama a meta de manusear o ouro.
  * O terceiro plano é o que realmente resulta em lidar com o ouro.
  * Aumenta a meta de ir para a posição X, Y, depois a meta de pegar o ouro,
  * então ir para a posição do depósito, e então largar o ouro e remover
  * a crença de que existe ouro na posição original.
  * Por fim, ele imprime uma mensagem e levanta a meta de escolher outra peça de ouro.
  * Os dois planos restantes lidam com o fracasso.
 */

@pih1[atomic]
+!init_handle(Gold)
  :  .desire(near(_,_))
  <- .print("Abandonando os desejos e intenções para buscar ",Gold);
     .drop_desire(near(_,_));
     !init_handle(Gold).
     
@pih2[atomic]
+!init_handle(Gold)
  :  pos(X,Y)
  <- .print("Indo para ",Gold);
     !!handle(Gold). // deve usar !! para executar "lidar" como não atômico

+!handle(gold(X,Y))
  :  not free
  <- .print("Manuseando ",gold(X,Y));
     !pos(X,Y);
     !ensure(pick,gold(X,Y));
     ?depot(_,DX,DY);
     !pos(DX,DY); // !pos(0,0);
     !ensure(drop, 0);
     .print("Finalizando manuseio ",gold(X,Y));
     ?score(S);
     -+score(S+1);
     .send(leader,tell,dropped);
     !!choose_gold.

// se ensure(pick/drop) falhou, busque outro ouro
-!handle(G) : G
  <- .print("falhou em pegar ouro ",G);
     .abolish(G); // ignore source
     !!choose_gold.
-!handle(G) : true
  <- .print("Falha ao manusear ",G,", nao esta no BB.");
     !!choose_gold.

/* Os próximos planos lidam com a coleta e o descarte de ouro. */

+!ensure(pick,_) : pos(X,Y) & gold(X,Y)
  <- pick;
     ?carrying_gold;
     -gold(X,Y).
// falhe se não houver ouro lá ou não carregar ouro após a colheita!
// handle(G) vai "pegar" essa falha.

+!ensure(drop, _) : carrying_gold & pos(X,Y) & depot(_,X,Y)
  <- drop.
  
/* Os próximos planos codificam como o agente pode escolher a próxima peça de ouro
  * para perseguir (o mais próximo de sua posição atual) ou,
  * se não houver localização de ouro conhecida, faz o agente acreditar que é gratuito.
  */

+!choose_gold
  :  not gold(_,_)
  <- -+free.

/* Terminou um ouro, mas outros sobraram encontre 
 * o ouro mais próximo entre as opções conhecidas
 */ 
+!choose_gold
  :  gold(_,_)
  <- .findall(gold(X,Y),gold(X,Y),LG);
     !calc_gold_distance(LG,LD);
     .length(LD,LLD); LLD > 0;
     .print("Distâncias de ouro: ",LD,LLD);
     .min(LD,d(_,NewG));
     .print("O proximo outro eh ",NewG);
     !!handle(NewG).
-!choose_gold <- -+free.

+!calc_gold_distance([],[]).
+!calc_gold_distance([gold(GX,GY)|R],[d(D,gold(GX,GY))|RD])
  :  pos(IX,IY)
  <- jia.dist(IX,IY,GX,GY,D);
     !calc_gold_distance(R,RD).
+!calc_gold_distance([_|R],RD)
  <- !calc_gold_distance(R,RD).
  
/* Vencedor */
+winning(A,S)[source(leader)] : .my_name(A)
   <-  -winning(A,S);
       .print("Sou o melhor!!!").

+winning(A,S)[source(leader)] : true
   <-  -winning(A,S).

/* fim da simulacao */

+end_of_simulation(S,_) : true
  <- .drop_all_desires;
     .abolish(gold(_,_));
     .abolish(picked(_));
     -+free;
     .print("------ FIM ",S," ------").
