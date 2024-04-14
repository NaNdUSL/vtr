#version 420

layout(triangles) in;
layout (line_strip, max_vertices=18) out;

uniform mat4 m_pvm;

in Data {
    vec3 normal;
	// vec2 texCoord;
	vec3 tangent;
} DataIn[3];

out vec4 color;

void main() {

    for (int i = 0; i < 3; i++) {

        vec4 pos = gl_in[i].gl_Position;
        vec3 b = cross(normalize(DataIn[i].normal), normalize(DataIn[i].tangent));

		color = vec4(0.0, 1.0, 0.0, 1.0);
        gl_Position = m_pvm * pos;
        EmitVertex();
        gl_Position = m_pvm * (pos + vec4(normalize(DataIn[i].normal), 0.0) * 0.1);
        EmitVertex();
        EndPrimitive();

		color = vec4(1.0, 0.0, 0.0, 1.0);
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
        EndPrimitive();
    }
}