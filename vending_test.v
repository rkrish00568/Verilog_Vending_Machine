`timescale 1ns / 1ps

module vending_machine_tb;

    reg clk;
    reg rst;
    reg [1:0] in;
    reg [1:0] select;
    wire dispense;
    wire [1:0] change;

    vending_machine uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .select(select),
        .dispense(dispense),
        .change(change)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("vending_machine.vcd");
        $dumpvars(0, vending_machine_tb);
        $dumpvars(1, uut);

        $display("Time\tclk\trst\tin\tselect\tdispense\tchange\tbalance\tprice\tstate");
        $monitor("%g\t%b\t%b\t%02b\t%02b\t%b\t\t%02b\t%d\t%d\t%02b",
                 $time, clk, rst, in, select, dispense, change,
                 uut.balance, uut.price, uut.state);

        rst = 1; in = 2'b00; select = 2'b00;
        #12;
        rst = 0;

        in = 2'b10; select = 2'b01;
        #10;
        in = 2'b00; select = 2'b01;
        #30;

        in = 2'b10; select = 2'b10;
        #10;
        in = 2'b01; select = 2'b10;
        #10;
        in = 2'b00; select = 2'b10;
        #30;

        in = 2'b10; select = 2'b11;
        #10;
        in = 2'b10; select = 2'b11;
        #10;
        in = 2'b00; select = 2'b11;
        #30;

        in = 2'b10; select = 2'b10;
        #10;
        in = 2'b10; select = 2'b10;
        #10;
        in = 2'b00; select = 2'b10;
        #30;

        in = 2'b10; select = 2'b01;
        #10;
        rst = 1;
        #10;
        rst = 0;
        in = 2'b00; select = 2'b00;
        #20;

        $finish;
    end

endmodule
