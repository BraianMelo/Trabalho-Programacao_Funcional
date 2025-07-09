module Dados where

class Dado d where
    imprimir :: d -> IO ()
    cadastrar :: IO d
    obter :: IO (Set d)
    buscar :: Int -> IO (Maybe d)
    apagar :: Int -> IO (Maybe d)
    showmenu :: Maybe d -> IO Int

data Set t = Set [t] deriving (Eq, Show, Read)

imprimirSet :: Dado t => Set t -> IO ()
imprimirSet (Set []) = putStr " "
imprimirSet (Set (i:f)) = do
    imprimir i
    imprimirSet (Set f)

contem :: Eq t => t -> Set t -> Bool
contem _ (Set []) = False
contem t (Set (i:f)) = if t == i
    then True
    else contem t (Set f)

inserir :: Eq t => t -> Set t -> Set t
inserir t (Set s) = if not (contem t (Set s)) 
    then Set (s ++ [t])
    else Set s

remover :: Eq t => t -> Set t -> Set t
remover _ (Set []) = Set []
remover t (Set (i:f))
    | t == i    = Set f
    | otherwise = Set (i : resto)
    where
        Set resto = remover t (Set f)

buscarSet :: Eq t => t -> Set t -> Maybe t
buscarSet _ (Set []) = Nothing
buscarSet t (Set (i:f))
    | t == i    = Just i
    | otherwise = buscarSet t (Set f)

estah_vazio :: Set t -> Bool
estah_vazio (Set []) = True
estah_vazio _ = False
