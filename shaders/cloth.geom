#version 430
#pragma optionNV unroll all

layout(triangles) in;
layout (triangle_strip, max_vertices=3) out;

uniform mat4 m_pvm;

void main() {

    for (int i = 0; i < 3; i++) {

        gl_Position = m_pvm * gl_in[i].gl_Position;
        EmitVertex();
    }
    EndPrimitive();
}
// uniform mat3 m_normal;
// uniform float timer;

// in Data {

//     // forces related variables
//     // vec3 gravity;
//     float M; // mass
//     float stiffness; // string stiffness
//     float edge_distance; // edge distance - local

//     // variables
// 	vec3 normal; // local
// 	vec3 tangent; // local

// } DataIn[3];

// out vec3 n;

// vec3 hookes_law(vec3 p1, vec3 p2, int i, float stiffness, float edge_distance) {

//     vec3 v = p1 - p2; // vector from p1 to p2
//     float l = length(v); // length of the vector
//     vec3 vec_dir = normalize(v); // normalized vector from p1 to p2 (direction)
//     vec3 x = (l - edge_distance) * vec_dir; // difference between the current length and the edge distance
//     return - stiffness * x;
// }

// vec4 calculate_position(vec4 position, float Mass, float time_interval, vec3 forces[3], int size) {

//     vec3 force = vec3(0.0, 0.0, 0.0);

//     for(int i = 0; i < size; i++) {

//         force = force + forces[i];
//     }

//     vec3 a = force / Mass;
//     vec4 final_pos = position + vec4(0.5 * a * time_interval * time_interval, 0);

//     return final_pos;
// }

// void main() {


    // float time_interval = timer * 0.0001;
    
    //vec4 triangle_vert[3];

    //vec3 forces[3];
    // int size = 3;
    // // forces[0] = DataIn.gravity;
    // forces[0] = DataIn[0].M * vec3(0.0, -9.8, 0.0);

    // for (int i = 0; i < 3; i++) {

    //     if (gl_in[i].gl_Position == vec4(0.0, 0.0, 0.0, 1) || gl_in[i].gl_Position == vec4(0.0, 0, 9.0, 1)) {
        
    //         triangle_vert[i] = gl_in[i].gl_Position;
    //     }
    //     else {

    //         vec3 spring_force_edge1 = hookes_law(gl_in[i].gl_Position.xyz, gl_in[(i + 1) % 3].gl_Position.xyz, i, DataIn[i].stiffness, DataIn[i].edge_distance);
    //         vec3 spring_force_edge2 = hookes_law(gl_in[i].gl_Position.xyz, gl_in[(i + 2) % 3].gl_Position.xyz, i, DataIn[i].stiffness, DataIn[i].edge_distance);

    //         forces[1] = spring_force_edge1;
    //         forces[2] = spring_force_edge2;

    //         triangle_vert[i] = calculate_position(gl_in[i].gl_Position, DataIn[i].M, time_interval, forces, size);
    //     }
    // }

    // vec3 edge1 = triangle_vert[1].xyz - triangle_vert[0].xyz;
    // vec3 edge2 = triangle_vert[2].xyz - triangle_vert[0].xyz;
    // vec3 nn = normalize(cross(edge1, edge2));

    // for (int i = 0; i < 3; i++) {

    //     gl_Position = m_pvm * triangle_vert[i];
    //     n = normalize(m_normal * nn);
    //     EmitVertex();
    // }
    // EndPrimitive();
// }