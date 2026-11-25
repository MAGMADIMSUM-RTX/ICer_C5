/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Thu Nov 19 13:13:31 2026
/////////////////////////////////////////////////////////////


module control_pad ( rst_, clk, zero, opcode, rd, wr, ld_ir, ld_ac, ld_pc, 
        inc_pc, halt, data_e, sel );
  input [2:0] opcode;
  input rst_, clk, zero;
  output rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, halt, data_e, sel;
  wire   rst_pad, clk_pad, zero_pad, rd_pad, wr_pad, ld_ir_pad, ld_ac_pad,
         inc_pc_pad, halt_pad, data_e_pad, n12, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n26, n27, n30, n31, n34, n35, n37, n40, n41, n43,
         n44, n45, n46, n47, n48, n49;
  wire   [2:0] opcode_pad;
  wire   [2:0] \i_control/state ;

  PI i_rst ( .PAD(rst_), .C(rst_pad) );
  PI i_clk ( .PAD(clk), .C(clk_pad) );
  PI i_zero ( .PAD(n16), .C(zero_pad) );
  PI i_opcode_0 ( .PAD(opcode[0]), .C(opcode_pad[0]) );
  PI i_opcode_1 ( .PAD(opcode[1]), .C(opcode_pad[1]) );
  PI i_opcode_2 ( .PAD(opcode[2]), .C(opcode_pad[2]) );
  PO8 i_rd ( .I(rd_pad), .PAD(rd) );
  PO8 i_wr ( .I(wr_pad), .PAD(wr) );
  PO8 i_ld_ir ( .I(ld_ir_pad), .PAD(ld_ir) );
  PO8 i_ld_ac ( .I(ld_ac_pad), .PAD(ld_ac) );
  PO8 i_ld_pc ( .I(n48), .PAD(ld_pc) );
  PO8 i_inc_pc ( .I(inc_pc_pad), .PAD(inc_pc) );
  PO8 i_halt ( .I(halt_pad), .PAD(halt) );
  PO8 i_data_e ( .I(data_e_pad), .PAD(data_e) );
  PO8 i_sel ( .I(n30), .PAD(sel) );
  DFFRX1 \i_control/state_reg[0]  ( .D(n31), .CK(clk_pad), .RN(rst_pad), .Q(
        \i_control/state [0]), .QN(n31) );
  DFFSXL \i_control/state_reg[1]  ( .D(n24), .CK(clk_pad), .SN(rst_pad), .Q(
        n49), .QN(\i_control/state [1]) );
  DFFRX2 \i_control/state_reg[2]  ( .D(n12), .CK(clk_pad), .RN(rst_pad), .Q(
        \i_control/state [2]), .QN(n30) );
  NAND3X8 U24 ( .A(n21), .B(n19), .C(opcode_pad[0]), .Y(n18) );
  NOR2X8 U25 ( .A(n22), .B(n34), .Y(data_e_pad) );
  XOR2X4 U26 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .Y(n22) );
  XOR2X4 U27 ( .A(opcode_pad[1]), .B(opcode_pad[2]), .Y(n15) );
  NAND2XL U28 ( .A(zero_pad), .B(n35), .Y(n20) );
  OR2X1 U29 ( .A(n23), .B(n45), .Y(n24) );
  NOR2X1 U30 ( .A(\i_control/state [0]), .B(\i_control/state [1]), .Y(n45) );
  CLKBUFX2 U31 ( .A(zero), .Y(n26) );
  NAND2X1 U32 ( .A(\i_control/state [2]), .B(\i_control/state [1]), .Y(n34) );
  NOR2X2 U33 ( .A(n30), .B(n43), .Y(n41) );
  NOR2X6 U34 ( .A(opcode_pad[2]), .B(n20), .Y(n19) );
  INVXL U35 ( .A(n34), .Y(n35) );
  NOR2X2 U36 ( .A(\i_control/state [2]), .B(n49), .Y(ld_ir_pad) );
  BUFX20 U37 ( .A(n26), .Y(n16) );
  NAND3X8 U38 ( .A(n18), .B(n37), .C(n17), .Y(inc_pc_pad) );
  NAND4X4 U39 ( .A(opcode_pad[0]), .B(opcode_pad[1]), .C(opcode_pad[2]), .D(
        n41), .Y(n17) );
  INVX4 U40 ( .A(opcode_pad[1]), .Y(n21) );
  NAND2X6 U41 ( .A(n15), .B(n41), .Y(n27) );
  NAND2X1 U42 ( .A(\i_control/state [0]), .B(\i_control/state [1]), .Y(n43) );
  INVXL U43 ( .A(n43), .Y(n23) );
  XNOR2XL U44 ( .A(n43), .B(\i_control/state [2]), .Y(n12) );
  NAND2X1 U45 ( .A(n45), .B(\i_control/state [2]), .Y(n37) );
  INVX8 U46 ( .A(n27), .Y(ld_ac_pad) );
  NOR4X8 U47 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .C(opcode_pad[0]), .D(n37), .Y(halt_pad) );
  NAND3X8 U48 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .C(\i_control/state [2]), 
        .Y(n44) );
  NAND2X2 U49 ( .A(opcode_pad[0]), .B(\i_control/state [1]), .Y(n40) );
  NOR2X8 U50 ( .A(n44), .B(n40), .Y(n48) );
  NOR3X8 U51 ( .A(n44), .B(opcode_pad[0]), .C(n43), .Y(wr_pad) );
  NOR3X4 U52 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .C(n30), .Y(n47) );
  INVX6 U53 ( .A(n44), .Y(n46) );
  NOR3X8 U54 ( .A(n47), .B(n46), .C(n45), .Y(rd_pad) );
endmodule

