/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Wed Aug 28 08:53:31 2024
/////////////////////////////////////////////////////////////


module Parity ( clk, rst, Data_valid, P_data, Par_type, Par_bit );
  input [7:0] P_data;
  input clk, rst, Data_valid, Par_type;
  output Par_bit;
  wire   n1, n3, n4, n5, n6, n7, n2;

  DFFRX1M par_reg ( .D(n7), .CK(clk), .RN(rst), .Q(Par_bit) );
  XNOR2X2M U3 ( .A(P_data[3]), .B(P_data[2]), .Y(n5) );
  OAI2BB2X1M U4 ( .B0(n1), .B1(n2), .A0N(Par_bit), .A1N(n2), .Y(n7) );
  INVX2M U5 ( .A(Data_valid), .Y(n2) );
  XOR3XLM U6 ( .A(n3), .B(Par_type), .C(n4), .Y(n1) );
  XOR3XLM U7 ( .A(P_data[1]), .B(P_data[0]), .C(n5), .Y(n4) );
  XOR3XLM U8 ( .A(P_data[5]), .B(P_data[4]), .C(n6), .Y(n3) );
  CLKXOR2X2M U9 ( .A(P_data[7]), .B(P_data[6]), .Y(n6) );
endmodule


module FSM ( clk, rst, Data_valid, ser_done, Par_en, mux_sel, ser_en, Busy, 
        idle_data );
  output [1:0] mux_sel;
  input clk, rst, Data_valid, ser_done, Par_en;
  output ser_en, Busy, idle_data;
  wire   n4, n5, n6, n7, n9, n10, n11, n2, n3, n8, n12;
  wire   [3:0] current_state;
  wire   [2:0] next_state;

  DFFRX4M \current_state_reg[1]  ( .D(next_state[1]), .CK(clk), .RN(rst), .Q(
        current_state[1]), .QN(n8) );
  DFFRX4M \current_state_reg[2]  ( .D(next_state[2]), .CK(clk), .RN(rst), .Q(
        current_state[2]), .QN(n12) );
  DFFRX4M \current_state_reg[0]  ( .D(next_state[0]), .CK(clk), .RN(rst), .Q(
        current_state[0]), .QN(n3) );
  AND3X2M U3 ( .A(n11), .B(n2), .C(current_state[2]), .Y(idle_data) );
  XNOR2X2M U4 ( .A(current_state[2]), .B(n3), .Y(n10) );
  NOR2X3M U5 ( .A(n3), .B(n8), .Y(n6) );
  XNOR2X4M U6 ( .A(n3), .B(n8), .Y(n11) );
  OAI32X2M U7 ( .A0(n5), .A1(current_state[0]), .A2(n8), .B0(n3), .B1(
        current_state[1]), .Y(n7) );
  NOR2X3M U8 ( .A(current_state[2]), .B(n11), .Y(ser_en) );
  AO21X2M U9 ( .A0(n12), .A1(n6), .B0(idle_data), .Y(mux_sel[0]) );
  OR2X8M U10 ( .A(ser_en), .B(mux_sel[0]), .Y(Busy) );
  NOR2BX2M U11 ( .AN(ser_done), .B(Par_en), .Y(n5) );
  NAND2X2M U12 ( .A(n8), .B(n10), .Y(mux_sel[1]) );
  INVX2M U13 ( .A(n6), .Y(n2) );
  NOR3X2M U14 ( .A(current_state[2]), .B(current_state[0]), .C(n9), .Y(
        next_state[0]) );
  AOI32X1M U15 ( .A0(ser_done), .A1(current_state[1]), .A2(Par_en), .B0(
        Data_valid), .B1(n8), .Y(n9) );
  NOR2X2M U16 ( .A(n4), .B(current_state[2]), .Y(next_state[2]) );
  AOI21X2M U17 ( .A0(n5), .A1(current_state[1]), .B0(n6), .Y(n4) );
  AND2X2M U18 ( .A(n7), .B(n12), .Y(next_state[1]) );
endmodule


module mux ( start_bit, stop_bit, mux_sel, Par_bit, ser_data, TX_out );
  input [1:0] mux_sel;
  input start_bit, stop_bit, Par_bit, ser_data;
  output TX_out;
  wire   n5, n2, n3, n4;

  CLKBUFX8M U1 ( .A(n5), .Y(TX_out) );
  OAI2B2X1M U2 ( .A1N(mux_sel[1]), .A0(n2), .B0(mux_sel[1]), .B1(n3), .Y(n5)
         );
  INVX2M U3 ( .A(mux_sel[0]), .Y(n4) );
  AOI22X1M U4 ( .A0(start_bit), .A1(n4), .B0(stop_bit), .B1(mux_sel[0]), .Y(n3) );
  AOI22X1M U5 ( .A0(Par_bit), .A1(mux_sel[0]), .B0(ser_data), .B1(n4), .Y(n2)
         );
endmodule


module serializer_DW01_inc_0 ( A, SUM );
  input [31:0] A;
  output [31:0] SUM;

  wire   [31:2] carry;

  ADDHX1M U1_1_30 ( .A(A[30]), .B(carry[30]), .CO(carry[31]), .S(SUM[30]) );
  ADDHX1M U1_1_29 ( .A(A[29]), .B(carry[29]), .CO(carry[30]), .S(SUM[29]) );
  ADDHX1M U1_1_28 ( .A(A[28]), .B(carry[28]), .CO(carry[29]), .S(SUM[28]) );
  ADDHX1M U1_1_27 ( .A(A[27]), .B(carry[27]), .CO(carry[28]), .S(SUM[27]) );
  ADDHX1M U1_1_26 ( .A(A[26]), .B(carry[26]), .CO(carry[27]), .S(SUM[26]) );
  ADDHX1M U1_1_25 ( .A(A[25]), .B(carry[25]), .CO(carry[26]), .S(SUM[25]) );
  ADDHX1M U1_1_24 ( .A(A[24]), .B(carry[24]), .CO(carry[25]), .S(SUM[24]) );
  ADDHX1M U1_1_23 ( .A(A[23]), .B(carry[23]), .CO(carry[24]), .S(SUM[23]) );
  ADDHX1M U1_1_22 ( .A(A[22]), .B(carry[22]), .CO(carry[23]), .S(SUM[22]) );
  ADDHX1M U1_1_21 ( .A(A[21]), .B(carry[21]), .CO(carry[22]), .S(SUM[21]) );
  ADDHX1M U1_1_20 ( .A(A[20]), .B(carry[20]), .CO(carry[21]), .S(SUM[20]) );
  ADDHX1M U1_1_19 ( .A(A[19]), .B(carry[19]), .CO(carry[20]), .S(SUM[19]) );
  ADDHX1M U1_1_18 ( .A(A[18]), .B(carry[18]), .CO(carry[19]), .S(SUM[18]) );
  ADDHX1M U1_1_17 ( .A(A[17]), .B(carry[17]), .CO(carry[18]), .S(SUM[17]) );
  ADDHX1M U1_1_16 ( .A(A[16]), .B(carry[16]), .CO(carry[17]), .S(SUM[16]) );
  ADDHX1M U1_1_15 ( .A(A[15]), .B(carry[15]), .CO(carry[16]), .S(SUM[15]) );
  ADDHX1M U1_1_14 ( .A(A[14]), .B(carry[14]), .CO(carry[15]), .S(SUM[14]) );
  ADDHX1M U1_1_13 ( .A(A[13]), .B(carry[13]), .CO(carry[14]), .S(SUM[13]) );
  ADDHX1M U1_1_12 ( .A(A[12]), .B(carry[12]), .CO(carry[13]), .S(SUM[12]) );
  ADDHX1M U1_1_11 ( .A(A[11]), .B(carry[11]), .CO(carry[12]), .S(SUM[11]) );
  ADDHX1M U1_1_10 ( .A(A[10]), .B(carry[10]), .CO(carry[11]), .S(SUM[10]) );
  ADDHX1M U1_1_9 ( .A(A[9]), .B(carry[9]), .CO(carry[10]), .S(SUM[9]) );
  ADDHX1M U1_1_8 ( .A(A[8]), .B(carry[8]), .CO(carry[9]), .S(SUM[8]) );
  ADDHX1M U1_1_7 ( .A(A[7]), .B(carry[7]), .CO(carry[8]), .S(SUM[7]) );
  ADDHX1M U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHX1M U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHX1M U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHX1M U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHX1M U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHX1M U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  INVX2M U1 ( .A(A[0]), .Y(SUM[0]) );
  CLKXOR2X2M U2 ( .A(carry[31]), .B(A[31]), .Y(SUM[31]) );
endmodule


module serializer ( clk, rst, Data_valid, P_data, ser_en, idle_data, ser_done, 
        ser_data );
  input [7:0] P_data;
  input clk, rst, Data_valid, ser_en, idle_data;
  output ser_done, ser_data;
  wire   N4, N5, N6, valid_reg, N14, N15, N16, N17, N18, N19, N20, N21, N22,
         N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36,
         N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, n3, n4, n6, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n22,
         n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50,
         n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64,
         n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78,
         n79, n80, n81, n82, n83, n84, n85, n86, n1, n2, n5, n21, n87, n88,
         n89, n90, n91, n92, n93, n95, n96;
  wire   [31:0] counter;
  wire   [7:0] parrllel_data;
  assign N47 = Data_valid;

  serializer_DW01_inc_0 add_34 ( .A({counter[31:3], N6, N5, N4}), .SUM({N46, 
        N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, N35, N34, N33, N32, 
        N31, N30, N29, N28, N27, N26, N25, N24, N23, N22, N21, N20, N19, N18, 
        N17, N16, N15}) );
  EDFFHQX1M \parrllel_data_reg[5]  ( .D(P_data[5]), .E(n53), .CK(clk), .Q(
        parrllel_data[5]) );
  EDFFHQX1M \parrllel_data_reg[1]  ( .D(P_data[1]), .E(n53), .CK(clk), .Q(
        parrllel_data[1]) );
  EDFFHQX1M \parrllel_data_reg[7]  ( .D(P_data[7]), .E(n53), .CK(clk), .Q(
        parrllel_data[7]) );
  EDFFHQX1M \parrllel_data_reg[3]  ( .D(P_data[3]), .E(n53), .CK(clk), .Q(
        parrllel_data[3]) );
  EDFFHQX1M \parrllel_data_reg[6]  ( .D(P_data[6]), .E(n53), .CK(clk), .Q(
        parrllel_data[6]) );
  EDFFHQX1M \parrllel_data_reg[2]  ( .D(P_data[2]), .E(n53), .CK(clk), .Q(
        parrllel_data[2]) );
  EDFFHQX1M \parrllel_data_reg[4]  ( .D(P_data[4]), .E(n53), .CK(clk), .Q(
        parrllel_data[4]) );
  EDFFHQX1M \parrllel_data_reg[0]  ( .D(P_data[0]), .E(n53), .CK(clk), .Q(
        parrllel_data[0]) );
  DFFSQX2M ser_data_reg ( .D(n54), .CK(clk), .SN(n89), .Q(ser_data) );
  DFFRX1M valid_reg_reg ( .D(n20), .CK(clk), .RN(rst), .Q(valid_reg), .QN(n93)
         );
  DFFRX1M \counter_reg[29]  ( .D(n56), .CK(clk), .RN(n90), .Q(counter[29]), 
        .QN(n24) );
  DFFRX1M \counter_reg[28]  ( .D(n57), .CK(clk), .RN(n89), .Q(counter[28]), 
        .QN(n25) );
  DFFRX1M \counter_reg[27]  ( .D(n58), .CK(clk), .RN(rst), .Q(counter[27]), 
        .QN(n26) );
  DFFRX1M \counter_reg[26]  ( .D(n59), .CK(clk), .RN(n90), .Q(counter[26]), 
        .QN(n27) );
  DFFRX1M \counter_reg[25]  ( .D(n60), .CK(clk), .RN(n90), .Q(counter[25]), 
        .QN(n28) );
  DFFRX1M \counter_reg[2]  ( .D(n83), .CK(clk), .RN(n89), .Q(N6), .QN(n50) );
  DFFRX1M \counter_reg[24]  ( .D(n61), .CK(clk), .RN(n90), .Q(counter[24]), 
        .QN(n29) );
  DFFRX1M \counter_reg[23]  ( .D(n62), .CK(clk), .RN(n90), .Q(counter[23]), 
        .QN(n30) );
  DFFRX1M \counter_reg[31]  ( .D(n86), .CK(clk), .RN(n90), .Q(counter[31]), 
        .QN(n22) );
  DFFRX1M \counter_reg[30]  ( .D(n55), .CK(clk), .RN(n90), .Q(counter[30]), 
        .QN(n23) );
  DFFRX1M \counter_reg[22]  ( .D(n63), .CK(clk), .RN(n90), .Q(counter[22]), 
        .QN(n31) );
  DFFRX1M \counter_reg[21]  ( .D(n64), .CK(clk), .RN(n90), .Q(counter[21]), 
        .QN(n32) );
  DFFRX1M \counter_reg[20]  ( .D(n65), .CK(clk), .RN(n90), .Q(counter[20]), 
        .QN(n33) );
  DFFRX1M \counter_reg[19]  ( .D(n66), .CK(clk), .RN(n90), .Q(counter[19]), 
        .QN(n34) );
  DFFRX1M \counter_reg[18]  ( .D(n67), .CK(clk), .RN(n90), .Q(counter[18]), 
        .QN(n35) );
  DFFRX1M \counter_reg[17]  ( .D(n68), .CK(clk), .RN(n90), .Q(counter[17]), 
        .QN(n36) );
  DFFRX1M \counter_reg[16]  ( .D(n69), .CK(clk), .RN(n90), .Q(counter[16]), 
        .QN(n37) );
  DFFRX1M \counter_reg[15]  ( .D(n70), .CK(clk), .RN(n90), .Q(counter[15]), 
        .QN(n38) );
  DFFRX1M \counter_reg[14]  ( .D(n71), .CK(clk), .RN(n90), .Q(counter[14]), 
        .QN(n39) );
  DFFRX1M \counter_reg[13]  ( .D(n72), .CK(clk), .RN(n89), .Q(counter[13]), 
        .QN(n40) );
  DFFRX1M \counter_reg[12]  ( .D(n73), .CK(clk), .RN(n89), .Q(counter[12]), 
        .QN(n41) );
  DFFRX1M \counter_reg[11]  ( .D(n74), .CK(clk), .RN(n89), .Q(counter[11]), 
        .QN(n42) );
  DFFRX1M \counter_reg[10]  ( .D(n75), .CK(clk), .RN(n89), .Q(counter[10]), 
        .QN(n43) );
  DFFRX1M \counter_reg[9]  ( .D(n76), .CK(clk), .RN(n89), .Q(counter[9]), .QN(
        n44) );
  DFFRX1M \counter_reg[8]  ( .D(n77), .CK(clk), .RN(n89), .Q(counter[8]), .QN(
        n45) );
  DFFRX1M \counter_reg[7]  ( .D(n78), .CK(clk), .RN(n89), .Q(counter[7]), .QN(
        n46) );
  DFFRX1M \counter_reg[6]  ( .D(n79), .CK(clk), .RN(n89), .Q(counter[6]), .QN(
        n47) );
  DFFRX1M \counter_reg[5]  ( .D(n80), .CK(clk), .RN(n89), .Q(counter[5]), .QN(
        n48) );
  DFFRX1M \counter_reg[4]  ( .D(n81), .CK(clk), .RN(n89), .Q(counter[4]), .QN(
        n49) );
  DFFRX4M \counter_reg[0]  ( .D(n85), .CK(clk), .RN(n89), .Q(N4), .QN(n52) );
  DFFRX4M \counter_reg[1]  ( .D(n84), .CK(clk), .RN(n89), .Q(N5), .QN(n51) );
  DFFRX4M \counter_reg[3]  ( .D(n82), .CK(clk), .RN(rst), .Q(counter[3]) );
  MX4XLM U3 ( .A(parrllel_data[0]), .B(parrllel_data[1]), .C(parrllel_data[2]), 
        .D(parrllel_data[3]), .S0(N4), .S1(N5), .Y(n92) );
  MX4XLM U4 ( .A(parrllel_data[4]), .B(parrllel_data[5]), .C(parrllel_data[6]), 
        .D(parrllel_data[7]), .S0(N4), .S1(N5), .Y(n91) );
  BUFX6M U5 ( .A(n8), .Y(n1) );
  BUFX6M U6 ( .A(n8), .Y(n2) );
  BUFX4M U7 ( .A(n8), .Y(n5) );
  CLKBUFX8M U8 ( .A(rst), .Y(n90) );
  NOR2BX4M U9 ( .AN(n88), .B(ser_done), .Y(n8) );
  CLKBUFX6M U10 ( .A(n7), .Y(n87) );
  CLKBUFX6M U11 ( .A(n7), .Y(n21) );
  CLKBUFX6M U12 ( .A(n7), .Y(n88) );
  CLKBUFX8M U13 ( .A(rst), .Y(n89) );
  OAI2BB1X2M U14 ( .A0N(idle_data), .A1N(n96), .B0(n6), .Y(n3) );
  NAND2X2M U15 ( .A(n9), .B(n6), .Y(n7) );
  INVX2M U16 ( .A(N47), .Y(n96) );
  CLKAND2X4M U17 ( .A(n89), .B(N47), .Y(n53) );
  NAND2X2M U18 ( .A(n93), .B(n96), .Y(n20) );
  INVX2M U19 ( .A(n9), .Y(ser_done) );
  OAI2B1X2M U20 ( .A1N(ser_data), .A0(n3), .B0(n4), .Y(n54) );
  OAI31X2M U21 ( .A0(n93), .A1(N14), .A2(n95), .B0(n3), .Y(n4) );
  INVX2M U22 ( .A(ser_en), .Y(n95) );
  MX2X2M U23 ( .A(n92), .B(n91), .S0(N6), .Y(N14) );
  OAI2BB2X1M U24 ( .B0(n26), .B1(n88), .A0N(N42), .A1N(n5), .Y(n58) );
  OAI2BB2X1M U25 ( .B0(n30), .B1(n88), .A0N(N38), .A1N(n2), .Y(n62) );
  OAI2BB2X1M U26 ( .B0(n34), .B1(n87), .A0N(N34), .A1N(n2), .Y(n66) );
  OAI2BB2X1M U27 ( .B0(n38), .B1(n87), .A0N(N30), .A1N(n2), .Y(n70) );
  OAI2BB2X1M U28 ( .B0(n42), .B1(n21), .A0N(N26), .A1N(n1), .Y(n74) );
  OAI2BB2X1M U29 ( .B0(n46), .B1(n21), .A0N(N22), .A1N(n1), .Y(n78) );
  OAI2BB2X1M U30 ( .B0(n50), .B1(n21), .A0N(N17), .A1N(n1), .Y(n83) );
  OAI2BB2X1M U31 ( .B0(n22), .B1(n21), .A0N(N46), .A1N(n2), .Y(n86) );
  OAI2BB2X1M U32 ( .B0(n23), .B1(n21), .A0N(N45), .A1N(n1), .Y(n55) );
  OAI2BB2X1M U33 ( .B0(n27), .B1(n88), .A0N(N41), .A1N(n5), .Y(n59) );
  OAI2BB2X1M U34 ( .B0(n31), .B1(n87), .A0N(N37), .A1N(n2), .Y(n63) );
  OAI2BB2X1M U35 ( .B0(n35), .B1(n87), .A0N(N33), .A1N(n2), .Y(n67) );
  OAI2BB2X1M U36 ( .B0(n39), .B1(n87), .A0N(N29), .A1N(n2), .Y(n71) );
  OAI2BB2X1M U37 ( .B0(n43), .B1(n21), .A0N(N25), .A1N(n1), .Y(n75) );
  OAI2BB2X1M U38 ( .B0(n47), .B1(n87), .A0N(N21), .A1N(n1), .Y(n79) );
  OAI2BB2X1M U39 ( .B0(n51), .B1(n21), .A0N(N16), .A1N(n1), .Y(n84) );
  OAI2BB2X1M U40 ( .B0(n25), .B1(n88), .A0N(N43), .A1N(n5), .Y(n57) );
  OAI2BB2X1M U41 ( .B0(n29), .B1(n88), .A0N(N39), .A1N(n2), .Y(n61) );
  OAI2BB2X1M U42 ( .B0(n33), .B1(n87), .A0N(N35), .A1N(n2), .Y(n65) );
  OAI2BB2X1M U43 ( .B0(n37), .B1(n87), .A0N(N31), .A1N(n2), .Y(n69) );
  OAI2BB2X1M U44 ( .B0(n41), .B1(n87), .A0N(N27), .A1N(n1), .Y(n73) );
  OAI2BB2X1M U45 ( .B0(n45), .B1(n21), .A0N(N23), .A1N(n1), .Y(n77) );
  OAI2BB2X1M U46 ( .B0(n49), .B1(n21), .A0N(N19), .A1N(n1), .Y(n81) );
  OAI2BB2X1M U47 ( .B0(n24), .B1(n88), .A0N(N44), .A1N(n5), .Y(n56) );
  OAI2BB2X1M U48 ( .B0(n28), .B1(n88), .A0N(N40), .A1N(n5), .Y(n60) );
  OAI2BB2X1M U49 ( .B0(n32), .B1(n87), .A0N(N36), .A1N(n2), .Y(n64) );
  OAI2BB2X1M U50 ( .B0(n36), .B1(n87), .A0N(N32), .A1N(n2), .Y(n68) );
  OAI2BB2X1M U51 ( .B0(n40), .B1(n87), .A0N(N28), .A1N(n2), .Y(n72) );
  OAI2BB2X1M U52 ( .B0(n44), .B1(n21), .A0N(N24), .A1N(n1), .Y(n76) );
  OAI2BB2X1M U53 ( .B0(n48), .B1(n21), .A0N(N20), .A1N(n1), .Y(n80) );
  OAI2BB2X1M U54 ( .B0(n52), .B1(n21), .A0N(N15), .A1N(n1), .Y(n85) );
  NAND3X2M U55 ( .A(ser_en), .B(n96), .C(valid_reg), .Y(n6) );
  AO2B2X2M U56 ( .B0(N18), .B1(n5), .A0(counter[3]), .A1N(n88), .Y(n82) );
  NAND4X2M U57 ( .A(n42), .B(n43), .C(n44), .D(n45), .Y(n14) );
  NAND4X2M U58 ( .A(n26), .B(n27), .C(n28), .D(n29), .Y(n18) );
  NAND2X2M U59 ( .A(n10), .B(n11), .Y(n9) );
  NOR4X2M U60 ( .A(n16), .B(n17), .C(n18), .D(n19), .Y(n10) );
  NOR4X2M U61 ( .A(n12), .B(n13), .C(n14), .D(n15), .Y(n11) );
  NAND4X2M U62 ( .A(n30), .B(n31), .C(n32), .D(n33), .Y(n17) );
  NAND4X2M U63 ( .A(n38), .B(n39), .C(n40), .D(n41), .Y(n15) );
  NAND4X2M U64 ( .A(n22), .B(n23), .C(n24), .D(n25), .Y(n19) );
  NAND4X2M U65 ( .A(n50), .B(n51), .C(n52), .D(counter[3]), .Y(n12) );
  NAND4X2M U66 ( .A(n34), .B(n35), .C(n36), .D(n37), .Y(n16) );
  NAND4X2M U67 ( .A(n46), .B(n47), .C(n48), .D(n49), .Y(n13) );
endmodule


module top ( clk, rst, Data_valid, P_data, Par_type, Par_en, Busy, TX_out );
  input [7:0] P_data;
  input clk, rst, Data_valid, Par_type, Par_en;
  output Busy, TX_out;
  wire   Par_bit, ser_done, ser_en, idle_data, ser_data, n1, n2;
  wire   [1:0] mux_sel;

  Parity DUT_2 ( .clk(clk), .rst(n1), .Data_valid(Data_valid), .P_data(P_data), 
        .Par_type(Par_type), .Par_bit(Par_bit) );
  FSM DUT_3 ( .clk(clk), .rst(n1), .Data_valid(Data_valid), .ser_done(ser_done), .Par_en(Par_en), .mux_sel(mux_sel), .ser_en(ser_en), .Busy(Busy), 
        .idle_data(idle_data) );
  mux DUT_4 ( .start_bit(1'b0), .stop_bit(1'b1), .mux_sel(mux_sel), .Par_bit(
        Par_bit), .ser_data(ser_data), .TX_out(TX_out) );
  serializer DUT_1 ( .clk(clk), .rst(n1), .Data_valid(Data_valid), .P_data(
        P_data), .ser_en(ser_en), .idle_data(idle_data), .ser_done(ser_done), 
        .ser_data(ser_data) );
  INVX4M U3 ( .A(n2), .Y(n1) );
  INVX2M U4 ( .A(rst), .Y(n2) );
endmodule

