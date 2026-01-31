# Design-and-Verify-AXI4-to-APB4-bridge-using-UVM
This is an implementation of a bridge between an AXI4-Full master and an APB4 slave. After that, the design is verified using a UVM.
## Architecture
<img width="676" height="387" alt="image" src="https://github.com/user-attachments/assets/8c30ebf4-f655-47ff-814f-911f81fa2e61" />
## Simulation environment structure
1. Checker - all SV checkers if any
2. rtl - RTL code
3. sequences - include many sequence item
4. sim - execution scripts
5. tb - including coverage, environment, scoreboard, 
6. testcase - include base_test and many directed testcase, random testcase
7. vip - source code of UVM components (Sequencer, Driver, Monitor, Interface, Transaction, Agent) and configuration object (apb_config - onfig object to configure the test)
