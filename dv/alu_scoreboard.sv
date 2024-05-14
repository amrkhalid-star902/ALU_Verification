

class alu_scoreboard extends uvm_test;
  `uvm_component_utils(alu_scoreboard)
  
  uvm_analysis_imp #(alu_seq_item, alu_scoreboard) scoreboard_port;
  
  alu_seq_item transactions[$];
  
  logic [8:0] result;
  logic overflow;
  logic [15:0] product;
  logic [7:0]  div;
  logic da_tmp, da_tmp1;
  logic [15:0] inc, dec;
  
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "alu_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
   
    scoreboard_port = new("scoreboard_port", this);
    
  endfunction: build_phase
  
  
  //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    
    super.connect_phase(phase);
    `uvm_info("SCB_CLASS", "Connect Phase!", UVM_HIGH)
    
   
  endfunction: connect_phase
  
  
  //--------------------------------------------------------
  //Write Method
  //--------------------------------------------------------
  function void write(alu_seq_item item);
    
    transactions.push_back(item);
    
  endfunction: write 
  
  
  
  //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    
    super.run_phase(phase);
    `uvm_info("SCB_CLASS", "Run Phase!", UVM_HIGH)
   
    forever begin
      /*
      // get the packet
      // generate expected value
      // compare it with actual value
      // score the transactions accordingly
      */
      alu_seq_item curr_trans;
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
      compare(curr_trans);
      
    end
    
  endtask: run_phase
  
  
  //--------------------------------------------------------
  //Compare : Generate Expected Result and Compare with Actual
  //--------------------------------------------------------
  task compare(alu_seq_item trans);

		`uvm_info("ALU_SB", "Received request transaction", UVM_NONE)
		trans.print();
		
		
        case(trans.op_code_m)
		
			ALU_ADD: begin
			
              result   = (trans.src1_m + trans.src2_m + trans.srcCy_m);
			  overflow = result[7];
			
			end
			
			ALU_SUB: begin
			
              result   = (trans.src1_m - trans.src2_m - trans.srcCy_m);
			  overflow = result[7];
              
			end
          
			ALU_MUL: begin
			
              product   = (trans.src1_m * trans.src2_m);
              result    = product[7:0];
              overflow  = |product[15:8];
              
			end
          
			ALU_DIV: begin
			
              div       = (trans.src1_m / trans.src2_m);
              result    = div;
              overflow  = trans.src2_m == 0;
              
			end
          
			ALU_DA: begin
			
              if(trans.srcAc_m == 1'b1 | trans.src1_m[3:0] > 4'b1001)
              	{da_tmp, result[3:0]} = {1'b0, trans.src1_m[3:0]} + 5'b00110;
              else 
              	{da_tmp, result[3:0]} = {1'b0, trans.src1_m[3:0]};  
                
              
              if(trans.srcCy_m | da_tmp | trans.src1_m[7:4] > 4'b1001)
              	{da_tmp1, result[7:4]} = {trans.srcCy_m, trans.src1_m[7:4]} + 5'b00110 + {4'b0, da_tmp};
              else
              	{da_tmp1, result[7:4]} = {trans.srcCy_m, trans.src1_m[7:4]} + {4'b0, da_tmp};
              
              
              overflow = 1'b0;
               
              
			end
			
			ALU_NOT: begin
			
				result   = ~(trans.src1_m);
				overflow = 1'b0;
			
			end
          
			ALU_AND: begin
			
                result  = (trans.src1_m & trans.src2_m);
				overflow = 1'b0;
			
			end
          
			ALU_XOR: begin
			
                result = (trans.src1_m ^ trans.src2_m);
				overflow = 1'b0;
			
			end
			
			ALU_OR: begin
			
                result = (trans.src1_m | trans.src2_m);
				overflow = 1'b0;
			
			end
									
			ALU_RL: begin
			
				result   = {trans.src1_m[6:0], trans.src1_m[7]};
				overflow = 1'h0;
			
			end
			
			ALU_RLC: begin
			
                result   = {trans.src1_m[6:0], trans.srcCy_m};
				overflow = 1'b0;
			
			end
			
			ALU_RR: begin
			
              result   = {trans.src1_m[0], trans.src1_m[7:1]};
			  overflow = 1'b0;
			
			end
			
			ALU_RRC: begin
			
              result   = {trans.srcCy_m, trans.src1_m[7:1]};
			  overflow = 1'b0;
			
			end
			
			ALU_INC: begin
			
              inc = {trans.src2_m, trans.src1_m} + {15'h0, 1'b1};
              dec = {trans.src2_m, trans.src1_m} - {15'h0, 1'b1};
              
              if(trans.srcCy_m)
                result = dec[7:0];
              else
                result = inc[7:0];
              
              overflow = 1'b0;
			
			end
          
          	ALU_XCH: begin
              
              if(trans.srcCy_m)
                result = trans.src2_m;
              else 
                
                result = {trans.src1_m[7:4],trans.src2_m[3:0]};
                overflow = 1'b0;
              
            end
			
			
			default: begin
			
				result   = trans.src1_m;
				overflow = 1'b0;
			
			end
		
		endcase
    	
        if((trans.op_code_m == ALU_MUL) || (trans.op_code_m == ALU_DIV)) begin
          
          if(trans.des2_m != result[7:0])
            `uvm_error("COMPARE", $sformatf("Transaction failed! Actual=%d, Expected=%d", trans.des2_m, result[7:0]))
          else
            `uvm_info("COMPARE", $sformatf("Transaction Passed! ACT=%d, EXP=%d", trans.des2_m, result[7:0]), UVM_LOW)
            
      
        end
		else begin
          
          if(trans.des_acc_m != result[7:0])
            `uvm_error("COMPARE", $sformatf("Transaction failed! Actual=%d, Expected=%d", trans.des_acc_m, result[7:0]))
          else
            `uvm_info("COMPARE", $sformatf("Transaction Passed! ACT=%d, EXP=%d", trans.des_acc_m, result[7:0]), UVM_LOW)
          
        end
    
  endtask: compare
  

  
endclass: alu_scoreboard
