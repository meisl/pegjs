// Deep Nesting: https://github.com/pegjs/pegjs/issues/623
{
  const tStart = Date.now();
  const calls = { add: 0, call: 0, prim: 0 };
}

start = profile:v1 // just to make it easy to switch between variants
/*
/  But: BE CAREFUL! You may easily choke your browser and loose your edits!
/  (with "results cache" you're on the safe side)
/
/  Variants:
/    - [ ] v0: using * operator
/    - [x] v1: variant from OP, choices with common prefix <<<<< BEWARE!
/    - [ ] v2: refactored v1, without * but ?
/    - [ ] v3: performant variant without *, + or ?
*/
{
  Object.assign(profile, {
    "max nesting": profile.n,
    "time (ms)": Date.now() - tStart,
    calls,
  });
  delete profile.n;

  return profile;
}

//v0 = p:add0 { p.variant = 0; return p; }
v1 = p:add1 { p.variant = 1; return p; }
//v2 = p:add2 { p.variant = 2; return p; }
//v3 = p:add3 { p.variant = 3; return p; }


bumpA = "" { calls.add++;  }
bumpC = "" { calls.call++; }
bumpP = "" { calls.prim++; }

// ------------------------------------------------------------------

add1 = bumpA p:(
       h:call1 "+" t:add1 { h.n = Math.max(h.n, t.n); return h; }
     / call1
  ) { return p; }

call1 = bumpC p:(
        h:prim1 "(" t:add1 ")" { t.n++; h.n = Math.max(h.n, t.n); return h; }
      / prim1
  ) { return p; }

prim1 = bumpP p:(
       "(" p:add1 ")" { p.n++; return p; }
	 / "x" { return {n: 0} }
  ) { return p; }

