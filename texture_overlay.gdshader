shader_type canvas_item;

uniform sampler2D overlay_tex: repeat_enable, filter_nearest;
uniform float scale = 0.006944444; // calculated by 1/texture size e.g. 1/144
varying vec2 world_position;

void vertex(){
	// calculate the world position for use in the fragment shader
    world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// only apply overlay_tex on the fully red parts of the original tiles
	// filter white which is (R=1,G=1,B=1) cause it would otherwise also trigger
	// also filter out alpha values for the case that red pixels are next to transparent pixels (cause godot saves the color values in transparent pixel of neighboring color pixels)
	float mix_amount = step(red_threshold, COLOR.r)
	             	* (1.0 - step(non_red_threshold, COLOR.g))
	             	* (1.0 - step(non_red_threshold, COLOR.b))
	             	* step(alpha_threshold, COLOR.a);
	
	// sample the overlay_tex using worldPos
	vec4 overlay_color = texture(overlay_tex, world_position * scale);
	
	// combine original color and overlay color together
	COLOR = mix(COLOR, overlay_color, mix_amount);
}
