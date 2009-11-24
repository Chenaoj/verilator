// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2009 by Wilson Snyder.

module t (/*AUTOARG*/);

   // IEEE: integer_atom_type
   byte		d_byte;
   shortint	d_shortint;
   int		d_int;
   longint	d_longint;
   integer	d_integer;
   time		d_time;

   // IEEE: integer_atom_type
   bit		d_bit;
   logic	d_logic;
   reg		d_reg;

   bit	  [1:0]	d_bit2;
   logic  [1:0]	d_logic2;
   reg	  [1:0]	d_reg2;

   // IEEE: non_integer_type
   //UNSUP shortreal	d_shortreal;
   //UNSUP real		d_real;
   //UNSUP realtime	d_realtime;

   // Declarations using var
   var byte 	v_b;
   var [2:0] 	v_b3;
   var signed [2:0] v_bs;

   // verilator lint_off WIDTH
   localparam 		p_implicit = {96{1'b1}};
   localparam [89:0]	p_explicit = {96{1'b1}};
   localparam byte 	p_byte	= {96{1'b1}};
   localparam shortint 	p_shortint = {96{1'b1}};
   localparam int 	p_int	= {96{1'b1}};
   localparam longint 	p_longint = {96{1'b1}};
   localparam integer 	p_integer = {96{1'b1}};
   localparam reg 	p_reg	= {96{1'b1}};
   localparam bit 	p_bit	= {96{1'b1}};
   localparam logic 	p_logic	= {96{1'b1}};
   localparam reg [1:0]	p_reg2	= {96{1'b1}};
   localparam bit [1:0]	p_bit2	= {96{1'b1}};
   localparam logic [1:0] p_logic2= {96{1'b1}};
   // verilator lint_on WIDTH

   // We do this in two steps so we can check that initialization inside functions works properly
   // verilator lint_off WIDTH
   function 		f_implicit;	reg		lv_implicit;	f_implicit	= lv_implicit;	endfunction
   function [89:0]	f_explicit;	reg [89:0]	lv_explicit;	f_explicit	= lv_explicit;	endfunction
   function byte 	f_byte;		byte 		lv_byte;	f_byte	 	= lv_byte;	endfunction
   function shortint 	f_shortint;	shortint 	lv_shortint;	f_shortint	= lv_shortint;	endfunction
   function int 	f_int;		int 		lv_int;		f_int	 	= lv_int;	endfunction
   function longint 	f_longint;	longint 	lv_longint;	f_longint	= lv_longint;	endfunction
   function integer 	f_integer;	integer 	lv_integer;	f_integer	= lv_integer;	endfunction
   function reg 	f_reg;		reg 		lv_reg;		f_reg	 	= lv_reg;	endfunction
   function bit 	f_bit;		bit 		lv_bit;		f_bit	 	= lv_bit;	endfunction
   function logic 	f_logic;	logic 		lv_logic;	f_logic		= lv_logic;	endfunction
   function reg [1:0]	f_reg2;		reg [1:0]	lv_reg2;	f_reg2	 	= lv_reg2;	endfunction
   function bit [1:0]	f_bit2;		bit [1:0]	lv_bit2;	f_bit2	 	= lv_bit2;	endfunction
   function logic [1:0] f_logic2;	logic [1:0] 	lv_logic2;	f_logic2	= lv_logic2;	endfunction
   function time 	f_time;		time 		lv_time;	f_time		= lv_time;	endfunction
   // verilator lint_on WIDTH

`ifdef verilator
   // For verilator zeroinit detection to work properly, we need to x-rand-reset to all 1s.  This is the default!
 `define XINIT 1'b1
 `define ALL_TWOSTATE 1'b1
`else
 `define XINIT 1'bx
 `define ALL_TWOSTATE 1'b0
`endif

`define CHECK_ALL(name,nbits,issigned,twostate,zeroinit) \
   if (zeroinit ? ((name & 1'b1)!==1'b0) : ((name & 1'b1)!==`XINIT)) \
	begin $display("%%Error: Bad zero/X init for %s: %b",`"name`",name); $stop; end \
   name = {96{1'b1}}; \
   if (name !== {(nbits){1'b1}}) begin $display("%%Error: Bad size for %s",`"name`"); $stop; end \
   if (issigned ? (name > 0) : (name < 0)) begin $display("%%Error: Bad signed for %s",`"name`"); $stop; end \
   name = {96{1'bx}}; \
   if (name !== {(nbits){`ALL_TWOSTATE ? `XINIT : (twostate ? 1'b0 : `XINIT)}}) \
	begin $display("%%Error: Bad twostate for %s: %b",`"name`",name); $stop; end \

   initial begin
      // verilator lint_off WIDTH
      // verilator lint_off UNSIGNED
      //         name           b  sign twost 0init
      `CHECK_ALL(d_byte		,8 ,1'b1,1'b1,1'b1);
      `CHECK_ALL(d_shortint	,16,1'b1,1'b1,1'b1);
      `CHECK_ALL(d_int		,32,1'b1,1'b1,1'b1);
      `CHECK_ALL(d_longint	,64,1'b1,1'b1,1'b1);
      `CHECK_ALL(d_integer	,32,1'b1,1'b0,1'b0);
      `CHECK_ALL(d_time		,64,1'b0,1'b0,1'b0);
      `CHECK_ALL(d_bit		,1 ,1'b0,1'b1,1'b1);
      `CHECK_ALL(d_logic	,1 ,1'b0,1'b0,1'b0);
      `CHECK_ALL(d_reg		,1 ,1'b0,1'b0,1'b0);
      `CHECK_ALL(d_bit2		,2 ,1'b0,1'b1,1'b1);
      `CHECK_ALL(d_logic2	,2 ,1'b0,1'b0,1'b0);
      `CHECK_ALL(d_reg2		,2 ,1'b0,1'b0,1'b0);
      // verilator lint_on WIDTH
      // verilator lint_on UNSIGNED

`define CHECK_P(name,nbits) \
   if (name !== {(nbits){1'b1}}) begin $display("%%Error: Bad size for %s",`"name`"); $stop; end \

      //       name              b
      `CHECK_P(p_implicit	,96);
      `CHECK_P(p_explicit	,90);
      `CHECK_P(p_byte		,8 );
      `CHECK_P(p_shortint	,16);
      `CHECK_P(p_int		,32);
      `CHECK_P(p_longint	,64);
      `CHECK_P(p_integer	,32);
      `CHECK_P(p_bit		,1 );
      `CHECK_P(p_logic		,1 );
      `CHECK_P(p_reg		,1 );
      `CHECK_P(p_bit2		,2 );
      `CHECK_P(p_logic2		,2 );
      `CHECK_P(p_reg2		,2 );

`define CHECK_F(fname,nbits,zeroinit) \
   if ($bits(fname()) !== nbits) begin $display("%%Error: Bad size for %s",`"fname`"); $stop; end \

      //       name              b 0init
      `CHECK_F(f_implicit	,1 ,1'b0);  // Note 1 bit, not 96
      `CHECK_F(f_explicit	,90,1'b0);
      `CHECK_F(f_byte		,8 ,1'b1);
      `CHECK_F(f_shortint	,16,1'b1);
      `CHECK_F(f_int		,32,1'b1);
      `CHECK_F(f_longint	,64,1'b1);
      `CHECK_F(f_integer	,32,1'b0);
      `CHECK_F(f_time		,64,1'b0);
      `CHECK_F(f_bit		,1 ,1'b1);
      `CHECK_F(f_logic		,1 ,1'b0);
      `CHECK_F(f_reg		,1 ,1'b0);
      `CHECK_F(f_bit2		,2 ,1'b1);
      `CHECK_F(f_logic2		,2 ,1'b0);
      `CHECK_F(f_reg2		,2 ,1'b0);

      // For unpacked types we don't want width warnings for unsized numbers that fit
      d_byte	= 2;
      d_shortint= 2;
      d_int	= 2;
      d_longint	= 2;
      d_integer	= 2;

      // Special check
      d_time = $time;
      if ($time !== d_time) $stop;

      $write("*-* All Finished *-*\n");
      $finish;
   end
endmodule