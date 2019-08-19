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