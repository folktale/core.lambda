# # Core combinators

/** ^
 * Copyright (c) 2013 Quildreen Motta
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


# ## Function: identity
#
# The identity combinator.
#  
# + type: a -> a
export identity = (a) -> a


# ## Function: constant
#
# The constant combinator.
#  
# + type: a -> b -> a
export constant = (a, b) --> a


# ## Function: flip
#
# The flip combinator.
#  
# + type: (a -> b -> c) -> b -> a -> c
export flip = (f, a, b) --> f b, a


# ## Function: compose
#
# Function composition.
#  
# + type: (b -> c) -> (a -> b) -> a -> c
export compose = (f, g, a) --> f (g a)


# ## Function: curry
#
# Transforms a function on tuples to a curried function.
#  
# + type: ((a, b) -> c) -> a -> b -> c
export curry = (f, a, b) --> f a, b

# ## Function: curry3
# + type: ((a, b, c) -> d) -> a -> b -> c -> d
export curry3 = (f, a, b, c) --> f a, b, c

# ## Function: curryN
# + type: Number -> ((a1, a2, ..., aN) -> b) -> a1 -> a2 -> ... -> aN -> b
export curryN = (n, f) -->
  | n < 2  => f
  | n is 2 => curry f
  | n is 3 => curry3 f
  | _      => [] |> curried = (as) -> (...bs) ->
                                         cs = as ++ bs

                                         if cs.length < n => curried cs
                                         else             => f.apply this, cs
                 

# ## Function: partial
#
# Partially applies a function from the left.
#  
# + type: ((a1, a2, ..., aN, b1, b2, ..., bN) -> c) -> a1, a2, ..., aN -> b1, b2, ..., bN -> c
export partial = (f, ...as) -> (...bs) -> f.apply this, (as ++ bs)


# ## Function: partial-right
#
# Partially applies a function from the right.
#  
# + type: ((b1, b2, ..., bN, a1, a2, ..., aN) -> c) -> a1, a2, ..., aN -> b1, b2, ..., bN -> c
export partial-right = (f, ...as) -> (...bs) -> f.apply this, (bs ++ as)


# ## Function: uncurry
#
# Transforms a curried function to a function on tuples.
#  
# + type: (a1 -> a2 -> ... -> aN -> b) -> ((a1, a2, ..., aN) -> b)
export uncurry = (f) -> (args) -> f.apply this, args


# ## Function: uncurry-bind
#
# Transforms a curried function to a function on tuples,
# with an explicit `this` parameter.
#
# + type: (c:Object) => (a1 -> a2 -> ... -> aN -> b) -> ((c, a1, a2, ..., aN) -> b)
export uncurry-bind = (f) -> (args) -> f.call.apply f, args


# ## Function: upon
#
# Applies an unary function to both arguments of a binary function.
#
# Typical usage: `sort-by (compare \`upon\` first)`
#
# + type: (b -> b -> c) -> (a -> b) -> a -> a -> c
export upon = (f, g, a, b) --> f (g a), (g b)
