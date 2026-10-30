class fifo_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(fifo_scoreboard)

    logic [7:0] expected_data[$];

    uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) imp;

   

    function new(string name = "fifo_scoreboard",
                 uvm_component parent = null);

        super.new(name, parent);
        imp = new("imp", this);

    endfunction


    // Receive transactions from monitor
    function void write(fifo_seq_item tr);

        bit write_accept;
        bit read_accept;

        write_accept = tr.wr_en && !tr.full_before;
        read_accept  = tr.rd_en && !tr.empty_before;

    

        // Read checking
        if (read_accept) begin

            if (expected_data.size() == 0) begin
                `uvm_error("SB",
                    "Read accepted, but expected queue is empty!")
            end
            else begin

                if (expected_data[0] !== tr.dout) begin
                    `uvm_error("SB",
                        $sformatf(
                            "DATA MISMATCH: Expected=%0h Actual=%0h",
                            expected_data[0], tr.dout
                        ))
                end
                else begin
                    `uvm_info("SB",
                        $sformatf("FIFO DATA MATCH: %0h", tr.dout),
                        UVM_MEDIUM)
                end

                void'(expected_data.pop_front());
            end
        end

        // Write checking/model update
        if (write_accept) begin
            expected_data.push_back(tr.din);

            `uvm_info("SB",
                $sformatf("WRITE: Data=%0h Queue Size=%0d",
                          tr.din, expected_data.size()),
                UVM_MEDIUM)
        end

    endfunction


    function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info("SB",
            $sformatf("Unread expected entries at end = %0d",
                      expected_data.size()),
            UVM_LOW)

    endfunction

endclass