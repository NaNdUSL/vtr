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

layout(std430, binding = 3) buffer stuckVertBuffer {
	float info[]; // 1D array of info
};

layout(std430, binding = 4) buffer normalsBuffer {
	vec3 normals[]; // 1D array of normals
};

layout(std430, binding = 5) buffer textureBuffer {
	vec2 text_coords[]; // 1D array of normals
};

layout(std430, binding = 6) buffer forcesBuffer {
	vec4 forces[]; // 1D array of forces
};

layout(std430, binding = 7) buffer velocitiesBuffer {
	vec4 vel[]; // 1D array of forces
};

uniform int width;
uniform int height;

out vec3 n;
out flat int vert_index;

in int v_index[3];

// looks weird (idk about air resistance)

// vec3 aerodynamic_force(vec3 v, vec3 v_air, float p, float c_d, vec3 normal, vec3 edge1, vec3 edge2) {

// 	vec3 v_surface = vel[v_index[0]].xyz + vel[v_index[1]].xyz + vel[v_index[2]].xyz;
// 	vec3 v = v_surface - v_air;
// 	a_0 = abs(0.5 * cross(edge1, edge2));
// 	a = a_0*(dot(v, normal)/length(v));

// 	return - 0.5 * p * abs(v*v) * c_d * a * normal;
// }

void main() {

	vec3 edge1 = gl_in[1].gl_Position.xyz - gl_in[0].gl_Position.xyz;
	vec3 edge2 = gl_in[2].gl_Position.xyz - gl_in[0].gl_Position.xyz;
	vec3 normal = normalize(cross(edge1, edge2));

	vec3 acc_normals_1 = vec3(0.0);
	vec3 acc_normals_2 = vec3(0.0);
	vec3 acc_normals_3 = vec3(0.0);

	for (int i = 0; i < 9; i++) {

		if (adjacents[(v_index[0] * 9) + i] > 0) {

			acc_normals_1 += normals[i];
		}
	}

	acc_normals_1 += normal;
	normals[v_index[0]] = normalize(acc_normals_1);

	n = normalize(m_normal * normalize(acc_normals_1));
	vert_index = v_index[0];

	gl_Position = m_pvm * gl_in[0].gl_Position;
	EmitVertex();

	for (int i = 0; i < 9; i++) {

		if (adjacents[(v_index[1] * 9) + i] > 0) {

			acc_normals_2 += normals[i];
		}
	}

	acc_normals_2 += normal;
	normals[v_index[1]] = normalize(acc_normals_2);

	n = normalize(m_normal * normalize(acc_normals_2));
	vert_index = v_index[1];

	gl_Position = m_pvm * gl_in[1].gl_Position;
	EmitVertex();

	for (int i = 0; i < 9; i++) {

		if (adjacents[(v_index[2] * 9) + i] > 0) {

			acc_normals_3 += normals[i];
		}
	}

	acc_normals_3 += normal;
	normals[v_index[2]] = normalize(acc_normals_3);

	n = normalize(m_normal * normalize(acc_normals_3));
	vert_index = v_index[2];

	gl_Position = m_pvm * gl_in[2].gl_Position;
	EmitVertex();
	EndPrimitive();

	n = normalize(m_normal * normalize(-acc_normals_1));
	vert_index = v_index[0];

	gl_Position = m_pvm * gl_in[1].gl_Position;
	EmitVertex();

	n = normalize(m_normal * normalize(-acc_normals_2));
	vert_index = v_index[1];

	gl_Position = m_pvm * gl_in[0].gl_Position;
	EmitVertex();

	n = normalize(m_normal * normalize(-acc_normals_3));
	vert_index = v_index[2];

	gl_Position = m_pvm * gl_in[2].gl_Position;
	EmitVertex();
	EndPrimitive();
}