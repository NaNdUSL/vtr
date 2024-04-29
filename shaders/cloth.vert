#version 430

// layout(std430, binding = 1) buffer clothBuffer {
// 	float pos[];
// };

uniform mat4 m_pvm;

in vec4 position;

// out Data {

//     // forces related variables
//     // vec3 gravity;
//     float M; // mass
//     float stiffness; // string stiffness
//     float edge_distance;

//     // variables
// 	vec3 normal; // local
// 	vec3 tangent; // local

// } DataOut;


void main() {

	// DataOut.normal = normal;
	// DataOut.tangent = tangent;
    // DataOut.M = pos[0].x;
    // DataOut.stiffness = 0.5;
    // DataOut.edge_distance = 1;
    // DataOut.gravity = DataOut.M * vec3(0.0, -9.8, 0.0);
    gl_Position = m_pvm * position;
}