class PMU10agent extends uvm_agent;
  `uvm_component_utils(PMU10agent)
  
  PMU10monitor pmu10mon;
  PMU10 pmu10;
  
  function new(string name="PMU10agent", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    pmu10mon=PMU10monitor::type_id::create("pmu10mon",this);
    pmu10=PMU10::type_id::create("pmu10",this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    pmu10mon.mnport.connect(pmu10.sbport);
  endfunction
  
endclass
