class PMU10 extends uvm_scoreboard;
  `uvm_component_utils(PMU10)
 
  int q[$];
  string st;
  int counter [15:0]; //the number of register accesseses 
  
  uvm_analysis_imp #(PMU10seq_item,PMU10) sbport;
  function new(string name="PMU10", uvm_component parent=null);
    super.new(name,parent);
    st = name;
    for (int i=0; i<16; i++)
      counter[i] = 0;
  endfunction
  
  function void build_phase(uvm_phase phase);
    sbport=new("PMU port",this);
  endfunction
  
  PMU10seq_item sq[$];
  function void write(PMU10seq_item s);
    sq.push_back(s);
  endfunction

  reg [7:0]data[*][*];
  task run_phase(uvm_phase phase);
    forever begin
      PMU10seq_item s; string st; int b;
      wait(sq.size()>0);
      s=sq.pop_front();
      counter[s.int_addr] = s.data[s.int_addr];
    end
  endtask

  function void extract_phase (uvm_phase phase);
    for (int i = 0; i < 16; i++)
      `uvm_info(st,$sformatf("register %0d, count=%0d", i, counter[i]),UVM_LOW)      
  endfunction
endclass
