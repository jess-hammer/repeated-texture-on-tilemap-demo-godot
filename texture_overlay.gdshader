shader_type canvas_item;

uniform sampler2D overlayTex: repeat_enable, filter_nearest;
uniform float scale = 0.006944444; // calculated by 1/texture size e.g. 1/144
varying vec2 world_position;

void vertex(){
    world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float mix_amount = floor(COLOR.r);
	COLOR = mix(COLOR, texture(overlayTex, world_position * scale), mix_amount);
}