`timescale 1ns/1ps

module serializer_tb;

// Signals

parameter width = 8;

reg [width-1:0] P_data;

reg clk, rst, Data_valid, ser_en;
reg idle_data;
wire ser_done;
wire [7:0] parallel_data;
wire ser_data;
integer correct = 0;
integer uncorrect = 0;

// Instantiate the module under test
serializer uut (
  .clk(clk),
  .rst(rst),
  .Data_valid(Data_valid),
  .P_data(P_data),
  .ser_en(ser_en),
  .ser_done(ser_done),
  .ser_data(ser_data),
  .idle_data(idle_data)
);

// Internal variables for testing
integer i = 0;
integer k = 0;
reg [7:0] ser_check;

// Clock generation
initial begin
  clk = 0;
  forever begin
    #1 clk = ~clk;
  end
end

// Reset generation and test cases
initial begin
  rst = 0;
  ser_en = 0;
  Data_valid = 0;
  @(negedge clk);

  // Function to check correctness after reset
  rst_chk();

  // Handle Data_valid = 1 for one clock cycle 
  // Apply test cases
  for (k = 0; k < 10; k = k + 1) begin
    // Generate random data
    Data_valid = 1;
    P_data = $random;
    @(negedge clk);
    Data_valid = 0;
    ser_en = 1;
    idle_data= $random;
    // Wait for serialization to complete
    repeat (8) begin
      @(negedge clk);
      ser_check[i] = ser_data;
      i = i + 1;
      if (i == 8) begin
        i = 0;
      end
    end
    // Function to check data correctness
    check_data(ser_check);
    ser_en = 0;
    if (idle_data) begin
      @(negedge clk);
      if (ser_data !== 1) begin
        $display("Uncorrected data after reset");
        uncorrect = uncorrect + 1;
      end
      else begin
        correct = correct + 1;
      end
    end
  end

  // Display total correctness
  $display("Total Correct: %d", correct);
  $display("Total Incorrect: %d", uncorrect);
  $stop;
end

// Task to check correctness after reset
task rst_chk;
begin
  if (ser_data !== 1 || ser_done !== 0) begin
    $display("Uncorrected data after reset");
    uncorrect = uncorrect + 1;
  end
  else begin
    correct = correct + 1;
  end
  rst = 1; // Release reset after check
end
endtask

// Task to check data correctness
task check_data(input [7:0] ser_check);
begin
  if (ser_check !== P_data || ser_done !== 1) begin
    $display("Uncorrected data after serialization");
    $display("Expected Serialized Data: %b", P_data);
    $display("Actual Serialized Data: %b", ser_check);
    $display("Expected ser_done: 1, Actual ser_done: %d", ser_done);
    uncorrect = uncorrect + 1;
  end
  else begin
    $display("Correct data after serialization");
    correct = correct + 1;
  end
end
endtask

endmodule
