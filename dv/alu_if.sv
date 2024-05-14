

interface alu_if(

  input clk,
  input reset
  
);
	
  logic [3:0] op_code;
  logic [7:0] src1;
  logic [7:0] src2;
  logic [7:0] src3;
  logic       srcCy;
  logic       srcAc;
  logic       bit_in;
  logic       valid_in;
  logic [7:0] des1;
  logic [7:0] des2;
  logic [7:0] des3;
  logic [7:0] des_acc;
  logic [7:0] sub_result;
  logic       desCy;
  logic       desAC;
  logic       desOv;
  logic       valid_out;
  
  
endinterface: alu_if 
