# Functor
## Typeclass and concept used in functional programming

Types `f` of kind `Type -> Type` supporting `map :: (a -> b) -> f a -> f b`.

# Description
`Functor` is a typeclass in Haskell and PureScript that is based on category theory.

# Definition
In PureScript’s Prelude [[link]](https://github.com/purescript/purescript-prelude/blob/v4.0.0/src/Data/Functor.purs#L13-L27):

```purescript
-- | A `Functor` is a type constructor which supports a mapping operation
-- | `map`.
-- |
-- | `map` can be used to turn functions `a -> b` into functions
-- | `f a -> f b` whose argument and return types use the type constructor `f`
-- | to represent some computational context.
-- |
-- | Instances must satisfy the following laws:
-- |
-- | - Identity: `map identity = identity`
-- | - Composition: `map (f <<< g) = map f <<< map g`
class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b

infixl 4 map as <$>
```

In Haskell’s Prelude [[link]](http://hackage.haskell.org/package/base-4.11.1.0/docs/src/GHC.Base.html#Functor):

```haskell
{- | The 'Functor' class is used for types that can be mapped over.
Instances of 'Functor' should satisfy the following laws:

> fmap id  ==  id
> fmap (f . g)  ==  fmap f . fmap g

The instances of 'Functor' for lists, 'Data.Maybe.Maybe' and 'System.IO.IO'
satisfy these laws.
-}

class  Functor f  where
  fmap        :: (a -> b) -> f a -> f b

  -- | Replace all locations in the input with the same value.
  -- The default definition is @'fmap' . 'const'@, but this may be
  -- overridden with a more efficient version.
  (<$)        :: a -> f b -> f a
  (<$)        =  fmap . const
```

# Laws
Laws:
- Identity: `map identity = identity` or $F(\mathrm{id}_{X}) = \mathrm{id}_{F(X)}\,\!$
- Composition: `map g <<< map f = map (g <<< f)` or $F(g \circ f) = F(g) \circ F(f)$

But the first law is sufficient; the second law follows from the first using parametricity as a free theorem!

These laws can be interpreted to mean that `map` preserves the essential structure of the functor, changing nothing but the parameters. Parametricity ensures that `map` must touch each and every value of the parameter type in its structure.

# Properties
- **Uniqueness**: Instances of this class, when they exist, are unique.
