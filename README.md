# FSM-Based Vending Machine in Verilog

This project simulates a finite state machine (FSM)-based vending machine using Verilog HDL. It models the behavior of a real-world vending machine that accepts coins and dispenses products with appropriate change.

## 🧠 Description

The vending machine accepts the following coin inputs:
- `00` → ₹0
- `01` → ₹5
- `10` → ₹10

The available items and their prices:
- `01` → Item A (₹10)
- `10` → Item B (₹15)
- `11` → Item C (₹20)

The machine operates with a simple three-state FSM:
- `IDLE`: Waiting for money input.
- `WAIT`: Accumulating money.
- `DISPENSE`: Dispensing the selected item and returning change.

## 🔁 FSM Architecture

| State     | Description                       |
|-----------|-----------------------------------|
| `IDLE`    | Waits for a non-zero coin input   |
| `WAIT`    | Waits until enough balance        |
| `DISPENSE`| Dispenses item & returns change   |

## 📁 Files

- `vending_machine.v`: Main Verilog module implementing the FSM logic.
- `vending_machine_tb.v`: Testbench simulating multiple usage scenarios.

## 🧪 Test Cases Covered

1. Buy Item A (₹10) using ₹10
2. Buy Item B (₹15) using ₹10 + ₹5
3. Buy Item C (₹20) using ₹10 + ₹10
4. Buy Item B with ₹20 and receive ₹5 change
5. Reset during transaction

## 🛠️ Simulation Instructions

To run the simulation with Icarus Verilog and GTKWave:

```bash

