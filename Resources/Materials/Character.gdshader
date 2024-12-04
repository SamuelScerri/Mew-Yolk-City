shader_type spatial;

global uniform float physics_interpolation;
instance uniform vec3 current_position;
instance uniform float current_rotation;
instance uniform vec3 color;

render_mode world_vertex_coords;

vec2 rotate2D(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(vec2(c,-s),vec2(s,c));
	return m * v;
}

void vertex() {
	//VERTEX.xz = rotate2D(VERTEX.xz, mix(-current_rotation, 0, physics_interpolation));
	VERTEX = mix(VERTEX - current_position, VERTEX, physics_interpolation);
}

void fragment() {
	ALBEDO = color;
}
