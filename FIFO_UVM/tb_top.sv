
`timescale 1ns/1ps

//====================================================
// 1. FIFO INTERFACE
//====================================================
interface fifo_if;
    logic clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [7:0] din;
    logic [7:0] dout;
    logic full;
    logic empty;
endinterface


//====================================================
// 2. UVM PACKAGE
//====================================================
package fifo_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "fifo_seq_item.sv"
    `include "fifo_sequencer.sv"
    `include "fifo_driver.sv"
    `include "fifo_monitor.sv"
 `include "fifo_coverage.sv"
    `include "fifo_agent.sv"
    `include "fifo_scoreboard.sv"
    `include "fifo_env.sv"
    `include "fifo_sequence.sv"
 
    `include "fifo_test.sv"

endpackage : fifo_pkg


//====================================================
// 3. TESTBENCH TOP
//====================================================
module tb_top;

    import uvm_pkg::*;
    import fifo_pkg::*;

    // Interface instance
    fifo_if F1();

    // Clock: 10 ns period
    initial begin
        F1.clk = 1'b0;
        forever #5 F1.clk = ~F1.clk;
    end

    // Active-low reset
    initial begin
        F1.rst_n = 1'b0;
        F1.wr_en = 1'b0;
        F1.rd_en = 1'b0;
        F1.din   = '0;

        repeat (2) @(negedge F1.clk);
        F1.rst_n = 1'b1;
    end

    // DUT
    sync_fifo #(
        .DATA_WIDTH(8),
        .DEPTH(8)
    ) S1 (
        .clk   (F1.clk),
        .rst_n (F1.rst_n),
        .wr_en (F1.wr_en),
        .rd_en (F1.rd_en),
        .din   (F1.din),
        .dout  (F1.dout),
        .full  (F1.full),
        .empty (F1.empty)
    );

    // UVM configuration and test launch
    initial begin
        uvm_config_db#(virtual fifo_if)::set(
            null, "*", "vif", F1
        );

        run_test("fifo_test");
    end

endmodule : tb_top
