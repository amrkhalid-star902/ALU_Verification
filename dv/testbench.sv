// Code your testbench here
// or browse Examples



//`timescale 1ns/10ps

import uvm_pkg::*;
`include "uvm_macros.svh"


//--------------------------------------------------------
//Include Files
//--------------------------------------------------------
`include "alu_if.sv"
`include "alu_seq_item.sv"
`include "alu_seq.sv"
`include "alu_sequencer.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "alu_agent.sv"
`include "alu_scoreboard.sv"
`include "alu_env.sv"
`include "alu_test.sv"


  
//--------------------------------------------------------
//Instantiation
//--------------------------------------------------------


module alu_tp;

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit clk;
  bit reset;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #1 clk = ~clk;
  
  //---------------------------------------
  //reset Generation
  //---------------------------------------
  initial begin
    reset = 1;
    #2 reset = 0;
  end
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  alu_if vif_inst(clk,reset);
  
  //---------------------------------------
  //DUT instance
  //---------------------------------------
  // Instantiate oc8051_alu module
  oc8051_alu oc8051_alu_inst (
    .clk(clk),
    .rst(reset),
    .op_code(vif_inst.op_code),
    .src1(vif_inst.src1),
    .src2(vif_inst.src2),
    .src3(vif_inst.src3),
    .srcCy(vif_inst.srcCy),
    .srcAc(vif_inst.srcAc),
    .bit_in(vif_inst.bit_in),
    .valid_in(vif_inst.valid_in),
    .des1(vif_inst.des1),
    .des2(vif_inst.des2),
    .des_acc(vif_inst.des_acc),
    .desCy(vif_inst.desCy),
    .desAc(vif_inst.desAC),
    .desOv(vif_inst.desOv),
    .sub_result(vif_inst.sub_result),
    .valid_out(vif_inst.valid_out)
  );
  
  //---------------------------------------
  //passing the interface handle to lower heirarchy using set method 
  //and enabling the wave dump
  //---------------------------------------
  initial begin 
    uvm_config_db#(virtual alu_if)::set(uvm_root::get(),"*","vif",vif_inst);
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  //---------------------------------------
  //calling test
  //---------------------------------------
  initial begin 
    run_test("alu_test");
  end
  
  //--------------------------------------------------------
  //Maximum Simulation Time
  //--------------------------------------------------------
  initial begin
    #5000;
    $display("Sorry! Ran out of clock cycles!");
    $finish();
  end
  

  
  
endmodule: alu_tp
