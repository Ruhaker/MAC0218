# (Nome do projeto a definir)

## Administre melhor seu curso na USP!

### Instalação e Execução

0 - Baixe o projeto do repositório;

1 - Instale as dependências:

```
bundle install
yarn install
```

2 - Gere o banco de dados:

```
rails db:migrate
```

3 - Inicialize o aplicativo em um servidor local:

```
foreman start
```

Para acessar a aplicação, abra um navegador e entre com seguinte endereço:

```
localhost:3000
```

### Execução de testes

Para rodar os testes, execute:

```
rails test
```

### Autores do projeto

* Lucas Yau (@Ruhaker) 
* Victor Seiji (@seijihariki)
* André Akabane (@andre19980)
* Gabriely Rangel (@gprangel)

### Planejamento (Entregas)

#### Primeira entrega:

Nesta primeira entrega, planejamos implementar:

* Autenticação de usuário;
* Implementar o banco de dados;

#### Segunda entrega:

Para a segunda entrega:

* Controladores para criação de usuários, curso, grupos e disciplinas;
* Criação de mais testes para os modelos e controladores;
* Visualização simples, para fins de depuração;

#### Terceira entrega:

Para a terceira e última entrega:

* Implementação do frontend, utilizando Vue.js;
* Melhoria no visual do site;
* Ligação do frontend com o backend;
* Finalização dos testes;
