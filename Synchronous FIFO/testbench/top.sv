`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

module top;

  bit clk = 0;
  always #5 clk = ~clk;

  fifo_if vif(clk);

  fifo dut (
    .clk(clk),
    .rst(vif.rst),
    .wr_en(vif.wr_en),
    .rd_en(vif.rd_en),
    .data_in(vif.data_in),
    .data_out(vif.data_out),
    .full(vif.full),
    .empty(vif.empty)
  );

  initial begin
    vif.rst = 1;
    #20;
    vif.rst = 0;
  end

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
    run_test("fifo_test");
  end

  //  Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end

  //  Ensure simulation runs long enough
  initial begin
    #1000;
  end

endmodule