/**
* Name: NewtestModel
* Based on the internal empty template. 
* Author: cecil
* Tags: 
*/


model NewtestModel

global{
	

	shape_file Ajijic0_shape_file <- shape_file("../includes/inegi/Ajijic.shp");
	shape_file frente_shape_ajijic0_shape_file <- shape_file("../includes/inegi/frente_shape_ajijic.shp");
	shape_file roads_shp <- shape_file("../includes/inegi/roads.shp");
	shape_file corteOSM_shp <- shape_file("../includes/inegi/corte_OSM.shp");


	geometry shape <- envelope(Ajijic0_shape_file);//square(1000#m);
	//file mi_archivo <- shp_file("");
	graph roads_network;
	field traffic <- field(100,100);
	map<string,int> map_recubrimiento<-[
		"Empedrado o adoquín"::100,
		"Pavimento o concreto"::60,
		"sin recubrimiento"::30,
		"Conjunto habitacional"::0,
		"No aplica"::0,
		"No especificado"::0
	];
	
	init{
		create road from:roads_shp;
		roads_network <- as_edge_graph(road,100);
		create manzana from:Ajijic0_shape_file  with:[
			pobtot::int(read("POBTOT")),
			viviendas_hab::int(read("TVIPAHAB")),
			calles_pav::int(read("RECUCALL_C")),
			banquetas::int(read("BANQUETA_C")),
			alumb_pub::int(read("ALUMPUB_C")),
			pob_14::int(read("POB0_14")),
			pob15_29::int(read("P15A29A")),
			pob30_59::int(read("P30A59A")),
			pob60_mas::int(read("P_60YMAS")),
			pob_discap::int(read("P_CD_T"))
		]; //corchete significa lista de cosas
		//create building from:mi_archivo; 
		create persona number:100; 
		create block_fronts from:frente_shape_ajijic0_shape_file with:[
			recubrimiento::read("RECUCALL_D")
		];
		
	}
	
	reflex principal{
		ask manzana{
			densidad <- pob_discap/shape.area#m2;
			//densidad <- pobtot/shape.area#m2;
		}
		list<float> mi_lista;
		//list<manzana>otra_lista;
		//list<persona> lista_persona <- one_of(persona);
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
	reflex update_heatmap{
		ask persona{
			traffic[location] <- traffic[location] + 10;
		}
	}
}


species manzana {
	int pobtot;
	int viviendas_hab; 
	int calles_pav;
	int banquetas;
	int alumb_pub;
	int pob_14;
	int pob15_29;
	int pob30_59;
	int pob60_mas;
	int pob_discap;
	float densidad;
	rgb mi_color;
	int transparencia <-80;
	
	aspect default{
		if(densidad<25){//valor densidad bajo
			mi_color <- #darkgreen;
		}
		else if(densidad<50){
			mi_color <- #mediumspringgreen;
		}
		else if(densidad<75){
			mi_color <- #chocolate;
		}
		else{
			mi_color <- #crimson;
		}
		draw shape color:mi_color;
		//rojointenso,rojo,amarillo,verde
	}
}

/*species building {
	aspect default{
		draw shape;
	}
}*/
	
species persona skills:[moving]{
	point home;
	point destiny;
	float estatura;
	int edad;
	string nombre;
	point ubicacion; 
	init{
		home <-any_location_in(one_of(manzana));
		destiny <-any_location_in(one_of(manzana));
		location <-home;
		estatura <- 1.70#m; 
	}
	reflex movement{
		//do wander;
		do goto target:destiny on:roads_network;
		if(location=destiny){
			destiny <-home;
		} 
	}
	aspect default{
		draw circle(15) color:#red; 
	}
}

species block_fronts{
	rgb mi_color;
	string recubrimiento;
	aspect default{
		int valor_numerico <- map_recubrimiento [recubrimiento];
		if (valor_numerico=100){
			mi_color <- #limegreen;
		}
		else if(valor_numerico=60){
			mi_color <- #gamaorange;
		}
		else if(valor_numerico=30){
			mi_color <- rgb (249,249,0,255);
		}
		else{
			mi_color <- #red;
		}
		draw shape color:mi_color width:5.0;
	}
}

species road{
	aspect default{
		draw shape color:#white;
	}
}
	
experiment mi_experimento{
	output{
		display mi_visualizacion background:#black{
			mesh traffic color:palette([#black, #black, #orange, #orange, #red, #red, #red]) smooth:2;
			species road aspect:default;
			//species manzana aspect:default; 
			//species block_fronts aspect:default;
			species persona aspect:default;
			
			 
		 }
		/*display su_visualizacion {
			
		}
	}*/
}


/* Insert your model definition here */
}
