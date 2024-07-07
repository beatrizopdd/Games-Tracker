# Games Tracker

Permitir ao usuário:
- [ ] Criar 
- [ ] Listar por data de lançamento, gênero e nota da review;
- [ ] Editar
- [ ] Remover
- [ ] Incluir uma review;

### Primeira Tela

- [ ] Logar
- [ ] Cadastrar
- [ ] Acessar sem cadastro

### Dashboard
- [ ] Filtros (data de lançamento, gênero e nota da review)
- [ ] Botão de buscar
- [ ] Lista de jogos adicionados com nome, imagem(opcional) e a média das notas das reviews (CADASTRADOS)
- [ ] Lista de jogos com review recente com nome, imagem(opcional) e a média das notas das reviews
- [ ] Botão de adicionar jogo (CADASTRADOS)
- [ ] Botão para deslogar (CADASTRADOS)
- [ ] Tela de reviews dos últimos 7 dias (CADASTRADOS)

### Página do jogo
- [ ] Detalhes do jogo
- [ ] Botão de adicionar review (CADASTRADOS)
- [ ] Botão de deletar jogo (CADASTRADOS)
- [ ] Botão de ver reviews

### Página de reviews
- [ ] Nota
- [ ] Descrição

Deve utilizar a api sqflite ou sqflite_common_ffi para implementar as tabelas no SQLlite.

#### Tabela Usuario
```
CREATE TABLE user(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL
);
```

#### Tabela Gênero
```
CREATE TABLE genre(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR NOT NULL
);
```

#### Tabela Jogo
```
CREATE TABLE game(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name VARCHAR NOT NULL UNIQUE,
    description TEXT NOT NULL,
    release_date VARCHAR NOT NULL,
    FOREIGN KEY(user_id) REFERENCES user(id),
);
```

#### Tabela Gênero do Jogo
```
CREATE TABLE game_genre(
    game_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    FOREIGN KEY(game_id) REFERENCES game(id),
    FOREIGN KEY(genre_id) REFERENCES genre(id),
);
```

#### Tabela Review
```
CREATE TABLE review(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    game_id INTEGER NOT NULL,
    score REAL NOT NULL,
    description TEXT NOT NULL,
    date VARCHAR NOT NULL,
    FOREIGN KEY(user_id) REFERENCES user(id),
    FOREIGN KEY(game_id) REFERENCES game(id)
);
```
