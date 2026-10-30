// Code your design here
module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  wr_en,
    input  logic                  rd_en,
    input  logic [DATA_WIDTH-1:0] din,

    output logic [DATA_WIDTH-1:0] dout,
    output logic                  full,
    output logic                  empty
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    logic [ADDR_WIDTH-1:0] wr_ptr;
    logic [ADDR_WIDTH-1:0] rd_ptr;
    logic [ADDR_WIDTH:0]   count;

    logic write_accept;
    logic read_accept;

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    assign write_accept = wr_en && !full;
    assign read_accept  = rd_en && !empty;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
            count  <= '0;
            dout   <= '0;
        end
        else begin

            if (write_accept) begin
                mem[wr_ptr] <= din;

                if (wr_ptr == DEPTH-1)
                    wr_ptr <= '0;
                else
                    wr_ptr <= wr_ptr + 1'b1;
            end

            if (read_accept) begin
                dout <= mem[rd_ptr];

                if (rd_ptr == DEPTH-1)
                    rd_ptr <= '0;
                else
                    rd_ptr <= rd_ptr + 1'b1;
            end

            case ({write_accept, read_accept})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase

        end
    end

endmodule