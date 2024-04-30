#version 430

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[]; // 1D array of positions
};
layout(std430, binding = 2) buffer adjBuffer {
    float adjacents[]; // 2D array of adjacents
};

uniform mat4 m_pvm;
uniform float timer;

in vec4 position;

vec3 hookes_law(vec3 p1, vec3 p2, float stiffness, float edge_distance) {

    vec3 v = p1 - p2; // vector from p1 to p2
    float l = length(v); // length of the vector
    vec3 vec_dir = normalize(v); // normalized vector from p1 to p2 (direction)
    vec3 x = (l - edge_distance) * vec_dir; // difference between the current length and the resting edge distance
    return - stiffness * x;
}

void main() {

    int index = int(position.y);

    if (index == 0 || index == 4 / 2 - 1) {

        gl_Position = pos[index];
    }
    else {

        float time_interval = timer * 0.000005;
        float M = 0.23;
        float stiffness = 2;

        vec3 force = vec3(0.0, 0.0, 0.0);

        force += M * vec3(0.0, -9.8, 0.0);

        for (int i = 0; i < 4; i++) {

            if (adjacents[index * 4 + i] > 0) {

                vec3 f = hookes_law(pos[index].xyz, pos[i].xyz, stiffness, adjacents[index * 4 + i]);
                force += f;
            }
        }

        vec3 a = force / M;
        vec4 new_pos = pos[index] + vec4(0.5 * a * time_interval * time_interval, 0.0);

        pos[index] = new_pos;

        gl_Position = pos[index];
    }
}