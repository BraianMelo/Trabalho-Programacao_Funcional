module Main where

import System.IO
import Alunos
import Livros
import Emprestimo
import Dados (Set, imprimirSet)

main :: IO ()
main = menuPrincipal

menuPrincipal :: IO ()
menuPrincipal = do
    putStrLn "\n=== MENU PRINCIPAL ==="
    putStrLn "1. Menu Aluno"
    putStrLn "2. Menu Livro"
    putStrLn "3. Menu Empréstimo"
    putStrLn "4. Sair"
    putStr "Digite uma opção: "
    opcao <- getLine
    
    case opcao of
        "1" -> do
            putStrLn "\nEntrando no Menu Aluno..."
            menuAluno
            menuPrincipal
        "2" -> do
            putStrLn "\nEntrando no Menu Livro..."
            menuLivro
            menuPrincipal
        "3" -> do
            putStrLn "\nEntrando no Menu Empréstimo..."
            menuEmprestimo
            menuPrincipal
        "4" -> putStrLn "Saindo do sistema..."
        _ -> do
            putStrLn "Opção inválida. Tente novamente."
            menuPrincipal

menuAluno :: IO ()
menuAluno = do
    opcao <- showmenu (Nothing :: Maybe Aluno)
    case opcao of
        1 -> do
            putStrLn "\n=== Visualizar Alunos ==="
            alunos <- obter :: IO (Set Aluno)
            imprimirSet alunos
            menuAluno
        2 -> do
            putStrLn "\n=== Cadastrar Aluno ==="
            _ <- cadastrar :: IO Aluno
            putStrLn "Aluno cadastrado com sucesso!"
            menuAluno
        3 -> do
            putStrLn "\n=== Apagar Aluno ==="
            putStr "Informe o código do aluno a ser removido: "
            codStr <- getLine
            let codigoAluno = read codStr
            aluno <- buscar codigoAluno :: IO (Maybe Aluno)
            case aluno of
                Nothing -> putStrLn "Aluno não encontrado!"
                Just a -> do
                    temEmprestimo <- existeEmprestimoComAluno a
                    if temEmprestimo
                        then putStrLn "Não é possível apagar: aluno tem empréstimos associados!"
                        else do
                            resultado <- apagar codigoAluno :: IO (Maybe Aluno)
                            case resultado of
                                Just _ -> putStrLn "Aluno removido com sucesso!"
                                Nothing -> putStrLn "Erro ao remover aluno!"
            menuAluno
        4 -> return ()
        _ -> menuAluno

menuLivro :: IO ()
menuLivro = do
    opcao <- showmenu (Nothing :: Maybe Livro)
    case opcao of
        1 -> do
            putStrLn "\n=== Visualizar Livros ==="
            livros <- obter :: IO (Set Livro)
            imprimirSet livros
            menuLivro
        2 -> do
            putStrLn "\n=== Cadastrar Livro ==="
            _ <- cadastrar :: IO Livro
            putStrLn "Livro cadastrado com sucesso!"
            menuLivro
        3 -> do
            putStrLn "\n=== Apagar Livro ==="
            putStr "Informe o registro do livro a ser removido: "
            regStr <- getLine
            let registroLivro = read regStr
            livro <- buscar registroLivro :: IO (Maybe Livro)
            case livro of
                Nothing -> putStrLn "Livro não encontrado!"
                Just l -> do
                    temEmprestimo <- existeEmprestimoComLivro l
                    if temEmprestimo
                        then putStrLn "Não é possível apagar: livro está em empréstimo!"
                        else do
                            resultado <- apagar registroLivro :: IO (Maybe Livro)
                            case resultado of
                                Just _ -> putStrLn "Livro removido com sucesso!"
                                Nothing -> putStrLn "Erro ao remover livro!"
            menuLivro
        4 -> return ()
        _ -> menuLivro

menuEmprestimo :: IO ()
menuEmprestimo = do
    opcao <- showmenu (Nothing :: Maybe Emprestimo)
    case opcao of
        1 -> do
            putStrLn "\n=== Visualizar Empréstimos ==="
            emprestimos <- obter :: IO (Set Emprestimo)
            imprimirSet emprestimos
            menuEmprestimo
        2 -> do
            putStrLn "\n=== Cadastrar Empréstimo ==="
            _ <- cadastrar :: IO Emprestimo
            putStrLn "Empréstimo cadastrado com sucesso!"
            menuEmprestimo
        3 -> do
            putStrLn "\n=== Apagar Empréstimo ==="
            putStr "Informe o número do empréstimo a ser removido: "
            numStr <- getLine
            resultado <- apagar (read numStr) :: IO (Maybe Emprestimo)
            case resultado of
                Just _ -> putStrLn "Empréstimo removido com sucesso!"
                Nothing -> putStrLn "Empréstimo não encontrado!"
            menuEmprestimo
        4 -> return ()
        _ -> menuEmprestimo