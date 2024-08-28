module FSM (
    input clk,                // Clock input
    input rst,                // Reset input
    input Data_valid,         // Data validity input
    input ser_done,           // Serializer done input
    input Par_en,             // Parity enable input
    output reg [1:0] mux_sel, // Mux select output
    output reg ser_en,        // Serializer enable output
    output reg Busy,          // Busy signal output
    output reg idle_data      // Idle data output
);

    // State definitions using state_t enumeration
    typedef enum logic [2:0] {
        IDLE = 3'b000,  // Idle state
        STR  = 3'b001,  // Start bit state
        DATA = 3'b010,  // Data transmission state
        PAR  = 3'b011,  // Parity bit state
        STP  = 3'b100   // Stop bit state
    } state_t;

    // Registers for state transition
    state_t current_state, next_state;

    // Current state logic
    always @(posedge clk or negedge rst) begin
        // State transition on positive clock edge or negative reset
        if (~rst) begin
            current_state <= IDLE;  
            // Reset to IDLE state
        end
        else begin
            current_state <= next_state;  // Update current state based on next state
        end
    end

    // Next state logic
    always @(*) begin
        // Logic for determining the next state based on the current state
        case (current_state)
            IDLE: begin
                if (Data_valid) begin
                    next_state = STR;  // Transition to Start bit state if data is valid
                end
                else begin
                    next_state = IDLE;  // Stay in IDLE state if no valid data
                end
            end
            STR: begin
                next_state = DATA;  // Transition to Data state after Start bit
            end
            DATA: begin
                if (!ser_done) begin
                    next_state = DATA;  // Stay in Data state if serialization is not done
                end
                else begin
                    if (Par_en) begin
                        next_state = PAR;  // Transition to Parity state if Parity is enabled
                    end
                    else begin
                        next_state = STP;  // Transition to Stop bit state if no Parity
                    end
                end
            end
            PAR: begin
                next_state = STP;  // Transition to Stop bit state after Parity bit
            end
            STP: begin
                next_state = IDLE;  // Transition back to IDLE state after Stop bit
            end
            default: begin
                next_state = IDLE;  // Default transition to IDLE state
            end
        endcase
    end

    // Output logic based on current state
    always @(*) begin
        // Output logic based on the current state to control mux_sel, ser_en, and Busy
        case (current_state)
            IDLE: begin
                idle_data = 0;  
                Busy = 0;       // Not busy in IDLE state
                ser_en = 0;     // Serializer disabled in IDLE state
                mux_sel = 2;    // Mux selects the IDLE state output
            end
            STR: begin
                idle_data = 0;
                Busy = 1;       // Busy during Start bit
                ser_en = 1;     // Serializer enabled during Start bit
                mux_sel = 0;    // Mux selects the Start bit output
            end
            DATA: begin
                idle_data = 0;
                Busy = 1;       // Busy during Data bits
                ser_en = 1;     // Serializer enabled during Data bits
                mux_sel = 2;    // Mux selects the Data bits output
            end
            PAR: begin
                idle_data = 0;  // Not active idle of serial data
                Busy = 1;       // Busy during Parity bit
                ser_en = 0;     // Serializer disabled during Parity bit
                mux_sel = 3;    // Mux selects the Parity bit output
            end
            STP: begin
                idle_data = 1;  // To make ser_data of serializer = 1   
                Busy = 1;       // Busy during Stop bit
                ser_en = 0;     // Serializer disabled during Stop bit
                mux_sel = 1;    // Mux selects the Stop bit output
            end
            default: begin
                idle_data = 0;
                Busy = 0;       // Not busy in default state
                ser_en = 0;     // Serializer disabled in default state
                mux_sel = 2;    // Mux selects the default state output
            end
        endcase
    end

endmodule
