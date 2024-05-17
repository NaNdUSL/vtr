#version 430
// #pragma optionNV unroll all

layout(triangles) in;
layout (line_strip, max_vertices=6) out;

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

uniform mat4 m_pvm;

out vec4 colour;

in int v_index[3];
in vec4 wind_coords[3];

void main() {

    colour = vec4(1.0, 0.0, 0.0, 1.0);
    gl_Position = m_pvm * pos[v_index[0]];
    EmitVertex();

    gl_Position = m_pvm * ((pos[v_index[0]] + wind_coords[0]) * 0.3);
    EmitVertex();
    EndPrimitive();

    gl_Position = m_pvm * pos[v_index[1]];
    EmitVertex();

    gl_Position = m_pvm * ((pos[v_index[1]] + wind_coords[1]) * 0.3);
    EmitVertex();
    EndPrimitive();

    gl_Position = m_pvm * pos[v_index[2]];
    EmitVertex();

    gl_Position = m_pvm * ((pos[v_index[2]] + wind_coords[2]) * 0.3);
    EmitVertex();
    EndPrimitive();
}