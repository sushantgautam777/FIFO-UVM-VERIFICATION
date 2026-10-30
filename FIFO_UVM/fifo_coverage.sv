// Covergroup declared at package scope
covergroup fifo_cg with function sample(
    bit wr,
    bit rd,
    bit full_flag,
    bit empty_flag
);

    option.per_instance = 1;

    cp_write: coverpoint wr {
        bins write_disabled = {0};
        bins write_enabled  = {1};
    }

    cp_read: coverpoint rd {
        bins read_disabled = {0};
        bins read_enabled  = {1};
    }

    cp_full: coverpoint full_flag {
        bins not_full = {0};
        bins full     = {1};
    }

    cp_empty: coverpoint empty_flag {
        bins not_empty = {0};
        bins empty     = {1};
    }

    read_write_cross: cross cp_read, cp_write;

endgroup


class fifo_coverage extends uvm_subscriber #(fifo_seq_item);

    `uvm_component_utils(fifo_coverage)

    fifo_cg cov;

    function new(string name = "fifo_coverage",
                 uvm_component parent = null);
        super.new(name, parent);
        cov = new();
    endfunction

    virtual function void write(fifo_seq_item tr);

        cov.sample(
            tr.wr_en,
            tr.rd_en,
            tr.full_before,
            tr.empty_before
        );

    endfunction

    function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info("COVERAGE",
            $sformatf("FIFO Functional Coverage = %0.2f%%",
                      cov.get_coverage()),
            UVM_NONE)

        `uvm_info("COVERAGE",
            $sformatf("Read-Write Cross Coverage = %0.2f%%",
                      cov.read_write_cross.get_coverage()),
            UVM_NONE)
      
      `uvm_info("COVERAGE",
    $sformatf("Write coverage = %0.2f%%",
              cov.cp_write.get_coverage()), UVM_NONE)

`uvm_info("COVERAGE",
    $sformatf("Read coverage = %0.2f%%",
              cov.cp_read.get_coverage()), UVM_NONE)

`uvm_info("COVERAGE",
    $sformatf("Full coverage = %0.2f%%",
              cov.cp_full.get_coverage()), UVM_NONE)

`uvm_info("COVERAGE",
    $sformatf("Empty coverage = %0.2f%%",
              cov.cp_empty.get_coverage()), UVM_NONE)
      

    endfunction

endclass