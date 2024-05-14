

class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)
  
  virtual alu_if vif;
  alu_seq_item item;
  
  uvm_analysis_port #(alu_seq_item) monitor_port;
  
    covergroup cg_alu_format;
	
		cp_alu_opcode: coverpoint item.op_code_m {
		  
          bins opcode_nop   = {4'b0000};
          bins opcode_add   = {4'b0001};
          bins opcode_sub   = {4'b0010};
          bins opcode_mul   = {4'b0011};
          bins opcode_div   = {4'b0100};
          bins opcode_da    = {4'b0101};
          bins opcode_not   = {4'b0110};
          bins opcode_and   = {4'b0111};
          bins opcode_xor   = {4'b1000};
          bins opcode_or    = {4'b1001};
          bins opcode_rl    = {4'b1010};
          bins opcode_rlc   = {4'b1011};
          bins opcode_rr    = {4'b1100};
          bins opcode_rrc   = {4'b1101};
          bins opcode_inc   = {4'b1110};
          bins opcode_xch   = {4'b1111};
		  
		}
		
		cp_alu_operand1: coverpoint item.src1_m {
		  bins operand1_0 = {8'h00};
		  bins operand1_1 = {8'h01};
		  bins operand1_2 = {[8'h02:8'hfd]};
		  bins operand1_3 = {8'hfe};
		  bins operand1_4 = {8'hff};
		}
		
		cp_alu_operand2: coverpoint item.src2_m {
		  //bins operand2_0 = {8'h00};
		  bins operand2_1 = {[8'h00:8'h01]};
		  bins operand2_2 = {[8'h02:8'hfd]};
		  bins operand2_3 = {8'hfe};
		  bins operand2_4 = {8'hff};
		}
          
		/*cp_alu_operand3: coverpoint item.src3_m {
		  bins operand3_0 = {8'h00};
		  bins operand3_1 = {8'h01};
		  bins operand3_2 = {[8'h02:8'hfd]};
		  bins operand3_3 = {8'hfe};
		  bins operand3_4 = {8'hff};
		}*/
		
		//cc_alu_format:cross cp_alu_opcode, cp_alu_operand1, cp_alu_operand2;
	
	endgroup
	
	
	covergroup cg_alu_result;
	
		cp_alu_result: coverpoint item.des_acc_m {
		  //bins result_0 = {8'h00};
		  bins result_1 = {[8'h00:8'h01]};
		  bins result_2 = {[8'h02:8'hfd]};
		  bins result_3 = {8'hfe};
		  bins result_4 = {8'hff};
		}
	
	endgroup
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_monitor", uvm_component parent);
    super.new(name, parent);
    cg_alu_format = new();
    cg_alu_result = new();
    
    `uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)
    
    monitor_port = new("monitor_port", this);
    
    
    if(!(uvm_config_db #(virtual alu_if)::get(this, "*", "vif", vif))) begin
      `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!")
    end
    
  endfunction: build_phase
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_HIGH)
    
    forever begin
      item = alu_seq_item::type_id::create("item");
      
      wait(!vif.reset);
      
      if(vif.valid_in) begin
        
        item.src1_m      = vif.src1;
        item.src2_m      = vif.src2;
        item.src3_m      = vif.src3;
        item.op_code_m   = vif.op_code;
        item.srcCy_m     = vif.srcCy;
        item.srcAc_m     = vif.srcAc;
        item.bit_in_m    = vif.bit_in;
        wait(vif.valid_out);
      	item.des_acc_m   = vif.des_acc;
	  	item.des2_m      = vif.des2;
        item.desCy_m     = vif.desCy;
        item.desOv       = vif.desOv;
      	cg_alu_format.sample();
	  	cg_alu_result.sample();
        monitor_port.write(item);
      
      end
      
      
      @(posedge vif.clk);
      
    end
        
  endtask: run_phase
  
  
endclass: alu_monitor
