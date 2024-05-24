import xml.etree.ElementTree as ET

class ClothGenerator:

	def __init__(self, height=0, width=0, divisions_h=1, divisions_v=1, vert_stuck=[]):

		self.height = height
		self.width = width
		self.divisions_h = divisions_h
		self.divisions_v = divisions_v
		self.vertices = []
		self.text_coords = []
		self.normals = []
		self.faces_front = []
		self.faces_back = []
		self.vert_stuck = vert_stuck

	# Generate a mesh of cloth into a .obj file (we only use the vertices from the generated file)
	def generate_cloth_mesh(self):

		text_coords_front = []
		text_coords_back = []

		# Generate vertices
		for z in range(self.divisions_h):

			for x in range(self.divisions_v):

				self.vertices.append([x * self.width / self.divisions_h, 0, z * self.height / self.divisions_v])

				text_coords_front.append([z / (self.divisions_v - 1), x / (self.divisions_h - 1)])
				text_coords_back.append([((-z - 1) % self.divisions_v) / (self.divisions_v - 1), ((-x - 1) % self.divisions_h) / (self.divisions_h - 1)])

		self.text_coords = text_coords_front + text_coords_back
		self.normals = [[0, 1, 0], [0, -1, 0]]

		# Generate faces
		for z in range(self.divisions_h - 1):

			for x in range(self.divisions_v - 1):

				v1 = z * self.divisions_h + x
				v2 = z * self.divisions_h + x + 1
				v3 = (z + 1) * self.divisions_h + x
				v4 = (z + 1) * self.divisions_h + x + 1

				self.faces_front.append([v1, v3, v2])
				self.faces_front.append([v2, v3, v4])

	def generate_cloth_adj(self):

		triangle_c_h = self.width / self.divisions_h
		triangle_c_v = self.height / self.divisions_v
		hipotenuse = (triangle_c_h ** 2 + triangle_c_v ** 2) ** 0.5
		adj_list = []

		for j in range(self.divisions_v):
			
			for i in range(self.divisions_h):

				indices = []

				for x in range(-1, 2):

					if i + x >= 0 and i + x < self.divisions_h and j - 1 >= 0:

						if 0 != x:

							indices.append(((i + x) + (j - 1) * self.divisions_h, hipotenuse))

						elif i + x >= 0 and i + x < self.divisions_h and j - 1 >= 0:

							indices.append(((i + x) + (j - 1) * self.divisions_h, triangle_c_h))

					else:
						
						indices.append((-1, -1))

				for x in range(-1, 2):

					if i + x >= 0 and i + x < self.divisions_h and 0 != x:

						indices.append(((i + x) + j * self.divisions_h, triangle_c_v))
					
					else:
						
						indices.append((-1, -1))

				for x in range(-1, 2):

					if i + x >= 0 and i + x < self.divisions_h and j + 1 < self.divisions_v:

						if 0 != x:

							indices.append(((i + x) + (j + 1) * self.divisions_h, hipotenuse))

						elif i + x >= 0 and i + x < self.divisions_h and j + 1 < self.divisions_v:

							indices.append(((i + x) + (j + 1) * self.divisions_h, triangle_c_h))

					else:
						
						indices.append((-1, -1))

				# indices.sort(key=lambda x: (x[1], x[0]))

				adj_list.append(indices)

		return adj_list

	# Function to write a .obj file
	def write_obj_file(self, filepath_obj):

		# print(f"Writing .obj file to {filepath_obj}")

		with open(filepath_obj, 'w') as f:

			index = 0

			for v in self.vertices:

				f.write(f"v {v[0]} {index} {v[2]}\n")
				index += 1

			for tex in self.text_coords:

				f.write(f"vt {tex[0]} {tex[1]}\n")

			for norm in self.normals:

				f.write(f"vn {norm[0]} {norm[1]} {norm[2]}\n")

			for face in self.faces_front:

				f.write(f"f {face[0]+1}/{face[0]+1}/1 {face[1]+1}/{face[1]+1}/1 {face[2]+1}/{face[2]+1}/1\n")

			for face in self.faces_back:

				f.write(f"f {face[0]+1}/{face[0]+1}/2 {face[1]+1}/{face[1]+1}/2 {face[2]+1}/{face[2]+1}/2\n")

		with open('../buffers/cloth_buffer_info.txt', 'w') as f:

			elem_count = 0

			for v in self.vertices:

				f.write(f"{v[0]} {v[1]} {v[2]} 1.0\n")
				elem_count += 1

		with open('../buffers/cloth_adj_info.txt', 'w') as f:

			adj = self.generate_cloth_adj()

			for index in range(self.divisions_v * self.divisions_h):

				# print(adj[index])

				for i in range(9):

					f.write(f"{adj[index][i][1]}\n")
				
				# f.write(f"\n")

	
		with open('../buffers/cloth_normals_info.txt', 'w') as f:

			for _ in self.vertices:

				f.write(f"0.0 1.0 0.0 0.0\n")

		with open('../buffers/cloth_texture_coords_info.txt', 'w') as f:

			for tex in self.text_coords:

				f.write(f"{tex[0]} {tex[1]}\n")

		with open('../buffers/cloth_forces_buffer.txt', 'w') as f:

			for _ in self.vertices:

				f.write(f"0.0 0.0 0.0 0.0\n")
		
		with open('../buffers/cloth_velocities_buffer.txt', 'w') as f:

			for _ in self.vertices:

				f.write(f"0.0 0.0 0.0 0.0\n")
		
		with open('../buffers/cloth_stuck_vert.txt', 'w') as f:

			f.write(f"{len(self.vert_stuck)}\n")

			for ind in self.vert_stuck:

				f.write(f"{ind}\n")

		# Update the number of elements in the .mlib file
		tree = ET.parse('../cloth.mlib')
		root = tree.getroot()

		values = {'clothBuffer': {'x': str(self.divisions_v * self.divisions_h), 'y': '1', 'z': '1'}, 'adjBuffer': {'x': str(self.divisions_v * self.divisions_h * 9), 'y': '1', 'z': '1'}, 'stuckVertBuffer': {'x': str(1 + len(self.vert_stuck)), 'y': '1', 'z': '1'}, 'normalsBuffer': {'x': str(self.divisions_v * self.divisions_h), 'y': '1', 'z': '1'}, 'textureBuffer': {'x': str(self.divisions_v * self.divisions_h), 'y': '1', 'z': '1'}, 'forcesBuffer': {'x': str(self.divisions_v * self.divisions_h), 'y': '1', 'z': '1'}, 'velocitiesBuffer': {'x': str(self.divisions_v * self.divisions_h), 'y': '1', 'z': '1'}}

		# Find the buffers element
		buffers = root.find('buffers')
		print(values['stuckVertBuffer'])

		for buffer in buffers.findall('buffer'):
			# Get the name of the buffer
			name = buffer.get('name')
			# If the name is in the values dictionary, update the DIM values
			if name in values:
				print(name)
				dim = buffer.find('DIM')
				dim.set('x', values[name]['x'])
				dim.set('y', values[name]['y'])
				dim.set('z', values[name]['z'])

		# Write the changes back to the file
		tree.write('../cloth.mlib')

		with open('../cloth.xml', 'r') as f:
			
			lines = f.readlines()
			xml_content = "".join(lines)

			root_1 = ET.fromstring(xml_content)
			tree_1 = ET.ElementTree(root_1) # Create an ElementTree object
			# Find and update width and height attributes
			for attribute in tree_1.iter('attribute'):

				if attribute.attrib['name'] == 'width':

					attribute.attrib['value'] = str(self.divisions_h)

				elif attribute.attrib['name'] == 'height':

					attribute.attrib['value'] = str(self.divisions_v)

			# Write changes back to the XML file
			tree_1.write('../cloth.xml')

# Generate cloth mesh and write .obj file
divisions_h = 25
divisions_v = 25
height = 1
width = 1
cloth_gen = ClothGenerator(height, width, divisions_h, divisions_v, [0, divisions_h - 1, (divisions_v * divisions_h) - divisions_h, (divisions_v * divisions_h) - 1])
cloth_gen.generate_cloth_mesh()
cloth_gen.write_obj_file('../objects/cloth.obj')