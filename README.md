# Toon Water Shader

Water shader styled after GameCube-era water effects. Created from scratch using Unity ShaderLab. All textures created by me except for *WaterDistortion.png*, sourced from [this tutorial](https://roystan.net/articles/toon-water.html). All code is my own, except for code snipped modified from the same tutorial. 

Heavily inspired by the video [How scrolling textures gave Super Mario Galaxy 2 its charm](https://youtu.be/8rCRsOLiO7k) by Jasper Ashworth, who demonstrated how Nintendo utilized textures to create some great effects. 

Features customizable scroll speed, distortion effects, and surface noise generation.

Future additions include foam around the rim, simulated waves, transparency, and splashes for objects moving through the water.

Created as a project for Computer Graphics II. Find the ToonWater.shader source code under "/ToonWaterShader_UnityProject/Assets/Shaders/"

Unity v2019.4.16f1

<img src="images/WaterShaderScroll.gif" alt="drawing" width="600"/><br />


# To Run on Windows:

* Simply downloaded the latest version from the [releases tab](https://github.com/jackyyym/toon-water-shader/releases), exctract, and run  "Graphics 2 Shader Project.exe"

# To Open This Project:

1. Download Unity v2019.4.16f1 either directly or via Unity Hub [here](https://unity3d.com/get-unity/download)
2. Clone or download a copy of this repository
3. Open the project folder "ToonWaterShader_UnityProject" in the Unity Engine
	* To modify the Shader Parameters, simply navigate to the "Water" object in the object hierarchy and find the ToonWater material in the inspector to the right.


