class fifo_seq_item extends uvm_sequence_item;

    `uvm_object_utils(fifo_seq_item)

    // Randomized stimulus
    rand bit       wr_en;
    rand bit       rd_en;
    rand bit [7:0] din;

    // Observed DUT signals
    logic [7:0] dout;
    logic       full;
    logic       empty;

    // Status sampled before the active clock edge
    logic       full_before;
    logic       empty_before;

    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction

endclass