module registerfile (input clk, input [2:0] regnum, input load, input [511:0] in_A1, in_A2, in_A3, in_A4, output reg [511:0] out_A1, out_A2, out_A3, out_A4);

always @(posedge clk) begin

    if(regnum == 3'b000) begin
        if(load == 1)
            out_A1 = in_A1;
    end else if(regnum == 3'b001) begin
        if(load == 1)
            out_A2 = in_A2;
    end else if(regnum == 3'b010) begin
        if(load == 1)
            out_A3 = in_A3;
    end else if(regnum == 3'b011) begin
        if(load == 1)
            out_A4 = in_A4;
    end else begin
        out_A3 = in_A3;
        out_A4 = in_A4;
    end
 
end

endmodule

module ALU (input add, mul, input [511:0] A1, A2, output reg [511:0] A3, A4);

always @(*) begin

    if((add == 1) && (mul == 0)) begin
        {A4, A3} = $signed(A1) + $signed(A2);
    end else if((add == 0) && (mul == 1)) begin
        {A4, A3} = $signed(A1) * $signed(A2);
    end

end

endmodule

module mem (input clk, load, store, input [8:0] address, input [2:0] regnum, input [511:0] out_A1, out_A2, out_A3, out_A4, output reg [511:0] in_A1, in_A2, in_A3, in_A4, output reg invalidmemaddress);

reg [31:0] memory [0:511];

    always @(posedge clk) begin
        if(address <= 9'd496) begin
            invalidmemaddress = 0;
            if((load ==1) && (store == 0)) begin
                if(regnum == 3'b000) begin
                    in_A1 = {memory[address], memory[address+1], memory[address+2], memory[address+3], memory[address+4], memory[address+5], memory[address+6], memory[address+7], memory[address+8], memory[address+9], memory[address+10], memory[address+11], memory[address+12], memory[address+13], memory[address+14], memory[address+15]};
                end else if(regnum == 3'b001) begin
                    in_A2 = {memory[address], memory[address+1], memory[address+2], memory[address+3], memory[address+4], memory[address+5], memory[address+6], memory[address+7], memory[address+8], memory[address+9], memory[address+10], memory[address+11], memory[address+12], memory[address+13], memory[address+14], memory[address+15]};
                end else if(regnum == 3'b010) begin
                    in_A3 = {memory[address], memory[address+1], memory[address+2], memory[address+3], memory[address+4], memory[address+5], memory[address+6], memory[address+7], memory[address+8], memory[address+9], memory[address+10], memory[address+11], memory[address+12], memory[address+13], memory[address+14], memory[address+15]};
                end else if(regnum == 3'b011) begin
                    in_A4 = {memory[address], memory[address+1], memory[address+2], memory[address+3], memory[address+4], memory[address+5], memory[address+6], memory[address+7], memory[address+8], memory[address+9], memory[address+10], memory[address+11], memory[address+12], memory[address+13], memory[address+14], memory[address+15]};
                end
            end else if((load ==0) && (store == 1)) begin
                if(regnum == 3'b000) begin
                    {memory[address], memory[address+1], memory[address+2], memory[address+3], memory[address+4], memory[address+5], memory[address+6], memory[address+7], memory[address+8], memory[address+9], memory[address+10], memory[address+11], memory[address+12], memory[address+13], memory[address+14], memory[address+15]} = out_A1;
                end else if(regnum == 3'b001) begin
                    {memory[address], memory[address+1], memory[address+2], memory[address+3], memory[address+4], memory[address+5], memory[address+6], memory[address+7], memory[address+8], memory[address+9], memory[address+10], memory[address+11], memory[address+12], memory[address+13], memory[address+14], memory[address+15]} = out_A2;
                end else if(regnum == 3'b010) begin
                    {memory[address], memory[address+1], memory[address+2], memory[address+3], memory[address+4], memory[address+5], memory[address+6], memory[address+7], memory[address+8], memory[address+9], memory[address+10], memory[address+11], memory[address+12], memory[address+13], memory[address+14], memory[address+15]} = out_A3;
                end else if(regnum == 3'b011) begin
                    {memory[address], memory[address+1], memory[address+2], memory[address+3], memory[address+4], memory[address+5], memory[address+6], memory[address+7], memory[address+8], memory[address+9], memory[address+10], memory[address+11], memory[address+12], memory[address+13], memory[address+14], memory[address+15]} = out_A4;
                end
            end
        end else begin
            invalidmemaddress = 1;
        end
    end

endmodule

module mux (input [511:0] a, b, input control, output reg [511:0] out);

    always @(*) begin
        if(control == 0)
            out = a;
        else
            out = b;
    end

endmodule

module cpu (input clk ,input [8:0] address, input [511:0] dip_A1, dip_A2, input [2:0] regnum, input loadreg, initialize, load, store, add, mul, output [511:0] q_1, q_2, q_3, q_4, output invalidmemaddress);

wire [511:0] mux1, mux2, mux3, mux4, in1_A3, in1_A4, in2_A1, in2_A2, in2_A3, in2_A4;

registerfile regs(clk, regnum, loadreg, mux1, mux2, mux3, mux4, q_1, q_2, q_3, q_4);
ALU alu(add, mul, q_1, q_2, in1_A3, in1_A4);
mem memory(clk, load, store, address, regnum, q_1, q_2, q_3, q_4, in2_A1, in2_A2, in2_A3, in2_A4, invalidmemaddress);
mux muxa1(in2_A1, dip_A1, initialize, mux1);
mux muxa2(in2_A2, dip_A2, initialize, mux2);
mux muxa3(in1_A3, in2_A3, ~(add || mul), mux3);
mux muxa4(in1_A4, in2_A4, ~(add || mul), mux4);

endmodule

module tb();

reg [8:0] address;
reg [511:0] dip_A1, dip_A2;
reg [2:0] regnum;
reg loadreg, initialize, load, store, add, mul;
wire [511:0] q_1, q_2, q_3, q_4;
wire invalidmemaddress;

reg clk;
initial
    clk = 0;
always
    #5 clk = ~clk;

cpu processor(clk, address, dip_A1, dip_A2, regnum, loadreg, initialize, load, store, add, mul, q_1, q_2, q_3, q_4, invalidmemaddress);

initial begin
    dip_A1 = 512'd2133; regnum = 3'b000; loadreg= 1; initialize = 1; load = 0; store = 0; add = 0; mul = 0;
    #100 $display("initialize A1:\nA_1 = %d,\nA_2 = %d,\n{A_4,A_3} = %d",$signed(q_1),$signed(q_2),$signed({q_4,q_3}));
    #100 dip_A2 = 512'd65323; regnum = 3'b001; loadreg= 1; initialize = 1; load = 0; store = 0; add = 0; mul = 0;
    #100 $display("initialize A2:\nA_1 = %d,\nA_2 = %d,\n{A_4,A_3} = %d",$signed(q_1),$signed(q_2),$signed({q_4,q_3}));
    #100 address = 9'd45; regnum = 3'b000; loadreg= 0; initialize = 0; load = 0; store = 1; add = 0; mul = 0;
    #100 $display("store A1 in mem[45]:\nA_1 = %d,\nA_2 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_1),$signed(q_2),$signed({q_4,q_3}), invalidmemaddress);
    #100 address = 9'd100; regnum = 3'b001; loadreg= 0; initialize = 0; load = 0; store = 1; add = 0; mul = 0;
    #100 $display("store A2 in mem[100]:\nA_1 = %d,\nA_2 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_1),$signed(q_2),$signed({q_4,q_3}), invalidmemaddress);
    #100 address = 9'd45; regnum = 3'b001; loadreg= 1; initialize = 0; load = 1; store = 0; add = 0; mul = 0;
    #100 $display("load mem[45] in A2:\nA_1 = %d,\nA_2 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_1),$signed(q_2),$signed({q_4,q_3}), invalidmemaddress);
    #100 address = 9'd100; regnum = 3'b000; loadreg= 1; initialize = 0; load = 1; store = 0; add = 0; mul = 0;
    #100 $display("load mem[100] in A1:\nA_1 = %d,\nA_2 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_1),$signed(q_2),$signed({q_4,q_3}), invalidmemaddress);
    #100 address = 9'd500; regnum = 3'b000; loadreg= 0; initialize = 0; load = 0; store = 1; add = 0; mul = 0;
    #100 $display("store A1 in mem[500]:\nA_1 = %d,\nA_2 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_1),$signed(q_2),$signed({q_4,q_3}), invalidmemaddress);
    #100 address = 9'd501; regnum = 3'b000; loadreg= 1; initialize = 0; load = 1; store = 0; add = 0; mul = 0;
    #100 $display("load mem[501] in A1:\nA_1 = %d,\nA_2 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_1),$signed(q_2),$signed({q_4,q_3}), invalidmemaddress);
    #100 regnum = 3'b100; loadreg = 1; initialize = 0; load = 0; store = 0; add = 1; mul = 0;
    #100 $display("addition:\nA_1 = %d,\nA_2 = %d,\n{A_4,A_3} = %d",$signed(q_1),$signed(q_2),$signed({q_4,q_3}));
    #100 regnum = 3'b100; loadreg = 1; initialize = 0; load = 0; store = 0; add = 0; mul = 1;
    #100 $display("multiplication:\nA_1 = %d,\nA_2 = %d,\n{A_4,A_3} = %d",$signed(q_1),$signed(q_2),$signed({q_4,q_3}));
    #100 address = 9'd299; regnum = 3'b010; loadreg= 0; initialize = 0; load = 0; store = 1; add = 0; mul = 0;
    #100 $display("store A3 in mem[299]:\nA_3 = %d,\nA_4 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_3),$signed(q_4),$signed({q_4,q_3}), invalidmemaddress);
    #100 address = 9'd400; regnum = 3'b011; loadreg= 0; initialize = 0; load = 0; store = 1; add = 0; mul = 0;
    #100 $display("store A4 in mem[400]:\nA_3 = %d,\nA_4 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_3),$signed(q_4),$signed({q_4,q_3}), invalidmemaddress);
    #100 address = 9'd299; regnum = 3'b000; loadreg= 1; initialize = 0; load = 1; store = 0; add = 0; mul = 0;
    #100 $display("load mem[299] in A1:\nA_1 = %d,\nA_2 =  %d,\n{A_4,A_3} = %d,\ninvalidmemaddress = %d\n",$signed(q_1),$signed(q_2),$signed({q_4,q_3}), invalidmemaddress);
    #100 dip_A2 = -512'd54229; regnum = 3'b001; loadreg= 1; initialize = 1; load = 0; store = 0; add = 0; mul = 0;
    #100 $display("initialize A2:\nA_1 = %d,\nA_2 = %d,\n{A_4,A_3} = %d",$signed(q_1),$signed(q_2),$signed({q_4,q_3}));
    #100 regnum = 3'b100; loadreg = 1; initialize = 0; load = 0; store = 0; add = 0; mul = 1;
    #100 $display("multiplication:\nA_1 = %d,\nA_2 = %d,\n{A_4,A_3} = %d",$signed(q_1),$signed(q_2),$signed({q_4,q_3}));
    #100 regnum = 3'b100; loadreg = 1; initialize = 0; load = 0; store = 0; add = 1; mul = 0;
    #100 $display("addition:\nA_1 = %d,\nA_2 = %d,\n{A_4,A_3} = %d",$signed(q_1),$signed(q_2),$signed({q_4,q_3}));
    #100 $stop;
end

endmodule