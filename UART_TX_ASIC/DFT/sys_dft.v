/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Wed Aug 28 08:58:53 2024
/////////////////////////////////////////////////////////////


module Mux_dft_1 ( IN_0, IN_1, SEL, OUT );
  input IN_0, IN_1, SEL;
  output OUT;


  MX2X6M U1 ( .A(IN_0), .B(IN_1), .S0(SEL), .Y(OUT) );
endmodule


module Mux_dft_0 ( IN_0, IN_1, SEL, OUT );
  input IN_0, IN_1, SEL;
  output OUT;


  MX2X2M U1 ( .A(IN_0), .B(IN_1), .S0(SEL), .Y(OUT) );
endmodule


module Parity_test_1 ( clk, rst, Data_valid, P_data, Par_type, Par_bit, 
        test_si, test_so, test_se );
  input [7:0] P_data;
  input clk, rst, Data_valid, Par_type, test_si, test_se;
  output Par_bit, test_so;
  wire   n1, n3, n4, n5, n6, n8, n9;

  OAI2BB2X1M U4 ( .B0(n1), .B1(n9), .A0N(Par_bit), .A1N(n9), .Y(n8) );
  INVX2M U5 ( .A(Data_valid), .Y(n9) );
  XOR3XLM U6 ( .A(n3), .B(Par_type), .C(n4), .Y(n1) );
  XOR3XLM U7 ( .A(P_data[1]), .B(P_data[0]), .C(n5), .Y(n4) );
  XOR3XLM U8 ( .A(P_data[5]), .B(P_data[4]), .C(n6), .Y(n3) );
  CLKXOR2X2M U9 ( .A(P_data[7]), .B(P_data[6]), .Y(n6) );
  XNOR2X2M U11 ( .A(P_data[3]), .B(P_data[2]), .Y(n5) );
  SDFFRX1M par_reg ( .D(n8), .SI(test_si), .SE(test_se), .CK(clk), .RN(rst), 
        .Q(Par_bit), .QN(test_so) );
endmodule


module FSM_test_1 ( clk, rst, Data_valid, ser_done, Par_en, mux_sel, ser_en, 
        Busy, idle_data, test_si, test_so, test_se );
  output [1:0] mux_sel;
  input clk, rst, Data_valid, ser_done, Par_en, test_si, test_se;
  output ser_en, Busy, idle_data, test_so;
  wire   n7, n8, n10, n12, n13, n4, n6, n9, n11, n14, n16, n17, n18, n27;
  wire   [3:0] current_state;
  wire   [2:0] next_state;
  assign test_so = n18;

  CLKXOR2X2M U6 ( .A(n16), .B(n9), .Y(n4) );
  AND3X2M U7 ( .A(n14), .B(n6), .C(n18), .Y(idle_data) );
  OR2X2M U8 ( .A(n16), .B(n9), .Y(n6) );
  INVX2M U10 ( .A(n6), .Y(n11) );
  OAI32X2M U11 ( .A0(n8), .A1(current_state[0]), .A2(n9), .B0(n16), .B1(
        current_state[1]), .Y(n10) );
  INVX2M U12 ( .A(n4), .Y(n14) );
  NAND2XLM U17 ( .A(n9), .B(n13), .Y(mux_sel[1]) );
  AO21X2M U21 ( .A0(n17), .A1(n11), .B0(idle_data), .Y(mux_sel[0]) );
  OR2X2M U22 ( .A(ser_en), .B(mux_sel[0]), .Y(Busy) );
  NOR2BX2M U23 ( .AN(ser_done), .B(Par_en), .Y(n8) );
  NOR2X4M U24 ( .A(n18), .B(n14), .Y(ser_en) );
  NOR3X2M U26 ( .A(n18), .B(current_state[0]), .C(n12), .Y(next_state[0]) );
  AOI32X1M U27 ( .A0(ser_done), .A1(current_state[1]), .A2(Par_en), .B0(
        Data_valid), .B1(n9), .Y(n12) );
  NOR2X2M U28 ( .A(n7), .B(n18), .Y(next_state[2]) );
  AOI21X2M U29 ( .A0(n8), .A1(current_state[1]), .B0(n11), .Y(n7) );
  AND2X2M U30 ( .A(n10), .B(n17), .Y(next_state[1]) );
  DLY1X1M U31 ( .A(test_se), .Y(n27) );
  SDFFRX4M \current_state_reg[2]  ( .D(next_state[2]), .SI(n9), .SE(n27), .CK(
        clk), .RN(rst), .Q(n18), .QN(n17) );
  SDFFRX4M \current_state_reg[1]  ( .D(next_state[1]), .SI(current_state[0]), 
        .SE(test_se), .CK(clk), .RN(rst), .Q(current_state[1]), .QN(n9) );
  SDFFRX2M \current_state_reg[0]  ( .D(next_state[0]), .SI(test_si), .SE(n27), 
        .CK(clk), .RN(rst), .Q(current_state[0]), .QN(n16) );
  XNOR2X1M U3 ( .A(n18), .B(n16), .Y(n13) );
endmodule


module mux ( start_bit, stop_bit, mux_sel, Par_bit, ser_data, TX_out );
  input [1:0] mux_sel;
  input start_bit, stop_bit, Par_bit, ser_data;
  output TX_out;
  wire   n1, n2, n3, n4;

  INVX2M U1 ( .A(mux_sel[0]), .Y(n4) );
  AO2B2X2M U2 ( .B0(n1), .B1(n2), .A0(n3), .A1N(n1), .Y(TX_out) );
  INVX2M U3 ( .A(mux_sel[1]), .Y(n1) );
  AO22X1M U4 ( .A0(start_bit), .A1(n4), .B0(stop_bit), .B1(mux_sel[0]), .Y(n2)
         );
  AO22X1M U5 ( .A0(Par_bit), .A1(mux_sel[0]), .B0(ser_data), .B1(n4), .Y(n3)
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


module serializer_test_1 ( clk, rst, Data_valid, P_data, ser_en, idle_data, 
        ser_done, ser_data, test_si, test_so, test_se );
  input [7:0] P_data;
  input clk, rst, Data_valid, ser_en, idle_data, test_si, test_se;
  output ser_done, ser_data, test_so;
  wire   N4, N6, valid_reg, N14, N15, N16, N17, N18, N19, N20, N21, N22, N23,
         N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36, N37,
         N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n53, n63, n64,
         n65, n66, n67, n68, n69, n70, n71, n72, n91, n93, n94, n95, n96, n97,
         n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109,
         n110, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120,
         n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, n131,
         n132, n133, n134, n62, n135, n178, n179, n180, n181, n182, n183, n184,
         n185, n186, n187, n188, n189, n190, n193, n194, n195, n196, n197,
         n198, n199, n200, n201, n202, n205, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n239, n240, n241, n242, n243,
         n244, n245, n246, n247, n248, n249, n250, n252, n253, n254, n255,
         n256, n257, n258, n259, n260, n261, n262, n263, n264, n265, n266, n1,
         n2, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35;
  wire   [31:0] counter;
  wire   [7:0] parrllel_data;
  assign N47 = Data_valid;

  SDFFSQX1M ser_data_reg ( .D(n94), .SI(n194), .SE(n224), .CK(clk), .SN(rst), 
        .Q(ser_data) );
  SDFFRX1M \counter_reg[29]  ( .D(n104), .SI(counter[28]), .SE(n239), .CK(clk), 
        .RN(rst), .Q(counter[29]), .QN(n65) );
  SDFFRX1M \counter_reg[24]  ( .D(n109), .SI(counter[23]), .SE(n241), .CK(clk), 
        .RN(n185), .Q(counter[24]), .QN(n70) );
  SDFFRX1M \counter_reg[23]  ( .D(n110), .SI(counter[22]), .SE(n239), .CK(clk), 
        .RN(n185), .Q(counter[23]), .QN(n71) );
  MX4XLM U6 ( .A(parrllel_data[0]), .B(parrllel_data[1]), .C(parrllel_data[2]), 
        .D(parrllel_data[3]), .S0(N4), .S1(n135), .Y(n190) );
  MX4XLM U7 ( .A(parrllel_data[4]), .B(parrllel_data[5]), .C(parrllel_data[6]), 
        .D(parrllel_data[7]), .S0(N4), .S1(n135), .Y(n189) );
  BUFX6M U50 ( .A(n7), .Y(n179) );
  BUFX6M U51 ( .A(n7), .Y(n180) );
  BUFX4M U52 ( .A(n7), .Y(n181) );
  CLKBUFX8M U53 ( .A(n188), .Y(n187) );
  BUFX6M U54 ( .A(n188), .Y(n185) );
  BUFX6M U55 ( .A(n188), .Y(n186) );
  NOR2BX4M U56 ( .AN(n184), .B(ser_done), .Y(n7) );
  CLKBUFX6M U57 ( .A(n6), .Y(n183) );
  CLKBUFX6M U58 ( .A(n6), .Y(n182) );
  CLKBUFX6M U59 ( .A(n6), .Y(n184) );
  INVX6M U60 ( .A(n178), .Y(n193) );
  BUFX2M U61 ( .A(rst), .Y(n188) );
  NAND2X2M U62 ( .A(n8), .B(n5), .Y(n6) );
  CLKBUFX6M U63 ( .A(N47), .Y(n178) );
  NAND2X2M U106 ( .A(test_so), .B(n193), .Y(n53) );
  INVX2M U107 ( .A(n8), .Y(ser_done) );
  OAI2BB2X1M U108 ( .B0(n64), .B1(n182), .A0N(N45), .A1N(n179), .Y(n103) );
  OAI2BB2X1M U109 ( .B0(n72), .B1(n183), .A0N(N37), .A1N(n180), .Y(n111) );
  OAI2BB2X1M U110 ( .B0(n34), .B1(n183), .A0N(N36), .A1N(n180), .Y(n112) );
  OAI2BB2X1M U111 ( .B0(n250), .B1(n183), .A0N(N35), .A1N(n180), .Y(n113) );
  OAI2BB2X1M U112 ( .B0(n265), .B1(n183), .A0N(N34), .A1N(n180), .Y(n114) );
  OAI2BB2X1M U113 ( .B0(n26), .B1(n183), .A0N(N33), .A1N(n180), .Y(n115) );
  OAI2BB2X1M U114 ( .B0(n2), .B1(n183), .A0N(N32), .A1N(n180), .Y(n116) );
  OAI2BB2X1M U115 ( .B0(n249), .B1(n183), .A0N(N31), .A1N(n180), .Y(n117) );
  OAI2BB2X1M U116 ( .B0(n264), .B1(n183), .A0N(N30), .A1N(n180), .Y(n118) );
  OAI2BB2X1M U117 ( .B0(n28), .B1(n183), .A0N(N29), .A1N(n180), .Y(n119) );
  OAI2BB2X1M U118 ( .B0(n20), .B1(n183), .A0N(N28), .A1N(n180), .Y(n120) );
  OAI2BB2X1M U119 ( .B0(n248), .B1(n183), .A0N(N27), .A1N(n179), .Y(n121) );
  OAI2BB2X1M U120 ( .B0(n263), .B1(n182), .A0N(N26), .A1N(n179), .Y(n122) );
  OAI2BB2X1M U121 ( .B0(n32), .B1(n182), .A0N(N25), .A1N(n179), .Y(n123) );
  OAI2BB2X1M U122 ( .B0(n24), .B1(n182), .A0N(N24), .A1N(n179), .Y(n124) );
  OAI2BB2X1M U123 ( .B0(n247), .B1(n182), .A0N(N23), .A1N(n179), .Y(n125) );
  OAI2BB2X1M U124 ( .B0(n262), .B1(n182), .A0N(N22), .A1N(n179), .Y(n126) );
  OAI2BB2X1M U125 ( .B0(n30), .B1(n183), .A0N(N21), .A1N(n179), .Y(n127) );
  OAI2BB2X1M U126 ( .B0(n22), .B1(n182), .A0N(N20), .A1N(n179), .Y(n128) );
  OAI2BB2X1M U127 ( .B0(n246), .B1(n182), .A0N(N19), .A1N(n179), .Y(n129) );
  OAI2BB2X1M U128 ( .B0(n261), .B1(n182), .A0N(N17), .A1N(n179), .Y(n131) );
  OAI2BB2X1M U129 ( .B0(n62), .B1(n182), .A0N(N16), .A1N(n179), .Y(n132) );
  OAI2BB2X1M U130 ( .B0(n93), .B1(n182), .A0N(N15), .A1N(n179), .Y(n133) );
  OAI2BB2X1M U131 ( .B0(n63), .B1(n182), .A0N(N46), .A1N(n180), .Y(n134) );
  OAI2BB2X1M U132 ( .B0(n67), .B1(n184), .A0N(N42), .A1N(n181), .Y(n106) );
  OAI2BB2X1M U133 ( .B0(n71), .B1(n184), .A0N(N38), .A1N(n180), .Y(n110) );
  OAI2BB2X1M U134 ( .B0(n68), .B1(n184), .A0N(N41), .A1N(n181), .Y(n107) );
  OAI2BB2X1M U135 ( .B0(n66), .B1(n184), .A0N(N43), .A1N(n181), .Y(n105) );
  OAI2BB2X1M U136 ( .B0(n70), .B1(n184), .A0N(N39), .A1N(n180), .Y(n109) );
  OAI2BB2X1M U137 ( .B0(n65), .B1(n184), .A0N(N44), .A1N(n181), .Y(n104) );
  OAI2BB2X1M U138 ( .B0(n69), .B1(n184), .A0N(N40), .A1N(n181), .Y(n108) );
  NAND3X2M U139 ( .A(ser_en), .B(n193), .C(valid_reg), .Y(n5) );
  AO2B2X2M U140 ( .B0(N18), .B1(n181), .A0(n202), .A1N(n184), .Y(n130) );
  OAI2BB2X1M U141 ( .B0(n3), .B1(n4), .A0N(n245), .A1N(n3), .Y(n94) );
  NOR3BX2M U142 ( .AN(ser_en), .B(test_so), .C(N14), .Y(n4) );
  AOI21BX2M U143 ( .A0(idle_data), .A1(n193), .B0N(n5), .Y(n3) );
  MX2X2M U144 ( .A(n190), .B(n189), .S0(N6), .Y(N14) );
  AO22X1M U145 ( .A0(P_data[6]), .A1(n178), .B0(parrllel_data[6]), .B1(n193), 
        .Y(n96) );
  AO22X1M U146 ( .A0(P_data[2]), .A1(n178), .B0(parrllel_data[2]), .B1(n193), 
        .Y(n100) );
  AO22X1M U147 ( .A0(P_data[3]), .A1(n178), .B0(parrllel_data[3]), .B1(n193), 
        .Y(n99) );
  AO22X1M U148 ( .A0(P_data[7]), .A1(n178), .B0(parrllel_data[7]), .B1(n193), 
        .Y(n95) );
  AO22X1M U149 ( .A0(P_data[0]), .A1(n178), .B0(parrllel_data[0]), .B1(n193), 
        .Y(n102) );
  AO22X1M U150 ( .A0(P_data[4]), .A1(n178), .B0(parrllel_data[4]), .B1(n193), 
        .Y(n98) );
  AO22X1M U151 ( .A0(P_data[1]), .A1(n178), .B0(parrllel_data[1]), .B1(n193), 
        .Y(n101) );
  AO22X1M U152 ( .A0(P_data[5]), .A1(n178), .B0(parrllel_data[5]), .B1(n193), 
        .Y(n97) );
  NAND2X2M U153 ( .A(n9), .B(n10), .Y(n8) );
  NOR4X2M U155 ( .A(n15), .B(n16), .C(n17), .D(n18), .Y(n9) );
  NAND4X2M U157 ( .A(n67), .B(n68), .C(n69), .D(n70), .Y(n17) );
  NAND4X2M U159 ( .A(n63), .B(n64), .C(n65), .D(n66), .Y(n18) );
  NAND4X2M U162 ( .A(n71), .B(n72), .C(n34), .D(n250), .Y(n16) );
  DLY1X1M U164 ( .A(test_se), .Y(n205) );
  DLY1X1M U165 ( .A(test_se), .Y(n206) );
  DLY1X1M U166 ( .A(test_se), .Y(n207) );
  DLY1X1M U167 ( .A(n231), .Y(n208) );
  DLY1X1M U168 ( .A(n208), .Y(n209) );
  DLY1X1M U169 ( .A(n227), .Y(n210) );
  DLY1X1M U170 ( .A(n229), .Y(n211) );
  DLY1X1M U171 ( .A(n214), .Y(n212) );
  DLY1X1M U172 ( .A(n215), .Y(n213) );
  DLY1X1M U173 ( .A(n232), .Y(n214) );
  DLY1X1M U174 ( .A(n233), .Y(n215) );
  DLY1X1M U175 ( .A(n211), .Y(n216) );
  DLY1X1M U176 ( .A(n234), .Y(n217) );
  DLY1X1M U177 ( .A(n226), .Y(n218) );
  DLY1X1M U178 ( .A(n237), .Y(n219) );
  DLY1X1M U179 ( .A(n238), .Y(n220) );
  DLY1X1M U180 ( .A(n227), .Y(n221) );
  DLY1X1M U181 ( .A(n242), .Y(n222) );
  DLY1X1M U182 ( .A(n243), .Y(n223) );
  DLY1X1M U183 ( .A(n225), .Y(n224) );
  DLY1X1M U184 ( .A(n231), .Y(n225) );
  DLY1X1M U185 ( .A(n208), .Y(n226) );
  DLY1X1M U186 ( .A(n230), .Y(n227) );
  DLY1X1M U187 ( .A(n230), .Y(n228) );
  DLY1X1M U188 ( .A(n206), .Y(n229) );
  DLY1X1M U189 ( .A(n205), .Y(n230) );
  DLY1X1M U190 ( .A(n207), .Y(n231) );
  DLY1X1M U191 ( .A(n206), .Y(n232) );
  DLY1X1M U192 ( .A(n205), .Y(n233) );
  DLY1X1M U193 ( .A(n233), .Y(n234) );
  DLY1X1M U194 ( .A(n209), .Y(n235) );
  DLY1X1M U195 ( .A(n225), .Y(n236) );
  DLY1X1M U196 ( .A(n228), .Y(n237) );
  DLY1X1M U197 ( .A(n229), .Y(n238) );
  DLY1X1M U198 ( .A(n210), .Y(n239) );
  DLY1X1M U199 ( .A(n226), .Y(n240) );
  DLY1X1M U200 ( .A(n210), .Y(n241) );
  DLY1X1M U201 ( .A(n232), .Y(n242) );
  DLY1X1M U202 ( .A(n211), .Y(n243) );
  DLY1X1M U203 ( .A(n209), .Y(n244) );
  DLY1X1M U204 ( .A(ser_data), .Y(n245) );
  DLY1X1M U220 ( .A(n91), .Y(n261) );
  serializer_DW01_inc_0 add_35 ( .A({counter[31:4], n202, N6, n135, N4}), 
        .SUM({N46, N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, N35, N34, 
        N33, N32, N31, N30, N29, N28, N27, N26, N25, N24, N23, N22, N21, N20, 
        N19, N18, N17, N16, N15}) );
  SDFFRX1M \parrllel_data_reg[5]  ( .D(n97), .SI(n197), .SE(n223), .CK(clk), 
        .RN(rst), .Q(parrllel_data[5]), .QN(n196) );
  SDFFRX1M \parrllel_data_reg[1]  ( .D(n101), .SI(n201), .SE(n242), .CK(clk), 
        .RN(n187), .Q(parrllel_data[1]), .QN(n200) );
  SDFFRX1M \parrllel_data_reg[6]  ( .D(n96), .SI(n196), .SE(n223), .CK(clk), 
        .RN(n188), .Q(parrllel_data[6]), .QN(n195) );
  SDFFRX1M \parrllel_data_reg[2]  ( .D(n100), .SI(n200), .SE(n222), .CK(clk), 
        .RN(n187), .Q(parrllel_data[2]), .QN(n199) );
  SDFFRX1M \parrllel_data_reg[4]  ( .D(n98), .SI(n198), .SE(n243), .CK(clk), 
        .RN(n187), .Q(parrllel_data[4]), .QN(n197) );
  SDFFRX1M \parrllel_data_reg[0]  ( .D(n102), .SI(counter[31]), .SE(n221), 
        .CK(clk), .RN(n187), .Q(parrllel_data[0]), .QN(n201) );
  SDFFRX1M \parrllel_data_reg[7]  ( .D(n95), .SI(n195), .SE(n244), .CK(clk), 
        .RN(rst), .Q(parrllel_data[7]), .QN(n194) );
  SDFFRX1M \parrllel_data_reg[3]  ( .D(n99), .SI(n199), .SE(n222), .CK(clk), 
        .RN(n185), .Q(parrllel_data[3]), .QN(n198) );
  SDFFRX1M valid_reg_reg ( .D(n53), .SI(n245), .SE(n240), .CK(clk), .RN(n187), 
        .Q(valid_reg), .QN(n266) );
  SDFFRX1M \counter_reg[10]  ( .D(n123), .SI(n24), .SE(n234), .CK(clk), .RN(
        n186), .Q(counter[10]), .QN(n253) );
  SDFFRX1M \counter_reg[9]  ( .D(n124), .SI(n247), .SE(n215), .CK(clk), .RN(
        n186), .Q(counter[9]), .QN(n257) );
  SDFFRX1M \counter_reg[6]  ( .D(n127), .SI(n22), .SE(n213), .CK(clk), .RN(
        n187), .Q(counter[6]), .QN(n252) );
  SDFFRX1M \counter_reg[5]  ( .D(n128), .SI(n246), .SE(n213), .CK(clk), .RN(
        n187), .Q(counter[5]), .QN(n256) );
  SDFFRX1M \counter_reg[2]  ( .D(n131), .SI(n62), .SE(n214), .CK(clk), .RN(
        n187), .Q(N6), .QN(n91) );
  SDFFRX1M \counter_reg[13]  ( .D(n120), .SI(n248), .SE(n236), .CK(clk), .RN(
        n186), .Q(counter[13]), .QN(n258) );
  SDFFRX1M \counter_reg[14]  ( .D(n119), .SI(n20), .SE(n218), .CK(clk), .RN(
        n186), .Q(counter[14]), .QN(n254) );
  SDFFRX1M \counter_reg[17]  ( .D(n116), .SI(n249), .SE(n236), .CK(clk), .RN(
        n186), .Q(counter[17]), .QN(n259) );
  SDFFRX1M \counter_reg[18]  ( .D(n115), .SI(n2), .SE(n218), .CK(clk), .RN(
        n185), .Q(counter[18]), .QN(n255) );
  SDFFRX1M \counter_reg[21]  ( .D(n112), .SI(n250), .SE(n219), .CK(clk), .RN(
        n185), .Q(counter[21]), .QN(n260) );
  SDFFRX1M \counter_reg[22]  ( .D(n111), .SI(n34), .SE(n238), .CK(clk), .RN(
        n185), .Q(counter[22]), .QN(n72) );
  SDFFRX1M \counter_reg[25]  ( .D(n108), .SI(counter[24]), .SE(n221), .CK(clk), 
        .RN(n185), .Q(counter[25]), .QN(n69) );
  SDFFRX1M \counter_reg[26]  ( .D(n107), .SI(counter[25]), .SE(n224), .CK(clk), 
        .RN(n185), .Q(counter[26]), .QN(n68) );
  SDFFRX1M \counter_reg[27]  ( .D(n106), .SI(counter[26]), .SE(n244), .CK(clk), 
        .RN(n185), .Q(counter[27]), .QN(n67) );
  SDFFRX1M \counter_reg[28]  ( .D(n105), .SI(counter[27]), .SE(n240), .CK(clk), 
        .RN(n185), .Q(counter[28]), .QN(n66) );
  SDFFRX1M \counter_reg[30]  ( .D(n103), .SI(counter[29]), .SE(n220), .CK(clk), 
        .RN(n186), .Q(counter[30]), .QN(n64) );
  SDFFRX1M \counter_reg[31]  ( .D(n134), .SI(counter[30]), .SE(n220), .CK(clk), 
        .RN(n187), .Q(counter[31]), .QN(n63) );
  SDFFRX2M \counter_reg[0]  ( .D(n133), .SI(test_si), .SE(n216), .CK(clk), 
        .RN(n187), .Q(N4), .QN(n93) );
  SDFFRX2M \counter_reg[3]  ( .D(n130), .SI(n261), .SE(n241), .CK(clk), .RN(
        n187), .Q(n202) );
  SDFFRX2M \counter_reg[4]  ( .D(n129), .SI(n202), .SE(n212), .CK(clk), .RN(
        n187), .Q(counter[4]), .QN(n246) );
  SDFFRX2M \counter_reg[1]  ( .D(n132), .SI(n93), .SE(n216), .CK(clk), .RN(rst), .Q(n135), .QN(n62) );
  SDFFRX2M \counter_reg[11]  ( .D(n122), .SI(n32), .SE(n217), .CK(clk), .RN(
        n186), .Q(counter[11]), .QN(n263) );
  SDFFRX2M \counter_reg[12]  ( .D(n121), .SI(n263), .SE(n217), .CK(clk), .RN(
        n186), .Q(counter[12]), .QN(n248) );
  SDFFRX2M \counter_reg[7]  ( .D(n126), .SI(n30), .SE(n212), .CK(clk), .RN(
        n186), .Q(counter[7]), .QN(n262) );
  SDFFRX2M \counter_reg[8]  ( .D(n125), .SI(n262), .SE(n228), .CK(clk), .RN(
        n186), .Q(counter[8]), .QN(n247) );
  SDFFRX2M \counter_reg[15]  ( .D(n118), .SI(n28), .SE(n235), .CK(clk), .RN(
        n186), .Q(counter[15]), .QN(n264) );
  SDFFRX2M \counter_reg[16]  ( .D(n117), .SI(n264), .SE(n235), .CK(clk), .RN(
        n186), .Q(counter[16]), .QN(n249) );
  SDFFRX2M \counter_reg[19]  ( .D(n114), .SI(n26), .SE(n237), .CK(clk), .RN(
        n185), .Q(counter[19]), .QN(n265) );
  SDFFRX2M \counter_reg[20]  ( .D(n113), .SI(n265), .SE(n219), .CK(clk), .RN(
        n185), .Q(counter[20]), .QN(n250) );
  NOR4X2M U3 ( .A(n11), .B(n12), .C(n13), .D(n14), .Y(n10) );
  NAND4X2M U4 ( .A(n262), .B(n30), .C(n22), .D(n246), .Y(n12) );
  NAND4X2M U5 ( .A(n263), .B(n32), .C(n24), .D(n247), .Y(n13) );
  NAND4X2M U8 ( .A(n91), .B(n62), .C(n93), .D(n202), .Y(n11) );
  NAND4X2M U9 ( .A(n265), .B(n26), .C(n2), .D(n249), .Y(n15) );
  NAND4X2M U10 ( .A(n264), .B(n28), .C(n20), .D(n248), .Y(n14) );
  INVXLM U11 ( .A(n259), .Y(n1) );
  INVX2M U12 ( .A(n1), .Y(n2) );
  INVXLM U13 ( .A(n258), .Y(n19) );
  INVX2M U14 ( .A(n19), .Y(n20) );
  INVXLM U15 ( .A(n256), .Y(n21) );
  INVX2M U16 ( .A(n21), .Y(n22) );
  INVXLM U17 ( .A(n257), .Y(n23) );
  INVX2M U18 ( .A(n23), .Y(n24) );
  INVXLM U19 ( .A(n255), .Y(n25) );
  INVX2M U20 ( .A(n25), .Y(n26) );
  INVXLM U21 ( .A(n254), .Y(n27) );
  INVX2M U22 ( .A(n27), .Y(n28) );
  INVXLM U23 ( .A(n252), .Y(n29) );
  INVX2M U24 ( .A(n29), .Y(n30) );
  INVXLM U25 ( .A(n253), .Y(n31) );
  INVX2M U26 ( .A(n31), .Y(n32) );
  INVXLM U27 ( .A(n260), .Y(n33) );
  INVX2M U28 ( .A(n33), .Y(n34) );
  INVXLM U29 ( .A(n266), .Y(n35) );
  INVX2M U30 ( .A(n35), .Y(test_so) );
endmodule


module top ( clk, rst, Data_valid, P_data, Par_type, Par_en, Busy, TX_out, SI, 
        SE, scan_clk, scan_rst, test_mode, SO );
  input [7:0] P_data;
  input clk, rst, Data_valid, Par_type, Par_en, SI, SE, scan_clk, scan_rst,
         test_mode;
  output Busy, TX_out, SO;
  wire   CLK_M, RST_M, Par_bit, ser_done, ser_en, idle_data, ser_data, n1, n2,
         n5, n6, n8, n9, n10, n11, n12, n13;
  wire   [1:0] mux_sel;

  INVX2M U4 ( .A(RST_M), .Y(n2) );
  DLY1X1M U5 ( .A(SE), .Y(n11) );
  INVXLM U6 ( .A(n11), .Y(n8) );
  DLY1X1M U7 ( .A(n8), .Y(n9) );
  DLY1X1M U8 ( .A(n12), .Y(n10) );
  INVXLM U9 ( .A(n9), .Y(n12) );
  INVXLM U10 ( .A(n9), .Y(n13) );
  Mux_dft_1 U0_mux2X1 ( .IN_0(clk), .IN_1(scan_clk), .SEL(test_mode), .OUT(
        CLK_M) );
  Mux_dft_0 U2_mux2X1 ( .IN_0(rst), .IN_1(scan_rst), .SEL(test_mode), .OUT(
        RST_M) );
  Parity_test_1 DUT_2 ( .clk(CLK_M), .rst(n1), .Data_valid(Data_valid), 
        .P_data(P_data), .Par_type(Par_type), .Par_bit(Par_bit), .test_si(n6), 
        .test_so(n5), .test_se(n13) );
  FSM_test_1 DUT_3 ( .clk(CLK_M), .rst(n1), .Data_valid(Data_valid), 
        .ser_done(ser_done), .Par_en(Par_en), .mux_sel(mux_sel), .ser_en(
        ser_en), .Busy(Busy), .idle_data(idle_data), .test_si(n5), .test_so(SO), .test_se(n10) );
  mux DUT_4 ( .start_bit(1'b0), .stop_bit(1'b1), .mux_sel(mux_sel), .Par_bit(
        Par_bit), .ser_data(ser_data), .TX_out(TX_out) );
  serializer_test_1 DUT_1 ( .clk(CLK_M), .rst(n1), .Data_valid(Data_valid), 
        .P_data(P_data), .ser_en(ser_en), .idle_data(idle_data), .ser_done(
        ser_done), .ser_data(ser_data), .test_si(SI), .test_so(n6), .test_se(
        SE) );
  INVX6M U3 ( .A(n2), .Y(n1) );
endmodule

