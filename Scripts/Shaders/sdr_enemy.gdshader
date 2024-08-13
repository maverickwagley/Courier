shader_type canvas_item;

//uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 hurt_color: source_color = vec4(0.6,0.2,0.2,1.0);
uniform float blink_intensity = 0;
uniform bool is_hurt = false;


void fragment() {
	//Get Screen Color
	//vec4 screen_color = texture(screen_texture,SCREEN_UV);
	//Sample Sprite Color
	if (is_hurt == true){
		vec4 sprite_color = texture(TEXTURE,UV);
		sprite_color = mix(sprite_color,hurt_color,blink_intensity * sprite_color.a);
		COLOR = sprite_color;
	}
}

