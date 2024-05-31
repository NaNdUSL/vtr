#version 430

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

layout(std430, binding = 2) buffer adjBuffer {
	float adjacents[]; // 2D array of adjacents
};

layout(std430, binding = 3) buffer stuckVertBuffer {
	float info[]; // 1D array of info
};

layout(std430, binding = 4) buffer normalsBuffer {
	vec4 normals[]; // 1D array of normals
};

layout(std430, binding = 5) buffer textureBuffer {
	vec2 text_coords[]; // 1D array of normals
};

layout(std430, binding = 6) buffer forcesBuffer {
	vec4 forces[]; // 1D array of forces
};

layout(std430, binding = 7) buffer velocitiesBuffer {
	vec4 vel[]; // 1D array of forces
};

uniform float wind_x;
uniform float wind_y;
uniform float wind_z;

uniform mat4 m_pvm;
uniform float timer;
uniform int width;
uniform int height;
uniform float stiffness;
uniform float damping_coeff;
uniform float M;
uniform float time_interval;
uniform sampler2D noise;
uniform float marbel_radius;
uniform float wind_scale;

in vec4 position;

out vec3 normal;
out int v_index;

vec3 hookes_law(vec3 p1, vec3 p2, float stiffness, float edge_distance) {

	vec3 v = p1 - p2; // vector from p1 to p2
	float l = length(v); // length of the vector
	vec3 vec_dir = normalize(v); // normalized vector from p1 to p2 (direction)
	vec3 x = (l - edge_distance) * vec_dir; // difference between the current length and the resting edge distance

	return - stiffness * x;
}

vec3 damping_force(vec3 p1, vec3 p2, vec4 vel1, vec4 vel2, float damping_coeff) {

	vec3 vec = p1 - p2; // vector from p1 to p2
	vec3 vel = vel1.xyz - vel2.xyz; // velocity difference
	vec3 vec_dir = normalize(vec); // normalized vector from p1 to p2 (direction)
	vec3 x = ((vel * vec) / length(vec)) * vec_dir; // difference between the current length and the resting edge distance

	return - damping_coeff * x;
}

bool check_stuck(int index) {

	int size = int(info[0]);

	for (int i = 0; i < size; i++) {

		if (index == int(info[1 + i])) {

			return true;
		}
	}

	return false;
}

bool is_adjacent(int index, int is_adj) {

	int x = index % width;
	int z = index / width;

	for (int j = 0; j < 3; j++) {

		for (int i = 0; i < 3; i++) {

			if (adjacents[(index * 9) + i + j * 3] > 0 && x + i - 1 + ((z + j - 1) * width) == is_adj) {

				return true;
			}
		}
	}

	return false;
}

void main() {

	// Sphere information

	vec3 sphereCenter = vec3(0.3, -1, 0.3);
	float sphereRadius = 0.3;

	int index = int(position.y);

	vec3 force = vec3(0.0);
	vec3 norm = vec3(0.0);

	force += vec3(0.0, -9.8, 0.0) * M;

	int x = index % width;
	int z = index / width;
	bool found = false;

	for (int j = 0; j < 3; j++) {

		for (int i = 0; i < 3; i++) {

			if (adjacents[(index * 9) + i + j * 3] > 0) {

				norm += normals[x + i - 1 + ((z + j - 1) * width)].xyz;
				vec3 f = hookes_law(pos[index].xyz, pos[x + i - 1 + ((z + j - 1) * width)].xyz, stiffness, adjacents[(index * 9) + i + j * 3]) + damping_force(pos[index].xyz, pos[x + i - 1 + ((z + j - 1) * width)].xyz, vel[index], vel[x + i - 1 + ((z + j - 1) * width)], damping_coeff);
				force += f;
			}
		}
	}

	if (length(vec3(wind_x, wind_y, wind_z)) != 0) {

		float wind_intensity = length(texture(noise, vec2(text_coords[index].x + timer * 0.00001, text_coords[index].y + timer * 0.00001)));

		force += normalize(vec3(wind_x, wind_y, wind_z)) * wind_intensity * wind_scale;
	}

	if (length(force) < 0.001 || check_stuck(index)) force = vec3(0.0);

	vec3 a = force / M;
	vec3 new_vel = vel[index].xyz + a * time_interval;
	vec4 new_pos = pos[index] + vec4(new_vel * time_interval, 0.0);

	for (int i = 0; i < height * width; i++) {

		if (i != index && !is_adjacent(index, i) && length(new_pos.xyz - pos[i].xyz) < 2 * marbel_radius) {

			vec3 n = normalize(new_pos.xyz - pos[i].xyz);
			new_pos.xyz = pos[i].xyz + n * 2 * marbel_radius;
			new_vel = -vel[index].xyz;
		}
	}

	if (length(new_pos.xyz - sphereCenter) < sphereRadius) {

		vec3 n = normalize(new_pos.xyz - sphereCenter);
		new_pos.xyz = sphereCenter + n * sphereRadius;
		new_vel = -vel[index].xyz; // talvez calcular com base na força
	}

	forces[index] = vec4(force, length(force));
	pos[index] = new_pos;
	vel[index] = vec4(new_vel, 0.0);
	normals[index] = vec4(0.0);
	normal = normalize(norm + normals[index].xyz);
	v_index = index;
	gl_Position = pos[index];
}