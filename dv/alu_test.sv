//`timescale 1ns/10ps

class alu_test extends uvm_test;

  `uvm_component_utils(alu_test)

  alu_env env;
  alu_seq seq;
  bit     phase_ended_m;
  uvm_table_printer m_printer;

  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_test", uvm_component parent);
    
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
    
  endfunction: new

  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
  
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)

    env = alu_env::type_id::create("env", this);
    m_printer = new();

  endfunction: build_phase

  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
  
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)

  endfunction: connect_phase

  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    
    super.run_phase(phase);
    `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)

    phase.raise_objection(this);


    repeat(60)begin
	
      //test_seq
      seq = alu_seq::type_id::create("seq");
      seq.start(env.agnt.seqr);
      #2;
      //$display("From Test progress");
	  
    end
    
    phase.drop_objection(this);

  endtask: run_phase
  
	virtual function void phase_ready_to_end(uvm_phase phase);
		const int unsigned watchdog = 20;
		super.phase_ready_to_end(phase);
		if(phase.is(uvm_run_phase::get())) begin
			if(!phase_ended_m) begin
				phase.raise_objection(this);
				fork begin
					repeat(watchdog) begin
					#1ns;
					end
					phase_ended_m = 1;
					phase.drop_objection(this);
				end
				join_none
			end
		end
	endfunction 
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);

     `uvm_info(get_full_name(), "Printing test topology", UVM_NONE)
      uvm_top.print_topology();

  endfunction

  

endclass: alu_test
