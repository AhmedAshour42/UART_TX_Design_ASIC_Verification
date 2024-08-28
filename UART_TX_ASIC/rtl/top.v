module top #(parameter width = 8) (
  input clk,               // Clock input
  input rst,               // Reset input
  input Data_valid,        // Valid data input
  input wire[width-1:0] P_data,  // Data input
  input Par_type,           // Parity type input
  input Par_en,             // Parity enable input
  output wire Busy,         // Busy signal output
  output wire TX_out,       // Output data signal
  // added signals for Dft
  input  wire SI,          // Scan input
  input  wire SE,          // Scan enable
  input  wire scan_clk,    // Scan clock
  input  wire scan_rst,    // Scan reset
  input  wire test_mode,   // Test mode select
  output wire SO           // Scan output
);

  wire ser_en;              // Serializer enable wire
  wire ser_done;            // Serializer done wire
  wire ser_data;            // Serializer data wire
  wire Par_bit;             // Parity bit wire
  wire [1:0] mux_sel;       // Mux selector wire
  wire start_bit;           // Start bit wire
  wire stop_bit;            // Stop bit wire
  wire idle_data;           // Idle data wire

  wire CLK_M, RST_M;        // Muxed clock and reset wires

  assign start_bit = 0;     // Assign start bit to 0
  assign stop_bit = 1;      // Assign stop bit to 1

  ///////////////////////////////////////////////////////////////////////////////////

  // Muxing primary clock
  Mux_dft U0_mux2X1 (
    .IN_0(clk),            // Input clock
    .IN_1(scan_clk),       // Scan clock
    .SEL(test_mode),       // Select signal for mux
    .OUT(CLK_M)            // Muxed clock output
  ); 
  
  // Muxing resets
  Mux_dft U2_mux2X1 (
    .IN_0(rst),            // Input reset
    .IN_1(scan_rst),       // Scan reset
    .SEL(test_mode),       // Select signal for mux
    .OUT(RST_M)            // Muxed reset output
  ); 

  /* ---------------------- // Instantiate Parity module ---------------------- */
  Parity #(.width(width)) DUT_2 (
    .clk(CLK_M),           // Muxed clock
    .rst(RST_M),           // Muxed reset
    .Data_valid(Data_valid), // Valid data input
    .P_data(P_data),       // Data input
    .Par_type(Par_type),   // Parity type input
    .Par_bit(Par_bit)      // Parity bit output
  );

  /* ------------------------ // Instantiate FSM module ----------------------- */
  FSM DUT_3 (
    .clk(CLK_M),           // Muxed clock
    .rst(RST_M),           // Muxed reset
    .Data_valid(Data_valid), // Valid data input
    .ser_done(ser_done),   // Serializer done signal
    .Par_en(Par_en),       // Parity enable input
    .mux_sel(mux_sel),     // Mux selector output
    .ser_en(ser_en),       // Serializer enable output
    .Busy(Busy),           // Busy signal output
    .idle_data(idle_data)  // Idle data output
  );

  /* ------------------------ // Instantiate Mux module ----------------------- */
  mux DUT_4 (
    .start_bit(start_bit), // Start bit input
    .stop_bit(stop_bit),   // Stop bit input
    .mux_sel(mux_sel),     // Mux selector input
    .Par_bit(Par_bit),     // Parity bit input
    .ser_data(ser_data),   // Serializer data input
    .TX_out(TX_out)        // Transmit data output
  );

  /* -------------------- // Instantiate Serializer module -------------------- */
  serializer #(.width(width)) DUT_1 (
    .clk(CLK_M),           // Muxed clock
    .rst(RST_M),           // Muxed reset
    .Data_valid(Data_valid), // Valid data input
    .P_data(P_data),       // Data input
    .ser_en(ser_en),       // Serializer enable input
    .ser_done(ser_done),   // Serializer done output
    .ser_data(ser_data),   // Serializer data output
    .idle_data(idle_data)  // Idle data output
  );

endmodule

