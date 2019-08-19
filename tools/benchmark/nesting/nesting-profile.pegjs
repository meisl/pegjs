//
// hmm ... look at what happens as we parse x, (x), ((x)), etc., in pegjs.org/online
//     on a fast machine, add 2 or 4 pairs of parens at once, but more than 12 pairs may be a problem...
//
//     on my laptop, ((((((((x)))))))) takes ~2s to parse, 4s to err when x is deleted,
//     time could be doubling with each added set of parens (it's rather tedious to check).
//
// Note that idiomatic usage, with the "*" (as per "replace" comments),
//     solves the problem ... 48 pairs of parenthesis is fine on my laptop
// However, that Ford's paper says there is a linear-time algorithm for any PEG,
//     so the original grammar is not inherently slow.
//

start
  = _ addPrec _

// replace with addPrec = callPrec (_ "+" _ callPrec)*
addPrec
  = callPrec _ "+" _ callPrec
  / callPrec

// replace with callPrec = primary  (_ "(" _ addPrec _ ")")*
callPrec
  = primary _ "(" _ addPrec _ ")"
  / primary

primary
  = "(" _ addPrec _ ")"
  / id

id = ([_a-zA-Z][_A-Za-z0-9]*)

_  = [ \t\r\n]*