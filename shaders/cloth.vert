#version 420

in vec4 position;
in vec3 normal;
in vec3 tangent;
// in vec2 texCoord;

out Data {
	vec3 normal;
	// vec2 texCoord;
	vec3 tangent;
} DataOut;

void main() {

	DataOut.normal = normal;
	DataOut.tangent = tangent;
	gl_Position = position;
} 