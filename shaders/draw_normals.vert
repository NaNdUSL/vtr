#version 420

uniform float timer; // local space

in vec4 position; // local space
in vec3 normal; // local space
in vec3 tangent; // local space
// in vec2 texCoord;

out Data {
	vec3 normal; // local
	vec3 tangent; // local
} DataOut;

void main() {

	DataOut.normal = normal;
	DataOut.tangent = tangent;

	if (position == vec4(0.0, 0, 0.0, 1) || position == vec4(0.0, 0, 9.0, 1)) {
        
        gl_Position = position;
    }
    else {

        vec4 p = position + vec4(0, - timer * 0.000001, 0, 0);
        gl_Position = p;
    }
}