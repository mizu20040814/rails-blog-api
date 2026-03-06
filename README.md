# Rails Blog API

Ruby on Rails で構築されたブログ API サーバーです。記事の管理（CRUD）、ユーザー認証、コメント、いいね機能を提供します。

## 技術スタック

- **Ruby** 3.4.5
- **Rails** 8.1.2 (API モード)
- **PostgreSQL** - メインデータベース
- **JWT** - 認証トークン
- **bcrypt** - パスワードハッシュ化
- **Puma** - Web サーバー
- **Kamal** - デプロイ
- **Solid Queue** - バックグラウンドジョブ
- **Solid Cache** - キャッシュ
- **Solid Cable** - Action Cable アダプター

## セットアップ

### Dev Container（推奨）

1. VS Code で Dev Containers 拡張をインストール
2. リポジトリを開き「Reopen in Container」を選択
3. 自動的に環境が構築されます

### ローカル環境

```sh
# 依存関係のインストール & DB セットアップ
bin/setup

# サーバー起動
bin/dev
```

### 環境変数

`.env` ファイルに以下を設定してください：

| 変数名 | 説明 |
|---|---|
| `ADMIN_EMAIL` | 管理者ログイン用メールアドレス |
| `ADMIN_PASSWORD` | 管理者ログイン用パスワード |
| `JWT_SECRET_KEY` | JWT トークンの署名キー |

## データベース

```sh
# DB 作成 & マイグレーション
bin/rails db:prepare

# DB リセット（開発用）
bin/rails db:reset
```

### スキーマ

| テーブル | 概要 |
|---|---|
| `articles` | 記事（title, content, status, published_at） |
| `users` | ユーザー（name, email, password_digest） |
| `comments` | コメント（body, user_id, article_id） |
| `likes` | いいね（user_id, comment_id） |

## API エンドポイント

### 認証（管理者）

| メソッド | パス | 説明 |
|---|---|---|
| POST | `/api/v1/auth/login` | 管理者ログイン（JWT 発行） |

### ユーザー認証

| メソッド | パス | 説明 |
|---|---|---|
| POST | `/api/v1/users/register` | ユーザー登録 |
| POST | `/api/v1/users/login` | ユーザーログイン（JWT 発行） |

### 公開 API（認証不要）

| メソッド | パス | 説明 |
|---|---|---|
| GET | `/api/v1/articles` | 公開済み記事一覧 |
| GET | `/api/v1/articles/:id` | 公開済み記事詳細 |
| GET | `/api/v1/articles/:article_id/comments` | コメント一覧 |

### コメント・いいね（ユーザー認証必要）

| メソッド | パス | 説明 |
|---|---|---|
| POST | `/api/v1/articles/:article_id/comments` | コメント作成 |
| DELETE | `/api/v1/comments/:id` | コメント削除 |
| POST | `/api/v1/comments/:comment_id/like` | いいね |
| DELETE | `/api/v1/comments/:comment_id/like` | いいね解除 |

### 管理者 API（管理者認証必要）

| メソッド | パス | 説明 |
|---|---|---|
| GET | `/api/v1/admin/articles` | 全記事一覧 |
| GET | `/api/v1/admin/articles/:id` | 記事詳細 |
| POST | `/api/v1/admin/articles` | 記事作成 |
| PATCH/PUT | `/api/v1/admin/articles/:id` | 記事更新 |
| DELETE | `/api/v1/admin/articles/:id` | 記事削除 |

## 認証方式

JWT Bearer トークンを `Authorization` ヘッダーに付与します：

```
Authorization: Bearer <token>
```

- **管理者トークン**: `POST /api/v1/auth/login` で取得（環境変数の認証情報を使用）
- **ユーザートークン**: `POST /api/v1/users/login` または `POST /api/v1/users/register` で取得
- トークンの有効期限は **24 時間** です

## テスト

```sh
# テスト実行
bin/rails test

# CI（lint + セキュリティ監査 + テスト）
bin/ci
```

## コード品質

```sh
# RuboCop
bin/rubocop

# セキュリティ: gem 監査
bin/bundler-audit

# セキュリティ: 静的解析
bin/brakeman
```

## デプロイ

[Kamal](https://kamal-deploy.org) を使用した Docker コンテナデプロイに対応しています。

```sh
bin/kamal deploy
```

## プロジェクト構成

```
app/
├── controllers/
│   ├── application_controller.rb        # API ベースコントローラー
│   └── api/v1/
│       ├── auth_controller.rb           # 管理者認証
│       ├── users_controller.rb          # ユーザー登録・ログイン
│       ├── articles_controller.rb       # 公開記事 API
│       ├── comments_controller.rb       # コメント CRUD
│       ├── likes_controller.rb          # いいね機能
│       └── admin/
│           ├── base_controller.rb       # 管理者認証の共通処理
│           └── articles_controller.rb   # 記事管理 CRUD
├── models/
│   ├── article.rb                       # 記事モデル
│   ├── user.rb                          # ユーザーモデル
│   ├── comment.rb                       # コメントモデル
│   └── like.rb                          # いいねモデル（※）
config/
├── routes.rb                            # ルーティング定義
└── ...
```

## ヘルスチェック

```
GET /up
```

Rails 標準のヘルスチェックエンドポイントです。
