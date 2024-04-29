#version 430

layout(std430, binding = 1) buffer clothBuffer {
	vec4 rgb_values[];
};

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

    color = vec4(rgb_values[7].x, rgb_values[7].y, rgb_values[7].z, 1.0);
}