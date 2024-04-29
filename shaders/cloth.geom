#version 430
// #pragma optionNV unroll all

layout(triangles) in;
layout (triangle_strip, max_vertices=3) out;

// layout(std430, binding = 1) buffer clothBuffer {
// 	vec4 pos[];
// };

uniform mat4 m_pvm;
uniform mat3 m_normal;
// uniform float timer;

out vec3 n;

vec3 edge1 = gl_in[1].gl_Position.xyz - gl_in[0].gl_Position.xyz;
vec3 edge2 = gl_in[2].gl_Position.xyz - gl_in[0].gl_Position.xyz;
vec3 normal = normalize(cross(edge1, edge2));

void main() {

    for (int i = 0; i < 3; i++) {

        n = normalize(m_normal * normal);
        gl_Position = m_pvm * gl_in[i].gl_Position;
        EmitVertex();
    }
    EndPrimitive();
}