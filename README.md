# UVM-Based Functional Verification of Synchronous FIFO

##  Project Overview
This project focuses on the functional verification of a synchronous FIFO (First-In, First-Out) using SystemVerilog and the Universal Verification Methodology (UVM). A reusable UVM testbench is developed to verify FIFO read and write operations, status flags, and data integrity through simulation.

##  Objectives
- Verify correct FIFO read and write operations.
- Validate `full` and `empty` status flags.
- Check data integrity and FIFO ordering.
- Test boundary conditions and simultaneous read/write operations.
- Develop a modular and reusable UVM verification environment.

##  Technologies Used
- **HDL:** SystemVerilog
- **Verification Methodology:** UVM
- **Simulator:** QuestaSim
- **Online Platform:** EDA Playground

##  Design Specifications

| Parameter | Description |
|---|---|
| FIFO Type | Synchronous FIFO |
| Data Width | 8 bits |
| FIFO Depth | 16 entries |
| Clock | Single clock |
| Reset | Reset signal |
| Control Signals | `wr_en`, `rd_en` |
| Status Signals | `full`, `empty` |

##  UVM Testbench Architecture

The testbench is organized into reusable UVM components:

- **Sequence Item:** Defines FIFO transaction fields.
- **Sequence:** Generates read and write stimulus.
- **Driver:** Drives transactions to the DUT through the virtual interface.
- **Monitor:** Observes interface activity and collects transactions.
- **Scoreboard:** Compares observed FIFO behavior against a reference model.
- **Agent:** Groups the driver, monitor, and sequencer.
- **Environment:** Integrates the verification components.
- **Test:** Configures and starts the verification scenario.

##  Project Structure

```text
UVM-Synchronous-FIFO-Verification/
├── fifo.sv          # FIFO RTL design
├── fifo_if.sv       # SystemVerilog interface
├── fifo_pkg.sv      # UVM classes and components
├── top.sv           # Top-level testbench
└── README.md        # Project documentation
```

##  Verification Scenarios

The testbench can be used to verify:

1. **Write Operation:** Write data into the FIFO.
2. **Read Operation:** Read stored data in FIFO order.
3. **Empty Condition:** Check the empty flag when no data is available.
4. **Full Condition:** Check the full flag when the FIFO reaches capacity.
5. **Data Integrity:** Compare read data with expected data.
6. **Boundary Conditions:** Test behavior near full and empty states.
7. **Simultaneous Read/Write:** Examine concurrent operations according to the DUT's specified behavior.

##  How to Run

1. Open [EDA Playground](https://www.edaplayground.com/).
2. Select SystemVerilog as the design and testbench language.
3. Select a compatible simulator with UVM support, such as Questa.
4. Add the RTL, interface, UVM package, and top-level testbench files.
5. Enable the UVM library if required by the selected simulator.
6. Compile and run the simulation.
7. Review UVM logs and waveforms to analyze the DUT behavior.

##  Expected Results

- FIFO write and read transactions execute according to the design specification.
- Read data matches the expected FIFO order.
- `full` and `empty` flags behave correctly.
- The scoreboard reports mismatches when observed behavior differs from the reference model.

*Actual results depend on the test scenarios implemented and successful simulation execution.*

##  Key Learnings

- Understanding UVM testbench architecture.
- Developing modular SystemVerilog verification components.
- Using a scoreboard and reference model for data checking.
- Debugging RTL and testbench behavior through simulation logs and waveforms.
- Verifying FIFO control logic and boundary conditions.

##  Author

**Vishwak Sai**

B.Tech – Electronics and Communication Engineering

**Focus Areas:** RTL Design | Design Verification | SystemVerilog | UVM

---

*This project demonstrates foundational skills in reusable verification environments and functional verification of digital designs.*
