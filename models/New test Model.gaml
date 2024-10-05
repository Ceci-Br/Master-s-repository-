/**
* Name: NewtestModel
* Based on the internal empty template. 
* Author: cecil
* Tags: 
*/


model NewtestModel

global{
	
	//shape_file mi_archivo <- shape_file("../includes/nha2.shp"); // arrastrar el objeto
	
	//shape_file manzanasv20_shape_file <- shape_file("../includes/inegi/manzanasv2.shp");
	
	shape_file Juanacatlan_posiblemente0_shape_file <- shape_file("../includes/juanacatlán/Juanacatlan_posiblemente.shp");


	//geometry shape <- envelope(mi_archivo);//square(1000#m); 
	//geometry shape <- envelope(manzanasv20_shape_file);//square(1000#m); 
	geometry shape <- envelope(Juanacatlan_posiblemente0_shape_file);//square(1000#m);
	//file mi_archivo <- shp_file("");
	init{
		create block from:Juanacatlan_posiblemente0_shape_file  with:[
			pobtot::int(read("POBTOT")),
			p_60ymas::int(read("P_60YMAS"))
		]; //corchete significa lista de cosas
		//create building from:mi_archivo; 
		create persona number:100; 
		
	}
	reflex principal{
		ask block{
			densidad <- pobtot/shape.area#m2;
		}
		list<float> mi_lista;
		//list<block>otra_lista;
		//list<persona> lista_persona <- one_of(persona);
		mi_lista <- block collect(each.densidad);
		float max_dens_value <- max(mi_lista); 
		write mi_lista;
		write max_dens_value; 
		ask block{
			densidad <- (densidad/max_dens_value)*100;
		}
		mi_lista <- block collect(each.densidad);
		write mi_lista; 
	}
}


species block {
	int pobtot;
	int p_60ymas;
	float densidad;
	rgb mi_color;
	aspect default{
		if(densidad<0.25){//valor densidad bajo
			mi_color <- #darkgreen;
		}
		else if(densidad<0.50){
			mi_color <- #mediumspringgreen;
		}
		else if(densidad<0.75){
			mi_color <- #gamaorange;
		}
		else{
			mi_color <- #red;
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
	float estatura;
	int edad;
	string nombre;
	point ubicacion; 
	init{
		//location <- one_of(building).location;
		//location <- building[30].location;
		location <- block[30].location;
		estatura <- 1.70#m; 
	}
	reflex{
		do wander; 
	}
	aspect default{
		draw circle(5) color:#red; 
	}
}


	
experiment mi_experimento{
	output{
		display mi_visualizacion{
			species block aspect:default; 
			//species building aspect:default;
			species persona aspect:default;
			 
		}
		//display otro {
			
		}
	}

experiment otro{
	output{
		
	}
}


/* Insert your model definition here */

