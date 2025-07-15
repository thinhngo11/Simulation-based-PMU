class PMU7scoreboard extends uvm_scoreboard;
  `uvm_component_utils(PMU7scoreboard)
 
  string st; PMU7seq_item sq[$];
  logic penable;
  logic preg [15:0]; //1 to monitor
  logic pacc [15:0]; //1 read 0 write
  int pthresh [15:0];
  int pcnt [15:0]; //counter for each pmureg
  int totalacc [15:0]; //number of pmu reg accesses
  uvm_analysis_imp #(PMU7seq_item,PMU7scoreboard) sbport;

  function new(string name="PMU7scoreboard",
               uvm_component parent=null);
    super.new(name,parent);
    st = name; penable = 1; 
    for (int i=0; i<16; i++) begin
      preg[i] = 1; //monitor all 
      pacc[i] = i % 2; //alternately monitor write/read 
      pthresh[i] = 10; //stop at 10
      pcnt[i] = 0; totalacc[i] = 0;
    end
  endfunction
  
  function void build_phase(uvm_phase phase);
    sbport=new("PMU port",this);
  endfunction
  
  function void write(PMU7seq_item s);
    sq.push_back(s);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      PMU7seq_item s; wait(sq.size()>0); s=sq.pop_front();
      if (penable&preg[s.int_addr]&
          pcnt[s.int_addr]<pthresh[s.int_addr])   
        for (int i=0;i<16;i++) totalacc[i]=totalacc[i]+1; 
      if (penable&preg[s.int_addr]&
          (pacc[s.int_addr]==s.readWrite)& 
          (pcnt[s.int_addr]<pthresh[s.int_addr])) begin 
        	pcnt[s.int_addr] = pcnt[s.int_addr] + 1;
      end
    end
  endtask

  function void extract_phase (uvm_phase phase);
    for (int i = 0; i < 16; i++)
    `uvm_info(st,$sformatf("reg%0dacc=%0dcnt=%0dStat=%0d",
       i,pacc[i],pcnt[i],100*pcnt[i]/totalacc[i]),UVM_LOW)      
  endfunction
endclass
