shader_type spatial;
render_mode cull_disabled;

//uniform float size_adj = 10;
uniform float bend = 0.01;
uniform vec3 color = vec3(0.171, 0.847, 0.723);

group_uniforms Object_Displacement;
uniform float object_radius = 1.0;
uniform vec3 object_position;

group_uniforms Wind_Options;
uniform sampler2D wind_noise;
uniform float wind_strength = 0.1;
uniform vec2 wind_direction = vec2(1.0, 0.0);
uniform float wind_ao_affect = 1.5;

varying float cut_height;
varying float bottom_to_top;
varying float current_wind_bend;

void vertex() {
	cut_height = 1.0;
	VERTEX.y = min(VERTEX.y, cut_height);
	UV.y = max(UV.y, 1.0 - cut_height);
	
	bottom_to_top = 1.0 - UV.y;
	
	vec2 wind_position = NODE_POSITION_WORLD.xz / 10.0;
	wind_position -= TIME * wind_direction * wind_strength;
	
	current_wind_bend = texture(wind_noise, wind_position).x;
	current_wind_bend *= wind_strength;
	current_wind_bend *= bottom_to_top * 2.0;
	
	mat4 inv_model = inverse(MODEL_MATRIX);
	vec2 local_direction = (inv_model * vec4(wind_direction.x, 0.0, wind_direction.y, 0.0)).xz;
	
	VERTEX.xz += current_wind_bend * local_direction;
	
	float object_distance = distance(object_position, NODE_POSITION_WORLD);
	float bend_away_strength = max(object_radius - object_distance, 0.0) / object_radius;
	vec2 bend_direction = normalize(object_position.xz - NODE_POSITION_WORLD.xz);
	
	VERTEX.xz -= (inv_model * vec4(bend_direction.x, 0.0, bend_direction.y, 0.0)).xz * bend_away_strength * bottom_to_top;
	VERTEX.y -= bend_away_strength * bottom_to_top * 0.5;
	
	//VERTEX.z += bend * pow(bottom_to_top, 2);
	//VERTEX *= size_adj;
}

void fragment() {
	AO = bottom_to_top - current_wind_bend * wind_ao_affect;
	AO_LIGHT_AFFECT = cut_height;
	
	ALBEDO = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
