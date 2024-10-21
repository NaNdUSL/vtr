# Cloth Simulation with NAU3D Engine

This project is a basic implementation of cloth physics using the [NAU3D Engine](https://github.com/Nau3D/nau). It's based on a particle-based system to simulate the cloth behavior, with simple physics interactions.

## Features
- **Cloth Physics Simulation**: The cloth mesh is simulated using a particle system that allows for realistic movement and deformation.
- **Sphere-Object Interaction**: The cloth responds to intersections with a sphere object, demonstrating simple collision detection.
- **Self-Intersection Detection**: Includes a basic implementation for detecting self-intersections within the cloth mesh, preventing unrealistic overlaps.

## Implementations
- **[Original Implementation](./original_implementation)**: In this version, all the primary calculations, such as vertex positions (based on intersections and other forces) and their normals, are handled within the vertex shader. It follows a more traditional approach, where each vertex's behavior and physics interactions are computed directly in the vertex shader.
- **[Concurrent Implementation](./concurrent_version)**: This version leverages the compute shader for parallel processing. By offloading heavy calculations (such as particle interactions and physics simulations) to the compute shader, it significantly improves performance and scalability, especially with larger meshes. This allows for more efficient cloth simulation with concurrent calculations for the vertices.

## Other Scripts
-  There is also a script in python that generates the necessary content for the cloth's mesh. 

## Requirements
- **[NAU3D Engine](https://github.com/Nau3D/nau)**: This project is built on the NAU3D engine, which must be installed.
- **Python3**: It is only necessary for the mesh generator.

## Future Improvements
- Improve the cloth’s self-intersection handling for more realistic simulations.
- Add more complex collision detection and response systems.
- Implement more advanced physics properties, like tearing or stretching of the cloth.

## Authors
- [NaNdUSL](https://github.com/NaNdUSL)
- [DavidsonMatz](https://github.com/DavidsonMatz)
- [Rúben](https://github.com/cosinhar)
