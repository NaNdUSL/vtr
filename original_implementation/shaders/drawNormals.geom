#version 430
// #pragma optionNV unroll all

layout(triangles) in;
layout (line_strip, max_vertices=6) out;

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

layout(std430, binding = 4) buffer normalsBuffer {
	vec4 normals[]; // 1D array of normals
};

uniform mat4 m_pvm;
uniform mat3 m_normal;

in int v_index[3];

void main() {

    gl_Position = m_pvm * pos[v_index[0]];
    EmitVertex();

    gl_Position = (m_pvm * (pos[v_index[0]] + (normalize(normals[v_index[0]]) * 0.03)));
    EmitVertex();
    EndPrimitive();

    gl_Position = m_pvm * pos[v_index[1]];
    EmitVertex();

    gl_Position = (m_pvm * (pos[v_index[1]] + (normalize(normals[v_index[1]]) * 0.03)));
    EmitVertex();
    EndPrimitive();

    gl_Position = m_pvm * pos[v_index[2]];
    EmitVertex();

    gl_Position = (m_pvm * (pos[v_index[2]] + (normalize(normals[v_index[2]]) * 0.03)));
    EmitVertex();
    EndPrimitive();
}