#version 430
// #pragma optionNV unroll all

layout(triangles) in;
layout (triangle_strip, max_vertices=6) out;

// layout(std430, binding = 1) buffer clothBuffer {
// 	vec4 pos[]; // 1D array of positions
// };

// layout(std430, binding = 2) buffer adjBuffer {
//     float adjacents[]; // 2D array of adjacents
// };

// layout(std430, binding = 3) buffer infoBuffer {
//     float info[]; // 2D array of adjacents
// };

uniform mat4 m_pvm;
uniform mat3 m_normal;
// uniform float timer;

out vec3 n;

void main() {

    vec3 edge1 = gl_in[1].gl_Position.xyz - gl_in[0].gl_Position.xyz;
    vec3 edge2 = gl_in[2].gl_Position.xyz - gl_in[0].gl_Position.xyz;
    vec3 normal = normalize(cross(edge1, edge2));

    n = normalize(m_normal * normal);

    gl_Position = m_pvm * gl_in[0].gl_Position;
    EmitVertex();
    gl_Position = m_pvm * gl_in[1].gl_Position;
    EmitVertex();
    gl_Position = m_pvm * gl_in[2].gl_Position;
    EmitVertex();
    EndPrimitive();

    n = normalize(m_normal * (-normal));

    gl_Position = m_pvm * gl_in[1].gl_Position;
    EmitVertex();
    gl_Position = m_pvm * gl_in[0].gl_Position;
    EmitVertex();
    gl_Position = m_pvm * gl_in[2].gl_Position;
    EmitVertex();
    EndPrimitive();
}