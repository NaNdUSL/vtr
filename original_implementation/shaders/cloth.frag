#version 430

layout(std430, binding = 5) buffer textureBuffer {
	vec2 text_coords[]; // 1D array of normals
};

layout(std430, binding = 4) buffer normalsBuffer {
	vec4 normals[]; // 1D array of normals
};

//uniform
// uniform vec4 diffuse;
uniform vec4 l_dir; // world space
uniform mat4 m_view;
uniform sampler2D tex;
uniform vec4 diffuse;
uniform mat3 m_normal;

// // input
in flat int vert_index;

// output
out vec4 color;

void main() {

	// compute light direction in camera space
	vec3 l = normalize(vec3(m_view * -l_dir));
	normals[vert_index] = vec4(0.0, 1.0, 0.0, 0.0);
	vec3 nn = normalize(m_normal * normalize(normals[vert_index]).xyz);
	float i = max(0.0, dot(l,nn));
	normals[vert_index] = vec4(0.0);

	color = max(0.25, i) * diffuse /** texture(tex, fract(text_coords[vert_index]))*/;
}