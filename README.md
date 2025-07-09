# Trabalho Prático II – Programação Funcional

## 📚 Projeto: Sistema de Biblioteca em Haskell

Este projeto implementa um sistema de gerenciamento de uma biblioteca utilizando a linguagem Haskell, com foco em programação funcional. O sistema permite cadastrar, visualizar, buscar e apagar dados relacionados a **alunos**, **livros** e **empréstimos**, respeitando regras específicas de consistência entre os dados.

---

## 📁 Estrutura do Projeto

O projeto está organizado no diretório `Biblioteca`, que contém os seguintes módulos:

- `Util.hs`  
  - Define o tipo algébrico `Data` (dia, mês, ano).
  - Funções auxiliares, como `dataStr` e `formata`.

- `Dados.hs`  
  - Define a **classe de tipos** `Dado`, com as funções `imprimir`, `cadastrar`, `obter`, `buscar`, `apagar` e `showmenu`.
  - Implementa o TAD `Set`, um conjunto sem valores repetidos.

- `Alunos.hs`  
  - Define o tipo `Aluno`.
  - Implementa a classe `Dado` para `Aluno`.

- `Livros.hs`  
  - Define o tipo `Livro`.
  - Implementa a classe `Dado` para `Livro`.

- `Emprestimo.hs`  
  - Define o tipo `Empréstimo`.
  - Implementa a classe `Dado` para `Empréstimo`.

- `Main.hs`  
  - Contém a função `main`.
  - Oferece menus de interação com o usuário para gerenciar alunos, livros e empréstimos.

---

## 🛠️ Funcionalidades Implementadas

Cada entidade (Aluno, Livro e Empréstimo) possui as seguintes funcionalidades:

- 📄 **Imprimir**: exibe todos os dados formatados.
- ✍️ **Cadastrar**: solicita dados do usuário e grava em arquivo.
- 📂 **Obter**: carrega todos os dados salvos do arquivo correspondente.
- 🔍 **Buscar**: retorna um valor específico dado um código/registro/número.
- ❌ **Apagar**: remove um dado salvo, com restrições para empréstimos existentes.
- 📋 **Menu**: exibe opções e permite navegação.

---

## 📌 Regras e Restrições

- Apenas funções `length`, `sum`, `product` e as apresentadas nos Slides 2, 7, 8, 10, 11 e 13 da disciplina foram utilizadas.
- Nenhuma função adicional pronta foi usada além das permitidas.
- A biblioteca padrão (`Prelude`) foi utilizada conforme especificado.
- Funções auxiliares foram implementadas manualmente conforme necessidade.
- Dados persistem em arquivos distintos para cada entidade.

---

## ▶️ Executando o Programa

1. Certifique-se de ter o GHC (Glasgow Haskell Compiler) instalado.
2. Compile os arquivos com:

   ```bash
   ghc Main.hs
   ```

3. Execute o programa:

   ```bash
   ./Main
   ```

---

## 👨‍💻 Autor

**Braian**  
**Leonardo**
Disciplina de Programação Funcional  
Curso de Ciência da Computação

---
