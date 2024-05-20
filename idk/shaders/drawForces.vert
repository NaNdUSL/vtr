#version 430

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

in vec4 position;
out int v_index;

void main() {

	int index = gl_VertexID;
	v_index = index;

	gl_Position = pos[index];
}