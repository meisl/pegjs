## How PEG.js handles deep nesting

This originates from PEG.js' [issue #623, "Performance problem...algorithmic complexity"](https://github.com/pegjs/pegjs/issues/623).

### Problem summary
[TODO: **common prefixes**, **memoization** (aka "results cache"), **automatic optimization?**]
Original problematic grammar boiled down:
```
A = C "+" A
  / C

C = P "(" A ")"
  / P

P = "(" A ")"
  / "x"
```
The problem as such could be reproduced with an even smaller grammar.
However, we'll stick with this, since we also want to discuss practical
aspects such as that the grammar should somewhat resemble the original intent.

Pathological case:
* *NO* memoization (ie. "Use results cache" OFF)
* AND deep nesting in inputs: eg depth 10 `((((((((((x))))))))))`
* BEWARE: parsing time will be **exponential in the nesting depth**
* Worth noting: there's a *huge* difference between *valid* and *invalid* input (both deeply nested). Eg.: `((((((((((x))))))))))` vs. `(((((((((())))))))))`. Guess what - the *latter takes way longer*!

### What's in this fork?
* Example from OP was given so it could be simply pasted into https://pegjs.org/online
* I had posted some more pegjs, for actual profiling (= real numbers), also ready to paste there
* Examples are growing, and polluting the issue
* Now I really need diffs etc., so I'm just putting it here, for the time being. Whatever...
* The [`nesting-profile.pegjs`](./nesting-profile.pegjs) in here can still be tried out just by pasting it into https://pegjs.org/online

Grammar variants (choose at start rule in [pegjs example](./nesting-profile.pegjs)):
  - [x] v0: using * operator
  - [x] v1: choices with common prefix ***<<<<< BEWARE!***
  - [ ] v2: refactored v1, without * but using ?
  - [ ] v3: performant variant without *, + or ?

### Warning!
BE CAREFUL with too large a nesting depth: > 10!
You may easily choke your browser and so loose edits you've made!
With "Use results cache" on you're on the safe side.

### v1 to v2: elimininate common prefixes with operator `?`
Rules `add` and `call` in variant 1:
```
// v1:
add = call "+" add
    / call

call = prim "(" add ")"
     / prim
```
...which is undoubtedly equivalent to
```
// v2:
add = call ("+" add)?

call = prim ("(" add ")")?
```
Btw.: compare this to v0 (using `*`)...

If we try that, ie. v2, we're back to linear time again. Even without memoization.
How come?

