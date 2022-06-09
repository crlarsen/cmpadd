`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2022 01:12:33 PM
// Design Name: 
// Module Name: cmpadd
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Test harness to compare binary16 addition using exact
//              intermediate results vs. minimal length intermediate results.
//              Final sums for both cases need to be equal.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module cmpadd(clk, btnL, btnR, sw, seg, an, led);
  parameter NEXP =  5;
  parameter NSIG = 10;
  `include "ieee-754-flags.vh"
  input clk, btnL, btnR;
  input [NEXP+NSIG:0] sw;
  output [0:6] seg;
  output [3:0] an;
  output [15:0] led;
  
  reg [15:0] a, b;
  reg stopped, error;
  reg [30:0] counter = 30'h00000000;
  wire clk190;
  parameter DR = 2; // Divided clock selector
  
  wire [15:0] hexdigits;
  wire [15:0] s;
  
  wire [NTYPES-1:0] sFlags, seFlags;
  wire [NEXCEPTIONS-1:0] exception, eException;
  
 // Generate 190 Hz clock signal
  always @(posedge clk)
    begin
      if (clk)
        counter = counter + 1;
    end
  assign clk190 = counter[18];
    
  wire select, clr;
  
  wire [NRAS-1:0] ra = sw[NRAS-1:0];
  
  initial
  begin
    a = 16'h0000;
    b = 16'h0000;
    stopped = 1'b0;
    error = 1'b0;
  end
  
  wire [15:0] checkS;

  always @(posedge counter[DR] or posedge clr)
  begin
    if (clr)
      begin
        a = 16'h0000;
        b = 16'h0000;
        stopped = 1'b0;
        error = 1'b0;
      end
    else if (counter[DR])
    begin
      if (~stopped)
        begin
          if (s != checkS)
            begin
              stopped = 1'b1;
              error = 1'b1;
            end
          else if (b == 16'hFBFF)
            begin
              if (a == 16'hFBFF)
                begin
                  stopped = 1'b1;
                end
              else
                begin
                  b = 16'h0000;
                  a = (a == 16'h7BFF) ? 16'h8000 : (a + 1);
                end
            end
          else
            b = (b == 16'h7BFF) ? 16'h8000 : (b + 1);
        end
    end
  end
  
  debounce U0(clk190, btnL, select);
  
  // Debounce btnR to generate "clear" signal
  debounce U1(clk190, btnR, clr);

  assign led = select ? sw : b;
  assign hexdigits = {(error&~select) ? 16'hDEAD : ((stopped&~select) ? 16'hAAAA : (select ? b : a))};
  x7seg U2(hexdigits, clk, clr, seg, an);
  
  fp_add #(NEXP,NSIG)       U3(a, b, ra,  s,      sFlags,  exception);
  fp_add_exact #(NEXP,NSIG) U4(a, b, ra,  checkS, seFlags, eException);
endmodule
