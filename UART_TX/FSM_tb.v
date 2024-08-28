`timescale 1ns/1ps

module FSM_tb;

// Signals
reg clk, rst, Data_valid, ser_done, Par_en;
wire [1:0] mux_sel;
wire ser_en, Busy;
wire idle_data ; // Signal indicating idle state

// Instantiate the module under test
FSM uut (
  .clk(clk),
  .rst(rst),
  .Data_valid(Data_valid),
  .ser_en(ser_en),
  .ser_done(ser_done),
  .Par_en(Par_en),
  .mux_sel(mux_sel),
  .Busy(Busy),
  .idle_data(idle_data)
);

// Counter for correct and wrong outputs
integer correct = 0, wrong = 0;

// Clock generation
initial begin
  clk = 0;
  // Generate a clock with a period of 2 time units
  forever begin
    #1 clk = ~clk;
  end
end

// Wire to capture the current state for checking
wire [3:0] cs;
assign cs = uut.current_state;

// Reset generation
initial begin
  rst = 0;
  Data_valid = 0;
  Par_en = 0;
  ser_done = 0;

  // Check correctness after reset
  check_rst();

  // Apply reset
  rst = 1;
  @(negedge clk);

  // Case 1: Data_valid = 0
  Data_valid = 0;
  // Expected outputs: Idle state
  $display("Case 1 - Expected outputs: Idle state");
  check_out(0,0, 0, 0, 2, 0);

  // Case 2: Data_valid = 1
  Data_valid = 1;
  // Expected outputs: Start state
  $display("Case 2 - Expected outputs: Start state");
  check_out(0,1, 1, 1, 0, 0);

  // Case 3: Data_valid = 1, ser_done = 0, Par_en = 0
  ser_done = 0;
  // Expected outputs: Data state
  $display("Case 3 - Expected outputs: Data state");
  check_out(0,2, 1, 1, 2, 0);

  // Case 4: ser_done = 1, Par_en = 1
  Par_en = 1;
  ser_done = 1;
  // Expected outputs: PAR state
  $display("Case 4 - Expected outputs: PAR state");
  check_out(0,3, 1, 0, 3, 0);

  // Expected outputs: Stop state
  $display("Case 5 - Expected outputs: Stop state");
  check_out(1,4, 1, 0, 1, 0);

  // Case 6: Data_valid = 1, ser_done = 0, Par_en = 0
  Data_valid = 1;
  ser_done = 1;
  Par_en = 0;

  // Wait for 3 clock cycles
  repeat (3) @(negedge clk);
  // Expected outputs: Stop state after Data state
  $display("Case 6 - Expected outputs: Stop state after Data state");
  check_out(1,4, 1, 0, 1, 1);

  // Display correct and wrong counts
  $display("Correct outputs: %0d", correct);
  $display("Wrong outputs: %0d", wrong);
  $stop;
end

// Task to check correctness of the outputs
task check_out(input idle_data_exp, input [3:0] cs_exp, input Busy_expect, input sen_exp, input [1:0] mux_sel_exp, input ideal_data_exp);
begin
  @(negedge clk);
  if (cs_exp !== cs || Busy_expect !== Busy || sen_exp !== ser_en || mux_sel_exp !== mux_sel || idle_data_exp !== idle_data) begin
    wrong = wrong + 1;
    $display("Output Mismatch:");
    $display("Expected Current state: %b, Actual Current state: %b", cs_exp, cs);
    $display("Expected Busy: %b, Actual Busy: %b", Busy_expect, Busy);
    $display("Expected Serializer enable: %b, Actual Serializer enable: %b", sen_exp, ser_en);
    $display("Expected Mux select: %b, Actual Mux select: %b", mux_sel_exp, mux_sel);
    $display("Expected ideal data: %b, Actual ideal data, %b", idle_data_exp, idle_data);
    $display("=========================================");
  end
  else begin
    correct = correct + 1;
  end
end
endtask

// Task to check correctness after reset
task check_rst;
begin
  @(negedge clk);
  if (cs !== 3'b000 || Busy !== 0 || ser_en !== 0 || mux_sel !== 2 || idle_data !== 0) begin
    wrong = wrong + 1;
    $display("Incorrect reset state:");
    $display("Actual Current state: %b", cs);
    $display("Actual Busy: %b", Busy);
    $display("Actual Serializer enable: %b", ser_en);
    $display("Actual Mux select: %b", mux_sel);
    $display("Actual ideal data: %b", idle_data);
    $display("=========================================");
  end
  else begin
    correct = correct + 1;
  end
end
endtask

endmodule
