# Vector Processor
Our project is a 512-bit vector processor for integers with three sections: a register file with four 512-bit arrays, a math unit with addition and multiplication capabilities and a memory.
# Tools
In this project, only Verilog language is used and you can run it on Modelsim tool.
# Implementation Details
The code of this project includes 5 modules for hardware implementation and a test bench module for testing the project.

Register file module: In addition to the inputs and outputs of the registers, this module also receives the clock input and number of the registers and the load control bit.
```
registerfile (input clk, input [2:0] regnum, input load, input [511:0] in_A1, in_A2, in_A3, in_A4, output reg [511:0] out_A1, out_A2, out_A3, out_A4);
```
ALU: This module is our math unit with add and mul control inputs to perform addition or multiplication on two register inputs and store the result on another two registers.
```
ALU (input add, mul, input [511:0] A1, A2, output reg [511:0] A3, A4);
```
Memory: In this section, in addition to load, store, clock, registernumber and address inputs, and the inputs and outputs connected to the registers, there is invalidregnum output to measure the correctness of the address.
```
mem (input clk, load, store, input [8:0] address, input [2:0] regnum, input [511:0] out_A1, out_A2, out_A3, out_A4, output reg [511:0] in_A1, in_A2, in_A3, in_A4, output reg invalidmemaddress);
```
Multiplexer: The reason for using multiplexer is given in the project description file.
```
mux (input [511:0] a, b, input control, output reg [511:0] out);
```
cpu: This module contains the hardwares created by the previous modules and we will finally take samples from this module for testing.<br />

tb: This module is test bench and we use it for testing modules.

For more information about the modules, you can refer to the project description file.

# How to Run
First step is cloning this repository
```
git clone https://github.com/AmirhoseinM82/dsd-final-jobrani.git / cd stack-based-alu
```
next open files with modelsim, compile and simulate project.<br />
Note that the main module is the test bench module.

# Results

 ![Screenshot (304)](https://github.com/AmirhoseinM82/dsd-final-jobrani/assets/119614563/dc184dc5-810c-48c0-916e-08839fecded0)
 ![Screenshot (305)](https://github.com/AmirhoseinM82/dsd-final-jobrani/assets/119614563/c4a02578-5518-43db-876a-c7127161c7db)
 ![Screenshot (308)](https://github.com/AmirhoseinM82/dsd-final-jobrani/assets/119614563/9a305827-056b-4a82-bcbf-3db2611222cd)
 ![Screenshot (307)](https://github.com/AmirhoseinM82/dsd-final-jobrani/assets/119614563/f65e2f41-e42e-487e-9b41-e50f202bcfee)

# Author
Amirhosein Mirdariyan 401106606




 
 
