
module vending_machine_fsm (
    input clk,
    input reset,
    input [1:0] coin,           // 00 = ₹1, 01 = ₹2, 10 = ₹5
    input [1:0] select_item,    // Item selection (00 to 11)
    input cancel,
    output reg dispense,
    output reg [3:0] refund,
    output reg low_stock,
    output reg [6:0] balance
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE,
        COIN_IN,
        WAIT_SELECT,
        CHECK_ITEM,
        DISPENSE,
        REFUND
    } state_t;

    state_t state, next_state;

    parameter LOW_STOCK_THRESHOLD = 2;

    reg [6:0] item_price[3:0];
    reg [3:0] stock[3:0];
    reg [6:0] current_balance;

    // Coin decoder
    wire [6:0] coin_value;
    assign coin_value = (coin == 2'b00) ? 1 :
                        (coin == 2'b01) ? 2 :
                        (coin == 2'b10) ? 5 : 0;

    // FSM state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            current_balance <= 0;
            dispense <= 0;
            refund <= 0;
            low_stock <= 0;

            stock[0] <= 5; stock[1] <= 5; stock[2] <= 5; stock[3] <= 5;
            item_price[0] <= 7;
            item_price[1] <= 10;
            item_price[2] <= 12;
            item_price[3] <= 15;
        end else begin
            state <= next_state;
        end
    end

    // FSM output logic
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                dispense <= 0;
                refund <= 0;
                low_stock <= 0;
                if (coin != 2'b11)
                    next_state <= COIN_IN;
                else
                    next_state <= IDLE;
            end

            COIN_IN: begin
                current_balance <= current_balance + coin_value;
                next_state <= WAIT_SELECT;
            end

            WAIT_SELECT: begin
                if (cancel)
                    next_state <= REFUND;
                else if (current_balance >= item_price[select_item])
                    next_state <= CHECK_ITEM;
                else if (coin != 2'b11)
                    next_state <= COIN_IN;
                else
                    next_state <= WAIT_SELECT;
            end

            CHECK_ITEM: begin
                if (stock[select_item] > 0)
                    next_state <= DISPENSE;
                else
                    next_state <= WAIT_SELECT;
            end

            DISPENSE: begin
                dispense <= 1;
                current_balance <= current_balance - item_price[select_item];
                stock[select_item] <= stock[select_item] - 1;
                if (stock[select_item] <= LOW_STOCK_THRESHOLD)
                    low_stock <= 1;
                next_state <= WAIT_SELECT;
            end

            REFUND: begin
                refund <= current_balance;
                current_balance <= 0;
                next_state <= IDLE;
            end

            default: next_state <= IDLE;
        endcase
    end

    assign balance = current_balance;

endmodule
