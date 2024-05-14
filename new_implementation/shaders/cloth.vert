#version 430

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};

layout(std430, binding = 2) buffer adjBuffer {
	float adjacents[]; // 2D array of adjacents
};

layout(std430, binding = 3) buffer infoBuffer {
	float info[]; // 1D array of info
};

layout(std430, binding = 6) buffer forcesBuffer {
	vec4 forces[]; // 1D array of forces
};

uniform mat4 m_pvm;
uniform float timer;

in vec4 position;
out int v_index;

// bool isPointInSphere(vec3 point, vec3 sphereCenter, float sphereRadius) {

// 	vec3 diff = point - sphereCenter;
// 	float distanceSquared = dot(diff, diff);
// 	return distanceSquared < (sphereRadius * sphereRadius);
// }

ivec3 hookes_law(vec3 p1, vec3 p2, float stiffness, float edge_distance) {

	ivec3 v = ivec3(p1 - p2); // vector from p1 to p2
	float l = length(v); // length of the vector
	vec3 vec_dir = normalize(v); // normalized vector from p1 to p2 (direction)
	vec3 x = (l - edge_distance) * vec_dir; // difference between the current length and the resting edge distance

	return ivec3(- stiffness * x);
}

bool check_stuck(int index) {

	int size = int(info[6]);

	for (int i = 0; i < size; i++) {

		if (index == int(info[7 + i])) {

			return true;
		}
	}

	return false;
}

void main() {

	// Sphere information

	vec3 sphereCenter = vec3(2.0, -7.0, 1.0);
	float sphereRadius = 5;
	int scaller = 1000;

	int index = int(position.y);
	int height = int(info[0]);
	int width = int(info[1]);
	info[4] = (timer - info[5]);
	float time_interval = 0.01;

	info[5] = timer;

	if (check_stuck(index)) {

		v_index = index;
		gl_Position = pos[index];
		forces[index] = vec4(0.0, 0.0, 0.0, 0.0);
	}
	else {

		float M = info[2];
		float stiffness = info[3];

		ivec3 force = ivec3(0);

		force += ivec3(scaller * vec3(0.0, -9.8, 0.0) * M);

		int x = 0;
		int z = 0;
		bool found = false;

		for (int j = 0; !found && j < height; j++) {
			
			for (int i = 0; !found && i < width; i++) {

				if (j * width + i == index) {

					x = i;
					z = j;
					found = true;
				}
			}
		}

		for (int j = 0; j < 3; j++) {

			for (int i = 0; i < 3; i++) {

				if (adjacents[(index * 9) + i + j * 3] > 0) {

					ivec3 f = hookes_law(scaller * pos[index].xyz, scaller * pos[x + i - 1 + ((z + j - 1) * width)].xyz, stiffness, scaller * adjacents[(index * 9) + i + j * 3]);
					force += f;
				}
			}
		}

		ivec3 a = ivec3(force / M);
		vec4 new_pos = pos[index] + vec4(0.5 * a * time_interval * time_interval / scaller, 0.0);

		// if (isPointInSphere(new_pos.xyz, sphereCenter, sphereRadius)) {

		// 	vec3 v = new_pos.xyz - sphereCenter;
		// 	vec3 vec_dir = normalize(v);
		// 	new_pos = vec4(sphereCenter + vec_dir * sphereRadius, 1.0);
		// }

		forces[index] = vec4(force / scaller, length(force / scaller));
		pos[index] = new_pos;
		v_index = index;

		gl_Position = pos[index];
	}
}