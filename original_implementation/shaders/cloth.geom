#version 430
// #pragma optionNV unroll all

layout(triangles) in;
layout (triangle_strip, max_vertices=3) out;

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

out flat int vert_index;

in int v_index[3];

void main() {

	vec4 edge1 = pos[v_index[1]] - pos[v_index[0]];
	vec4 edge2 = pos[v_index[2]] - pos[v_index[0]];
	vec4 normal = vec4(normalize(cross(edge1.xyz, edge2.xyz)), 0.0);

	// for (int i = 0; i < 9; i++) {

	// 	if (adjacents[(v_index[0] * 9) + i] > 0) {

	// 		acc_normals_1 += normals[i];
	// 	}

	// 	if (adjacents[(v_index[1] * 9) + i] > 0) {

	// 		acc_normals_2 += normals[i];
	// 	}

	// 	if (adjacents[(v_index[2] * 9) + i] > 0) {

	// 		acc_normals_3 += normals[i];
	// 	}
	// }

	normals[v_index[0]] = normalize(normals[v_index[0]] + normal);
	vert_index = v_index[0];

	gl_Position = m_pvm * pos[v_index[0]];
	EmitVertex();

	normals[v_index[1]] = normalize(normals[v_index[1]] + normal);
	vert_index = v_index[1];

	gl_Position = m_pvm * pos[v_index[1]];
	EmitVertex();

	normals[v_index[2]] = normalize(normals[v_index[2]] + normal);
	vert_index = v_index[2];

	gl_Position = m_pvm * pos[v_index[2]];
	EmitVertex();
	EndPrimitive();

	// n = -normals[v_index[1]];
	// vert_index = v_index[1];

	// gl_Position = m_pvm * pos[v_index[1]];
	// EmitVertex();

	// n = -normalize(m_normal * normalize(acc_normals_1));
	// vert_index = v_index[0];

	// gl_Position = m_pvm * pos[v_index[0]];
	// EmitVertex();

	// n = -normalize(m_normal * normalize(acc_normals_3));
	// vert_index = v_index[2];

	// gl_Position = m_pvm * pos[v_index[2]];
	// EmitVertex();
	// EndPrimitive();
}