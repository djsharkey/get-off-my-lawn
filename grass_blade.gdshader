shader_type spatial;
render_mode cull_disabled;

uniform sampler2D grass_mask : hint_default_black, filter_linear;
uniform vec2 field_origin;
uniform vec2 field_size;

uniform vec4 base_color : source_color = vec4(0.2, 0.5, 0.3, 1.0);
uniform vec4 tip_color : source_color = vec4(0.5, 0.8, 0.1, 1.0);

uniform sampler2D wind_noise;
uniform vec2 wind_direction = vec2(-1.0, 0.3);
uniform float wind_scroll_speed = 0.55;
uniform float wind_noise_scale = 0.05;
uniform float wind_noise_strength = 0.15;

uniform float wind_speed = 2.0;
uniform float wind_strength = 0.15;
uniform float flutter_strength = 0.03;

void vertex() {
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float height_weight = pow(1.0 - UV.y, 3.0);

	vec2 noise_uv = world_pos.xz * wind_noise_scale + wind_direction * TIME * wind_scroll_speed;
	float gust = texture(wind_noise, noise_uv).r * 2.0 - 1.0;  // this turns 0 to 1 into -1 to 1
	float flutter = sin(world_pos.x * 2.0 + TIME * wind_speed * 3.0) * flutter_strength;

	float sway = gust * wind_noise_strength + flutter;
	vec3 world_offset = vec3(wind_direction.x, 0.0, wind_direction.y) * sway * height_weight;
	vec3 local_offset = (inverse(MODEL_MATRIX) * vec4(world_offset, 0.0)).xyz;

	vec2 mask_uv = (world_pos.xz - field_origin) / field_size;
	float mowed = texture(grass_mask, mask_uv).r;

	VERTEX.y *= mix(1.0, 0.05, mowed);
	VERTEX += local_offset * (1.0 - mowed);

}

void fragment() {
	ALBEDO = mix(base_color.rgb, tip_color.rgb, 1.0 - UV.y);
}