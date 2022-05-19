// Stars Shader
// Last edited: 17.05.2022
// Copyright © 2022 Divin Gavran
shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded;

// Variables
uniform float point_size : hint_range(0, 128) = 1.5;
uniform vec3 multiplier = vec3(1.0, 1.0, 1.0);
uniform vec4 albedo : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float depth = 1.0;
uniform float alpha = 1.0;
uniform float specular = 0.5;
uniform float metallic = 0.0;
uniform float roughness : hint_range(0, 1) = 1.0;

uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset = vec3(0.0, 0.0, 0.0);
uniform vec3 uv2_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv2_offset = vec3(0.0, 0.0, 0.0);

varying vec3 color;

void vertex() {
	POINT_SIZE = point_size;
	color = INSTANCE_CUSTOM.rgb;
}

void fragment() {
	DEPTH = depth;
	ALPHA = alpha;
	SPECULAR = specular;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	ALBEDO = albedo.rgb + multiplier * color;
}