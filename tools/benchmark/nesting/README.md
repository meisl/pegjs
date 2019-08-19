## How PEG.js handles deep nesting

This originates from PEG.js' [issue #623, "Performance problem...algorithmic complexity"](https://github.com/pegjs/pegjs/issues/623).

### Problem summary
[TODO: **common prefixes**, **memoization** (aka "results cache"), **automatic optimization?**]

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


