# A Multiagent system of Gold Miners Game

O objetivo do trabalho é implementar soluções baseadas em grupos de agentes no contexto do jogo Gold Miners inicialmente proposto em [Multiagent Contest, 2006](https://multiagentcontest.org/2006/).
Detalhes: A partir do código disponível em [Tutorial Jacamo Gold Miners](http://jacamo.sourceforge.net/tutorial/gold-miners/)

## Introdução

O trabalho foi desenvolvido na disciplina de Sistemas Multiagentes da UFSC.

O objetivo do trabalho foi implementar soluções baseadas nos recursos de Jason, JaCaMo e com utilização de organização de Moise no contexto de um Jogo do tipo Minerador de Ouro (Gold miners).
Wooldridge e Jennings (1997) em sua definição de agentes, listam as seguintes características: reatividade é perceber o ambiente e responder de maneira oportuna (timely fashion) a mudanças que acontecem nele; autonomia é a capacidade de operar sem intervenção direta de humanos ou outros e ter alguma espécie de controle sobre suas ações e estado interno; habilidade social é a capacidade de interagir com outros agentes via algum tipo de linguagem de comunicação de agentes; pró-atividade é a capacidade de exibir comportamentos baseados em objetivos.

O SMA foi programado em uma versão estendida da linguagem AgentSpeak(L), por meio do interpretador Jason é baseado em sistemas de crenças, desejos e intenções (BDI - Beliefs, Desires and Intentions); CArtAgO é um framework e infraestrutura para programação e execução de ambientes baseados em artefato e Moise é um modelo organizacional para sistemas multiagentes baseado em noções como funções, grupos e missões. Ele permite que um MAS tenha uma especificação explícita de sua organização. 

Segundo Boissier et al. (2011), a plataforma JaCaMo decorre de várias propostas, pois permite o desenvolvimento de sistemas multiagentes que além de envolvem muitas entidades autônomas, elas também interagem de formas complexas por meio de estruturas sociais de coordenação e normas que regulam o comportamento social geral em um ambiente compartilhado. JaCaMo é uma plataforma que integra as três dimensões fundamentais da programação de sistema multiagente: dimensão de agente; dimensão de ambiente; e dimensão de organização, realizando assim o modelo AEO (Agent, Environment, Organization. 

Nessa direção a importância da combinação das três dimensões trazem muitos benefícios (BOISSIER et al., 2011):
- a base de ações dos agentes é dinâmica porque depende dos artefatos disponíveis;
- as ações ganham uma semântica baseada em processos, o que permite definir ações de longo prazo, bem como coordenar ações;
- uma noção explícita e bem definida de sucesso/falha para as ações é fornecida;
- a interação entre os agentes e as organizações é obtida uniformemente usando os mesmos mecanismos que permitem a interação agente-artefato;
- as organizações podem ser remodeladas dinamicamente agindo nos artefatos ;
- a delegação de objetivos organizacionais aos agentes é facilitada;

## O Ambiente

O ambiente é um mundo é a uma grade (Figura 1), tem vários mapas disponíveis para utilizar, podendo ser criado outros, onde os agentes podem se mover de uma célula para outra célula vizinha, caso ela não contenha nenhum agente ou um obstáculo. 
Os agentes, operando como uma equipe, devem explorar o ambiente, evitar obstáculos e coletar o máximo de ouro possível para ser levado a um depósito. Cada agente pode carregar um ouro por vez (um agente que não carrega ouro é livre). 
Os agentes têm apenas uma visão local de seu ambiente porque eles só podem ver peças de ouro nas células adjacentes; mas, eles podem se comunicar com os outros agentes para compartilhar suas descobertas.
A equipe é composta por duas funções desempenhadas por cinco agentes. A função de minerador é desempenhada por quatro agentes que terão como objetivo encontrar ouro e transportá-lo para o depósito.
A equipe também tem um agente desempenhando o papel de líder; seus objetivos são alocar quadrantes de agentes e alocar agentes livres para uma peça de ouro que foi encontrada.
O agente líder ajuda a equipe, mas cada equipe deve ter exatamente quatro agentes mineradores que se conectam ao servidor de simulação como competidores oficiais, para que o líder não seja registrado no servidor.

## Para rodar o projeto no eclipse (Rodar como Jacamo project)
Para rodar no eclipse o projeto requer algumas bibliotecas (classpath) que estão na pasta /lib do projeto, precisa ser incluído (Configure Build Path >> Classpath >> Add External JARs >>)
- bin/cartago-2-5.jar
- gradle/wrapper/gradle-wrapper.jar
- /bin/jason-2.5.1.jar
- /bin/search.jar
- /bin/twitter4j-async-4.0.2.jar
- /bin/twitter4j-core-4.0.2.jar
- /bin/twitter4j-media-support-4.0.2.jar
- /bin/twitter4j-stream-4.0.2.jar

Mais detalhes no relatório.  
