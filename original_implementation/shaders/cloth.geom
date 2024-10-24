#version 430
// #pragma optionNV unroll all

layout(triangles) in;
layout (triangle_strip, max_vertices=6) out;

uniform mat4 m_pvm;
uniform mat3 m_normal;
// uniform float timer;

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

layout(std430, binding = 2) buffer adjBuffer {
	float adjacents[]; // 2D array of adjacents
};

layout(std430, binding = 4) buffer normalsBuffer {
	vec4 normals[]; // 1D array of normals
};

uniform int width;
uniform int height;

out vec3 n;

in vec3 normal[3];
in int v_index[3];

void main() {

	vec4 edge1 = pos[v_index[1]] - pos[v_index[0]];
	vec4 edge2 = pos[v_index[2]] - pos[v_index[0]];
	vec4 norm = vec4(normalize(cross(edge1.xyz, edge2.xyz)), 0.0);

	normals[v_index[0]] += norm;
	normals[v_index[1]] += norm;
	normals[v_index[2]] += norm;

	n = normalize(normal[0]);
	gl_Position = m_pvm * pos[v_index[0]];
	EmitVertex();

	n = normalize(normal[1]);
	gl_Position = m_pvm * pos[v_index[1]];
	EmitVertex();

	n = normalize(normal[2]);
	gl_Position = m_pvm * pos[v_index[2]];
	EmitVertex();
	EndPrimitive();

	n = -normalize(normal[0]);
	gl_Position = m_pvm * pos[v_index[0]];
	EmitVertex();

	n = -normalize(normal[2]);
	gl_Position = m_pvm * pos[v_index[2]];
	EmitVertex();

	n = -normalize(normal[1]);
	gl_Position = m_pvm * pos[v_index[1]];
	EmitVertex();
	EndPrimitive();
}