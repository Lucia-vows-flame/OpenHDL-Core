# Introduction

OpenHDL-Core is an open, modular, and extensible hardware design core library.

It aims to provide a unified and reusable foundation for digital hardware development, covering a wide spectrum of hardware building blocks across different abstraction levels and design domains. Rather than focusing on a specific category of components, the project is intended to serve as a long-term, evolving foundation for diverse hardware systems.

The project is not limited to a particular hardware description language, implementation style, or fixed set of modules. As new components, architectures, and design methodologies emerge, OpenHDL-Core is designed to grow and adapt accordingly.

Emphasizing modularity, clarity, and long-term maintainability, OpenHDL-Core is designed to support scalable and sustainable hardware system development.

# Project Philosophy

OpenHDL-Core is built around a set of design principles that prioritize long-term usability, clarity, and evolution over short-term completeness.

## Modularity First

All designs are structured as independent and self-contained modules with well-defined interfaces. Each module should be reusable in different contexts without relying on implicit assumptions about the surrounding system.

## Clarity over Cleverness

Readability and explicitness are preferred over overly compact or obscure implementations. The code should be easy to understand, review, and maintain, even by developers who are not the original authors.

## Reusability as a Core Goal

Modules are designed to serve as general-purpose building blocks rather than project-specific solutions. Flexibility and composability are favored over narrow, highly specialized implementations.

## Language and Methodology Agnostic

The project does not enforce a single hardware description language or design methodology. Any language or approach suitable for digital hardware design is acceptable, as long as it adheres to the overall project philosophy.

## Evolution-Oriented Design

OpenHDL-Core is expected to grow and evolve over time. Architectural consistency and clean abstractions are valued more than having a complete feature set at any given moment.

# Project Structure

To ensure consistency and support the "Modularity First" philosophy, every module within OpenHDL-Core adheres to a standardized directory layout.

This structure strictly separates portable user design assets (`user/`) from vendor-specific engineering files (`prj/`), ensuring that the core design remains reusable and tool-agnostic.

![project_structure](readme_image/test.svg)

## Repository Contents

To maintain a clean and lightweight codebase, only the essential source files are committed to the repository. The version control system tracks only:

*   **src**: RTL source code.
*   **sim**: User simulation code and testbenches.
*   **data**: Constraint files (e.g., .xdc, .sdc).
*   **docs**: Design documentation (detailed below).

All other directories (such as `prj`, `ip`, `bd`, `.vscode`) are considered local workspace artifacts or generated files and are excluded.

## Documentation Details

The `docs` directory is the knowledge base for each module. It is divided into three categories to serve different purposes and audiences.

### 1. Specification (`ModuleName_spec`)

**Target Audience:** Users and Integrators.
This document describes *what* the module does and how to use it. It covers:

#### 1.1 Overview

*   **Functional Summary:**
    *   High-level description of the module's purpose and primary capabilities.
*   **Performance Metrics:**
    *   **Latency:** `[e.g., Fixed 3 cycles]`
    *   **Throughput:** `[e.g., 1 data word per clock]`
    *   **Resource Estimation (PPA):** `[e.g., ~500 LUTs, 2 BRAMs]`
*   **Dependencies:**
    *   Required sub-modules, vendor libraries (e.g., Xilinx/Intel primitives), or specific packages.

#### 1.2 Configuration Parameters
*Static configuration via Verilog `parameter` or `localparam`.*

| Parameter Name | Default Value | Valid Range | Description |
| :--- | :--- | :--- | :--- |
| `DATA_WIDTH` | 32 | 16, 32, 64 | Width of the data bus. |
| `FIFO_DEPTH` | 16 | 2^N | Depth of the internal buffer. |
| `ENABLE_FEATURE_X` | 0 | 0 or 1 | Enable switch for Feature X. |

#### 1.3 Interface

##### 1.3.1 Signal List

| Name | Width | Direction | Clock Domain | Description |
| :--- | :--- | :--- | :--- | :--- |
| `clk` | 1 | Input | N/A | System Clock. |
| `rst_n` | 1 | Input | `clk` | Active-low asynchronous reset. |
| `[signal_name]` | `[width]` | `[dir]` | `[domain]` | `[Description]` |

##### 1.3.2 Timing Diagrams

*   **Critical Transaction Sequences:**
    *   *(Place waveform images here showing Read/Write operations)*
    *   *Description of the waveform timing requirements.*

##### 1.3.3 Protocol Definitions

*   **Handshake Mechanisms:**
    *   Detailed explanation of the protocol used (e.g., AXI4-Stream, APB, custom Ready/Valid handshake).
- **Packet / Frame Structure (Format):**
    - **Definition:** How is a data packet organized? (e.g., Header, Payload, Footer/CRC).
    - **Signaling:** Usage of sideband signals like `Start of Frame (SOF)`, `End of Frame (EOF/TLAST)`, or `Byte Enables (Strobe)`.
- **Transaction Types & Bursts:**
    - **Burst Support:** Does the module support Single beat, Incrementing bursts, or Wrapping bursts?
    - **Atomic Operations:** Are locked or atomic transactions supported?
- **Data Alignment & Endianness:**
    - **Endianness:** Little-Endian vs. Big-Endian byte ordering.
    - **Alignment:** How is sub-word data aligned? (e.g., Is 8-bit data in a 32-bit bus placed at `[7:0]` or `[31:24]`?).
- **Error Reporting Protocol:**
    - **Mechanism:** How does the protocol signal a transaction failure? (e.g., AXI `bresp`, `rresp` codes).
    - **Abort Sequence:** Protocol behavior during a bus timeout or reset abort.

#### 1.4 Register Map

*   **Base Address:** `[e.g., 0x4000_0000]` (The offset base for this module).

##### 1.4.1 Register Description Table
| Offset | Name | Width | Access | Reset Value | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `0x00` | `CTRL` | 32 | RW | `0x0000` | Control Register. |
| `0x04` | `STATUS`| 32 | RO | `0x0000` | Status Register. |

##### 1.4.2 Field Details
*   **CTRL Register (0x00):**
    *   `Bit[0]`: **Enable** - Asserts module operation.
    *   `Bit[1]`: **Int_En** - Interrupt Enable.
*   **Detailed behavior:**
    *   Specific bit manipulation effects.

#### 1.5 Micro-Architecture

*Detailed functional decomposition and internal logic description.*

##### 1.5.1 Module Decomposition Tree (Functional Hierarchy)

*A hierarchical view of the module's logical partitioning.*
*(Recommended Addition: Corresponds 1-to-1 with the Block Diagram below)*

```text
ModuleName (Top)
├── [Sub-Block A] (e.g., Protocol Engine)
├── [Sub-Block B] (e.g., Data Buffer/FIFO)
└── [Sub-Block C] (e.g., Arithmetic Core)
```

##### 1.5.2 Block Diagrams & Sub-module Partitioning

- **Micro-Architecture Block Diagram:**
    - *(Insert Diagram Here - This diagram must visually match the Tree structure above)*
    - **Data Flow:** Shows how data moves through Sub-Block A $\to$ B $\to$ C.
    - **Control Flow:** Shows how signals control the processing.

##### 1.5.3 Key FSM Descriptions

- **State Diagrams:**
    - Graphical representation of the main Finite State Machine.
- **Logic Description:**
    - Explanation of state transitions and conditions.
##### 1.5.4 Data Flow Paths

- **Pipeline Stages:** Description of latency stages.
- **Data Manipulation:** How data is transformed (e.g., width conversion, encoding).

##### 1.5.5 Error Handling

- **Detection:**
    - How errors are detected (e.g., Parity error, Timeout, Protocol violation).
- **Reporting:**
    - How errors are reported (e.g., Interrupt assertion, Status flags in registers).

#### 1.6 Clock & Reset

- **Clock Domains:**
    - **Definition:** List of clock inputs and frequency requirements/restrictions.
- **CDC Strategy:**
    - **Synchronization:** Methods used between domains (e.g., Async FIFO, Handshake, 2-FF Synchronizer).
- **Reset Strategy:**
    - **Strategy:** Synchronous vs. Asynchronous reset.
    - **Polarity:** Active High or Active Low.
    - **Sequence:** Any specific reset assertion time requirements.

#### 1.7 Integration & Usage

##### 1.7.1 Instantiation Template

```verilog
// Verilog code snippet for easy instantiation
ModuleName #(
    .DATA_WIDTH (32),
    .FIFO_DEPTH (16)
) u_module (
    .clk   (clk),
    .rst_n (rst_n),
    // ... ports
);
```

##### 1.7.2 Simulation Guide

- **Instructions**: Steps to run the provided testbenches.
- **Test Cases:** Brief description of sanity tests included.

### 2. Implementation Guide (`ModuleName_impl_guides`)

**Target Audience:** Developers and Maintainers.
**Scope**: Internal design choices, hierarchical structure, logic implementation details, and maintenance guidelines.

This document describes *how* the module is implemented internally. It covers:

#### 2.1 Design Rationale

*This section explains the high-level architectural decisions and trade-offs.*

- **Architecture Selection:**
    - **Description:** Describe the chosen high-level architecture (e.g., Multi-stage pipeline, Decoupled FIFO interface, In-memory computing).
    - **Why:** Explain the reasoning behind this choice (e.g., "Chosen to meet the 500MHz timing requirement," or "Selected to comply with AXI4-Stream protocol").
- **Alternatives Considered:**
    - **Description:** Brief summary of other architectures or algorithms considered during the initial phase.
    - **Why Rejected:** Explain why they were discarded (e.g., "Alternative A saved area but failed timing closure," "Alternative B was too complex to verify").
- **PPA Trade-offs:**
    - **Goal:** State the primary optimization goal (Performance, Power, or Area).
    - **Sacrifice:** What was compromised to achieve the goal? (e.g., "Sacrificed area for lower latency").
**Algorithms & Protocols:**
    - If specific mathematical algorithms (CRC, DSP) or protocols are used, reference their standards or derivation here.

#### 2.2 Structural & Micro-Architectural View

*This section visualizes the module hierarchy and internal connectivity.* ***The Block Diagram blocks must correspond to the Module Tree nodes.***

##### 2.2.1 Module Decomposition Tree

- **Description:** A hierarchical tree diagram showing the instantiation structure (Physical Hierarchy).
- **Structure:**
    `Top_Module`
    ├── `Sub_Module_A` (e.g., Arbiter Unit)
    ├── `Sub_Module_B` (e.g., Datapath Unit)
    │   ├── `Sub_B_1` (e.g., ALU)
    │   └── `Sub_B_2` (e.g., Register File)
    └── `Sub_Module_C` (e.g., Main Control FSM)


##### 2.2.2 Micro-Architecture Block Diagram

- **Description:** A functional diagram showing data flow paths, control signals, and sub-module interaction.
- **Correspondence:** Blocks in this diagram should map 1-to-1 with the components listed in the Module Decomposition Tree.
- **Highlights:**
    - Clearly mark the **Datapath** flow.
    - Clearly mark the **Control** signals (Handshakes, interrupts).

##### 2.2.3 Sub-Module Implementation Details

*Detailed breakdown of each node defined in the Module Tree. This explains the "Tactics" of the design.*

- **Node: [Sub_Module Name]**
    - **Function:** Brief summary of what this module does.
    - **Implementation Details:**
        - Describe the internal logic (e.g., "Uses a 4-deep skid buffer," "Implemented as a Round-Robin arbiter").
    - **Design Reasoning (Why):**
        - Explain specific micro-level choices. (e.g., "Why use a skid buffer here? $\to$ To break the critical timing path from the previous stage," or "Why One-Hot encoding? $\to$ To reduce decoding latency").

##### 2.2.4 Key FSM & Control Logic

*Focus on the complex state machines and control logic.*

- **State Diagram:** Visual representation of the FSM states and transitions.
- **Complex Transitions:** Explanation of non-trivial state jumps (e.g., counter-based timeouts, external handshake dependencies).
- **Deadlock Prevention:** Mechanisms implemented to ensure the FSM never enters a stuck state.

##### 2.2.5 Coding Specifics & Parameters

- **Derived Parameters:**
    - Explain how `localparam` values are calculated based on input `parameters` (e.g., `ADDR_WIDTH = $clog2(DEPTH)`).
- **Scripting & Generation:**
    - If any code (LUTs, CSRs) is generated by scripts (Python/Tcl), provide the script location and generation commands.
- **File Hierarchy:**
    - Organization of source files (`.v`/`.sv`), headers (`.vh`), and constraints (`.sdc`).
- **Dependencies & Portability:**
    - **Vendor Primitives:**
        - List any specific vendor macros used (e.g., `Xilinx BUFG`, `Altera M20K`).
        - **Workaround:** If porting to a different technology, what needs to be replaced? (e.g., "Replace Xilinx FIFO with generic dual-port RAM").
    - **Third-Party IP:**
        - List any external open-source or commercial IPs instantiated (e.g., `Synopsys DW_div_pipe`).

##### 2.2.6 Handling Corner Cases

*Critical for maintenance. Describes how the design handles "Edge Cases."*

- **Hazards & CDC:**
    - How are Clock Domain Crossings handled? (FIFOs, Handshakes, Synchronizers).
    - How are Read-After-Write (RAW) hazards resolved?
- **Overflow/Underflow:**
    - Behavior when buffers are full or empty (Back-pressure, Drop packet, Error flag).
- **Error Recovery:**
    - How does the module recover from an illegal state or soft error?

##### 2.2.7 Verification & Debug Support

- **Critical Assertions (SVA):**
    - List key internal assertions used to catch logic bugs (e.g., `assert property (req |-> ##[1:10] ack)`).
- **Debug Hooks:**
    - List internal signals exposed for FPGA debugging (ILA/ChipScope) or performance counters.

##### 2.2.8 Optimization Record

- **Timing Closure:**
    - Documentation of past critical paths and the techniques used to fix them (Retiming, Logic Duplication, etc.).
- **Resource/Power:**
    - Specific techniques used for area reduction or clock gating.

##### 2.2.9 Performance Analysis

- **Latency Model:**
    - Formula: Define the precise latency formula (e.g., `Latency = Pipeline_Depth + (Backpressure ? 1 : 0)`).
    - Variable Latency: If latency is not fixed, explain what factors affect it (e.g., "Latency increases by 2 cycles during refresh operations").
- **Throughput Constraints:**
    - Bottlenecks: Identify the limiting logic for throughput (e.g., "The CRC calculation limits the max frequency to 400MHz, affecting total throughput").
    - Recovery Time: How many cycles does it take to recover full throughput after a reset or idle state?

##### 2.2.10 Known Issues & Roadmap (TODOs)

- **Current Limitations:**
    - Features described in the Spec but not yet implemented (e.g., "Parity Check is currently a stub").
    - Known bugs or waivers (e.g., "Sequence X causes a hang, currently mitigated by software restriction").
- **Future Work:**
    - Planned optimizations or refactoring (e.g., "Plan to replace the ripple-carry adder with a look-ahead adder in v2.0").

### 3. IP/BD Configuration
**Target Audience:** Implementation Engineers.
*   Contains configuration files or settings for Block Designs (BD) or Vendor IPs used in the project, ensuring the design environment can be reproduced.


### Note on Documentation Availability

> *   **Specification**: Mandatory for **ALL** modules.
> *   **Implementation Guide**: Provided only for complex modules. Simple utility modules may skip this if the code is self-explanatory.
> *   **IP/BD Configuration**: Provided only for modules that utilize specific Vendor IPs or Block Designs.


