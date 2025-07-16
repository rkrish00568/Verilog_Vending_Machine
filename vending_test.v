

module vending_machine_fsm_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [1:0] coin;
    reg [1:0] select_item;
    reg cancel;

    // Outputs
    wire dispense;
    wire [3:0] refund;
    wire low_stock;
    wire [6:0] balance;

    // Instantiate the DUT (Device Under Test)
    vending_machine_fsm dut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .select_item(select_item),
        .cancel(cancel),
        .dispense(dispense),
        .refund(refund),
        .low_stock(low_stock),
        .balance(balance)
    );

    // Clock Generation
    always #5 clk = ~clk;
  
  initial begin
    $dumpfile("vending_machine.vcd");         // Name of the VCD output file
    $dumpvars(0, vending_machine_fsm_tb);     // Dump all variables in the testbench hierarchy
end


    // Test Sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        coin = 2'b11;          // No coin inserted
        select_item = 2'b00;
        cancel = 0;

        // Hold reset
        #10 reset = 0;

        $display("\n=== Test 1: Insert 5 + 2 and buy Item 0 (₹7) ===");
        coin = 2'b10; #10 coin = 2'b11; // Insert ₹5
        coin = 2'b00; #10 coin = 2'b11; // Insert ₹1
        coin = 2'b00; #10 coin = 2'b11; // Insert ₹1 (total = ₹7)
        select_item = 2'b00; #20;       // Try to buy item 0

        #10;

        $display("\n=== Test 2: Insert ₹5 and try to buy Item 1 (₹10) ===");
        coin = 2'b10; #10 coin = 2'b11; // ₹5 only
        select_item = 2'b01; #20;       // Not enough, should NOT dispense

        #10;

        $display("\n=== Test 3: Insert ₹5 + ₹5, buy Item 1 (₹10) ===");
        coin = 2'b10; #10 coin = 2'b11; // ₹5
        coin = 2'b10; #10 coin = 2'b11; // ₹5 (total ₹10)
        select_item = 2'b01; #20;       // Buy item 1

        #10;

        $display("\n=== Test 4: Cancel and Refund ===");
        coin = 2'b01; #10 coin = 2'b11; // ₹2
        cancel = 1; #10 cancel = 0;     // Cancel, should refund ₹2

        #10;

        $display("\n=== Test 5: Buy Item 0 until Low Stock ===");
        repeat (4) begin
            coin = 2'b10; #10 coin = 2'b11; // ₹5
            coin = 2'b00; #10 coin = 2'b11; // ₹1
            coin = 2'b00; #10 coin = 2'b11; // ₹1
            select_item = 2'b00; #20;       // Buy item 0
        end

        #50 $finish;
    end

endmodule
