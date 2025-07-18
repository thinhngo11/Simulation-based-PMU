class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
 
  int q[$];
  
  uvm_analysis_imp #(seq_item,scoreboard) sbport;
  function new(string name="Scoreboard", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    sbport=new("Scoreboard port",this);
  endfunction
  
  seq_item sq[$];
  function void write(seq_item s);
    sq.push_back(s);
  endfunction

  reg [7:0]data[*][*];
  task run_phase(uvm_phase phase);
    forever begin
      seq_item s; string st; int b;
      wait(sq.size()>0);
      s=sq.pop_front();
    if(s.rd_wr) begin st="Read "; b=s.rdata; end
    else begin st="Write"; b=s.wdata; end
    `uvm_info("Scoreboard",$sformatf("%s @Slave addr=%0d, Address ack=%0d, Register=%0d, Reg ack=%0d, Data=%0d",st,s.slv_addr,s.a_ack,s.int_addr,s.i_ack,b),UVM_LOW)
      if(s.a_ack==1) continue;
      if(s.i_ack==1) continue;
      if(s.rd_wr) begin
//         $display("\t Read");
        if(s.rdata==data[s.slv_addr][s.int_addr])
          `uvm_info("Hit","Data match",UVM_LOW)
        else 
          `uvm_error("Flop","Data mismatch");
      end
      else begin
        data[s.slv_addr][s.int_addr]=s.wdata;
        q.push_back(s.wdata);
//         $display("\t Write");
      end
    end
  endtask
  
endclass
