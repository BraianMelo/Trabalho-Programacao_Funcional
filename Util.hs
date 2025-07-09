module Util where

data Data = 
    Data {dia :: Int, mes :: Int, ano :: Int}
    deriving (Eq, Show, Read)

dataStr :: Data -> String
dataStr (Data dia mes ano) = formatar dia ++ "/" ++ formatar mes ++"/"++ show ano where
    formatar n = if n > 9 then show n else "0" ++ show n

cadastrarData :: IO Data
cadastrarData = do
  putStr $ "Informe o dia: "
  diaStr <- getLine

  putStr $ "Informe o mês: "
  mesStr <- getLine

  putStr $ "Informe o ano: "
  anoStr <- getLine
  return (Data (read diaStr) (read mesStr) (read anoStr))

formata :: String -> String -> String
formata chave valor = formata_esquerda chave ++ formata_direita valor
  where
    formata_esquerda str = chave ++ repete '.' (29 - length chave) ++ ":"
    
    formata_direita str = repete ' ' (49 - length valor) ++ valor

    repete _ 0 = ""
    repete caractere n = caractere : repete caractere (n - 1)

