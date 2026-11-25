/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Thu Nov 19 13:13:39 2026
/////////////////////////////////////////////////////////////


module control_pad ( rst_, clk, zero, opcode, rd, wr, ld_ir, ld_ac, ld_pc, 
        inc_pc, halt, data_e, sel );
  input [2:0] opcode;
  input rst_, clk, zero;
  output rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, halt, data_e, sel;
  wire   rst_pad, clk_pad, zero_pad, rd_pad, wr_pad, ld_ir_pad, ld_ac_pad,
         ld_pc_pad, inc_pc_pad, halt_pad, data_e_pad, n1, n2, n3, n4, n5, n6,
         n7, n8, n9, n11, n12, n15, n16, n17, n18, n19;
  wire   [2:0] opcode_pad;
  wire   [2:0] \i_control/state ;

  PI i_rst ( .PAD(rst_), .C(rst_pad) );
  PI i_clk ( .PAD(clk), .C(clk_pad) );
  PI i_zero ( .PAD(zero), .C(zero_pad) );
  PI i_opcode_0 ( .PAD(opcode[0]), .C(opcode_pad[0]) );
  PI i_opcode_1 ( .PAD(opcode[1]), .C(opcode_pad[1]) );
  PI i_opcode_2 ( .PAD(opcode[2]), .C(opcode_pad[2]) );
  PO8 i_rd ( .I(rd_pad), .PAD(rd) );
  PO8 i_wr ( .I(wr_pad), .PAD(wr) );
  PO8 i_ld_ir ( .I(ld_ir_pad), .PAD(ld_ir) );
  PO8 i_ld_ac ( .I(ld_ac_pad), .PAD(ld_ac) );
  PO8 i_ld_pc ( .I(ld_pc_pad), .PAD(ld_pc) );
  PO8 i_inc_pc ( .I(inc_pc_pad), .PAD(inc_pc) );
  PO8 i_halt ( .I(halt_pad), .PAD(halt) );
  PO8 i_data_e ( .I(data_e_pad), .PAD(data_e) );
  PO8 i_sel ( .I(n18), .PAD(sel) );
  DFFRXL \i_control/state_reg[0]  ( .D(n19), .CK(clk_pad), .RN(rst_pad), .Q(
        \i_control/state [0]), .QN(n19) );
  OAI2BB2XL U8 ( .B0(opcode_pad[2]), .B1(opcode_pad[1]), .A0N(opcode_pad[2]), 
        .A1N(opcode_pad[1]), .Y(n7) );
  OAI211XL U15 ( .A0(\i_control/state [1]), .A1(n19), .B0(n3), .C0(zero_pad), 
        .Y(n1) );
  OAI2BB2XL U16 ( .B0(n4), .B1(n1), .A0N(\i_control/state [2]), .A1N(n11), .Y(
        n2) );
  DFFRX1 \i_control/state_reg[2]  ( .D(n12), .CK(clk_pad), .RN(rst_pad), .Q(
        \i_control/state [2]), .QN(n18) );
  AO21X1 U17 ( .A0(\i_control/state [0]), .A1(ld_pc_pad), .B0(n2), .Y(
        inc_pc_pad) );
  NAND3XL U11 ( .A(\i_control/state [2]), .B(opcode_pad[2]), .C(opcode_pad[1]), 
        .Y(n9) );
  INVXL U12 ( .A(opcode_pad[0]), .Y(n4) );
  NOR3XL U13 ( .A(n5), .B(n9), .C(n4), .Y(ld_pc_pad) );
  NOR3XL U14 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .C(n18), .Y(n3) );
  NOR3XL U21 ( .A(n18), .B(n7), .C(n8), .Y(ld_ac_pad) );
  NOR3XL U22 ( .A(opcode_pad[0]), .B(n9), .C(n8), .Y(wr_pad) );
  AND2XL U9 ( .A(n7), .B(\i_control/state [2]), .Y(n6) );
  NOR2BXL U19 ( .AN(n6), .B(n5), .Y(data_e_pad) );
  NOR2XL U10 ( .A(n11), .B(n6), .Y(rd_pad) );
  AND3XL U18 ( .A(n4), .B(n3), .C(n11), .Y(halt_pad) );
  DFFSXL \i_control/state_reg[1]  ( .D(n17), .CK(clk_pad), .SN(rst_pad), .Q(n5), .QN(\i_control/state [1]) );
  NOR2X2 U24 ( .A(\i_control/state [2]), .B(n5), .Y(ld_ir_pad) );
  NAND2XL U25 ( .A(\i_control/state [1]), .B(\i_control/state [0]), .Y(n8) );
  NOR2XL U26 ( .A(\i_control/state [1]), .B(\i_control/state [0]), .Y(n11) );
  INVXL U27 ( .A(n8), .Y(n16) );
  NOR2XL U28 ( .A(n16), .B(n11), .Y(n15) );
  INVXL U29 ( .A(n15), .Y(n17) );
  OAI22XL U30 ( .A0(\i_control/state [2]), .A1(n8), .B0(n18), .B1(n16), .Y(n12) );
endmodule

