class fifo_driver extends uvm_driver#(fifo_seq_item);
`uvm_component_utils(fifo_driver)

virtual fifo_if vif;
fifo_seq_item tr;

function new(string name = "fifo_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual fifo_if)::get(this,"","vif",vif)) 
`uvm_fatal("DRV","CANNOT GET INF ")
endfunction

task run_phase(uvm_phase phase);

forever begin
    
    seq_item_port.get_next_item(tr);
    @(negedge vif.clk);
    vif.wr_en <= tr.wr_en;
    vif.rd_en <= tr.rd_en;
    vif.din <= tr.din;   
    @(posedge vif.clk);
    seq_item_port.item_done();

    end
endtask 


endclass