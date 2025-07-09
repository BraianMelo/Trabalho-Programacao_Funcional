module Alunos (Aluno(..), imprimir, cadastrar, obter, buscar, apagar, showmenu) where


import System.IO 
import System.Directory 

import Dados 
import Util

data Aluno = 
    Aluno {codigo :: Int, nome :: String, email :: String}
    deriving (Show, Read)

instance Eq Aluno where
    (Aluno cod1 _ _) == (Aluno cod2 _ _) = cod1 == cod2

nome_arquivo = "Lista_Aluno.txt"

instance Dado Aluno where
    imprimir (Aluno codigo nome mail) = do
        putStrLn (formata "Código" (show codigo))
        putStrLn (formata "Nome" nome)
        putStrLn (formata "Email" mail)
        putStrLn ("")

    cadastrar = do
        putStr "Informe o código: "
        codStr <- getLine

        putStr "Informe o nome: "
        nome <- getLine

        putStr "Informe o email: "
        email <- getLine

        let aluno = Aluno (read codStr) nome email

        handle <- openFile nome_arquivo AppendMode
        hPutStrLn handle (show aluno)
        hClose handle

        return aluno

    obter = do
        existe <- doesFileExist nome_arquivo
        
        if not existe
            then return (Set [])

            else do
                conteudo <- readFile nome_arquivo
                let linhas = lines conteudo
                let alunos = foldr (\l s -> inserir (read l) s) (Set []) linhas
                return alunos

    buscar codigo = do
        lista <- obter :: IO (Set Aluno)
        return (buscarSet (Aluno codigo "" "") lista)

    apagar codigo = do
        lista <- obter :: IO (Set Aluno)
        let alvo = Aluno codigo "" ""
        let encontrado = buscarSet alvo lista
        if encontrado == Nothing
            then return Nothing
            else do
                let Just alunoRemovido = encontrado
                let novaLista = remover alvo lista
                salvar novaLista
                return (Just alunoRemovido)
      where
        salvar (Set alunos) = do
            handle <- openFile nome_arquivo WriteMode
            mapM_ (\a -> hPutStrLn handle (show a)) alunos
            hClose handle

    showmenu _ = do
        putStrLn "\n=== Menu Aluno ==="
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
                showmenu (Nothing :: Maybe Aluno)

