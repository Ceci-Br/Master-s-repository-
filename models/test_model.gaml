/**
* Name: testmodel
* Based on the internal empty template. 
* Author: Gamaliel Palomo
* Tags: test, demo
*/


model testmodel

global{ 
	
	shape_file mi_archivo <- shape_file("../includes/inegi/manzanas_v2.shp");
	shape_file frentes_manzana_clip <- shape_file("../includes/inegi/frentes_manzana_clip.shp");

	geometry shape <- envelope(mi_archivo);//square(1000#m);
	//shape_file nha20_shape_file <- shape_file("../includes/nha2.shp");
	
	map<string,int> map_recubrimiento<-[
		"Empedrado o adoquín"::100,
		"Pavimento o concreto"::60,
		"Sin recubrimiento"::30,
		"Conjunto habitacional"::0,
		"No aplica"::0,
		"No especificado"::0
	];
	
	init{
		//P_60YMAS
		
		create manzana from:mi_archivo with:[
			pobtot::int(  read("POBTOT")  ),
			pob60ymas::int( read("P_60YMAS"))
		];
		create persona number:100;
		create block_fronts from:frentes_manzana_clip with:[
			recubrimiento::read("RECUCALL_D")
		];
	}
	
	reflex principal{
		ask manzana{
			densidad <- pobtot/shape.area#m2;
		}
		list<float> mi_lista;
		//list<manzana> otra_lista;
		//list<persona> lista_personas <- one_of(persona);
		mi_lista <- manzana collect(each.densidad);
		float max_dens_value <- max(mi_lista);
		write mi_lista;
		write max_dens_value;
		ask manzana{
			densidad <- (densidad/max_dens_value)*100;
		}
		mi_lista <- manzana collect(each.densidad);
		write mi_lista;
	}
}
species persona skills:[moving]{
	float estatura;
	int edad;
	string nombre;
	point ubicacion;
	init{
		location <- one_of(manzana).location;
		estatura <- 1.70#cm;
		//location <- building[30].location;
	}
	reflex{
		do wander;
	}
	aspect default{
		draw circle(5) color:rgb (68, 196, 167, 255);
	}
}

species manzana{
	int pobtot;
	int pob60ymas;
	float densidad;
	rgb mi_color;
	int transparencia <- 80;
	
	aspect default{
		if(densidad<25){//Valor de densidad bajo
			mi_color <- rgb (66, 174, 30, transparencia);
		}
		else if(densidad<50){
			mi_color <- rgb (234, 196, 43, transparencia);
		}
		else if(densidad<75){
			mi_color <- rgb (230, 74, 47, transparencia);
		}
		else{
			mi_color <- rgb (140, 4, 4, transparencia);
		}
		draw shape color:mi_color;
		//rojointenso,rojo,amarillo,verde
	}
}

species block_fronts{
	rgb mi_color;
	string recubrimiento;
	aspect default{
		int valor_numerico <- map_recubrimiento[recubrimiento];
		if(valor_numerico=100){
			mi_color <- #limegreen;
		}
		else if(valor_numerico=60){
			mi_color <- #gamaorange;
		}
		else if(valor_numerico=30){
			mi_color <- rgb (249, 249, 0, 255);
		}
		else{
			mi_color <- #red;
		}	
		draw shape color:mi_color width:5.0;
	}
}

experiment mi_experimento{
	output{
		display mi_visualizacion background:#black{
			species manzana aspect:default;
			species block_fronts aspect:default;
			species persona aspect:default;
		}
		
		/*display otra_visualizacion{
			
		}*/
	}
}
experiment otro_experimento{
	output{
		
	}
}

experiment batch_experiment type:batch until:cycle>50{
	output{
		//save persona file:"personas.shp" type:"shp";
	}
}

/* Insert your model definition here */

