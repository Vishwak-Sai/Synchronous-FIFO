interface fifo_if(input bit clk);

  logic rst;
  logic wr_en, rd_en;
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic full, empty;

endinterface