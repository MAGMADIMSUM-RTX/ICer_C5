/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Thu Nov 19 13:14:33 2026
/////////////////////////////////////////////////////////////


module control ( rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, halt, data_e, sel, 
        opcode, zero, clk, rst_ );
  input [2:0] opcode;
  input zero, clk, rst_;
  output rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, halt, data_e, sel;
  wire   n1, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n2;
  wire   [2:0] state;
  wire   [2:0] nextstate;

  DFFRX1 \state_reg[1]  ( .D(nextstate[1]), .CK(clk), .RN(rst_), .Q(state[1]), 
        .QN(n3) );
  DFFRX1 \state_reg[0]  ( .D(n4), .CK(clk), .RN(rst_), .Q(state[0]), .QN(n4)
         );
  DFFRX2 \state_reg[2]  ( .D(nextstate[2]), .CK(clk), .RN(rst_), .Q(state[2]), 
        .QN(sel) );
  OA21XL U3 ( .A0(n18), .A1(n6), .B0(n19), .Y(n2) );
  CLKINVX1 U4 ( .A(n2), .Y(inc_pc) );
  CLKINVX1 U5 ( .A(n9), .Y(ld_ac) );
  NOR3X2 U6 ( .A(n6), .B(n16), .C(n8), .Y(ld_pc) );
  NOR2X2 U7 ( .A(n16), .B(n11), .Y(data_e) );
  NAND2X1 U8 ( .A(n17), .B(n11), .Y(n9) );
  CLKINVX1 U9 ( .A(n8), .Y(n5) );
  NOR2BX1 U10 ( .AN(n13), .B(n17), .Y(n16) );
  NAND2X1 U11 ( .A(n15), .B(n14), .Y(ld_ir) );
  NAND2BX1 U12 ( .AN(n12), .B(n15), .Y(nextstate[1]) );
  NOR4X2 U13 ( .A(opcode[2]), .B(opcode[1]), .C(opcode[0]), .D(n19), .Y(halt)
         );
  AOI32X1 U14 ( .A0(zero), .A1(n1), .A2(n20), .B0(n17), .B1(n5), .Y(n18) );
  CLKINVX1 U15 ( .A(n16), .Y(n1) );
  NOR2X1 U16 ( .A(opcode[2]), .B(opcode[1]), .Y(n20) );
  NAND3BX1 U17 ( .AN(ld_ir), .B(n9), .C(n10), .Y(rd) );
  AOI22X1 U18 ( .A0(n11), .A1(n12), .B0(sel), .B1(state[0]), .Y(n10) );
  NOR3X2 U19 ( .A(n7), .B(n3), .C(n8), .Y(wr) );
  NAND3X1 U20 ( .A(state[2]), .B(n6), .C(state[0]), .Y(n7) );
  NAND2X1 U21 ( .A(opcode[2]), .B(opcode[1]), .Y(n8) );
  XOR2X1 U22 ( .A(opcode[1]), .B(opcode[2]), .Y(n11) );
  CLKINVX1 U23 ( .A(opcode[0]), .Y(n6) );
  NOR3X1 U24 ( .A(n4), .B(sel), .C(n3), .Y(n17) );
  NAND3X1 U25 ( .A(state[2]), .B(n4), .C(state[1]), .Y(n13) );
  OAI21XL U26 ( .A0(state[1]), .A1(n4), .B0(n13), .Y(n12) );
  NAND3X1 U27 ( .A(n4), .B(sel), .C(state[1]), .Y(n15) );
  NAND3X1 U28 ( .A(n4), .B(n3), .C(state[2]), .Y(n19) );
  NAND3X1 U29 ( .A(state[0]), .B(sel), .C(state[1]), .Y(n14) );
  OAI211X1 U30 ( .A0(state[1]), .A1(sel), .B0(n13), .C0(n14), .Y(nextstate[2])
         );
endmodule


module control_pad ( rst_, clk, zero, opcode, rd, wr, ld_ir, ld_ac, ld_pc, 
        inc_pc, halt, data_e, sel );
  input [2:0] opcode;
  input rst_, clk, zero;
  output rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, halt, data_e, sel;
  wire   rst_pad, clk_pad, zero_pad, rd_pad, wr_pad, ld_ir_pad, ld_ac_pad,
         ld_pc_pad, inc_pc_pad, halt_pad, data_e_pad, sel_pad;
  wire   [2:0] opcode_pad;

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
  PO8 i_sel ( .I(sel_pad), .PAD(sel) );
  control i_control ( .rd(rd_pad), .wr(wr_pad), .ld_ir(ld_ir_pad), .ld_ac(
        ld_ac_pad), .ld_pc(ld_pc_pad), .inc_pc(inc_pc_pad), .halt(halt_pad), 
        .data_e(data_e_pad), .sel(sel_pad), .opcode(opcode_pad), .zero(
        zero_pad), .clk(clk_pad), .rst_(rst_pad) );
endmodule

