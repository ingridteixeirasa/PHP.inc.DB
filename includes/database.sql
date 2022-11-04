-- Apaga o banco de dados caso ele exista:
-- Isso é útil em "tempo de desenvolvimento".
-- Quando o aplicativo estiver pronto, isso NUNCA deve ser usado.
DROP DATABASE IF EXISTS bancodedados;

-- Recria o banco de dados:
-- CHARACTER SET utf8 especifica que o banco de dados use a tabela UTF-8.
-- COLLATE utf8_general_ci especifica que as buscas serão "case-insensitive".
CREATE DATABASE bancodedados CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Seleciona banco de dados:
-- Todas as ações seguintes se referem a este banco de dados, até que outro
-- "USE nomedodb" seja encontrado.
USE bancodedados;

-- Cria a tabela users:
CREATE TABLE users (

    -- O campo uID (PK → Primary Key) é usado para identificar cada registro 
    -- como único. Ele não pode ter valores repetidos.
    -- A opção AUTO_INCREMENT força que o próprio MySQL incremente o uID.
    uid INT PRIMARY KEY AUTO_INCREMENT,

    -- A data do cadastro está no fomrato TIMESTAMP (AAAA-MM-DD HH:II:SS).
    -- Só funciona com datas à partir de 01/01/1970 (Unix timestamp).
    -- DEFAULT especifica um valor padrão para o campo, durante a inserção.
    -- CURRENT_TIMESTAMP insere a data atual do sistema neste campo.
    udate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 
    -- NOT NULL especifica que este campo precisa de um valor.
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    photo VARCHAR(255),

    -- Formato do tipo DATE → AAAA-MM-DD.
    birth DATE,

    -- O tipo TEXT aceita strings de até 65.536 caracteres. 
    bio TEXT,

    -- O tipo ENUM(lista) só aceita um dos valores de "lista".
    -- DEFAULT especifica um valor padrão para o campo, durante a inserção.
    -- Neste caso, DEFAULT deve ter um avalor presente na lista de ENUM.
    type ENUM('admin', 'author', 'moderator', 'user') DEFAULT 'user',

    -- Formato do tipo DATETIME → AAAA-MM-DD HH:II:SS.
    last_login DATETIME,
    ustatus ENUM('online', 'offline', 'deleted', 'banned') DEFAULT 'online'
);

-- Cadastra alguns usuários para testes:
INSERT INTO users (
    -- Listamos somente os campos onde queremos inserir dados.
    -- Os outros campos já inserem automaticamente, valores padrão (DEFAULT).
    uid,
    name,
    email,
    password,
    photo,
    birth,
    bio,
    type
) VALUES (
    -- Dados a serem inseridos nos campos.
    -- Muito cuidado com a ordem e a quantidade de dados,
    -- elas devem coincidir com os campos acima.
    '1',
    'Joca da Silva',
    'joca@silva.com',

    -- A senha será criptografada pela função SHA1 antes de ser inserida.
    SHA1('senha123'),
 
    -- Não vamos inserir a imagem diretamente no banco de dados.
    -- Buscamos a imagem pela URL dela.
    'https://randomuser.me/api/portraits/men/14.jpg',

    -- Lembre-se de sempre inserir datas e números no formato correto.
    '1990-12-14',
    'Pintor, programador, escultor e enrolador.',

    -- O campo "type" é do tipo ENUM e aceita somente os valores da lista.
    'author'
), 

-- Para inserir um novo registro, basta adicionar vírgula no final do anterior
-- e inserir os dados, sem repetir a query inteira.
-- Dependendo do sistema, pode haver algum limite máximo para o tamanho 
-- da query, portanto, evite repetir este processo muitas vezes.
(
    '2',
    'Marineuza Siriliano',
    'mari@neuza.com',
    SHA1('senha123'),
    'https://randomuser.me/api/portraits/women/72.jpg',
    '2002-03-21',
    'Escritora, montadora, organizadora e professora.',
    'author'
), (
    '3',
    'Hemengarda Sirigarda',
    'hemen@garda.com',
    SHA1('senha123'),
    'https://randomuser.me/api/portraits/women/20.jpg',
    '2004-08-19',
    'Sensitiva, intuitiva, normativa e omissiva.',
    'author'
), (
    '4',
    'Setembrino Trocatapas',
    'set@brino.com',
    SHA1('senha123'),
    'https://randomuser.me/api/portraits/men/20.jpg',
    '1979-02-03',
    'Um dos maiores inimigos do Pernalonga.',
    'author'
);

-- Cria tabela articles:
CREATE TABLE articles (
    aid INT PRIMARY KEY AUTO_INCREMENT,
    adate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    author INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT NOT NULL,
    thumbnail VARCHAR(255) NOT NULL,
    resume VARCHAR(255) NOT NULL,
    astatus ENUM('online', 'offline', 'deleted') DEFAULT 'online',
    views INT DEFAULT 0,

    -- Define author como chave estrangeira.
    -- Isso faz com que a tabela "articles" seja dependente da tabela "users"
    -- para receber valores.
    -- Somente o id de um usuário já cadastrado na tabela "users" pode ser 
    -- usado no campo "author" da tabela "articles".
    FOREIGN KEY (author) REFERENCES users (uid)
);

-- Insere alguns artigos para testes:
INSERT INTO articles (
    adate,
    author,
    title,
    content,
    thumbnail,
    resume
) VALUES (
    '2022-09-14 10:44:45',
    '2',
    'Por que as folhas são verdes',
    '<p> A Honda anunciou nos EUA a chegada do Civic Type R 2023 aos concessionários norte-americanos da marca, com preço de US$ 42.895 (R$ 230 mil) - sem frete.
    O Civic Type R de 315 cavalos de potência é o veículo de produção Honda mais potente já vendido nos EUA.
    O preço preço com frete sobe a US$ 43.990 (R$ 235 mil).
    É importante apontar que esse valor não incorpora os impostos estaduais, de modo que o preço final ao consumidor sobe ao menos 8%.
    A chegada do Civic Type R encerra a linha Civic de 11ª geração da Honda.
    A Honda divulgou os dados de consumo do Civic Type R 2023 e classificações de economia de combustível da EPA, com indicador de 22/28/24 (MPG).
    Convertendo para a unidade brasileira (km/l), corresponde a 9,35 km/l em cidade e 11,9 km/l em estrada. O consumo médio é de 10,2 Km/l.
    O novo Honda Civic Type R tem lançamento confirmado para o Brasil em 2023.</p>',
    '\img\civic.jpg',
    'Última versão do Civic no Brasil.'
),
(
    '2022-09-14 10:44:45',
    '2', 
    '<p>Os machistas de plantão dizem por aí que carro e mulher não combinam a não ser com ela no banco do carona. Relendo a história, encontro a incrível Bertha Ringer, mulher perseverante que participou ativamente no nascimento e na popularização do automóvel.
Bertha Ringer, nascida em 1849 em Pforzheim, na Alemanha, casou-se com o inventor Karl Benz em 1872 e juntos começaram a dividir vários projetos mecânicos, alguns relevantes, outros nem tanto. E foi neste caminho, no ano de 1886, após quatorze anos de casamento, que nasceu uma maquina motorizada de três rodas, o Patent-Motorwagen, considerado o primeiro automóvel fabricado no mundo.  Exceto o casal Benz, ninguém mais acreditava no triciclo e até o repudiava por achá-lo perigoso circulando entre os pedestres. Karl não sabia mais o que fazer para convencer a população que seu invento era revolucionário e não tinha nada de perigoso.
Bertha, com inteligência e perspicácia, teve uma grande ideia para impulsionar o novo invento.  Ela como motorista e seus dois filhos como passageiros, saiu acelerando o triciclo em uma intrépida aventura de 104 quilômetros na região de Baden, com o objetivo de propagandear a funcionalidade da máquina. Imagine o leitor aquele triciclo barulhento com motor monocilíndrico, quatro tempos, de 1 HP a 400 rpm circulando a 20 km/h pelas picadas da região alemã. Durante a viagem de ida que durou dois dias com um pernoite no caminho, ela aproveitou o tempo para anotar todos os problemas observados e que serviram para Karl Benz fazer profundas melhorias no carro. Porém o fato mais relevante foi que a primeira piloto de testes do mundo levou uma multidão de curiosos à sua oficina, dando uma reviravolta positiva à imagem do triciclo.

E foi assim que o Patent-Motorwagen serviu de estímulo para que outros veículos fossem desenvolvidos, não somente por Karl Benz, mas por outros empreendedores dentro e fora da Alemanha.
Hoje o roteiro turístico Bertha Benz Memorial Route é preservado como homenagem a uma verdadeira lenda dos tempos em que dirigir automóveis ainda era uma aventura. O trajeto entre Mannheim e  Pforzheim, passando por Heidelberg, atravessa uma belíssima região vinícola e gastronômica, com diversas atrações que mantém viva a história da primeira mulher piloto no mundo, a inesquecível  Bertha Benz.
E falando francamente, antigamente a maioria das mulheres não tinha voz ativa com respeito ao automóvel. Eram os homens que os escolhiam, compravam e curtiam os seus veículos e a mulher somente os contemplava passivamente. Automóvel era coisa de homem e mesmo a publicidade tinha ares masculinos, raramente aparecendo uma mulher a não ser como coadjuvante. Principalmente nas décadas de 1920 e 1930 eram raras as propagandas de automóveis que incluíam mulheres ao volante.
Após a Segunda Guerra Mundial, os Estados Unidos grandes vencedores junto com os aliados, vivenciaram um enorme salto desenvolvimentista, abrangendo novas tecnologias, novos produtos e também novos carros com desenhos modernos e muito mais femininos em sua essência. Os anos dourados nas décadas de 1950 e 1960 foram um grande salto em termos da valorização da mulher. Ficou comum a presença feminina em propagandas, cartazes, salões do automóvel e mesmo em corridas onde a classe masculina predominava.
E pouco a pouco as mulheres começaram a decidir fortemente na escolha do automóvel em termos de estilo, cor, acessórios e itens de conforto; as fábricas começaram a entender que o toque feminino influenciava positivamente os veículos, alavancando fortemente as suas vendas. Realmente, a maioria dos veículos na época tinha uma sensualidade feminina notável em seus estilos. E foi neste período que a arte começou a dar seus recados com as famosas pin-up girls, por exemplo, desenhos de grandes artistas retratando a mulher e o automóvel como um conjunto inseparável. Bons tempos…</p>',
'\img\carmen-jorda.jpg.jpg',
'Conheça a história das mulheres e os carros'
)

-- Cria a tabela "comments":
CREATE TABLE comments (
    cid INT PRIMARY KEY AUTO_INCREMENT,
    cdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cautor INT NOT NULL,
    article INT NOT NULL,
    comment TEXT NOT NULL,
    cstatus ENUM('online', 'offline', 'deleted') DEFAULT 'online',
    FOREIGN KEY (cautor) REFERENCES users (uid),
    FOREIGN KEY (article) REFERENCES articles (aid)
);

-- Insere comentários para testes:
INSERT INTO comments (
    cautor,
    comment,
    article
) VALUES (
    '1',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo quia provident reiciendis earum, tenetur reprehenderit iure ipsum.',
    '1'
), (
    '2',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo quia provident reiciendis earum, tenetur reprehenderit iure ipsum.',
    '1'
), (
    '1',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo quia provident reiciendis earum, tenetur reprehenderit iure ipsum.',
    '1'
), (
    '3',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo quia provident reiciendis earum, tenetur reprehenderit iure ipsum.',
    '1'
), (
    '4',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo quia provident reiciendis earum, tenetur reprehenderit iure ipsum.',
    '1'
), (
    '1',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo quia provident reiciendis earum, tenetur reprehenderit iure ipsum.',
    '1'
), (
    '3',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Nemo quia provident reiciendis earum, tenetur reprehenderit iure ipsum.',
    '6'
);

-- Cria a tabela "contacts":
CREATE TABLE contacts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('sended', 'readed', 'responded', 'deleted') DEFAULT 'sended'
);

-- CRIANDO E TESTANDO:
-- Selecione todo este conteúdo teclando [Ctrl]+[A];
-- Copie o conteúdo para a área de transferência teclando [Ctrl]+[C];
-- Acesse o PHPMyAdmin → http://localhost/phpmyadmin;
-- Clique na guia [SQL] na porção esquerda;
-- Cole o código no campo, teclando [Ctrl]+[V];
-- Verifique se ocorreram erros de sintaxe.
--     Aparece um "X" dentro de uma bola vermelha.
-- Clique no botão [Continuar] que está logo abaixo;
-- Verifique se não ocorrem erros.
-- Atualize a página para ver se o banco foi corretamente criado, juntamente
-- com as tabelas e os campos destas...