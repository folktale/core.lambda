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
exports.identity = identity
function identity(a) {
  return a
}


/**
 * The constant combinator. Always returns the first argument it's given.
 *
 * @example
 *   constant(3)(2)             // => 3
 *   constant('foo')([1])       // => 'foo'
 *
 * @summary a → b → a
 */
exports.constant = curry(2, constant)
function constant(a, b) {
  return a
}


/**
 * Applies a function to an argument.
 *
 * @example
 *   var inc = (a) => a + 1
 *   apply(inc)(3)      // => 4
 *
 * @summary (a → b) → a → b
 */
exports.apply = curry(2, apply)
function apply(f, a) {
  return f(a)
}


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
exports.flip = curry(3, flip)
function flip(f, a, b) {
  return f(b)(a)
}


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
exports.compose = curry(3, compose)
function compose(f, g, a) {
  return f(g(a))
}


/**
 * Transforms any function on tuples into a curried function.
 *
 * @example
 *   var sub3 = (a, b, c) => a - b - c
 *   curry(3, sub3)(5)(2)(1)   // => 2
 *
 * @summary Number → ((a1, a2, ..., aN) → b) → (a1 → a2 → ... → aN → b)
 */
exports.curry = curry(2, curry)
function curry(n, f) {
  return curried([])

  function curried(args) {
    return function() {
      var newArgs  = toArray(arguments)
      var allArgs  = args.concat(newArgs)
      var argCount = allArgs.length

      return argCount < n?    curried(allArgs)
      :      argCount === n?  f.apply(null, allArgs)
      :      /* > n */        f.apply(null, allArgs.slice(0, n))
                               .apply(null, allArgs.slice(n)) }}
}


/**
 * Transforms a curried function into one accepting a list of arguments.
 *
 * @example
 *   var add = (a) => (b) => a + b
 *   spread(add)([3, 2])        // => 5
 *
 * @summary (a1 → a2 → ... → aN → b) → (#[a1, a2, ..., aN) → b)
 */
exports.spread = curry(2, spread)
function spread(f, as) {
  return as.reduce(function(g, a) { return g(a) }, f)
}


/**
 * Transforms a curried function into a function on tuples.
 *
 * @example
 *   var add = (a) => (b) => a + b
 *   uncurry(add)(3, 2)         // => 5
 *
 * @summary (a1 → a2 → ... → aN → b) → ((a1, a2, ..., aN) → b)
 */
exports.uncurry = uncurry
function uncurry(f) {
  return function() { return spread(f, toArray(arguments)) }
}


/**
 * Applies an unary function to both arguments of a binary function.
 *
 * @example
 *   var xss = [[1, 2], [3, 1], [-2, 4]]
 *   sortBy(upon(compare, first))
 *
 * @summary (b → b → c) → (a → b) → (a → a → c)
 */
exports.upon = curry(4, upon)
function upon(f, g, a, b) {
  return f(g(a))(g(b))
}
