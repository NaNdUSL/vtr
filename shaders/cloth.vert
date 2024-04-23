#version 420

layout(location = 2) buffer cloth_buffer {
    float pos;
};

in vec4 position; // local space
in vec3 normal; // local space
in vec3 tangent; // local space
// in vec2 texCoord;

out Data {

    // forces related variables
    // vec3 gravity;
    float M; // mass
    float stiffness; // string stiffness
    float edge_distance;

    // variables
	vec3 normal; // local
	vec3 tangent; // local

} DataOut;


void main() {

	DataOut.normal = normal;
	DataOut.tangent = tangent;
    DataOut.M = 0.23;
    DataOut.stiffness = 0.5;
    DataOut.edge_distance = 1.414;
    // DataOut.gravity = DataOut.M * vec3(0.0, -9.8, 0.0);
    gl_Position = position;
}