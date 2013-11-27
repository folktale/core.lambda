# # Specification for the core functions

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

spec                     = (require 'hifive')!
{for-all, data: { Int }} = require 'claire'
λ                        = require '../../src/'

module.exports = spec 'Core combinators' (o, spec) ->

  o 'Identity: id a <=> a' do
     for-all(Int).satisfy (a) ->
       (λ.identity a) is a
     .as-test!

  o 'Constant: k a b <=> a' do
     for-all(Int, Int).satisfy (a, b) ->
       (λ.constant a, b) is a
     .as-test!

  o 'Flip: flip f a b <=> f b a' do
     for-all(Int, Int).satisfy (a, b) ->
       (λ.flip (-))(a, b) is b - a
     .as-test!

  spec 'Compose' (o) ->
    f = (+ 1)
    g = (- 2)
    h = (* 3)
    id = (a) -> a

    o 'Given `f: a → b` and `g: b → c`, then `(g . f): a → c`' do
       for-all (Int) .satisfy (a) ->
         λ.compose(g, f)(a) == g(f(a))
       .as-test!

    o 'associativity: `f . (g . h)` = `(f . g) . h`' do
       for-all (Int) .satisfy (a) ->
         λ.compose(f, λ.compose(g, h))(a) == λ.compose(λ.compose(f, g), h)(a)
       .as-test!

    o 'left identity: `id . f` = f`' do
       for-all (Int) .satisfy (a) ->
         λ.compose(id, f)(a) == f(a)
       .as-test!

    o 'right identity: `f . id` = f`' do
       for-all (Int) .satisfy (a) ->
         λ.compose(f, id)(a) == f(a)
       .as-test!
    
  o 'Curry: curry f a b <=> f (a, b)' ->
     f = (a, b) -> a + b
     for-all(Int, Int).satisfy (a, b) ->
       λ.curry(f)(a)(b) is f(a, b)
     .as-test!!

  o 'Curry3: curry f a b c <=> f (a, b, c)' ->
     f = (a, b, c) -> a + b + c
     for-all(Int, Int, Int).satisfy (a, b, c) ->
       λ.curry3(f)(a)(b)(c) is f(a, b, c)
     .as-test!!

  o 'CurryN: curry f a... <=> f [a]' ->
     f = (a, b, c, d, e) -> a + b + c + d + e
     for-all(Int, Int, Int, Int, Int).satisfy (a, b, c, d, e) ->
       λ.curryN(5, f)(a)(b, c)(d)(e) is f(a, b, c, d, e)
     .as-test!!

  o 'Partial: (partial f a) b <=> f a b' ->
     f = (a, b) -> a - b
     for-all(Int, Int).satisfy (a, b) ->
       λ.partial(f, a)(b) is f(a, b)
     .as-test!!

  o 'Partial right: (partial-right f a) b <=> f b a' ->
     f = (a, b) -> a - b
     for-all(Int, Int).given((!=)).satisfy (a, b) ->
       λ.partial-right(f, a)(b) is f(b, a)
     .as-test!!

  o 'Uncurry: (uncurry f) [a, b] <=> f a b' ->
     f = (a, b) --> a + b
     for-all(Int, Int).satisfy (a, b) ->
       λ.uncurry(f)([a, b]) is f(a, b)
     .as-test!!

  o 'Uncurry bind: (uncurry-bind f) [@a, b] <=> f.call a b' ->
     f = (a, b) --> a + b + @c
     for-all(Int, Int, Int).satisfy (a, b, c) ->
       λ.uncurry-bind(f)([{c:c}, a, b]) is f.call({c:c}, a, b)
     .as-test!!
       
       
       
           
               
