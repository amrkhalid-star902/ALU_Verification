//`timescale 1ns/10ps

typedef enum bit [3:0]{

  ALU_NOP   = 4'b0000,
  ALU_ADD   = 4'b0001,
  ALU_SUB   = 4'b0010,
  ALU_MUL   = 4'b0011,
  ALU_DIV   = 4'b0100,
  ALU_DA    = 4'b0101,
  ALU_NOT   = 4'b0110,
  ALU_AND   = 4'b0111,
  ALU_XOR   = 4'b1000,
  ALU_OR    = 4'b1001,
  ALU_RL    = 4'b1010,
  ALU_RLC   = 4'b1011,
  ALU_RR    = 4'b1100,
  ALU_RRC   = 4'b1101,
  ALU_INC   = 4'b1110,
  ALU_XCH   = 4'b1111

}opcodes;


class alu_seq_item extends uvm_sequence_item;

    rand bit [3 : 0] op_code_m;
    rand bit [7 : 0] src1_m;
    rand bit [7 : 0] src2_m;  
    rand bit [7 : 0] src3_m; 
  	rand bit         srcCy_m;
    rand bit         srcAc_m;
	rand bit         bit_in_m;
         bit [7 : 0] des_acc_m;
         bit [7 : 0] des2_m;
         bit         desCy_m;
         bit         desOv;
  
  
	constraint src1_constr{
		
		src1_m dist {
		
			8'h00            :/ 1,
			8'h01            :/ 1,
			[8'h02 : 8'hfd]  :/ 10,
			8'hfe            :/ 1,
			8'hff            :/ 1
		
		};	
	
	}
  
	constraint src2_constr{
		
		src2_m dist {
		
			8'h00            :/ 1,
			8'h01            :/ 1,
			[8'h02 : 8'hfd]  :/ 10,
			8'hfe            :/ 1,
			8'hff            :/ 1
		
		};	
	
	}
  

	constraint src3_constr{
		
		src1_m dist {
		
			8'h00            :/ 1,
			8'h01            :/ 1,
			[8'h02 : 8'hfd]  :/ 10,
			8'hfe            :/ 1,
			8'hff            :/ 1
		
		};	
	
	}
  
  `uvm_object_utils_begin(alu_seq_item)
    `uvm_field_int(op_code_m, UVM_ALL_ON)
    `uvm_field_int(src1_m, UVM_ALL_ON)
    `uvm_field_int(src2_m, UVM_ALL_ON)
    `uvm_field_int(src3_m, UVM_ALL_ON)
    `uvm_field_int(srcCy_m, UVM_ALL_ON)
    `uvm_field_int(srcAc_m, UVM_ALL_ON)
    `uvm_field_int(bit_in_m, UVM_ALL_ON)
    `uvm_field_int(des_acc_m, UVM_ALL_ON)
    `uvm_field_int(des2_m, UVM_ALL_ON)
    `uvm_field_int(desCy_m, UVM_ALL_ON)
    `uvm_field_int(desOv, UVM_ALL_ON)
  `uvm_object_utils_end
  
   function new(string name = "alu_seq_item");
   
		super.new(name);
   
   endfunction
  
endclass
