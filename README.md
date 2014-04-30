lensPlay
========

playing with Haskell lenses (examples for blog post)

to install:
git clone https://github.com/elisehuard/lensPlay.git

I recommend using [cabal sandbox](http://coldwa.st/e/blog/2013-08-20-Cabal-sandbox.html)
    
    cabal sandbox init
    cabal install --only-dependencies
    cabal build

To run the tests

    cabal test hunit
