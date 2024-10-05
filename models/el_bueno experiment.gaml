model bueno

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
species persona skills:[moving]{
	int estatura;
	int edad;
	string nombre;
	point ubicacion;
	init {
		//location <- one_of(building).location;
		//location <- building[30].location;
		location <- manzanas[30].location;
	}reflex {
		do wander;
	}
	aspect normal{draw circle(8) color:#navy;
	} 
}

//species building {
	//aspect default{
	//	draw shape;
	//}
species manzanas {
	int pobtot;
	int P_60YMAS;
	aspect default{
		draw shape;
	}
}	

experiment mi_experimento{
	output {
		display mi_visualizacion {
			species manzanas aspect:default;
			species persona aspect:normal;
			
		}
		//display otra_visua {}
	}
}

experiment otro_experimento {
	output{
		
	}
}
experiment batch_experiment type:batch until:cycle>50{
	
}