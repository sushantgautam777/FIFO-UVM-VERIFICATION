class fifo_sequence extends uvm_sequence#(fifo_seq_item);
`uvm_object_utils(fifo_sequence)
fifo_seq_item tr;

function new(string name = "fifo_sequence");
super.new(name);
endfunction

task body();
    repeat (10) begin
        tr = fifo_seq_item::type_id::create("tr");

        start_item(tr);

        if (!tr.randomize())
            `uvm_fatal("SEQ", "Randomization failed")

        finish_item(tr);
    end
endtask
  
endclass



class fifo_single_write_read_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_single_write_read_seq)

    function new(string name="fifo_single_write_read_seq");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item tr;

        // Write one item
        tr = fifo_seq_item::type_id::create("write_tr");
        start_item(tr);
        tr.wr_en = 1;
        tr.rd_en = 0;
        tr.din   = 8'hA5;
        finish_item(tr);

        // Read the item back
        tr = fifo_seq_item::type_id::create("read_tr");
        start_item(tr);
        tr.wr_en = 0;
        tr.rd_en = 1;
        tr.din   = 8'h00;
        finish_item(tr);
    endtask
endclass


class fifo_fill_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_fill_seq)

    function new(string name="fifo_fill_seq");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item tr;

        // Fill all 8 FIFO locations
        for (int i = 0; i < 8; i++) begin
            tr = fifo_seq_item::type_id::create("tr");
            start_item(tr);
            tr.wr_en = 1;
            tr.rd_en = 0;
            tr.din   = 8'(i + 1);
            finish_item(tr);
        end
    endtask
endclass


class fifo_drain_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_drain_seq)

    function new(string name="fifo_drain_seq");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item tr;

        // Read all 8 FIFO locations
        for (int i = 0; i < 8; i++) begin
            tr = fifo_seq_item::type_id::create("tr");
            start_item(tr);
            tr.wr_en = 0;
            tr.rd_en = 1;
            tr.din   = 8'h00;
            finish_item(tr);
        end
    endtask
endclass


class fifo_wraparound_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_wraparound_seq)

    function new(string name="fifo_wraparound_seq");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item tr;

        // Repeat writes and reads to move pointers around the FIFO
        for (int i = 0; i < 16; i++) begin
            tr = fifo_seq_item::type_id::create("write_tr");
            start_item(tr);
            tr.wr_en = 1;
            tr.rd_en = 0;
            tr.din   = 8'(i);
            finish_item(tr);

            tr = fifo_seq_item::type_id::create("read_tr");
            start_item(tr);
            tr.wr_en = 0;
            tr.rd_en = 1;
            tr.din   = 0;
            finish_item(tr);
        end
    endtask
endclass
