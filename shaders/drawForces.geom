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

out vec4 colour;

in int v_index[3];
in vec3 sum_force[3];

void main() {

    int height = int(info[0]);
    int width = int(info[1]);

    colour = vec4(0.0, 1.0, 0.0, 1.0);
    gl_Position = m_pvm * pos[v_index[0]];
    EmitVertex();
    gl_Position = m_pvm * (pos[v_index[0]] + vec4(sum_force[0], 0.0) * 0.5);
    EmitVertex();
    EndPrimitive();

    gl_Position = m_pvm * pos[v_index[1]];
    EmitVertex();
    gl_Position = m_pvm * (pos[v_index[1]] + vec4(sum_force[1], 0.0) * 0.5);
    EmitVertex();
    EndPrimitive();

    gl_Position = m_pvm * pos[v_index[2]];
    EmitVertex();
    gl_Position = m_pvm * (pos[v_index[2]] + vec4(sum_force[2], 0.0) * 0.5);
    EmitVertex();
    EndPrimitive();
}