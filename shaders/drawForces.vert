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

uniform mat4 m_pvm;
uniform float timer;

in vec4 position;
out int v_index;
out vec3 sum_force;

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

    // if (length(x) < 0.5) return vec3(0.0);

    return - stiffness * x;
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
    float sphereRadius = 6;

    int index = int(position.y);
    int height = int(info[0]);
    int width = int(info[1]);
    float time_interval = timer * 0.000001;
    // float time_interval = (timer - info[5]) *  0.01;
    info[4] = (timer - info[5]);
    info[5] = timer;

    if (check_stuck(index)) {

        v_index = index;
        sum_force = vec3(0.0);
        gl_Position = pos[index];
    }
    else {

        float M = info[2];
        float stiffness = info[3];

        vec3 force = vec3(0.0);

        force += M * vec3(0.0, -9.8, 0.0);

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

                    vec3 f = hookes_law(pos[index].xyz, pos[x + i - 1 + ((z + j - 1) * width)].xyz, stiffness, adjacents[(index * 9) + i + j * 3]);
                    force += f;
                }
            }
        }

        if (length(force) < 0.00001) force = vec3(0.0);

        vec3 a = force / M;
        vec4 new_pos = pos[index] + vec4(1 * a * time_interval * time_interval, 0.0);

        if (isPointInSphere(new_pos.xyz, sphereCenter, sphereRadius)) {

            vec3 v = new_pos.xyz - sphereCenter;
            vec3 vec_dir = normalize(v);
            new_pos = vec4(sphereCenter + vec_dir * sphereRadius, 1.0);
        }

        pos[index] = new_pos;
        v_index = index;
        sum_force = force;

        gl_Position = pos[index];
    }
}