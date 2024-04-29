#version 430

layout(std430, binding = 1) buffer clothBuffer {
	vec4 pos[];
};

uniform mat4 m_pvm;
uniform float timer;

in vec4 position;


vec3 hookes_law(vec3 p1, vec3 p2, float stiffness, float edge_distance) {

    vec3 v = p1 - p2; // vector from p1 to p2
    float l = length(v); // length of the vector
    vec3 vec_dir = normalize(v); // normalized vector from p1 to p2 (direction)
    vec3 x = (l - edge_distance) * vec_dir; // difference between the current length and the edge distance
    return - stiffness * x;
}

vec4 calculate_position(vec4 position, float Mass, float time_interval, vec3 forces[10], int size) {

    vec3 force = vec3(0.0, 0.0, 0.0);

    for(int i = 0; i < size; i++) {

        force = force + forces[i];
    }

    vec3 a = force / Mass;
    vec4 final_pos = position + vec4(0.5 * a * time_interval * time_interval, 0);

    return final_pos;
}


void main() {

    float M = 0.23;
    float stiffness = 1;
    vec3 f_gravity = M * vec3(0.0, -9.8, 0.0);
    int index = int(position.y);

    vec3 forces[10];
    forces[0] = f_gravity;
    int count = 1;

    float time_interval = timer * 0.000005;

    vec3 f_first = vec3(0.0, 0.0, 0.0);
    vec3 f_second = vec3(0.0, 0.0, 0.0);
    vec3 f_third = vec3(0.0, 0.0, 0.0);

    float edge_distance = 1;

    if (index == 0) {

        // f_first = hookes_law(pos[0].xyz, pos[1].xyz, stiffness, edge_distance);
        // f_second = hookes_law(pos[0].xyz, pos[2].xyz, stiffness, edge_distance);
        // f_third = hookes_law(pos[0].xyz, pos[3].xyz, stiffness, sqrt(2.0));
        forces[0] = vec3(0.0, 0.0, 0.0);
    }
    else if (index == 1) {
            
        // f_first = hookes_law(pos[1].xyz, pos[0].xyz, stiffness, edge_distance);
        // f_second = hookes_law(pos[1].xyz, pos[2].xyz, stiffness, sqrt(2.0));
        // f_third = hookes_law(pos[1].xyz, pos[3].xyz, stiffness, edge_distance);
        forces[0] = vec3(0.0, 0.0, 0.0);
    }
    else if (index == 2) {

        f_first = hookes_law(pos[2].xyz, pos[0].xyz, stiffness, edge_distance);
        f_second = hookes_law(pos[2].xyz, pos[1].xyz, stiffness, sqrt(2.0));
        f_third = hookes_law(pos[2].xyz, pos[3].xyz, stiffness, edge_distance);
    }
    else if (index == 3) {

        f_first = hookes_law(pos[3].xyz, pos[0].xyz, stiffness, sqrt(2.0));
        f_second = hookes_law(pos[3].xyz, pos[1].xyz, stiffness, edge_distance);
        f_third = hookes_law(pos[3].xyz, pos[2].xyz, stiffness, edge_distance);
    }
    else if (index == 4) {

        // f_first = hookes_law(pos[4].xyz, pos[5].xyz, stiffness, edge_distance);
        // f_second = hookes_law(pos[4].xyz, pos[6].xyz, stiffness, edge_distance);
        // f_third = hookes_law(pos[4].xyz, pos[7].xyz, stiffness, sqrt(2.0));
        forces[0] = vec3(0.0, 0.0, 0.0);
    }
    else if (index == 5) {

        // f_first = hookes_law(pos[5].xyz, pos[4].xyz, stiffness, edge_distance);
        // f_second = hookes_law(pos[5].xyz, pos[6].xyz, stiffness, sqrt(2.0));
        // f_third = hookes_law(pos[5].xyz, pos[7].xyz, stiffness, edge_distance);
        forces[0] = vec3(0.0, 0.0, 0.0);
    }
    else if (index == 6) {

        f_first = hookes_law(pos[6].xyz, pos[4].xyz, stiffness, edge_distance);
        f_second = hookes_law(pos[6].xyz, pos[5].xyz, stiffness, sqrt(2.0));
        f_third = hookes_law(pos[6].xyz, pos[7].xyz, stiffness, edge_distance);
    }
    else {

        f_first = hookes_law(pos[7].xyz, pos[4].xyz, stiffness, sqrt(2.0));
        f_second = hookes_law(pos[7].xyz, pos[5].xyz, stiffness, edge_distance);
        f_third = hookes_law(pos[7].xyz, pos[6].xyz, stiffness, edge_distance);
    }

    forces[1] = f_first;
    count++;
    forces[2] = f_second;
    count++;
    forces[3] = f_third;
    count++;

    pos[index] = calculate_position(pos[index], M, time_interval, forces, count);

    gl_Position = pos[index];
}