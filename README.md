# :video_game: ​FPGA-based 3D Renderer :space_invader:
This is the Final Project of ECE385 in UIUC 

implemented on DE2-115 FPGA board

Team Member: [debugevent90901](https://github.com/debugevent90901) :sweat_smile:, [TaKeTube](https://github.com/TaKeTube) :tanabata_tree:

**This is only a project that is for learning and fun, not industrial productive.**

**For complete Quartus Project Files, please refer to https://github.com/TaKeTube/FPGA-based-3D-renderer-Project**

## 1. Description :page_facing_up:
​	This project implements a simple graphics pipeline on FPGA. It can render 3D objects with FPGA, and control the position of camera, rotations of the object through keyboard.
​	It uses on-chip memory to store the information of the 3D object and 2 frame buffers, and uses NIOS-II as a controller to communicate with the keyboard.
​	Other features include simple clipping, .obj loading, etc.

For more details, see report.pdf and proposal.pdf.

+   In Final folder are the final finished files, all well-commented.
+    In MidPoint folder are existing files before mid point check, not fully functioned and may be messy. Not all files are commented.

## 2. Third-Party Libraries :rocket:
Original contributor: [WangXuan95/Verilog-FixedPoint](https://github.com/WangXuan95/Verilog-FixedPoint)
Instead of floating point, we choose to use fixed point number. This is the only outer existing library we used, and we make certian modification to it, see details in /Final/trigonometric_lib.sv.

## 3. Design & Implementation Details :page_with_curl:

**Top Block Diagram**

<img src="https://github.com/debugevent90901/FPGA-based-3D-graphics-renderer/blob/main/topBD.png?raw=true" style="zoom: 20%;" />

See the **Final Report** and **Final Proposal** for detailed description.

## 4. Operations​ :video_game:

| op        | description         | op    | description         |
| --------- | ------------------- | ----- | ------------------- |
| **↑**     | Forward (camera)    | ↓     | Backward (camera)   |
| **←**     | Left (camera)       | **→** | Right (camera)      |
| **w**     | Rotate along y axis | **s** | Rotate along y axis |
| **a**     | Rotate along x axis | **d** | Rotate along x axis |
| **q**     | Rotate along z axis | **e** | Rotate along z axis |
| **key 0** | Reset               |       |                     |

To load a model (.obj format), please use the python script inside the ObjConvertScript folder and follow the description in Final Report & Comments in the code.

When the screen is locked, you should push key 0 to reset.


## 5. Final Result :computer:

#### Cube

<img src="https://github.com/debugevent90901/FPGA-based-3D-graphics-renderer/blob/main/Result1.gif?raw=true" alt="Result1.gif" style="zoom:80%;" />

#### Dodecahedron

<img src="https://github.com/debugevent90901/FPGA-based-3D-graphics-renderer/blob/main/Result2.gif?raw=true" alt="Result2.gif" style="zoom:80%;" />

#### Stanford Bunny :rabbit2:

Unfortunately, this model failed to rotate smoothly because of the unconverging timing

<img src="https://github.com/debugevent90901/FPGA-based-3D-graphics-renderer/blob/main/Result3.gif?raw=true" alt="Result3.gif" style="zoom: 67%;" />