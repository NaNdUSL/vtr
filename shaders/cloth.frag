#version 430

//uniform
// uniform vec4 diffuse;
// uniform vec4 l_dir; // world space
// uniform mat4 m_view;

// // input
// in vec3 n;

// output
out vec4 color;

void main() {

   // compute light direction in camera space
    // vec3 l = normalize(vec3(m_view * -l_dir));
    // vec3 nn = normalize(n);
    // float i = max(0.0, dot(l,nn));

    color = vec4(1,0,0,1);
}