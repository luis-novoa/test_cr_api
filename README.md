# Aplicação de Venda de Remédios
## Sumário
- [Introdução](##introdução)
- [Objetivos Alcançados](##objetivos-alcançados)
- [Futuros Aprimoramentos](##futuros-aprimoramentos)
- [Como Utilizar a API](##como-utilizar-a-api)
  - [Requisitos Mínimos](###requisitos-mínimos)
  - [Instalação](###instalação)
  - [Utilização](###utilização)
  - [Testes](###testes)
- [Autor](##autor)
- [Documentação](#documentação)
  - [Visão Geral da Base de Dados](##visão-geral-da-base-de-dados)
  - [Customers](##customers)
    - [Create](###create)
    - [Index](###index)
    - [Destroy](###destroy)
  - [Medicines](##medicines)
    - [Create](#medicines-create)
    - [Show](#medicines-show)
    - [Index](#medicines-index)
    - [Update](#medicines-update)
    - [Destroy](#medicines-destroy)
  - [Carts](##carts)
    - [Create](#carts-create)
    - [Show](#carts-show)
    - [Index](#carts-index)
    - [Destroy](#carts-destroy)
  - [CartItems](##cartitems)
    - [Create](#cart-items-create)
    - [Destroy](#cart-items-destroy)

## Introdução

API desenvolvida para facilitar as operações de venda de remédios. Com ela, é possível criar consumidores (`Customer`), remédios (`Medicine`), carros de compra (`Cart`) e ordens de compra (`CartItem`). Foi implementado um sistema de descontos que incentiva o consumidor a diversificar sua compra. Quanto mais medicamentos distintos são adicionados ao carrinho, maior é o desconto, conforme visto a seguir:
- 2 medicamentos diferentes: 5% de desconto em cada
- 3 medicamentos diferentes: 10% de desconto em cada
- 4 medicamentos diferentes: 20% de desconto em cada
- 5 medicamentos diferentes: 25% de desconto em cada

## Objetivos Alcançados
- Implementação de um sistema de carrinhos de compras
- Validação de atributos nos modelos `Customer`, `Medicine`, `Cart` e `CartItem`.
- Implementação de sistema de descontos baseado na diversificação do carrinho.
- Método no modelo `Cart` para calcular o custo total dos itens adicionados ao carrinho.
- Nomes dos consumidores e remédios são sempre salvos na base de dados com a primeira letra em maiúscula.

## Futuros Aprimoramentos
- Deletar todos os `CartItems` associados à uma `Medicine` deletada.
- Deletar todos os `CartItems` associados à um `Cart` deletado.
- Deletar todos os `Cart` associados à um `Customer` deletado.
- Criar uma lista de palavras ignoradas para o método de nomes com a primeira letra em maiúsculo.
- Otimizar o método de cálculo de descontos.

## Como Utilizar a API
### Requisitos Mínimos
- Ruby 2.4.0
- Rails 5.2.3
- Bundler 2.1.4
- Git

### Instalação
1 - Abra seu terminal e clone este repositório para sua máquina com o seguinte código:

```
git clone git@github.com:luis-novoa/test_cr_api.git
```
2 - Acesse a pasta do projeto pelo terminal e execute `bundle install`.

### Utilização

1 - Inicie o servidor com `rails s`.

2 - Faça requisições HTTP para `http://0.0.0.0:3000/` para interagir com a API. Confira detalhes sobre o formato das requisições e as respostas esperadas na [Documentação](#documentação).

### Testes
Esta API foi desenvolvida utilizando a metodologia _Test Driven Development_. Até o momento, 115 testes foram criados. Confira-os executando `rspec --format documentation`.

## Autor

👤 **Luis Novoa**

- GitHub: [luis-novoa](https://github.com/luis-novoa)
- Twitter: [@LuisMatteNovoa](https://twitter.com/LuisMatteNovoa)
- Linkedin: [Luis Novoa](https://www.linkedin.com/in/luismattenovoa/)
- [Portfolio](https://luis-novoa.github.io/)

## Demonstre seu apoio

Dê uma ⭐️ se você gostou deste projeto!

# Documentação
Esta API foi desenvolvida visando integração com pacotes _front end_ que operam de forma separada ao _back end_ e se comunicam com ele através de requisições HTTP. Todos os _endpoints_ se encaixam no modelo _REST_.

## Visão Geral da Base de Dados
A base de dados é composta de quatro modelos. `Customer`, `Medicine`, `Cart` e `CartItem`. A seguir, um panorama geral das relações destes quatro modelos e a representação gráfica delas através de tabelas relacionais.
- Um `Customer` pode possuir muitos `Carts`.
- Cada `Cart` pertence apenas a um `Customer`.
- Um `Cart` pode possuir muitos `CartItems`.
- Uma `Medicine` pode possuir muitos `CartItems`.
- Cada `CartItem` pertence a apenas um `Cart` e uma `Medicine`.

![Estrutura da Base de Dados](./readme-imgs/consultaremedios.png)

## Customers
### Create
Cria um novo consumidor.

#### Requisição HTTP

`POST https://0.0.0.0:3000/api/customers`

Resposta HTTP bem sucedida: `201 Created`

#### Parâmetros _Query_

Parâmetro | Descrição
--------- | -----------
name | Nome do consumidor

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/customers
  -X POST
  -H "Content-Type: application/json"
  -d '{
    "customer":{
      "name": "exemplo"
    }
  }'
```
Resposta:
```
[
  {
    "id": 1,
    "name": "Exemplo",
    "created_at": "<data e hora atual>",
    "updated_at": "<data e hora atual>"
  }
]
```

### Index
Fornece uma lista com todos os consumidores.

#### Requisição HTTP

`GET https://0.0.0.0:3000/api/customers/`

Resposta HTTP bem sucedida: `200 OK`

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/customers
  -X GET
```
Resposta:
```
[
  {
    "id": 1,
    "name": "Exemplo",
    "created_at": "<data e hora de criação>",
    "updated_at": "<data e hora de atualização>"
  },
  {
    "id": 2,
    "name": "Antônio",
    "created_at": "<data e hora de criação>",
    "updated_at": "<data e hora de atualização>"
  }
]
```

### Destroy
Apaga um consumidor.

#### Requisição HTTP

`DELETE https://0.0.0.0:3000/api/customers/:id`

Resposta HTTP bem sucedida: `200 OK`

#### Parâmetros URL

Parâmetro | Descrição
--------- | -----------
id | ID do consumidor a ser excluído

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/customers/1
  -X DELETE
```
Resposta:
```
[
  "Exemplo was deleted!"
]
```

## Medicines
<h3 id='medicines-create'>Create</h3>
Cria um novo medicamento.

#### Requisição HTTP

`POST https://0.0.0.0:3000/api/medicines`

Resposta HTTP bem sucedida: `201 Created`

#### Parâmetros _Query_

Parâmetro | Descrição
--------- | -----------
name | Nome do medicamento
value | Preço do medicamento
quantity | Quantidade do medicamento
stock | Quantidade em estoque do medicamento

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/medicines
  -X POST
  -H "Content-Type: application/json"
  -d '{
    "medicine":{
      "name": "medicamento teste",
      "value": "1",
      "quantity": "1",
      "stock": "1"
    }
  }'
```
Resposta:
```
[
  {
    "id": 1,
    "name": "Medicamento Teste",
    "value": 1.0,
    "quantity": 1,
    "stock": 1,
    "created_at": "<data e hora atual>",
    "updated_at": "<data e hora atual>"
  }
]
```

<h3 id='medicines-show'>show</h3>
Fornece as características de um medicamento em específico.

#### Requisição HTTP

`GET https://0.0.0.0:3000/api/medicines/:id`

Resposta HTTP bem sucedida: `200 OK`

#### Parâmetros URL

Parâmetro | Descrição
--------- | -----------
id | ID do medicamento

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/medicines/1
  -X GET
```
Resposta:
```
[
  {
    "id": 1,
    "name": "Medicamento Teste",
    "value": 1.0,
    "quantity": 1,
    "stock": 1,
    "created_at": "<data e hora de criação>",
    "updated_at": "<data e hora de atualização>"
  }
]
```

<h3 id='medicines-index'>Index</h3>
Fornece uma lista com todos os medicamentos.

#### Requisição HTTP

`GET https://0.0.0.0:3000/api/medicines/`

Resposta HTTP bem sucedida: `200 OK`

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/medicines
  -X GET
```
Resposta:
```
[
  {
    "id": 1,
    "name": "Medicamento Teste",
    "value": 1.0,
    "quantity": 1,
    "stock": 1,
    "created_at": "<data e hora de criação>",
    "updated_at": "<data e hora de atualização>"
  },
  {
    "id": 2,
    "name": "Aspirina",
    "value": 1.0,
    "quantity": 1,
    "stock": 1,
    "created_at": "<data e hora de criação>",
    "updated_at": "<data e hora de atualização>"
  }
]
```

<h3 id='medicines-update'>Update</h3>
Atualiza atributos de um medicamento.

#### Requisição HTTP

`POST https://0.0.0.0:3000/api/medicines/:id`

Resposta HTTP bem sucedida: `200 OK`

#### Parâmetros URL

Parâmetro | Descrição
--------- | -----------
id | ID do medicamento a ser modificado

#### Parâmetros _Query_

Parâmetro | Descrição
--------- | -----------
name | Nome do medicamento
value | Preço do medicamento
quantity | Quantidade do medicamento
stock | Quantidade em estoque do medicamento

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/medicines/2
  -X POST
  -H "Content-Type: application/json"
  -d '{
    "medicine":{
      "name": "dipirona"
    }
  }'
```
Resposta:
```
[
  {
    "id": 1,
    "name": "Dipirona",
    "value": 1.0,
    "quantity": 1,
    "stock": 1,
    "created_at": "<data e hora de criação>",
    "updated_at": "<data e hora atual>"
  }
]
```

<h3 id='medicines-destroy'>Destroy</h3>
Apaga um medicamento.

#### Requisição HTTP

`DELETE https://0.0.0.0:3000/api/medicines/:id`

Resposta HTTP bem sucedida: `200 OK`

#### Parâmetros URL

Parâmetro | Descrição
--------- | -----------
id | ID do medicamento a ser excluído

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/medicines/1
  -X DELETE
```
Resposta:
```
[
  "Medicamento Teste was deleted!"
]
```

## Carts
<h3 id='carts-create'>Create</h3>
Cria um carrinho de compras.

#### Requisição HTTP

`POST https://0.0.0.0:3000/api/carts`

Resposta HTTP bem sucedida: `201 Created`

#### Parâmetros _Query_

Parâmetro | Descrição
--------- | -----------
customer_id | ID do consumidor que será o dono do carrinho

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/carts
  -X POST
  -H "Content-Type: application/json"
  -d '{
    "cart":{
      "customer_id": "1"
    }
  }'
```
Resposta:
```
[
  {
    "id": 1,
    "customer_id": 1,
    "created_at": "<data e hora atual>",
    "updated_at": "<data e hora atual>"
  }
]
```

<h3 id='carts-index'>Index</h3>
Mostra as características de um carrinho em específico, seu conteúdo e seu valor total.

#### Requisição HTTP

`GET https://0.0.0.0:3000/api/carts/:id`

Resposta HTTP bem sucedida: `200 OK`

#### Parâmetros URL

Parâmetro | Descrição
--------- | -----------
id | ID do carrinho

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/carts/1
  -X GET
```
Resposta:
```
[
  {
    "id":1,
    "customer_id":1,
    "created_at":"<data e hora de criação>",
    "updated_at":"<data e hora de atualização>",
    "cart_items":[
      {
        "id":1,
        "cart_id":1,
        "medicine_id":1,
        "quantity":1,
        "created_at":"<data e hora de criação>",
        "updated_at":"<data e hora de atualização>"
      },
      {
        "id":2,
        "cart_id":1,
        "medicine_id":2,
        "quantity":1,
        "created_at":"<data e hora de criação>",
        "updated_at":"<data e hora de atualização>"
      }
    ],
    "total":1.9
  }
]
```

<h3 id='carts-index'>Index</h3>
Fornece uma lista com todos os carrinhos.

#### Requisição HTTP

`GET https://0.0.0.0:3000/api/carts/`

Resposta HTTP bem sucedida: `200 OK`

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/carts
  -X GET
```
Resposta:
```
[
  {
    "id": 1,
    "customer_id": 1,
    "created_at": "<data e hora de criação>",
    "updated_at": "<data e hora de atualização>"
  },
  {
    "id": 2,
    "customer_id": 1,
    "created_at": "<data e hora de criação>",
    "updated_at": "<data e hora de atualização>"
  }
]
```

<h3 id='carts-destroy'>Destroy</h3>
Apaga um carrinho.

#### Requisição HTTP

`DELETE https://0.0.0.0:3000/api/carts/:id`

Resposta HTTP bem sucedida: `200 OK`

#### Parâmetros URL

Parâmetro | Descrição
--------- | -----------
id | ID do carrinho a ser excluído

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/carts/1
  -X DELETE
```
Resposta:
```
[
  "Cart 1 was deleted!"
]
```

## CartItems
<h3 id='cart-items-create'>Create</h3>
Cria uma relação entre carrinho e item, efetivamente adicionando o item ao carrinho.

#### Requisição HTTP

`POST https://0.0.0.0:3000/api/cart_items`

Resposta HTTP bem sucedida: `201 Created`

#### Parâmetros _Query_

Parâmetro | Descrição
--------- | -----------
cart_id | ID do carrinho ao qual o item será adicionado
medicine_id | ID do medicamento a ser adicionado ao carrinho
quantity | Quantidade a ser adicionada ao carrinho

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/cart_items
  -X POST
  -H "Content-Type: application/json"
  -d '{
    "cart_item":{
      "cart_id": "1",
      "medicine_id": "1",
      "quantity": "1"
    }
  }'
```
Resposta:
```
[
  "Medicamento Teste added to cart 1."
]
```

<h3 id='cart-items-destroy'>Destroy</h3>
Apaga uma relação entre carrinho e item, efetivamente removendo o item do carrinho.

#### Requisição HTTP

`DELETE https://0.0.0.0:3000/api/cart_items/:id`

Resposta HTTP bem sucedida: `200 OK`

#### Parâmetros URL

Parâmetro | Descrição
--------- | -----------
id | ID da relação CartItem a ser excluída

#### Exemplo
Requisição usando `curl`:

```
curl https://0.0.0.0:3000/api/cart_items/1
  -X DELETE
```
Resposta:
```
[
  "Medicamento Teste removed from cart 1."
]
```

## Erros

Caso a requisição HTTP não seja feita de forma adequada, a API avisará o usuário através de um dos seguintes códigos:


Código de Erro | Significado
-------------- | -----------
404 | Not Found -- Você tentou acessar um recurso que não existe ou não está disponível para você.
422 | Unprocessable entity -- Existem problemas com os parâmetros de sua requisição.

Detalhes sobre o recurso não encontrado ou os problemas com os parâmetros são revelados no corpo da resposta HTTP!
