# Nome do executável final
EXEC = biblioteca

# Lista de arquivos Haskell do projeto
SOURCES = Main.hs Alunos.hs Livros.hs Emprestimo.hs Dados.hs Util.hs

# Regra padrão
all: $(EXEC)

# Compila o projeto
$(EXEC): $(SOURCES)
	ghc -o $(EXEC) $(SOURCES)

# Limpa arquivos gerados (.o, .hi e o executável)
clean:
	rm -f *.o *.hi $(EXEC)
	rm *.txt

# Recompila tudo do zero
rebuild: clean all
