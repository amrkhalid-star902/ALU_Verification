

class alu_driver extends uvm_driver#(alu_seq_item);
  `uvm_component_utils(alu_driver)
  
  virtual alu_if vif;
  alu_seq_item item;
  
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_driver", uvm_component parent);
    
    super.new(name, parent);
    `uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_HIGH)
    
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_HIGH)
    
    if(!(uvm_config_db #(virtual alu_if)::get(this, "*", "vif", vif))) begin
      `uvm_error("DRIVER_CLASS", "Failed to get VIF from config DB!")
    end
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    
    super.connect_phase(phase);
    `uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_HIGH)
    
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    
    super.run_phase(phase);
    `uvm_info("DRIVER_CLASS", "Inside Run Phase!", UVM_HIGH)
    
    forever begin
      item = alu_seq_item::type_id::create("item"); 
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();
    end
    
  endtask: run_phase
  
  
  //--------------------------------------------------------
  //[Mehod] Drive
  //--------------------------------------------------------
  task drive(alu_seq_item trans);
    
    vif.valid_in <= 1'b1;
	vif.src1     <= trans.src1_m;
	vif.src2     <= trans.src2_m;
    vif.src3     <= trans.src3_m;
	vif.op_code  <= trans.op_code_m;
	vif.srcCy    <= trans.srcCy_m;
	vif.srcAc    <= trans.srcAc_m;
    vif.bit_in   <= trans.bit_in_m;
    
    repeat(4) begin
      
      @(posedge vif.clk);
    
    end
    
    vif.valid_in <= 1'b0;
	vif.src1     <= 0;
	vif.src2     <= 0;
    vif.src3     <= 0;
	vif.op_code  <= 0;
	vif.srcCy    <= 0;
	vif.srcAc    <= 0;
    vif.bit_in   <= 0;
			
  endtask: drive
  
  
endclass: alu_driver
