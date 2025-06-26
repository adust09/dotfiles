---
title: 'Create Universal CI/CD Pipeline'
read_only: true
type: 'command'
---

# Create Universal CI/CD Pipeline

よく使用する言語・環境に特化したCIパイプライン生成コマンド。

## 使用方法

```bash
@create-ci <type>
```

### 引数:
- `<type>`: 必須 - プロジェクトタイプ
  - `go` - Go言語プロジェクト
  - `rust` - Rustプロジェクト  
  - `frontend` - TypeScript + Node.js + React フロントエンドプロジェクト

### 例:
- `@create-ci go`
- `@create-ci rust`
- `@create-ci frontend`

## 実行手順

### 1. 引数解析・検証
- `$ARGUMENTS` からプロジェクトタイプを取得
- サポート対象タイプ（go, rust, frontend）かを確認
- 現在のディレクトリがプロジェクトルートかを確認（.git存在確認）
- 既存のCI設定ファイルの確認

### 2. プロジェクト情報の収集

#### タイプ別設定ファイルの確認:

- **go**: `go.mod`の存在確認
- **rust**: `Cargo.toml`の存在確認
- **frontend**: `package.json`, `tsconfig.json`の存在確認

#### テスト・ビルドコマンドの設定:

- **go**: `go test ./...`, `go build`, `go vet`, `gofmt`
- **rust**: `cargo test`, `cargo build --release`, `cargo clippy`, `cargo fmt --check`
- **frontend**: `npm test`, `npm run build`, `npm run lint`, `npm run type-check`

### 3. CI設定ファイル生成

#### テンプレートファイルの読み込み:

指定されたタイプに応じて、対応するテンプレートディレクトリからファイルを読み込む:

- **go**: `~/dotfiles/config/ci/go/` ディレクトリからテンプレートを読み込み
- **rust**: `~/dotfiles/config/ci/rust/` ディレクトリからテンプレートを読み込み
- **frontend**: `~/dotfiles/config/ci/frontend/` ディレクトリからテンプレートを読み込み

#### 生成されるファイル:

1. `.github/workflows/ci.yml` - `~/dotfiles/config/ci/<type>/ci.yml` から読み込み
2. `.github/dependabot.yml` - `~/dotfiles/config/ci/<type>/dependabot.yml` から読み込み
3. `.pre-commit-config.yaml` - `~/dotfiles/config/ci/<type>/pre-commit-config.yaml` から読み込み（選択時）

### 4. ディレクトリ構造の作成

#### 必要なディレクトリの作成:
```bash
mkdir -p .github/workflows
```

#### ファイルコピー処理:
```bash
# GitHub Actions ワークフロー
cp ~/dotfiles/config/ci/<type>/ci.yml .github/workflows/ci.yml

# Dependabot設定
cp ~/dotfiles/config/ci/<type>/dependabot.yml .github/dependabot.yml

# Pre-commit hooks (選択時)
cp ~/dotfiles/config/ci/<type>/pre-commit-config.yaml .pre-commit-config.yaml
```

### 5. 設定のカスタマイズ

#### 対話式設定:
1. "Pre-commit hooks を設定しますか? [Y/n]"

### 6. 生成完了・検証

#### ファイル生成確認:
- `.github/workflows/ci.yml`
- `.github/dependabot.yml` 
- `.pre-commit-config.yaml` (選択時)

#### Git commit:
```bash
git add .github/ .pre-commit-config.yaml
git commit -m "feat: add CI pipeline for <type>

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

#### 手動デプロイメントの案内:
- ビルド成果物のダウンロード方法を表示
- 各プラットフォームへの手動デプロイ手順を案内
- 必要に応じてデプロイ用スクリプトのサンプルを提供

### 7. ドキュメント更新

#### README.md への追記:
```markdown
## CI Pipeline

This project uses GitHub Actions for automated testing and building.

### Workflows:
- **CI**: Runs on every push and PR (test + build)
- **Dependency Updates**: Weekly automated updates via Dependabot

### Manual Deployment:
Build artifacts are available in GitHub Actions for manual deployment.
```

## エラーハンドリング

### 引数不正:
- サポート対象タイプ（go, rust, frontend）を表示
- 使用方法を再表示

### プロジェクト検出失敗:
- 対象タイプの設定ファイル例を表示
- 手動作成の案内

### 既存CI設定の競合:
- バックアップ作成
- 上書き確認プロンプト

### 権限エラー:
- GitHub Actions権限設定ガイド表示
- 必要な権限リスト提示

## サポート対象

### プロジェクトタイプ:
- **go**: Go言語プロジェクト
- **rust**: Rustプロジェクト  
- **frontend**: TypeScript + Node.js + React

### CIプラットフォーム:
- GitHub Actions
