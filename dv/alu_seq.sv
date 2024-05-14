//`timescale 1ns/10ps


class alu_seq extends uvm_sequence;
  `uvm_object_utils(alu_seq)
  
  alu_seq_item pkt;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name= "alu_seq");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
  
  virtual function bit get_trans(alu_seq_item trans);
	
	//Inline constraint
    return (trans.randomize() with {op_code_m inside{
	
		ALU_NOP, ALU_ADD, 
		ALU_SUB, ALU_MUL, 
		ALU_DIV, ALU_DA, 
        ALU_NOT, ALU_AND, 
        ALU_XOR, ALU_OR, 
        ALU_RL,  ALU_RLC,
        ALU_RR,  ALU_RRC,
        ALU_INC, ALU_XCH
	
	};
	});
  
  endfunction
  
  
  //--------------------------------------------------------
  //Body Task
  //--------------------------------------------------------
  task body();
    `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
    
    pkt = alu_seq_item::type_id::create("pkt");
    start_item(pkt);
    if(!get_trans(pkt))
      `uvm_fatal("ALU_SEQ", "Randomized trans failed!")	
    finish_item(pkt);
        
  endtask: body
  
  
endclass: alu_seq



