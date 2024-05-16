#version 430
// #pragma optionNV unroll all

layout(triangles) in;
layout (line_strip, max_vertices=6) out;

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

uniform float wind_x = 0.5;
uniform float wind_y = 0.5;
uniform float wind_z = 0.5;

uniform mat4 m_pvm;

out vec4 colour;

in int v_index[3];

void main() {

    colour = vec4(1.0, 0.0, 0.0, 1.0);
    gl_Position = m_pvm * pos[v_index[0]];
    EmitVertex();

    gl_Position = m_pvm * (pos[v_index[0]] + vec4(wind_x, wind_y, wind_z, 0.0));
    EmitVertex();

    EndPrimitive();
}