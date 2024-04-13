# Function to generate a squared mesh of cloth
def generate_cloth_mesh(size):

	vert_front = []
	vert_back = []
	faces = []
	tangents = []

	# Generate vertices
	for x in range(size):

		for z in range(size):

			vert_front.append([x, 0, z])
			vert_back.append([x, 0, z])
	
	vertices = vert_front + vert_back

	# Generate faces and tangents
	for x in range(size-1):

		for z in range(size-1):

			v1 = x * size + z
			v2 = x * size + z + 1
			v3 = (x + 1) * size + z
			v4 = (x + 1) * size + z + 1

			vert_front.append

			normals.append([0, 1, 0])
			faces.append([v1, v2, v3])
			faces.append([v2, v4, v3])
			faces.append([v3, v2, v1])
			faces.append([v3, v4, v2])

			normals.append([0, 1, 0])

			# Calculate tangents
			deltaPos1 = [vertices[v2][i] - vertices[v1][i] for i in range(3)]
			deltaPos2 = [vertices[v3][i] - vertices[v1][i] for i in range(3)]
			deltaUV1 = [1, 0]  # Assuming horizontal texture mapping
			deltaUV2 = [0, 1]  # Assuming vertical texture mapping

			r = 1.0 / (deltaUV1[0] * deltaUV2[1] - deltaUV1[1] * deltaUV2[0])
			tangent = [(deltaPos1[0] * deltaUV2[1] - deltaPos2[0] * deltaUV1[1]) * r,
					   (deltaPos1[1] * deltaUV2[1] - deltaPos2[1] * deltaUV1[1]) * r,
					   (deltaPos1[2] * deltaUV2[1] - deltaPos2[2] * deltaUV1[1]) * r]
			tangents.append(tangent)

		for x in range(size-1):
			for z in range(size-1):
				v1 = x*size + z
				v2 = x*size + z + 1
				v3 = (x+1)*size + z
				v4 = (x+1)*size + z + 1

				faces.append([v1, v2, v3])
				faces.append([v2, v4, v3])
				faces.append([v3, v2, v1])
				faces.append([v3, v4, v2])

				normals.append([0, 1, 0])
				normals.append([0, 1, 0])

				# Calculate tangents
				deltaPos1 = [vertices[v2][i] - vertices[v1][i] for i in range(3)]
				deltaPos2 = [vertices[v3][i] - vertices[v1][i] for i in range(3)]
				deltaUV1 = [1, 0]  # Assuming horizontal texture mapping
				deltaUV2 = [0, 1]  # Assuming vertical texture mapping

				r = 1.0 / (deltaUV1[0] * deltaUV2[1] - deltaUV1[1] * deltaUV2[0])
				tangent = [(deltaPos1[0] * deltaUV2[1] - deltaPos2[0] * deltaUV1[1]) * r,
						(deltaPos1[1] * deltaUV2[1] - deltaPos2[1] * deltaUV1[1]) * r,
						(deltaPos1[2] * deltaUV2[1] - deltaPos2[2] * deltaUV1[1]) * r]
				tangents.append(tangent)

	return vertices, faces, normals, tangents

# Function to write a .obj file
def write_obj_file(vertices, faces, normals, tangents, filepath):
	with open(filepath, 'w') as f:
		for v in vertices:
			f.write(f"v {v[0]} {v[1]} {v[2]}\n")
		for tan in tangents:
			f.write(f"vt {tan[0]} {tan[1]} {tan[2]}\n")
		for norm in normals:
			f.write(f"vn {norm[0]+1} {norm[1]+1} {norm[2]+1}\n")
		for face in faces:
			f.write(f"f {face[0]+1} {face[1]+1} {face[2]+1}\n")

# Generate cloth mesh and write .obj file
size = 10
vertices, faces, normals, tangents = generate_cloth_mesh(size)
write_obj_file(vertices, faces, normals, tangents, 'cloth.obj')