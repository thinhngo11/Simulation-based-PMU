class PMU10seq_item extends uvm_sequence_item;
  logic [3:0] state;
  logic [9:0] slaveAddress;
  logic [7:0] int_addr;
  
  logic [7:0] data[15:0];
  logic [7:0] t_data;
  
  logic readWrite;

  function new(string name="PMU10seq_item");
    super.new(name);
  endfunction
  
endclass
