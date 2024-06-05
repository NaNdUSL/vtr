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
uniform float wind_scale;

in vec4 position;

out int v_index;
out vec4 wind_coords;

void main() {

	int index = int(position.y);
	v_index = index;

	float radius = 0.5;

	float wind_intensity = length(texture(noise, vec2(text_coords[index].x + timer * 0.00001, text_coords[index].y + timer * 0.00001)));

    float theta = texture(noise, vec2(text_coords[index].x + timer * 0.00001, text_coords[index].y + timer * 0.00001)).r * 2.0 * 3.14159265;

    float phi = texture(noise, vec2(text_coords[index].x + timer * 0.00002, text_coords[index].y + timer * 0.00002)).r * 2.0 * 3.14159265;

	float deviation_x = radius * sin(theta) * cos(phi);
	float deviation_y = radius * sin(theta) * sin(phi);
	float deviation_z = radius * cos(theta);
	vec3 vector_deviation = vec3(deviation_x, deviation_y, deviation_z) * 0.5;
    
	wind_coords = vec4(normalize(vec3(wind_x, wind_y, wind_z) + vector_deviation) * wind_intensity * wind_intensity * wind_intensity * wind_scale, 0.0);

	gl_Position = pos[index];
}