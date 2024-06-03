module tb_mux32to1;
    wire [16:0] y;
    reg [16:0] aa, ab, ac, ad, ae, af, ag, ah, ai, aj, ba, bb, bc, bd, be, bf, bg, bh, bi, bj, ca, cb, cc, cd, ce, cf, cg, ch, ci, cj, da, db;
    reg [7:0] sel; // for문을 이용하기 위해
    reg [255:0] n;
    mux32to1 u0 (.aa(aa), .ab(ab), .ac(ac), .ad(ad), .ae(ae), .af(af), .ag(ag), .ah(ah), .ai(ai), .aj(aj), .ba(ba), .bb(bb), .bc(bc), .bd(bd), .be(be), .bf(bf), .bg(bg), .bh(bh), .bi(bi), .bj(bj), .ca(ca), .cb(cb), .cc(cc), .cd(cd), .ce(ce), .cf(cf), .cg(cg), .ch(ch), .ci(ci), .cj(cj), .da(da), .db(db), .y(y), .sel(sel));
    
    initial begin
    aa = $random()%256;
    ab = $random()%256; 
    ac = $random()%256; 
    ad = $random()%256;
    ae = $random()%256;
    af = $random()%256; 
    ag = $random()%256; 
    ah = $random()%256;
    ai = $random()%256;
    aj = $random()%256; 
    ba = $random()%256; 
    bb = $random()%256;
    bc = $random()%256;
    bd = $random()%256; 
    be = $random()%256; 
    bf = $random()%256;
    bg = $random()%256;
    bh = $random()%256; 
    bi = $random()%256; 
    bj = $random()%256;
    ca = $random()%256;
    cb = $random()%256; 
    cc = $random()%256; 
    cd = $random()%256;
    ce = $random()%256;
    cf = $random()%256; 
    cg = $random()%256; 
    ch = $random()%256;
    ci = $random()%256;
    cj = $random()%256; 
    da = $random()%256; 
    db = $random()%256;
    n = 0;
    for (sel = 0 ; sel < 32 ; sel = sel+1)
        //sel = $urandom() + $urandom();
        #10;
    #10; 
    end
    
endmodule