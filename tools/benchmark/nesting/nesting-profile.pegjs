// Deep Nesting: https://github.com/pegjs/pegjs/issues/623
// Details: https://github.com/meisl/pegjs/tree/master/tools/benchmark/nesting
//
// Just paste into https://pegjs.org/online - but do be careful
// with nesting depths > 10. Sic!
{
  // Global state:
  // * start time
  // * call counters; increased by rules bumpA, bumpC and bumpP
  const tStart = Date.now();
  const calls = { add: 0, call: 0, prim: 0 };
  
  // Aggregate results from one or more profile objects.
  // head: profile object
  // tail: list of profile objects
  function listUpdate(head, tail = []) {
    head.n = tail.map(p => p.n)
                .reduce((a, v) => Math.max(a, v), head.n);
   	// ATTENTION: reduce(Math.max, head.n) does NOT work, since
    // Math.max takes as many args as it gets, not only 2!
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

start = profile:v0 // <<<<<<<< SELECT VARIANT HERE <<<<<<<<
{ return polish(profile) }

v0 = p:add0 { p.variant = 0; p.description = "no common prefixes, using * operator";   return p; }
v1 = p:add1 { p.variant = 1; p.description = "common prefixes, without *  <<<<< BEWARE!"; return p; }
v2 = p:add2 { p.variant = 2; p.description = "no commmon prefixes, ? operator";     return p; }
v3 = p:add3 { p.variant = 3; p.description = "no nothing, just ε";                  return p; }

bumpA = "" { calls.add++;  }
bumpC = "" { calls.call++; }
bumpP = "" { calls.prim++; }

// - Variant 0 -------------------------------------------------------------
// Repetition done with * (non-recursively). W/out clutter:
//   add  = call ("+" add)*
//   call = prim ("(" add ")")*
//   prim = "(" add ")"
//        / "x"

add0 = bumpA p:(
        h:call0 t:("+" t:add0 { return t })* { return listUpdate(h, t) }
  ) { return p; }

call0 = bumpC p:(
        h:prim0 t:("(" t:add0 ")" { t.n++; return t })* { return listUpdate(h, t) }
  ) { return p; }

prim0 = bumpP p:(
       "(" p:add0 ")" { p.n++; return p; }
	 / "x" { return {n: 0} }
  ) { return p; }
  
// - Variant 1 -------------------------------------------------------------
// Repetition done via recursion, common prefixes. W/out clutter:
//   add  = call ("+" add)
//        / call
//   call = prim ("(" add ")")
//        / prim
//   prim = "(" add ")"
//        / "x"

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

// - Variant 2 -------------------------------------------------------------
// Avoid common prefixes by using ?. W/out clutter:
//   add  = call ("+" add)?
//   call = prim ("(" add ")")?
//   prim = "(" add ")"
//        / "x"

add2 = bumpA p:(
        h:call2 t:("+" t:add2 { return t })?
        { return t ? listUpdate(h, [t]) : h }
  ) { return p; }

call2 = bumpC p:(
        h:prim2 t:("(" t:add2 ")" { t.n++; return t })?
        { return t ? listUpdate(h, [t]) : h }
  ) { return p; }

prim2 = bumpP p:(
       "(" p:add2 ")" { p.n++; return p; }
	 / "x" { return {n: 0} }
  ) { return p; }

// - Variant 3 -------------------------------------------------------------
// Avoid common prefixes by using ε. W/out clutter:
//   add  = call ("+" add / "")
//   call = prim ("(" add ")" / "")
//   prim = "(" add ")"
//        / "x"

add3 = bumpA p:(
        h:call3 t:("+" t:add3 { return t } / "")
        { return t ? listUpdate(h, [t]) : h }
  ) { return p; }

call3 = bumpC p:(
        h:prim3 t:("(" t:add3 ")" { t.n++; return t } / "")
        { return t ? listUpdate(h, [t]) : h }
  ) { return p; }

prim3 = bumpP p:(
       "(" p:add3 ")" { p.n++; return p; }
	 / "x" { return {n: 0} }
  ) { return p; }

