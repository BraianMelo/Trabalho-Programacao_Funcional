module Emprestimo (Emprestimo(..), imprimir, cadastrar, obter, buscar, apagar, showmenu, existeEmprestimoComAluno, existeEmprestimoComLivro) where


import System.IO 
import System.Directory 

import Alunos
import Livros
import Util
import Dados

data Emprestimo =
    Emprestimo { numero :: Int, aluno :: Aluno, dataEmprestimo :: Data, dataDevolucao :: Data, livros :: Set Livro}
    deriving (Show, Read)

instance Eq Emprestimo where
    (Emprestimo numero1 _ _ _ _) == (Emprestimo numero2 _ _ _ _) = numero1 == numero2 

instance Dado Emprestimo where
    imprimir (Emprestimo numero aluno dataEmprestimo dataDevolucao livros) = do
        putStrLn (formata "Número" (show numero))
        imprimir aluno
        putStrLn (formata "Data de empréstimo" (dataStr dataEmprestimo))
        putStrLn (formata "Data de devolução" (dataStr dataDevolucao))
        imprimirSet livros
        putStrLn ("")

    cadastrar = do
        putStr "Informe o número do empréstimo: "
        hFlush stdout
        numeroStr <- getLine

        putStrLn "\n-- Informe o código do aluno --"
        putStr "Código do aluno: "
        hFlush stdout
        codigoAlunoStr <- getLine
        let codigoAluno = read codigoAlunoStr
        maybeAluno <- Alunos.buscar codigoAluno
        
        case maybeAluno of
            Nothing -> do
                putStrLn "Aluno não encontrado!"
                cadastrar
            Just aluno -> do
                putStrLn "\n-- Informe o registro do livro --"
                putStr "Registro do livro: "
                hFlush stdout
                registroLivroStr <- getLine
                let registroLivro = read registroLivroStr
                maybeLivro <- Livros.buscar registroLivro
                
                case maybeLivro of
                    Nothing -> do
                        putStrLn "Livro não encontrado!"
                        cadastrar 
                    Just livro -> do
                        putStrLn "\n-- Informe a data de empréstimo --"
                        dataEmprestimo <- cadastrarData
                        
                        putStrLn "\n-- Informe a data de devolução --"
                        dataDevolucao <- cadastrarData
                        
                        let livros = inserir livro (Set [])
                        let emprestimo = Emprestimo (read numeroStr) aluno dataEmprestimo dataDevolucao livros
                        
                        livroEmprestado <- existeEmprestimoComLivro livro
                        if livroEmprestado
                            then do
                                putStrLn "Este livro já está emprestado!"
                                cadastrar
                            else do
                                handle <- openFile "Emprestimo.txt" AppendMode
                                hPutStrLn handle (show emprestimo)
                                hClose handle
                                putStrLn "Empréstimo cadastrado com sucesso!"
                                return emprestimo

    obter = do
        existe <- doesFileExist "Emprestimo.txt"
        if not existe
            then return (Set [])
            else do
                conteudo <- readFile "Emprestimo.txt"
                let linhas = lines conteudo
                let emprestimos = foldr (\linha acc -> inserir (read linha :: Emprestimo) acc) (Set []) linhas
                return emprestimos

    buscar numero = do
        lista <- obter :: IO (Set Emprestimo)
        let chave = Emprestimo numero fakeAluno fakeData fakeData (Set [])
        return (buscarSet chave lista)
            where
                fakeAluno = Aluno 0 "" ""
                fakeData = Data 0 0 0
            
    apagar numero = do
        lista <- obter
        let alvo = Emprestimo numero fakeAluno fakeData fakeData (Set [])
            fakeAluno = Aluno 0 "" ""
            fakeData = Data 0 0 0

        let encontrado = buscarSet alvo lista
        case encontrado of
            Nothing -> return Nothing
            Just emprestimoRemovido -> do
                let novaLista = remover alvo lista
                salvar novaLista
                return (Just emprestimoRemovido)
        where
            salvar (Set emprestimos) = do
                handle <- openFile "Emprestimo.txt" WriteMode
                mapM_ (hPutStrLn handle . show) emprestimos
                hClose handle


    showmenu _ = do
        putStrLn "\n=== Menu Empréstimo ==="
        putStrLn "1. Visualizar"
        putStrLn "2. Cadastrar"
        putStrLn "3. Apagar"
        putStrLn "4. Voltar"
        putStr   "Digite uma opção: "
        hFlush stdout
        resp <- getLine
        case reads resp of
            [(n, "")] | n >= 1 && n <= 4 -> return n
            _ -> do
                putStrLn "Opção inválida. Tente novamente."
                showmenu (Nothing :: Maybe Emprestimo)


existeEmprestimoComAluno :: Aluno -> IO Bool
existeEmprestimoComAluno aluno = do
    Set emprestimos <- obter 
    return (verifica aluno emprestimos)
    where
        verifica _ [] = False
        verifica aluno (i:f)
            | aluno == alunoDe i = True
            | otherwise = verifica aluno f

        alunoDe (Emprestimo _ al _ _ _) = al

existeEmprestimoComLivro :: Livro -> IO Bool
existeEmprestimoComLivro livro = do
    Set emprestimos <- obter
    return (verifica livro emprestimos)
  where
    verifica _ [] = False
    verifica livro (i:f)
        | contem livro (livros i) = True
        | otherwise = verifica livro f

    livros (Emprestimo _ _ _ _ ls) = ls




