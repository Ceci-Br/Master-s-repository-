/**
* Name: Prueba1
* Based on the internal empty template. 
* Author: cecil
* Tags: 
*/


model Prueba1

/* Insert your model definition here */

global{
	geometry shape <- square(1000#m);
	init{
		create persona number:50;
		create animal number:30;
		}
}

species persona skills:[moving]{
	int estatura;
	int edad;
	string nombre;
	reflex{
		do wander;
	}
	aspect default{
		draw circle(10) color:#red;
	}
}
species animal skills:[moving]{
	int estatura;
	int parent;
	string nombre; 
	reflex{
		do wander;
	}
	aspect default{
		draw triangle(15) color:#blue;
	}
}

experiment PruebaVarios type:batch until:cycle>50{
	output{
		//save persona file:"personas.shp" type:"shp";
	}
}
	
		
	

experiment mi_experimento{
	output{
		display mi_visualizacion{
			species persona aspect:default; 
		}
		display otro {
			
		}
	}
} 
experiment otro{
	output{
		display mi_vision{
			species animal aspect:default;
		}
	}
}

experiment tres{
	output{
		display visual{
			species persona aspect:default;
			species animal aspect:default;
		}
	}
}

