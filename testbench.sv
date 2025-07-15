import uvm_pkg::*;
`include "uvm_macros.svh"

`include "Slave_7b.sv"
`include "Slave_10b.sv"
`include "interface.sv"
`include "PMU7interface.sv"
`include "PMU10interface.sv"
`include "tb_pkg.sv"

module top;
  
  intface intf();
  
  bind Slave_10b:sl2 PMU10interface PMU10intf(state,
         slaveAddress,int_addr,data,t_data,readWrite,ack);
  bind Slave_7b:sl1 PMU7interface PMU7intf(state, 
         slaveAddress,int_addr,data,t_data,readWrite,ack);
  
  Slave_7b#(4) sl1(intf.sda, intf.scl);
  Slave_10b#(8) sl2(intf.sda, intf.scl);
  
  initial begin
    uvm_config_db#(virtual PMU7interface)::set(uvm_root::
                   get(),"*","PMU7monitor",sl1.PMU7intf);
    uvm_config_db#(virtual PMU10interface)::set(uvm_root::
                  get(),"*","PMU10monitor",sl2.PMU10intf);
    uvm_config_db#(virtual intface)::set(uvm_root::
                  get(),"*","driver",intf);
    uvm_config_db#(virtual intface)::set(uvm_root::
                  get(),"*","monitor",intf);
  end
  
  initial run_test("test");
  
  assign intf.sda=1;
  assign intf.scl=1;
  

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  // To check clock streching
  initial begin
    #62 @(negedge intf.scl);
    force intf.scl=0;
    #11 release intf.scl;
    #185 @(negedge intf.scl);
    force intf.scl=0;
    #16 release intf.scl;
  end
  
endmodule
