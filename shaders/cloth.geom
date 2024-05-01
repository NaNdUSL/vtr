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

layout(std430, binding = 3) buffer infoBuffer {
    float info[]; // 1D array of info
};

layout(std430, binding = 4) buffer normalsBuffer {
    float normals[]; // 1D array of normals
};

out vec3 n;
in int v_index[3];

void main() {

    int size = int(info[0]);
    int max_adj = int(info[3]);

    vec3 edge1 = gl_in[1].gl_Position.xyz - gl_in[0].gl_Position.xyz;
    vec3 edge2 = gl_in[2].gl_Position.xyz - gl_in[0].gl_Position.xyz;
    vec3 normal = normalize(cross(edge1, edge2));

    vec3 acc_normals_1 = vec3(0.0);
    vec3 acc_normals_2 = vec3(0.0);
    vec3 acc_normals_3 = vec3(0.0);

    for (int i = 0; i < max_adj; i++) {

        if (adjacents[v_index[0] * (size * size) + i] > 0) {

            acc_normals_1 += normals[i];
        }
    }

    acc_normals_1 += normal;

    n = normalize(m_normal * normalize(acc_normals_1));

    gl_Position = m_pvm * gl_in[0].gl_Position;
    EmitVertex();

    for (int i = 0; i < max_adj; i++) {

        if (adjacents[v_index[1] * (size * size) + i] > 0) {

            acc_normals_2 += normals[i];
        }
    }

    acc_normals_2 += normal;

    n = normalize(m_normal * normalize(acc_normals_2));

    gl_Position = m_pvm * gl_in[1].gl_Position;
    EmitVertex();

    for (int i = 0; i < max_adj; i++) {

        if (adjacents[v_index[2] * (size * size) + i] > 0) {

            acc_normals_3 += normals[i];
        }
    }

    acc_normals_3 += normal;

    n = normalize(m_normal * normalize(acc_normals_3));

    gl_Position = m_pvm * gl_in[2].gl_Position;
    EmitVertex();
    EndPrimitive();

    n = normalize(m_normal * normalize(-acc_normals_1));

    gl_Position = m_pvm * gl_in[1].gl_Position;
    EmitVertex();

    n = normalize(m_normal * normalize(-acc_normals_2));

    gl_Position = m_pvm * gl_in[0].gl_Position;
    EmitVertex();

    n = normalize(m_normal * normalize(-acc_normals_3));

    gl_Position = m_pvm * gl_in[2].gl_Position;
    EmitVertex();
    EndPrimitive();
}