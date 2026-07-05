# Todo List API

API em Ruby on Rails para gerenciamento de tarefas (tasks), comentários e usuários.

## Stack

* Ruby 3.1.2 / Rails 7.2
* PostgreSQL
* Devise + DeviseTokenAuth (autenticação via token)
* Pundit (autorização)
* ActiveModelSerializers (serialização JSON)
* EnumerateIt (enum de status da task)
* RSpec + FactoryBot (testes)
* Rswag (documentação Swagger)
* Rubocop (lint)

## Domínio

* **User** — devise + devise_token_auth, tem muitas tasks, flag `is_admin`
* **Task** — pertence a um user, tem muitos comentários e anexos (ActiveStorage). Status: `to_do`, `in_progress`, `testing`, `completed`
* **Comment** — pertence a task e user, suporta respostas aninhadas (`parent`/`replies`)

Autorização via Pundit: usuário só edita/deleta o que é seu (ou é admin). Rotas de `User` (index/show/create/update/destroy) exigem admin.

## Requisitos

* Ruby 3.1.2
* PostgreSQL
* Bundler

## Instalação

```bash
bundle install
```

## Banco de dados

Configuração em `config/database.yml` (usuário/senha padrão: `joinin`/`joinin`, host `localhost:5432`).

```bash
bin/rails db:create db:schema:load
```

## Rodando a aplicação

```bash
bin/rails server
```

## Autenticação

Endpoints do devise_token_auth montados em `/auth` (sign_up, sign_in, sign_out, etc.). Requisições autenticadas precisam dos headers `access-token`, `client` e `uid` retornados no login.

## Rotas principais

* `/auth/*` — autenticação (devise_token_auth)
* `/users` — CRUD de usuários (admin only)
* `/tasks` — CRUD de tasks
* `/tasks/:task_id/attachments/:id` (DELETE) — remove anexo da task
* `/comments` — CRUD de comentários
* `/api-docs` — Swagger UI

## Testes

```bash
RAILS_ENV=test bin/rails db:create db:schema:load
bundle exec rspec
```

## Lint

```bash
bundle exec rubocop
```
