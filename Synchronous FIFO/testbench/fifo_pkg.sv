package fifo_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // =============================
  // 1. Sequence Item
  // =============================
  class fifo_seq_item extends uvm_sequence_item;
    rand bit wr_en;
    rand bit rd_en;
    rand bit [7:0] data;
    `uvm_object_utils(fifo_seq_item)
    function new(string name="fifo_seq_item");
      super.new(name);
    endfunction
  endclass


  // =============================
  // 2. Sequence
  // =============================
  class fifo_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_sequence)

    task body();
      fifo_seq_item req;
      repeat(20) begin
        req = fifo_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
      end
    endtask
  endclass


  // =============================
  // 3. Driver
  // =============================
  class fifo_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(fifo_driver)

    virtual fifo_if vif;

    function void build_phase(uvm_phase phase);
      if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
      fifo_seq_item req;

      forever begin
        seq_item_port.get_next_item(req);
        @(posedge vif.clk);

        vif.wr_en   <= req.wr_en;
        vif.rd_en   <= req.rd_en;
        vif.data_in <= req.data;

        seq_item_port.item_done();
      end
    endtask
  endclass


  // =============================
  // 4. Monitor
  // =============================
  class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_if vif;
    uvm_analysis_port #(fifo_seq_item) ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
      if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF", "No VIF")
    endfunction

    task run_phase(uvm_phase phase);
      fifo_seq_item trans;

      forever begin
        @(posedge vif.clk);

        trans = fifo_seq_item::type_id::create("trans");

        trans.wr_en = vif.wr_en;
        trans.rd_en = vif.rd_en;

        // ⚠️ IMPORTANT FIX
        if (vif.wr_en)
          trans.data = vif.data_in;
        else if (vif.rd_en)
          trans.data = vif.data_out;

        ap.write(trans);
      end
    endtask
  endclass


  // =============================
  // 5. Scoreboard
  // =============================
  class fifo_scoreboard extends uvm_component;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) imp;
    bit [7:0] queue[$];

    function new(string name, uvm_component parent);
      super.new(name, parent);
      imp = new("imp", this);
    endfunction

    function void write(fifo_seq_item t);

      if (t.wr_en)
        queue.push_back(t.data);

      if (t.rd_en) begin
        if (queue.size() == 0)
          `uvm_error("FIFO", "UNDERFLOW")
        else begin
          bit [7:0] expected = queue.pop_front();
          if (expected != t.data)
            `uvm_error("FIFO", "MISMATCH")
        end
      end

    endfunction
  endclass


  // =============================
  // 6. Agent
  // =============================
  class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)

    fifo_driver driver;
    fifo_monitor monitor;
    uvm_sequencer #(fifo_seq_item) sequencer;

    function void build_phase(uvm_phase phase);
      driver = fifo_driver::type_id::create("driver", this);
      monitor = fifo_monitor::type_id::create("monitor", this);
      sequencer = uvm_sequencer#(fifo_seq_item)::type_id::create("sequencer", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
  endclass


  // =============================
  // 7. Environment
  // =============================
  class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    fifo_agent agent;
    fifo_scoreboard sb;

    function void build_phase(uvm_phase phase);
      agent = fifo_agent::type_id::create("agent", this);
      sb = fifo_scoreboard::type_id::create("sb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      agent.monitor.ap.connect(sb.imp);
    endfunction
  endclass


  // =============================
  // 8. Test
  // =============================
  class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)

    fifo_env env;

    function void build_phase(uvm_phase phase);
      env = fifo_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
      fifo_sequence seq;

      phase.raise_objection(this);

      seq = fifo_sequence::type_id::create("seq");
      seq.start(env.agent.sequencer);

      #200;
      phase.drop_objection(this);
    endtask
  endclass

endpackage