#version 420

layout(triangles) in;
layout (line_strip, max_vertices=6) out;

uniform mat4 m_pvm;
uniform float timer;

in Data {

    // forces related variables
    // vec3 gravity;
    float M; // mass

    // variables
	vec3 normal; // local
	vec3 tangent; // local
} DataIn[3];

out vec4 color;

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
    
    for (int i = 0; i  < 3; i++) {
            
            triangle_vert[i] = gl_in[i].gl_Position;
    }

    vec3 forces[1];
    int size = 1;
    // forces[0] = DataIn.gravity;
    forces[0] = DataIn[0].M * vec3(0.0, -9.8, 0.0);

    for (int i = 0; i < 3; i++) {

        if (triangle_vert[i] == vec4(0.0, 0.0, 0.0, 1) || triangle_vert[i] == vec4(0.0, 0, 9.0, 1)) {
        
            triangle_vert[i] = triangle_vert[i];
        }
        else {

            triangle_vert[i] = calculate_position(triangle_vert[i], DataIn[i].M, time_interval, forces, size);
            gl_Position = triangle_vert[i];
        }
    }

    vec3 edge1 = triangle_vert[1].xyz - triangle_vert[0].xyz;
    vec3 edge2 = triangle_vert[2].xyz - triangle_vert[0].xyz;
    vec3 normal = normalize(cross(edge1, edge2));

    for (int i = 0; i < 3; i++) {

		color = vec4(0.0, 1.0, 0.0, 1.0);
        gl_Position = m_pvm * triangle_vert[i];
        EmitVertex();
        gl_Position = m_pvm * (triangle_vert[i] + vec4(normalize(normal), 0.0) * 0.1);
        EmitVertex();
        EndPrimitive();
    }

    /*color = vec4(1.0, 0.0, 0.0, 1.0);
    gl_Position = m_pvm * pos;
    EmitVertex();
    gl_Position = m_pvm * (pos + vec4(normalize(DataIn[i].tangent), 0.0) * 0.1);
    EmitVertex();
    EndPrimitive();

    color = vec4(0.0, 0.0, 1.0, 1.0);
    gl_Position = m_pvm * pos;
    EmitVertex();
    gl_Position = m_pvm * (pos + vec4(normalize(b), 0.0) * 0.1);
    EmitVertex();
    EndPrimitive(); */
}