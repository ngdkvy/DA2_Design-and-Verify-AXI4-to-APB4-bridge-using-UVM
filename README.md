# Design-and-Verify-AXI4-to-APB4-bridge-using-UVM
This is an implementation of a bridge between an AXI4-Full master and an APB4 slave. After that, the design is verified using a UVM.
## Architecture UVM
<img width="543" height="311" alt="image" src="https://github.com/user-attachments/assets/c4b2775b-7912-40f7-917e-af11df1f9716" />

## Simulation environment structure
1. Checker - all SV checkers if any
2. rtl - RTL code
3. sequences - include many sequence item
4. sim - execution scripts
5. tb - including coverage, environment, scoreboard, 
6. testcase - include base_test and many directed testcase, random testcase
7. vip - source code of UVM components (Sequencer, Driver, Monitor, Interface, Transaction, Agent) and configuration object (apb_config - onfig object to configure the test)
