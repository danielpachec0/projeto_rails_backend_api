### PROJETO ESTÁGIO - BACK-END-API

Para resolver os problemas apresentados, de organizar e estruturar os dados coletados e Saída e JSON dos resultados, foi desenvolvido uma api que recebe requisições HTTP para autenticar usuários, receber e devolver dados específicos.

O sistema armazena os dados dos modelos requisitados(User, Visit, Formulary, Question e Answer) num banco de dados fazendo as validações necessárias para que apenas sejam salvos itens que respeitem as validações requisitadas.

Para realizar a comunicação do sistema cada modelo tem um controlador que está programado para receber requisições HTTP para realizar o CRUD dos elementos de cada modelo.

Além dos controladores de cada modelo também existe um controlador para fazer a autenticação de usuários (Utilizando JWT como apresentado em: www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api) recebendo suas credenciais e retornando um token se as credenciais forem válidas. dessa forma também foi implementado que para acessar as rotas da aplicação é necessário que as requisições tenham um header de autenticação que informe um token válido, se não a rota retorna o status 401 Unauthorized(menos para as rotas de criar um novo usuário e de autenticar um usuário).
Também em razão de implementação da autenticação foi adicionada por uma migração o campo password_digest na tabela de usuário e adicionado ao seu modelo o method ‘has_secure_password’, proporcionado pela gem bcrypt, para garantir a segurança dos dados da aplicação, já que dessa forma a senha de cada usuário não é armazenada no banco de dados, mas sim o resultado do hash aplicado pela criptografia. 

Importante também salientar a solução utilizada para armazenar as imagens atreladas ao objetos do modelo Question que possuem imagem. já que está sendo usado uma versão do rails superior a 5.2 eu optei por usar o Active Storge que é a solução nativa e simples para armazenar arquivos do rails ao invés da gem paperclip que está sinalizada como deprecated. dessa forma foi apenas necessário habilitar o  armazenamento local com o comando de rail e adicionar ‘has_one_attached :image’ e programar o controller do modelo para estar preparado no caso de um POST para receber uma imagem se o atributo question_type for ‘image’ e quando e para fazer a query pela imagem da pergunta no caso de GET requests.

Outro ponto que também estava na especificação do projeto é o uso da GEM paranoia para o uso de soft delete. esse foi requisito foi facilmente resolvido adicionando a gem e colocando nos modelos a linha de codigo ‘acts_as_paranoid’, de forma que quando um controller recebe uma requisição HTTP com o verbo delete o item a ser deletado não vai ser excluído do banco de dados e sim o campo ‘deleted_at’(adicionado para o funcionamento do paranoid) deixa de ter nil e passa a ser o timestamp de quando foi requisitado a deleção. dessa forma o banco de dados tem o histórico completo e os itens deletados ainda podem ser acessado se necessario.

Para garantir a corretude do funcionamento da aplicação enquanto ela foi desenvolvida foi utilizado Rspec para descrever os comportamentos desejados e testá-los seguindo no que possivel as boas práticas apresentadas em www.betterspecs.org.(O link na especificação do projeto é para uma pagina /br mas ele resultou em 404)



**Specs de modelos:**
>Os testes referentes aos modelos da aplicação seguiram todos um mesmo padrão, onde primeiro é testado se a criação de um objeto do modelo com os atributos válidos com o factory_bot gera a criação de um objeto válido.
>Em seguida são testadas as validações necessárias para a criação de um objeto do modelo, e esses testes foram feitos utilizando o factory bot passando o atributo referente a validação testada como invalido, de forma que o teste espera que a criação do objeto seja inválida.(por exemplo tentar criar um usuário com um cpf que não seja válido ou utilizar um email já cadastrado)

**Specs de requisição:**
>No caso das requisições eu fiz os testes baseados nas diferentes requisições HTTP de cada controlado, que no caso dos controladores de modelos todos tem os métodos index, show, create, update e destroy, e o controlador de autenticação que apenas possui o método post. dessa forma foram feitos testes para todos os possíveis comportamentos de cada requisição, checando o status da resposta,  corpo devolvido e se houve alguma alteração no banco de dados dependendo de cada comportamento esperado.
>No caso das rotas que foram protegidas pelo uso do token de autenticação também foram feitos testes para validar que o uso de um token não correto gera como resposta o código 401.

**Specs de rotas:**
>No caso das rotas os testes realizados foram os próprios testes gerados pelo rails ao fazer os scaffolds para criar recursos, e como não houve criação de rotas adicionais, fora a de autenticação que eu criei o spec manualmente, não houve necessidade de alterar os specs gerados automaticamente.
                                                                                             


**Ferramentas e programas utilizadas no desenvolvimento:**
- SO - Linux Mint 20.3 kernel 5.4.0
- Vscode como editor de texto
- insomnia e curl como métodos de testar as requisições HTTP
- DBeaver para conferir o funcionamento do banco de dados

**Versões:**
- Ruby 3.1.1
- rails 7.0.2
- Database - SQLite
- rspec-rails 5.1
- factory_bot_rails 6.2
- bcrypt 3.1.7
- jwt 1.5.4
- active_storage_validations 0.9.6
- simple_command 0.1.0
- paranoia 2.1