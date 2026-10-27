// Code your design here
module fifo #(
  parameter DATA_WIDTH = 8,
  parameter DEPTH = 16,
  parameter ADDR_WIDTH = 4   // log2(DEPTH)
)(
  input  logic clk,
  input  logic rst,

  input  logic wr_en,
  input  logic rd_en,

  input  logic [DATA_WIDTH-1:0] data_in,
  output logic [DATA_WIDTH-1:0] data_out,

  output logic full,
  output logic empty
);

  // Memory
  logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  // Pointers
  logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;

  // Counter to track number of elements
  logic [ADDR_WIDTH:0] count;

  // WRITE LOGIC
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr <= 0;
    end else if (wr_en && !full) begin
      mem[wr_ptr] <= data_in;
      wr_ptr <= wr_ptr + 1;
    end
  end

  // READ LOGIC
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      rd_ptr <= 0;
      data_out <= 0;
    end else if (rd_en && !empty) begin
      data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
  end

  // COUNT LOGIC
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      count <= 0;
    end else begin
      case ({wr_en && !full, rd_en && !empty})
        2'b10: count <= count + 1; // write only
        2'b01: count <= count - 1; // read only
        2'b11: count <= count;     // simultaneous
        default: count <= count;
      endcase
    end
  end

  // STATUS FLAGS
  assign full  = (count == DEPTH);
  assign empty = (count == 0);

endmodule