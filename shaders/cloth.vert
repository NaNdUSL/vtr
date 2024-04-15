#version 460

// uniforms
uniform mat4 m_pvm;
uniform mat3 m_normal;
uniform float timer;

// input streams - local space
in vec4 position;
in vec3 normal;

//output
out vec3 n; // normal in camera space

void main() {

    n = normalize(m_normal * normal);
    vec4 p = position + vec4(0, - timer * 0.000005, 0, 0);
    gl_Position = m_pvm * p;
}