shader_type spatial;
render_mode cull_disabled;

//uniform float size_adj = 10;
uniform float bend = 0.01;
uniform vec3 color = vec3(0.171, 0.847, 0.723);

group_uniforms Wind_Options;
uniform sampler2D wind_noise;
uniform float wind_strength = 0.1;
uniform vec2 wind_direction = vec2(1.0, 0.0);

varying float bottom_to_top;
varying float current_wind_bend;

void vertex() {
	bottom_to_top = 1.0 - UV.y;
	
	vec2 wind_position = NODE_POSITION_WORLD.xz / 10.0;
	wind_position -= TIME * wind_direction * wind_strength;
	
	current_wind_bend = texture(wind_noise, wind_position).x;
	current_wind_bend *= wind_strength;
	current_wind_bend *= bottom_to_top * 2.0;
	
	//VERTEX.z += bend * pow(bottom_to_top, 2);
	//VERTEX *= size_adj;
}

void fragment() {
	AO = bottom_to_top;
	AO_LIGHT_AFFECT = 0.3;
	
	ALBEDO = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
