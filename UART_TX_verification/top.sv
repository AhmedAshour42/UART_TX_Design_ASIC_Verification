
module top(UART_TX_INTF.DUT top_intf);
  
  wire ser_en;              // Serializer enable wire
  wire ser_done;            // Serializer done wire
  wire ser_data;            // Serializer data wire
  wire Par_bit;             // Parity bit wire
  wire [1:0] mux_sel;       // Mux selector wire
  wire start_bit;           // Start bit wire
  wire stop_bit;            // Stop bit wire
  wire idle_data;           // Idle data wire 
  
  assign start_bit = 0;     // Assign start bit to 0
  assign stop_bit = 1;      // Assign stop bit to 1
  
  /* ---------------------- // Instantiate Parity module ---------------------- */
  Parity #(.width(top_intf.width)) DUT_2 (
    .clk(top_intf.clk),
    .rst(top_intf.rst),
    .Data_valid(top_intf.Data_valid),
    .P_data(top_intf.P_data),
    .Par_type(top_intf.Par_type),
    .Par_bit(Par_bit)
  );

  /* ------------------------ // Instantiate FSM module ----------------------- */
  FSM DUT_3 (
    .clk(top_intf.clk),
    .rst(top_intf.rst),
    .Data_valid(top_intf.Data_valid),
    .ser_done(ser_done),
    .Par_en(top_intf.Par_en),
    .mux_sel(mux_sel),
    .ser_en(ser_en),
    .Busy(top_intf.Busy),
    .idle_data(idle_data)
  );

  /* ------------------------ // Instantiate Mux module ----------------------- */
  mux DUT_4 (
    .start_bit(start_bit),
    .stop_bit(stop_bit),
    .mux_sel(mux_sel),
    .Par_bit(Par_bit),
    .ser_data(ser_data),
    .TX_out(top_intf.TX_out)
  );

  /* -------------------- // Instantiate Serializer module -------------------- */
  serializer #(.width(top_intf.width)) DUT_1 (
    .clk(top_intf.clk),
    .rst(top_intf.rst),
    .Data_valid(top_intf.Data_valid),
    .P_data(top_intf.P_data),
    .ser_en(ser_en),
    .ser_done(ser_done),
    .ser_data(ser_data),
    .idle_data(idle_data)
  );

endmodule
