module TOP_INTEFACE ();
    bit clk;
    
initial begin
    clk =0;
    forever begin
        #1 clk =!clk;
    end
end
UART_TX_INTF intf(clk);
top_tb top_tbs(intf);
top tops (intf);

    
endmodule