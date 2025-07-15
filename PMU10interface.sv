interface PMU10interface(
  input logic [3:0] state,
  input logic [9:0] slaveAddress,
  input logic [7:0] int_addr,
  
  input logic [7:0] data[15:0],
  input logic [7:0] t_data,
  
  input logic readWrite,
  input logic ack);
endinterface
