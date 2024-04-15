#version 420

uniform float timer; // local space

in vec4 position; // local space
in vec3 normal; // local space
in vec3 tangent; // local space
// in vec2 texCoord;

out Data {
	vec3 normal; // camera
	// vec2 texCoord;
	vec3 tangent; // camera
} DataOut;

void main() {

	DataOut.normal = normal;
	DataOut.tangent = tangent;
	vec4 p = position + vec4(0, -timer * 0.000005, 0, 0);
    gl_Position = p;
} 