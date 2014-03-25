// Copyright (c) 2013-2014 Quildreen Motta <quildreen@gmail.com>
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/**
 * Provides pure functional combinators.
 *
 * @module Core/Lambda
 */

// -- Aliases ----------------------------------------------------------
var toArray = Function.call.bind([].slice)


// -- Implementation ---------------------------------------------------

/**
 * The identity combinator. Always returns the argument it's given.
 *
 * @example
 *   identity(3)        // => 3
 *   identity([1])      // => [1]
 *
 * @summary a → a
 */
exports.identity = λ a -> a


/**
 * The constant combinator. Always returns the first argument it's given.
 *
 * @example
 *   constant(3)(2)             // => 3
 *   constant('foo')([1])       // => 'foo'
 *
 * @summary a → b → a
 */
exports.constant = λ a b -> a


/**
 * Applies a function to an argument.
 *
 * @example
 *   var inc = (a) => a + 1
 *   apply(inc)(3)      // => 4
 *
 * @summary (a → b) → a → b
 */
exports.apply = λ f a -> f(a)


/**
 * Inverts the order of the parameters of a binary function.
 *
 * @example
 *   var subtract = (a) => (b) => a - b
 *   subtract(3)(2)             // => 1
 *   flip(subtract)(3)(2)       // => -1
 *
 * @summary (a → b → c) → (b → a → c)
 */
exports.flip = λ f a b -> f(b)(a)


/**
 * Composes two functions together.
 *
 * @example
 *   var inc    = (a) => a + 1
 *   var square = (a) => a * a
 *   compose(inc)(square)(2)    // => 5,        inc(square(2))
 *
 * @summary (b → c) → (a → b) → (a → c)
 */
exports.compose = λ f g a -> f(g(a))


/**
 * Transforms a binary function on tuples into a curried function.
 *
 * @example
 *   var add = (a, b) => a + b
 *   curry(add)(3)(4)           // => 7
 *
 * @summary ((a, b) → c) → (a → b → c)
 */
exports.curry = λ f a b -> f(a, b)


/**
 * Transforms any function on tuples into a curried function.
 *
 * @example
 *   var sub3 = (a, b, c) => a - b - c
 *   curryN(3)(sub3)(5)(2)(1)   // => 2
 *
 * @summary Number → ((a1, a2, ..., aN) → b) → (a1 → a2 → ... → aN → b)
 */
exports.curryN = λ n f -> n < 2?           f
                        : n === 2?         curry(f)
                        : /* otherwise */  function curried(as) {
                                             return function(a) {
                                               if (arguments.length > 1)
                                                 throw new Error('Too many arguments.')

                                               var bs = as.concat([a])
                                               return bs.length < n?   curried(bs)
                                               :      /* otherwise */  f.apply(this, bs)
                                             }}([])


/**
 * Transforms a curried function into one accepting a list of arguments.
 *
 * @example
 *   var add = (a) => (b) => a + b
 *   spread(add)([3, 2])        // => 5
 *
 * @summary (a1 → a2 → ... → aN → b) → (#[a1, a2, ..., aN) → b)
 */
var spread = exports.spread = λ(f) -> λ(as) -> as.reduce(λ(g, a) -> g(a), f)


/**
 * Transforms a curried function into a function on tuples.
 *
 * @example
 *   var add = (a) => (b) => a + b
 *   uncurry(add)(3, 2)         // => 5
 *
 * @summary (a1 → a2 → ... → aN → b) → ((a1, a2, ..., aN) → b)
 */
exports.uncurry = λ(f) -> λ() -> spread(f)(toArray(arguments))


/**
 * Applies an unary function to both arguments of a binary function.
 *
 * @example
 *   var xss = [[1, 2], [3, 1], [-2, 4]]
 *   sortBy(upon(compare, first))
 *
 * @summary (b → b → c) → (a → b) → (a → a → c)
 */
exports.upon = λ f g a b -> f(g(a))(g(b))