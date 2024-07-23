shader_type canvas_item;

uniform vec4 hurt_color: source_color = vec4(1.0,1.0,1.0,1.0);
uniform bool active = false;


void fragment() {
	// Called for every pixel the material is visible on.
	if (active == true){
		COLOR = hurt_color;
	}
	else{
		COLOR = vec4(0.0);
	}
}

