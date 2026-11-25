/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Thu Nov 19 13:13:28 2026
/////////////////////////////////////////////////////////////


module control_pad ( rst_, clk, zero, opcode, rd, wr, ld_ir, ld_ac, ld_pc, 
        inc_pc, halt, data_e, sel );
  input [2:0] opcode;
  input rst_, clk, zero;
  output rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, halt, data_e, sel;
  wire   n39, rst_pad, clk_pad, zero_pad, rd_pad, wr_pad, ld_ir_pad, ld_ac_pad,
         inc_pc_pad, halt_pad, data_e_pad, n12, n15, n16, n17, n18, n19, n20,
         n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37, n38;
  wire   [2:0] opcode_pad;
  wire   [2:0] \i_control/state ;

  PI i_rst ( .PAD(rst_), .C(rst_pad) );
  PI i_clk ( .PAD(clk), .C(clk_pad) );
  PI i_zero ( .PAD(n39), .C(zero_pad) );
  PI i_opcode_0 ( .PAD(opcode[0]), .C(opcode_pad[0]) );
  PI i_opcode_1 ( .PAD(opcode[1]), .C(opcode_pad[1]) );
  PI i_opcode_2 ( .PAD(opcode[2]), .C(opcode_pad[2]) );
  PO8 i_rd ( .I(rd_pad), .PAD(rd) );
  PO8 i_wr ( .I(wr_pad), .PAD(wr) );
  PO8 i_ld_ir ( .I(ld_ir_pad), .PAD(ld_ir) );
  PO8 i_ld_ac ( .I(ld_ac_pad), .PAD(ld_ac) );
  PO8 i_ld_pc ( .I(n37), .PAD(ld_pc) );
  PO8 i_inc_pc ( .I(inc_pc_pad), .PAD(inc_pc) );
  PO8 i_halt ( .I(halt_pad), .PAD(halt) );
  PO8 i_data_e ( .I(data_e_pad), .PAD(data_e) );
  PO8 i_sel ( .I(n22), .PAD(sel) );
  DFFRX1 \i_control/state_reg[0]  ( .D(n23), .CK(clk_pad), .RN(rst_pad), .Q(
        \i_control/state [0]), .QN(n23) );
  DFFSXL \i_control/state_reg[1]  ( .D(n16), .CK(clk_pad), .SN(rst_pad), .Q(
        n38), .QN(\i_control/state [1]) );
  DFFRX2 \i_control/state_reg[2]  ( .D(n12), .CK(clk_pad), .RN(rst_pad), .Q(
        \i_control/state [2]), .QN(n22) );
  CLKINVX3 U24 ( .A(n17), .Y(n20) );
  NAND2X4 U25 ( .A(opcode_pad[0]), .B(\i_control/state [1]), .Y(n29) );
  NOR3X6 U26 ( .A(n36), .B(n35), .C(n34), .Y(rd_pad) );
  OR2X1 U27 ( .A(n15), .B(n34), .Y(n16) );
  CLKINVX6 U28 ( .A(n33), .Y(n35) );
  NOR2X1 U29 ( .A(\i_control/state [0]), .B(\i_control/state [1]), .Y(n34) );
  NAND2X6 U30 ( .A(opcode_pad[0]), .B(zero_pad), .Y(n17) );
  INVX8 U31 ( .A(opcode_pad[2]), .Y(n24) );
  NAND2X1 U32 ( .A(\i_control/state [2]), .B(\i_control/state [1]), .Y(n25) );
  NOR2X2 U33 ( .A(n22), .B(n32), .Y(n30) );
  NOR2X2 U34 ( .A(\i_control/state [2]), .B(n38), .Y(ld_ir_pad) );
  BUFX20 U35 ( .A(zero), .Y(n39) );
  NOR2X6 U36 ( .A(opcode_pad[1]), .B(n25), .Y(n19) );
  NAND2X1 U37 ( .A(\i_control/state [0]), .B(\i_control/state [1]), .Y(n32) );
  INVXL U38 ( .A(n32), .Y(n15) );
  NAND2X6 U39 ( .A(n31), .B(n30), .Y(n18) );
  XNOR2XL U40 ( .A(n32), .B(\i_control/state [2]), .Y(n12) );
  NAND2X1 U41 ( .A(n34), .B(\i_control/state [2]), .Y(n26) );
  INVX8 U42 ( .A(n18), .Y(ld_ac_pad) );
  XOR2X4 U43 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .Y(n31) );
  NAND4X4 U44 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .C(opcode_pad[0]), .D(
        n30), .Y(n27) );
  NAND3X8 U45 ( .A(n27), .B(n28), .C(n26), .Y(inc_pc_pad) );
  NAND3X6 U46 ( .A(n20), .B(n24), .C(n19), .Y(n28) );
  NOR2X8 U47 ( .A(n31), .B(n25), .Y(data_e_pad) );
  NOR4X8 U48 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .C(opcode_pad[0]), .D(n26), .Y(halt_pad) );
  NAND3X8 U49 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .C(\i_control/state [2]), 
        .Y(n33) );
  NOR2X8 U50 ( .A(n33), .B(n29), .Y(n37) );
  NOR3X8 U51 ( .A(n33), .B(opcode_pad[0]), .C(n32), .Y(wr_pad) );
  NOR3X4 U52 ( .A(opcode_pad[2]), .B(opcode_pad[1]), .C(n22), .Y(n36) );
endmodule

