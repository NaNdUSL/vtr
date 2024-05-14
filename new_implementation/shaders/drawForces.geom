#version 430
// #pragma optionNV unroll all

layout(triangles) in;
layout (line_strip, max_vertices=6) out;

uniform mat4 m_pvm;
// uniform float timer;

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

layout(std430, binding = 3) buffer infoBuffer {
	float info[]; // 1D array of info
};

layout(std430, binding = 6) buffer forcesBuffer {
	vec4 forces[]; // 1D array of forces
};

out vec4 colour;

in int v_index[3];

void main() {

	int height = int(info[0]);
	int width = int(info[1]);

	colour = vec4(0.0, 1.0, 0.0, 1.0);

	gl_Position = m_pvm * pos[v_index[0]];
	EmitVertex();
	gl_Position = m_pvm * (pos[v_index[0]] + vec4(forces[v_index[0]].xyz, 0.0) * 0.5);
	EmitVertex();
	EndPrimitive();

	gl_Position = m_pvm * pos[v_index[1]];
	EmitVertex();
	gl_Position = m_pvm * (pos[v_index[1]] + vec4(forces[v_index[1]].xyz, 0.0) * 0.5);
	EmitVertex();
	EndPrimitive();

	gl_Position = m_pvm * pos[v_index[2]];
	EmitVertex();
	gl_Position = m_pvm * (pos[v_index[2]] + vec4(forces[v_index[2]].xyz, 0.0) * 0.5);
	EmitVertex();
	EndPrimitive();
}