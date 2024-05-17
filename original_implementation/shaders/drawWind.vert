#version 430

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

layout(std430, binding = 5) buffer textureBuffer {
	vec2 text_coords[]; // 1D array of normals
};

uniform float wind_x = 0.5;
uniform float wind_y = 0.5;
uniform float wind_z = 0.5;
uniform sampler2D noise;
uniform float timer;

in vec4 position;

out int v_index;
out vec4 wind_coords;

void main() {

	int index = int(position.y);
	v_index = index;

	float wind_intensity = (sin(length(texture(noise, vec2(1 / (pos[index].x + timer * 0.0001), 1 / (pos[index].y + timer * 0.0001))))) * 2 - 1);

    wind_coords = vec4(normalize(vec3(wind_x, wind_y, wind_z)) * wind_intensity * 2, 0.0);

	gl_Position = pos[index];
}