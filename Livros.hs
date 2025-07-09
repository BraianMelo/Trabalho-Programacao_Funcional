module Livros (Livro(..), imprimir, cadastrar, obter, buscar, apagar, showmenu ) where

import System.IO 
import System.Directory 

import Util
import Dados

data Livro = 
    Livro {registro :: Int, titulo :: String, edicao :: Int}
    deriving(Show, Read)

instance Eq Livro where
    (Livro registro1 _ _) == (Livro registro2 _ _ ) = registro1 == registro2

nome_arquivo = "Lista_Livros.txt"

instance Dado Livro where
    imprimir (Livro registro titulo edicao) = do
        putStrLn (formata "Registro" (show registro))
        putStrLn (formata "Titulo" titulo)
        putStrLn (formata "Edição" (show edicao))
        putStrLn ("")

    cadastrar = do
        putStr "Informe o registro: "
        registroStr <- getLine

        putStr "Informe o título: "
        titulo <- getLine

        putStr "Informe a edição: "
        edicaoStr <- getLine

        let livro = (Livro (read registroStr) titulo (read edicaoStr))

        handle <- openFile nome_arquivo AppendMode
        hPutStrLn handle (show livro)
        hClose handle

        return livro

    obter = do
        existe <- doesFileExist nome_arquivo

        if not existe
            then return (Set [])

            else do
                conteudo <- readFile nome_arquivo
                let linhas = lines conteudo
                let livros = foldr (\l s -> inserir (read l) s) (Set []) linhas
                return livros

    buscar registro = do
        lista <- obter :: IO (Set Livro)
        return (buscarSet (Livro registro "" 0) lista)

    apagar registro = do
        lista <- obter :: IO (Set Livro)
        let alvo = Livro registro "" 0
        let encontrado = buscarSet alvo lista
        if encontrado == Nothing
            then return Nothing
            else do
                let Just livroRemovido = encontrado
                let novaLista = remover alvo lista
                salvar novaLista
                return (Just livroRemovido)
      where
        salvar (Set livros) = do
            handle <- openFile nome_arquivo WriteMode
            mapM_ (\a -> hPutStrLn handle (show a)) livros
            hClose handle


    showmenu _ = do
        putStrLn "\n=== Menu Livro ==="
        putStrLn "1. Visualizar"
        putStrLn "2. Cadastrar"
        putStrLn "3. Apagar"
        putStrLn "4. Voltar"
        putStr   "Digite uma opção: "
        resp <- getLine
        case reads resp of
            [(n, "")] | n >= 1 && n <= 4 -> return n
            _ -> do
                putStrLn "Opção inválida. Tente novamente."
                showmenu (Nothing :: Maybe Livro)
