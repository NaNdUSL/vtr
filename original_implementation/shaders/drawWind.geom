#version 430
// #pragma optionNV unroll all

layout(points) in;
layout (line_strip, max_vertices=2) out;

uniform float wind_x;
uniform float wind_y;
uniform float wind_z;

uniform mat4 m_pvm;

void main() {
    gl_Position = gl_in[0].gl_Position;
    EmitVertex();

    gl_Position = vec4(1.0, 1.0, 0.0, 1.0); // Fixed point (1,1,0)
    EmitVertex();

    EndPrimitive();
}