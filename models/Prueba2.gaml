/**
* Name: Prueba2
* Based on the internal empty template. 
* Author: cecil
* Tags: 
*/


model Prueba2

/* Insert your model definition here */

global{
	//geometry shape <- 
	shape_file Juanacatlan_posiblemente0_shape_file <- shape_file("../includes/juanacatlán/Juanacatlan_posiblemente.shp");
	//square(100#m); 
	geometry shape <- envelope(Juanacatlan_posiblemente0_shape_file);
	init{
		create manzanas from:Juanacatlan_posiblemente0_shape_file with:[
			pobtot::int(read("POBTOT")),
			P_60YMAS::int(read("P_60YMAS"))
		];
	
		create persona number:100; 
	}
}

species manzanas {
	int pobtot;
	int P_60YMAS;
	aspect default{
		draw shape;
	}
}
species building {
	aspect default{
		draw shape;
	}
}
species persona skills:[moving]{
	int estatura;
	int edad;
	string nombre;
	point ubicacion;
	init{
		location <- manzanas[30].location;
	}
	reflex{
		do wander; 
	}
	aspect default{
		draw circle(2) color:#red; 
	}
}
experiment mi_experimento{
	output{
		display mi_visualizacion{
			species manzanas aspect:default;
			species persona aspect:default; 
		}

	}
} 



/* Insert your model definition here */

