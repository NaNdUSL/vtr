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
    
    if (position == vec4(0.0, 0, 0.0, 1) || position == vec4(0.0, 0, 9.0, 1)) {
        
        gl_Position = m_pvm * position;
    }
    else {

        vec4 p = position + vec4(0, - timer * 0.000001, 0, 0);
        gl_Position = m_pvm * p;
    }
}