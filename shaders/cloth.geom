#version 420

layout(triangles) in;
layout (triangle_strip, max_vertices=3) out;

uniform mat4 m_pvm;
uniform mat3 m_normal;
uniform float timer;

in Data {

    // forces related variables
    // vec3 gravity;
    float M; // mass

    // variables
	vec3 normal; // local
	vec3 tangent; // local

} DataIn[3];

out vec3 n;

vec4 calculate_position(vec4 position, float Mass, float time_interval, vec3 forces[1], int size) {

    vec3 force = vec3(0.0, 0.0, 0.0);

    for(int i = 0; i < size; i++) {

        force = force + forces[i];
    }

    vec3 a = force / Mass;
    vec4 final_pos = position + vec4(0.5 * a * time_interval * time_interval, 0);

    return final_pos;
}

void main() {

    float time_interval = timer * 0.0001;
    
    vec4 triangle_vert[3];

    vec3 forces[1];
    int size = 1;
    // forces[0] = DataIn.gravity;
    forces[0] = DataIn[0].M * vec3(0.0, -9.8, 0.0);

    for (int i = 0; i < 3; i++) {

        if (gl_in[i].gl_Position == vec4(0.0, 0.0, 0.0, 1) || gl_in[i].gl_Position == vec4(0.0, 0, 9.0, 1)) {
        
            triangle_vert[i] = gl_in[i].gl_Position;
        }
        else {

            triangle_vert[i] = calculate_position(gl_in[i].gl_Position, DataIn[i].M, time_interval, forces, size);
        }
    }

    vec3 edge1 = triangle_vert[1].xyz - triangle_vert[0].xyz;
    vec3 edge2 = triangle_vert[2].xyz - triangle_vert[0].xyz;
    vec3 nn = normalize(cross(edge1, edge2));

    for (int i = 0; i < 3; i++) {

        gl_Position = m_pvm * triangle_vert[i];
        n = normalize(m_normal * nn);
        EmitVertex();
    }
    EndPrimitive();
}