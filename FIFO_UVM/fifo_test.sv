class fifo_test extends uvm_test;

`uvm_component_utils(fifo_test)
fifo_env env;
fifo_sequence seq;

function new(string name ="fifo_test",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
env = fifo_env::type_id::create("env",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = fifo_sequence::type_id::create("seq");
    seq.start(env.agt.seqr);
    phase.drop_objection(this);
endtask
  
  
endclass





class fifo_single_test extends uvm_test;
    `uvm_component_utils(fifo_single_test)

    fifo_env env;

    function new(string name="fifo_single_test",
                 uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_single_write_read_seq seq;

        phase.raise_objection(this);
        seq = fifo_single_write_read_seq::type_id::create("seq");
        seq.start(env.agt.seqr);
        phase.drop_objection(this);
    endtask
endclass


class fifo_fill_test extends uvm_test;
    `uvm_component_utils(fifo_fill_test)

    fifo_env env;

    function new(string name="fifo_fill_test",
                 uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_fill_seq seq;

        phase.raise_objection(this);
        seq = fifo_fill_seq::type_id::create("seq");
        seq.start(env.agt.seqr);
        phase.drop_objection(this);
    endtask
endclass


class fifo_wraparound_test extends uvm_test;
    `uvm_component_utils(fifo_wraparound_test)

    fifo_env env;

    function new(string name="fifo_wraparound_test",
                 uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_wraparound_seq seq;

        phase.raise_objection(this);
        seq = fifo_wraparound_seq::type_id::create("seq");
        seq.start(env.agt.seqr);
        phase.drop_objection(this);
    endtask
endclass
