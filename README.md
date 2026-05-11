# Smart-Bike-Rental-FSM-with-Embedded-Payment-System

## Project Overview
This project features a complete **RTL digital controller** for a smart bike-sharing system, developed in **SystemVerilog**. It manages the entire user lifecycle—from hardware-level authentication and credit validation to real-time session tracking and automated billing.

The design emphasizes **Finite State Machine (FSM)** precision, **Datapath-Control synchronization**, and high-performance **Arithmetic Logic Units (ALU)**. It is a robust example of a hardware-verified "IP Core" suitable for embedded payment architectures.

## Technical Architecture & Module Breakdown
The system follows a modular, hierarchical design, demonstrating clean separation between control logic and data storage:

### **1. Finite State Machine (Control Unit)**
A 5-state logic controller (`IDLE`, `CHECK`, `RENTING`, `PAY`, `ERROR`) that dictates system behavior. It ensures that no state transition occurs without proper validation, safeguarding the system against illegal operations.
<img width="1416" height="556" alt="graf" src="https://github.com/user-attachments/assets/8f89f85e-c229-403d-9a71-9eaa13135ded" />

### **2. Synchronous Memory Management**
The `memory.sv` module simulates a **Non-Volatile Storage** bank for 8 unique users:
* **Storage Architecture:** Implemented as a register file (`logic [15:0] mem [0:7]`).
* **Asynchronous Read:** Balance lookup is instantaneous based on the `user_id`, reducing access latency.
* **Synchronous Write:** Credit updates occur strictly on the positive clock edge when `write_en` is asserted, preventing data corruption during the payment phase.

### **3. High-Precision Timer Unit**
The `timer.sv` module is responsible for the temporal accuracy of the billing system:
* **Deterministic Counting:** Increments exactly once per clock cycle when enabled, providing a reliable time-base for the ALU.
* **Hardwired Reset:** Features a dedicated `start_rent` reset path to ensure every new session begins from zero, eliminating cumulative timing errors from previous users.

### **4. Pricing ALU**
A dedicated arithmetic unit that calculates costs using a **Threshold-Based Billing** model:
* **Base Fee:** 5 Credits (covers the first 15 time units).
* **Incremental Rate:** 1 Credit per time unit after the threshold.
  
<img width="1430" height="551" alt="Screenshot 2026-05-11 234246" src="https://github.com/user-attachments/assets/6db6bd5c-9390-41a7-a478-7fc12590eaf4" />

## Engineering Highlights & Optimizations

### **1. Zero-Latency Timing (Look-Ahead Logic)**
A critical challenge in FSM-based hardware is the 1-clock-cycle latency during state transitions. In this design, I implemented a **combinational look-ahead logic** for the `timer_en` signal. By evaluating the `return_bike` input asynchronously within the `RENTING` state, the timer freezes in the **exact nanosecond** the user initiates a return. This ensures 100% billing accuracy.

### **2. Real-Time Safety Thresholds**
The system acts as a watchdog for the user’s balance:
* **Warning LED:** Triggers when the remaining credit drops below the **5-Credit safety threshold**.
* **Error LED:** Instantly terminates the session (`lock_open = 0`) if the balance is depleted, ensuring no overdraft occurs.


##  Simulation & Functional Verification
The system was rigorously verified using a comprehensive Testbench covering the following edge cases:

1.  **Standard Rental (User 0):** Validated the transition from base fee to incremental billing (100 → 94 Credits).
2.  **Quick Cancellation (User 1):** Confirmed the application of the minimum base fee for short-duration trips.
3.  **Credit Depletion (User 5):** Demonstrated the sequential activation of **Warning** and **Error** signals as the balance hit 0.
4.  **Graceful Return (User 3):** Verified that the system successfully returns to `IDLE` after a `Warning` signal.
5.  **Access Rejection (User 4):** Validated the security check; users with less than the 5-Credit minimum (e.g., 3 Credits) are denied access immediately.

<img width="1413" height="542" alt="Screenshot 2026-05-11 234012" src="https://github.com/user-attachments/assets/907c3db5-724b-49af-a87d-ddf4ba42a5c5" />


## Skills Demonstrated
* **Hardware Description:** RTL design in SystemVerilog (Always_ff, Always_comb, and State Encoding).
* **Memory & Storage:** Synchronous write/Asynchronous read memory modeling.
* **Timing Analysis:** Clock-cycle accurate timer design and latency compensation.
* **Verification:** Functional testing, Waveform analysis, and Nanosecond-level debugging.
* **Architecture:** Separation of Control Path (FSM) and Data Path (ALU/Memory).
