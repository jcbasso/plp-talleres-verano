import Util
import Data.Maybe
import Data.List

-- Ejercicio 1
singleton:: Eq t => t -> Anillo t
singleton t = A t proximo
            where proximo x | x == t = Just t
                            | otherwise = Nothing 

insertar :: Eq t => t -> Anillo t -> Anillo t
insertar t anillo = A (actual anillo) proximo
                    where proximo x | x == (actual anillo) = Just t
                                    | x == t = siguiente anillo (actual anillo)
                                    | otherwise = siguiente anillo x  

avanzar :: Anillo t -> Anillo t
avanzar anillo = A (fromJust (siguiente anillo (actual anillo))) (siguiente anillo) 

-- Ejercicio 2

enAnillo:: Eq t => t -> Anillo t -> Bool
enAnillo e anillo = not (null (filter (== e) (valoresDelAnillo anillo)))

valoresDelAnillo :: Eq t => Anillo t -> [t]
valoresDelAnillo a = (actual a) : (takeWhile (/= actual a) (drop 1 infList))
                        where infList = iterate (\elem -> fromJust (siguiente a elem)) (actual a)

siguienteEnLista :: Eq t => t -> [t] -> Int
siguienteEnLista e xs = (fromJust (elemIndex e xs) + 1 ) `mod` (length xs)

-- Ejercicio 3
filterAnillo :: Eq t => (t -> Bool) -> Anillo t -> Maybe (Anillo t)
filterAnillo f a =  crearAnillo valoresFiltrados
                    where { valoresFiltrados = filter f (valoresDelAnillo a);}

crearAnillo :: Eq t => [t] -> Maybe (Anillo t)
crearAnillo xs =  if (length xs) == 0 then Nothing
                  else Just (A (head xs) siguiente)
                  where{
                    siguiente = (\elem ->
                                    if (elemIndex elem xs) == Nothing then Nothing
                                    else Just (xs !! (siguienteEnLista elem xs))
                                );
                  }
         
-- Ejercicio 4
mapAnillo:: Eq a => Eq b => (a -> b) -> Anillo a -> Anillo b
mapAnillo f a = (A (f (actual a) ) siguienteInversa)
                where {
                  siguienteInversa =(\elem ->
                                if (inversae elem) == Nothing then Nothing else
                               Just (f (fromJust (siguiente a (fromJust (inversae elem)))))
                              );
                  inversae elem = inversa a f elem
                }

inversa :: Eq a => Eq b => Anillo a -> (a->b) -> b ->  Maybe a
inversa anillo f b = if null luegoDeFiltrar then Nothing
                     else Just (head luegoDeFiltrar)
                     where luegoDeFiltrar = filter (\x -> f x == b) (valoresDelAnillo anillo)

--Ejercicio 5
palabraFormable :: String -> [Anillo Char] -> Bool
palabraFormable ss as = todosCumplen ( zip ss as) [0 .. (length ss)-1] 

todosCumplen:: [(Char, Anillo Char)] -> [Int] -> Bool
todosCumplen as = foldr (\i rec -> (rec && iesimoEsta i)) True
                              where {iesimoEsta i = enAnillo (fst (as !! i)) (snd (as !! i));}

--Ejercicio 6
anillos:: Eq a => [a] -> [Anillo a]
anillos xs = crearAnilloConIndices (partes xs) [0 .. (length (partes xs))]

crearAnilloConIndices :: Eq a => [[a]] -> [Int] -> [Anillo a]
crearAnilloConIndices ps = foldr (\i rec -> fromJust (crearAnillo (ps !! i)) : rec ) []

partes :: Eq a => [a] -> [[a]]
partes = foldr (\a rec -> ( (agregar a rec) ++ rec) ) [[]]

agregar ::Eq a => a -> [[a]] -> [[a]]
agregar e = map (e:)
