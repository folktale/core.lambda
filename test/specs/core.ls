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
λ                        = require '../../lib/'

module.exports = spec 'Core combinators' (o, spec) ->

  o 'Identity: id a <=> a' do
     for-all(Int).satisfy (a) ->
       (λ.identity a) is a
     .as-test!

  o 'Constant: k a b <=> a' do
     for-all(Int, Int).satisfy (a, b) ->
       λ.constant(a)(b) is a
     .as-test!

  o 'Apply: apply f a <=> f a' do
     for-all(Int).satisfy (a) ->
       λ.apply((+ 1))(a) is (a + 1)
     .as-test!

  o 'Flip: flip f a b <=> f b a' do
     for-all(Int, Int).satisfy (a, b) ->
       (λ.flip (-))(a)(b) is b - a
     .as-test!

  spec 'Compose' (o) ->
    f = (+ 1)
    g = (- 2)
    h = (* 3)
    id = (a) -> a

    o 'Given `f: a → b` and `g: b → c`, then `(g . f): a → c`' do
       for-all (Int) .satisfy (a) ->
         λ.compose(g)(f)(a) == g(f(a))
       .as-test!

    o 'associativity: `f . (g . h)` = `(f . g) . h`' do
       for-all (Int) .satisfy (a) ->
         λ.compose(f)(λ.compose(g)(h))(a) == λ.compose(λ.compose(f)(g))(h)(a)
       .as-test!

    o 'left identity: `id . f` = f`' do
       for-all (Int) .satisfy (a) ->
         λ.compose(id)(f)(a) == f(a)
       .as-test!

    o 'right identity: `f . id` = f`' do
       for-all (Int) .satisfy (a) ->
         λ.compose(f)(id)(a) == f(a)
       .as-test!
    

  o 'Curry: curry n f a1, a2, ..., aN <=> f a1 a2 ... aN -> ...' ->
     f = (a, b, c, d, e, x, y) -> a + b + c + d + e + x + y
     for-all(Int, Int, Int, Int, Int, Int, Int).satisfy (a, b, c, d, e, x, y) ->
       λ.curry(7)(f)(a)(b, c)(d, e, x)(y) is f(a, b, c, d, e, x, y)
     .as-test!!

  o 'Uncurry: (uncurry f) (a, b) <=> f a b' ->
     f = λ.curry 2, (a, b) -> a + b
     for-all(Int, Int).satisfy (a, b) ->
       λ.uncurry(f)(a, b) is f(a)(b)
     .as-test!!

  o 'Spread: (spread f) [a, b] <=> f a b' ->
     f = λ.curry 2, (a, b) -> a + b
     for-all(Int, Int).satisfy (a, b) ->
       λ.spread(f)([a, b]) is f(a)(b)
     .as-test!!


  spec 'Upon' (o) ->

    o '(*) `upon` id  <=>  (*)' ->
       id = (a) -> a
       for-all(Int, Int).satisfy (a, b) ->
         ((*) `λ.upon` id)(a)(b) is a * b
       .as-test!!
    
    o '((*) `upon` f) `upon` g  <=>  (*) `upon` (f . g)' ->
       f = (* 2)
       g = (- 1)
       for-all(Int, Int).satisfy (a, b) ->
         (((*) `λ.upon` f) `λ.upon` g)(a)(b) is ((*) `λ.upon` (f . g))(a)(b)
       .as-test!!

    o 'flip upon f . flip upon g  <=>  flip upon (g . f)' ->
       f = (* 2)
       g = (- 1)
       for-all(Int, Int).satisfy (a, b) ->
         h = λ.flip(λ.upon)(f) . λ.flip(λ.upon)(g)
         i = λ.flip(λ.upon)(g . f)
         h((+))(a)(b)  is  i((+))(a)(b)
       .as-test!!
