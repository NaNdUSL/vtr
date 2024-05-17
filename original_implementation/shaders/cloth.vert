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

// uniform float windScale;

in vec4 position;
out int v_index;

bool isPointInSphere(vec3 point, vec3 sphereCenter, float sphereRadius) {

	vec3 diff = point - sphereCenter;
	float distanceSquared = dot(diff, diff);
	return distanceSquared < (sphereRadius * sphereRadius);
}

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

void main() {

	// Sphere information

	vec3 sphereCenter = vec3(2.0, -7.0, 3.0);
	float sphereRadius = 5;

	int index = int(position.y);

	if (check_stuck(index)) {

		v_index = index;
		gl_Position = pos[index];
		forces[index] = vec4(0.0, 0.0, 0.0, 0.0);
	}
	else {

		vec3 force = vec3(0);

		force += vec3(0.0, -9.8, 0.0) * M;

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

					vec3 f = hookes_law(pos[index].xyz, pos[x + i - 1 + ((z + j - 1) * width)].xyz, stiffness, adjacents[(index * 9) + i + j * 3]) + damping_force(pos[index].xyz, pos[x + i - 1 + ((z + j - 1) * width)].xyz, vel[index], vel[x + i - 1 + ((z + j - 1) * width)], damping_coeff);
					force += f;
				}
			}
		}

		if (length(vec3(wind_x, wind_y, wind_z)) != 0) {

			float wind_intensity = length(texture(noise, vec2(text_coords[index].x + timer * 0.00001, text_coords[index].y + timer * 0.00001)));

			force += normalize(vec3(wind_x, wind_y, wind_z)) * wind_intensity * wind_intensity;
		}

		if (length(force) < 0.001) force = vec3(0.0);

		vec3 a = force / M;
		vec3 new_vel = vel[index].xyz + a * time_interval;
		vec4 new_pos = pos[index] + vec4(new_vel * time_interval, 0.0);

		// if (isPointInSphere(new_pos.xyz, sphereCenter, sphereRadius)) {

		// 	vec3 v = new_pos.xyz - sphereCenter;
		// 	vec3 vec_dir = normalize(v);
		// 	new_pos = vec4(sphereCenter + vec_dir * sphereRadius, 1.0);
		// }

		forces[index] = vec4(force, length(force));
		pos[index] = new_pos;
		vel[index] = vec4(new_vel, 0.0);
		v_index = index;

		gl_Position = pos[index];
	}
}



// #version 330

// in vec4 position;

// void main () {

// 	vec4 pos;
// 	pos.x = gl_InstanceID / 1000;
// 	pos.z = gl_InstanceID % 1000;
// 	pos.y = 0; pos.w = 1;	
// 	pos.xyz = pos.xyz * 0.15;
// 	gl_Position = pos;	
// }