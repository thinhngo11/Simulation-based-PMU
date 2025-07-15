class PMU7monitor extends uvm_monitor;
  `uvm_component_utils(PMU7monitor)
  parameter INT_ACK = 4'b0100;
  
  PMU7seq_item PMUmon_item;
  virtual PMU7interface vif;
  uvm_analysis_port #(PMU7seq_item) mnport;
  
  function new(string name="PMU7Monitor", 
               uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual PMU7interface)::
       get(this,"","PMU7monitor",vif))
      `uvm_fatal("No_Vif","PMU7interface not found");
    mnport=new("PMU7Monitor port",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      `uvm_info(get_full_name,"started",UVM_MEDIUM)
      PMUmon_item=new();
      @(posedge vif.ack);
      if (vif.state == INT_ACK) begin
        PMUmon_item.state = vif.state;
        PMUmon_item.slaveAddress = vif.slaveAddress;
        PMUmon_item.int_addr = vif.int_addr;
        PMUmon_item.data = vif.data;
        PMUmon_item.t_data = vif.t_data;
        PMUmon_item.readWrite = vif.readWrite;
        
        mnport.write(PMUmon_item);
      end
      @(negedge vif.ack);
    end
  endtask
          
endclass
