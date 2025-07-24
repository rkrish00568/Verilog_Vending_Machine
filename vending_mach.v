module vending_machine (
    input clk,
    input rst,
    input [1:0] in,
    input [1:0] select,
    output reg dispense,
    output reg [1:0] change
);

    parameter IDLE = 2'b00, WAIT = 2'b01, DISPENSE = 2'b10;

    reg [1:0] state, next_state;
    reg [5:0] balance;
    reg [5:0] price;

    always @(*) begin
        case (select)
            2'b01: price = 10;
            2'b10: price = 15;
            2'b11: price = 20;
            default: price = 0;
        endcase
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (in != 2'b00) next_state = WAIT;
            WAIT: if (balance >= price && price != 0) next_state = DISPENSE;
            DISPENSE: next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            balance <= 0;
            dispense <= 0;
            change <= 2'b00;
        end else begin
            state <= next_state;

            if (in == 2'b01)
                balance <= balance + 5;
            else if (in == 2'b10)
                balance <= balance + 10;

            if (next_state == DISPENSE) begin
                dispense <= 1;
                if (balance > price) begin
                    case (balance - price)
                        5: change <= 2'b01;
                        10: change <= 2'b10;
                        15: change <= 2'b11;
                        default: change <= 2'b00;
                    endcase
                end else begin
                    change <= 2'b00;
                end
                balance <= 0;
            end else begin
                dispense <= 0;
                change <= 2'b00;
            end
        end
    end

endmodule
