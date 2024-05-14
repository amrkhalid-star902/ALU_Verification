
module oc8051_multiply (clk, rst, enable, valid_out, src1, src2, des1, des2, desOv);
//
// this module is part of alu
// clk          (in)
// rst          (in)
// enable       (in)
// src1         (in)  first operand
// src2         (in)  second operand
// des1         (out) first result
// des2         (out) second result
// desOv        (out) Overflow output
//
 
input clk, rst, enable;
input [7:0] src1, src2;
output desOv, valid_out;
output [7:0] des1, des2;
 
// wires
wire [15:0] mul_result1, mul_result, shifted;
 
// real registers
reg [1:0] cycle;
reg [15:0] tmp_mul;
 
assign mul_result1 = src1 * (cycle == 2'h0 ? src2[7:6] 
                           : cycle == 2'h1 ? src2[5:4]
                           : cycle == 2'h2 ? src2[3:2]
                           : src2[1:0]);
 
assign shifted = (cycle == 2'h0 ? 16'h0 : {tmp_mul[13:0], 2'b00});
assign mul_result = mul_result1 + shifted;
assign des1 = mul_result[15:8];
assign des2 = mul_result[7:0];
assign desOv = | des1;
assign valid_out = cycle == 3'h3;
 
always @(posedge clk or posedge rst)
begin
  if (rst) begin
    cycle <= #1 2'b0;
    tmp_mul <= #1 16'b0;
  end else begin
    if (enable) cycle <= #1 cycle + 2'b1;
    tmp_mul <= #1 mul_result;
  end
end
 
endmodule
