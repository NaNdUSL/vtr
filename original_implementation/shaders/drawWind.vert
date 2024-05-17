#version 430

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

layout(std430, binding = 5) buffer textureBuffer {
	vec2 text_coords[]; // 1D array of normals
};

uniform float wind_x;
uniform float wind_y;
uniform float wind_z;
uniform sampler2D noise;
uniform float timer;

in vec4 position;

out int v_index;
out vec4 wind_coords;

void main() {

	int index = int(position.y);
	v_index = index;

	float wind_intensity = length(texture(noise, vec2(text_coords[index].x + timer * 0.00001, text_coords[index].y + timer * 0.00001)));

    wind_coords = vec4(normalize(vec3(wind_x, wind_y, wind_z)) * wind_intensity * wind_intensity * wind_intensity, 0.0);

	gl_Position = pos[index];
}