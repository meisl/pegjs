// Deep Nesting: https://github.com/pegjs/pegjs/issues/623
// Details: https://github.com/meisl/pegjs/tree/master/tools/benchmark/nesting
//
// Just paste into https://pegjs.org/online - but do be careful
// with nesting depths > 10. Sic!
{
  const tStart = Date.now();
  const calls = { add: 0, call: 0, prim: 0 };
  
  // Aggregate results from one or more profile objects.
  // head: profile object
  // tail: list of profile objects
  function listUpdate(head, tail = []) {
    head.n = tail.map(p => p.n).reduce(Math.max, head.n);
    return head;
  }
  // Nicify final output
  function polish(profile) {
    calls.TOTAL = calls.add + calls.call + calls.prim;
    Object.assign(profile, {
      "max nesting": profile.n,
      "time (ms)": Date.now() - tStart,
      calls,
    });
    delete profile.n;
    return profile;
  }
}

start = profile:v1 // <<<<<<<< SELECT VARIANT HERE <<<<<<<<
{ return polish(profile) }

v0 = p:add0 { p.variant = 0; p.description = "using * operator";                         return p; }
v1 = p:add1 { p.variant = 1; p.description = "choices with common prefix <<<<< BEWARE!"; return p; }
//v2 = p:add2 { p.variant = 2; p.description = "refactored v1, without * but using ?";     return p; }
//v3 = p:add3 { p.variant = 3; p.description = "performant variant without *, + or ?";     return p; }

bumpA = "" { calls.add++;  }
bumpC = "" { calls.call++; }
bumpP = "" { calls.prim++; }

// ------------------------------------------------------------------

add0 = bumpA p:(
        h:call0 t:("+" t:add0 { return t })*
          { t.n++; return listUpdate(h, t) }
      / call0
  ) { return p; }

call0 = bumpC p:(
        h:prim0 t:("(" t:add0 ")" { return t })*
          { t.n++; return listUpdate(h, t) }
      / prim0
  ) { return p; }

prim0 = bumpP p:(
       "(" p:add0 ")" { p.n++; return p; }
	 / "x" { return {n: 0} }
  ) { return p; }
  
// ------------------------------------------------------------------

add1 = bumpA p:(
       h:call1 "+" t:add1 { return listUpdate(h, [t]); }
     / call1
  ) { return p; }

call1 = bumpC p:(
        h:prim1 "(" t:add1 ")" { t.n++; return listUpdate(h, [t]); }
      / prim1
  ) { return p; }

prim1 = bumpP p:(
       "(" p:add1 ")" { p.n++; return p; }
	 / "x" { return {n: 0} }
  ) { return p; }

