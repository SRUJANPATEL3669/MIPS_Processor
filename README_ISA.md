# 🖥️ Custom 24-bit Instruction Set Architecture (ISA) Design

### 📁 Computer Architecture Course Project  
**Team Members:**  
- **Srujan Patel (230001063)**  
- **Prayag Lakhani (230001045)**  

---

## 📌 Overview

This project presents the design and implementation of a **custom 24-bit Reduced Instruction Set Architecture (RISC)**. The primary goal is to balance compact instruction encoding with functional completeness—supporting arithmetic, logical, memory, and control operations using a clean, modular design.

---

## 🧠 ISA Highlights

- **Instruction Width:** 24 bits  
- **Instruction Types:** R-type, I-type, J-type  
- **Opcode Width:** 4 bits  
- **Register IDs:** 5 bits each  
- **Registers:** 16 or 32 General-Purpose Registers

---

## 📐 Instruction Formats

### 🔸 R-type (Register-Register)
Used for arithmetic and logical operations.

```
[ opcode (4) | rs (5) | rt (5) | rd (5) | pad (5) ]
```

### 🔸 I-type (Immediate & Memory)
Used for immediate arithmetic, memory access, and branches.

```
[ opcode (4) | rs/rt (5) | rd (5) | immediate (10) ]
```

### 🔸 J-type (Jump)
Used for jump instructions.

```
[ opcode (4) | address (20) ]
```

---

## 🧾 Instruction Set

| Instruction | Operation                     | Type | Opcode | Format                  |
|-------------|-------------------------------|------|--------|--------------------------|
| ADD         | `RD ← RS + RT`                | R    | 0000   | R-type                   |
| SUB         | `RD ← RS - RT`                | R    | 0001   | R-type                   |
| AND         | `RD ← RS & RT`                | R    | 0010   | R-type                   |
| OR          | `RD ← RS | RT`                | R    | 0011   | R-type                   |
| XOR         | `RD ← RS ^ RT`                | R    | 0100   | R-type                   |
| SLT         | `RD ← (RS < RT)`              | R    | 0101   | R-type                   |
| SLL         | `RD ← RT << IMM`              | I    | 0110   | I-type                   |
| SRL         | `RD ← RT >> IMM`              | I    | 0111   | I-type                   |
| ADDI        | `RD ← RS + IMM`               | I    | 1000   | I-type                   |
| ANDI        | `RD ← RS & IMM`               | I    | 1001   | I-type                   |
| ORI         | `RD ← RS | IMM`               | I    | 1010   | I-type                   |
| XORI        | `RD ← RS ^ IMM`               | I    | 1011   | I-type                   |
| LW          | `RD ← MEM[RS + IMM]`          | I    | 1100   | I-type                   |
| SW          | `MEM[RS + IMM] ← RD`          | I    | 1101   | I-type                   |
| BEQ         | `if (RS == RT) PC += IMM`     | I    | 1110   | I-type (branch)          |
| JUMP        | `PC ← address`                | J    | 1111   | J-type                   |

---

## 🧱 Pipeline Design (IF & ID Stages)

### 🔹 Instruction Fetch (IF)
- **Program Counter (PC):** Points to the current instruction  
- **Instruction Memory:** Supplies 24-bit instructions  
- **PC + 1:** Advances the pipeline

### 🔹 Instruction Decode (ID)
- **Instruction Register:** Stores current instruction  
- **Opcode Decoder:** Decodes the operation  
- **Register File:** Holds general-purpose registers  
- **Immediate Extractor:** Extracts 10-bit constants  
- **Control Unit:** Generates control signals

### 📷 Pipeline Diagram

![Pipeline Diagram](pipeline_diagram.png)

---

## ✅ Deliverables

- ✅ Instruction Set Specification  
- ✅ Instruction Format Design  
- ✅ Control Signal Mapping  
- ✅ IF and ID Stage Block Diagram

---

## 📎 Future Scope

- Implement pipeline stages (EX, MEM, WB)  
- Simulate instruction execution in Verilog or Logisim  
- Add support for interrupts and hazard handling

---

## 🛠️ Tools Suggested

- `draw.io` for diagrams  
- `Logisim` or `Verilog` for simulation (optional extensions)

---

## 📃 License

This project is for academic use only under the IIT Indore course on Computer Architecture.
