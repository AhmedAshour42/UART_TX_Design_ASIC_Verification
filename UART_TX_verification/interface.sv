interface UART_TX_INTF(input clk);
    parameter int width = 8;
    
    logic rst;               // Reset logic
    logic Data_valid;        // Valid data logic
    logic [width-1:0] P_data;  // Data logic
    logic Par_type;          // Parity type logic
    logic Par_en;            // Parity enable logic
    logic Busy;              // Busy signal logic
    logic TX_out;            // TX data signal

    modport DUT (
        input clk, rst, Data_valid, P_data, Par_en, Par_type,
        output Busy, TX_out
    );
    
    modport TEST (
        output rst, Data_valid, P_data, Par_en, Par_type,
        input Busy, TX_out, clk
    );
endinterface
