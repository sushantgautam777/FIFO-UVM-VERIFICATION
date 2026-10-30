class fifo_monitor extends uvm_monitor;

    `uvm_component_utils(fifo_monitor)

    virtual fifo_if vif;
    uvm_analysis_port #(fifo_seq_item) ap;
    fifo_seq_item tr;

    function new(string name = "fifo_monitor",
                 uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual fifo_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("MON", "Virtual interface not found")

        ap = new("ap", this);
    endfunction

  task run_phase(uvm_phase phase);
    forever begin
        @(posedge vif.clk);

        if (vif.rst_n) begin
            tr = fifo_seq_item::type_id::create("tr");

            // Capture inputs and status before DUT updates
            tr.wr_en       = vif.wr_en;
            tr.rd_en       = vif.rd_en;
            tr.din         = vif.din;
            tr.full_before = vif.full;
            tr.empty_before = vif.empty;

            // Allow the DUT's nonblocking assignments to settle
            #1;
            tr.dout  = vif.dout;
            tr.full  = vif.full;
            tr.empty = vif.empty;

            ap.write(tr);
        end
    end
endtask

endclass