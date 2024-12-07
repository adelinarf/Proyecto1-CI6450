# Proyecto - CI6450




# Entregas anteriores

## Primera entrega

1. Descargar Godot 4
2. Abrir Godot e importar el proyecto desde la carpeta en la que se encuentra alojado. 

Al dar click en play se abrirá un menú que permite moverse entre las diferentes escenas que contienen la implementación de los algoritmos de movimiento.

## Segunda entrega


Por default, los personajes están coloreados con un color asociado al estado en el que se encuentran actualmente, para ver el color original de los sprites, tocar la barra de espacio.

Al presionar la tecla s se pueden diferenciar los personajes con un color asociado a la máquina de estados o árbol de decisión que están utilizando.

Para conocer los colores asociados a los estados y los colores de cada máquina o árbol de decisión, presionar la tecla l para visualizar la leyenda de los colores.

Es posible activar y desactivar el grafo visual (nodos y aristas) con ayuda de la tecla enter.

#### La segunda entrega se encuentra en la escena path_finding_visibility_graph.tscn, para correr la implementación se debe correr esta escena

### Máquinas de estado y árboles de decisión

## Estados

<img src="images/segunda_entrega/states.png" alt="states"/>

## Decisión 1

<img src="images/segunda_entrega/decision1.png" alt="decision1"/>

## Decisión 2

<img src="images/segunda_entrega/decision2.png" alt="decision2"/>

## Decisión 3

<img src="images/segunda_entrega/decision3.png" alt="decision3"/>

## Decisión 4

<img src="images/segunda_entrega/decision4.png" alt="decision4"/>

## Decisión 5

<img src="images/segunda_entrega/decision5.png" alt="decision5"/>

## Decisión 6

<img src="images/segunda_entrega/decision6.png" alt="decision6"/>

## Decisión 7

<img src="images/segunda_entrega/decision7.png" alt="decision7"/>

## Decisión 8

<img src="images/segunda_entrega/decision8.png" alt="decision8"/>

## Decisión 9

<img src="images/segunda_entrega/decision9.png" alt="decision9"/>


## Tercera Entrega

En la tercera entrega se considera la salud de los enemigos. La salud de los enemigos disminuye al acercarse al jugador y al acercarse a diversos puntos tácticos. Se agregaron los siguientes puntos tácticos:

	Puntos de cover en los que se recarga la salud del enemigo 

	Puntos visuales en los que se detiene el enemigo

	Puntos de sniper en los que se detiene el enemigo para lanzar proyectiles

#### Los puntos tácticos están marcados con varios sprites que pueden verse en la leyenda.

También existen puntos de terreno táctico:

	Zona en rojo disminuye la salud del enemigo, si este se encuentra en la zona

<img src="images/red_zone.png" alt="red"/>

	Zona de barriles aumenta la salud del enemigo, si este se encuentra en la zona

<img src="images/barrel.png" alt="barrel"/>

	Zona de madera que es difícil de recorrer para los enemigos

<img src="images/wood.png" alt="wood"/>

Para esta entrega se agregaron diversas funcionalidades con los siguientes botones:

	ENTER: Activa y desactiva los nodos y los arcos del grafo 

	X : Activa y desactiva todas las líneas existentes hasta el momento

	ESPACIO : Elimina los colores del sprite del enemigo

	L : Muestra la leyenda con los colores asociados a las decisiones, los estados y los puntos tácticos

	S : Diferencia los personajes segun la leyenda por la máquina de estado utilizada por cada uno

	D : Activa o desactiva la capacidad de morir, si está activada el jugador muere si su salud es menor 
 	a 0, sino sigue el juego.

	1,2,3,4,5 - Muestra solo el personaje asociado a cada número (según la máquina de estado que usa) 
	y las líneas de su pathfinding (El personaje 5 solo hace pathfinding)

	0 : Muestra todos los personajes

	W : Hace visibles/invisibles los sprites de los nodos tácticos

Las líneas que se generan para el pathfinding de los enemigos son del mismo color que el color asociado al enemigo
según su máquina de estado, solo el enemigo 5 hace únicamente pathfinding y no está asociado a ninguna máquina de estado. El color más claro indica el camino generado por A* y el color más oscuro indica el camino generado por el A* táctico. Como se indica en la siguiente figura:

<img src="images/lineas.png" alt="lineas"/>

### Máquinas de estado

## Estados de las máquinas de estado

<img src="images/states.png" alt="states"/>

## Máquina 1

<img src="images/decision1.png" alt="maquina 1"/>

## Máquina 2

<img src="images/decision2.png" alt="maquina 2"/>

## Máquina 3

<img src="images/decision3.png" alt="maquina 3"/>

## Máquina 4

<img src="images/decision4.png" alt="maquina 4"/>

### Corrida
Para la corrida de la entrega 3 se creó un menú principal que puede accederse al correr el proyecto en Godot o dar click en F5, este menú permite iniciar una nueva partida del juego.

