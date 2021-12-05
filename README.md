# ECSG - The Friendly CSG Plugin

This plugin is a collection of custom CSG compatible presets, generators and utilities to speed up whiteboxing. 

# Alpha 1

This plugin is freshly created. It is not stable by any means. Please make sure to backup any work before using this plugin or use it in a freshly created project only.
Feel free to open an issue if you encounter bugs or odd behaviour. This plugin was made for Godot 3.4. Other versions may work as well.

### Known Issues

- the Godot autoload system prevents the plugin from loading, while I will sort this out in the next commits, in the meantime you may need to add an AutoLoad in Project Settings > Autoloads name `ECSG` that points to the file `addons/e_csg_plugin/ecsg.gd`

# Features

### Categories

The plugin provides several categories of presets

### Useful Whitebox Shapes

 Cones, Blocks, Sphere, Cylinders, Free-Form-Block, Stairs, Ramps, Terrain, Stars, NGons and more. Most of them with additional options and/or in editor gizmos for easy handling

 ### CSG Compatible

All shapes are in general fully compatible with the built in CSG system of Godot

### Colorful

You can easily switch between 6 Prototype colors and 16 diffuse colors (PICO-8). Additionally, you can set up easily your own materials

### Collision

All shapes have collision enabled by default

### Terrain Edit

You can edit the terrain shape directly inside the 3d viewport. 

# More to come

I will add more presets and functionality. Make sure to check for updates.

# Contribution

Feel free to provide your own shape presets. A tutorial how to create one, will come with the stable release

# 3rd Party Licenses

- Kenney Prototype Textures CC0 (https://kenney.nl)