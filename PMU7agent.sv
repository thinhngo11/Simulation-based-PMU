class PMU7agent extends uvm_agent;
  `uvm_component_utils(PMU7agent)
  
  PMU7monitor pmu7mon;
  PMU7scoreboard pmu7score;
  
  function new(string name="PMU7agent", 
               uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    pmu7mon=PMU7monitor::type_id::create("pmu7mon",this);
    pmu7score=PMU7scoreboard::type_id::create("pmu7score",this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    pmu7mon.mnport.connect(pmu7score.sbport);
  endfunction
  
endclass
