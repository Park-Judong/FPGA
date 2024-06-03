module mux32to1(aa, ab, ac, ad, ae, af, ag, ah, ai, aj, ba, bb, bc, bd, be, bf, bg, bh, bi, bj, ca, cb, cc, cd, ce, cf, cg, ch, ci, cj, da, db, sel, y);
    input [16:0] aa, ab, ac, ad, ae, af, ag, ah, ai, aj, ba, bb, bc, bd, be, bf, bg, bh, bi, bj, ca, cb, cc, cd, ce, cf, cg, ch, ci, cj, da, db;
    input [7:0] sel;
    output [16:0] y;
    
    reg [16:0]y;
    
    always @(*) 
    case(sel)
    8'd0 : y = aa;
    8'd1 : y = ab;
    8'd2 : y = ac;
    8'd3 : y = ad;
    8'd4 : y = ae;
    8'd5 : y = af;
    8'd6 : y = ag;
    8'd7 : y = ah;
    8'd8 : y = ai;
    8'd9 : y = aj;
    8'd10 : y = ba;
    8'd11 : y = bb;
    8'd12 : y = bc;
    8'd13 : y = bd;
    8'd14 : y = be;
    8'd15 : y = bf;
    8'd16 : y = bg;
    8'd17 : y = bh;
    8'd18 : y = bi;
    8'd19 : y = bj;
    8'd20 : y = ca;
    8'd21 : y = cb;
    8'd22 : y = cc;
    8'd23 : y = cd;
    8'd24 : y = ce;
    8'd25 : y = cf;
    8'd26 : y = cg;
    8'd27 : y = ch;
    8'd28 : y = ci;
    8'd29 : y = cj;
    8'd30 : y = da;
    8'd31 : y = db;
    endcase
endmodule