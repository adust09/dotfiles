# PR作成手順 (MCP Server経由)

Claude Codeが自動的にPRを作成する際の手順テンプレートです。

## 前提条件

- GitHub MCP serverが設定済みであること
- 適切な権限でGitHubにアクセス可能であること
- 作業用ブランチが作成済みであること

## 手順

### 1. 現在の状態確認

```bash
# 現在のブランチとコミット状況を確認
git status
git log --oneline -5
```

### 2. 変更内容の最終確認

```bash
# 変更内容をdiffで確認
git diff origin/main...HEAD
```

### 3. MCP経由でPR作成

```bash
# 現在のレポジトリ名を取得
REPO_NAME=$(basename `git rev-parse --show-toplevel`)
```

```javascript
// GitHub MCP serverを使用してPR作成
// 実際の実行時は、Claude Codeが自動的に現在のレポジトリ名を取得して設定する
const repoName = await Bash({ command: "basename `git rev-parse --show-toplevel`" });

mcp__github__create_pull_request({
  owner: "adust09",
  repo: repoName.trim(),
  title: "機能追加: [具体的なタイトル]",
  body: `## 概要
[変更内容の概要を記述]

## 変更内容
- [変更点1]
- [変更点2]

## テスト
- [テスト内容を記述]

## チェックリスト
- [ ] テストが通ることを確認
- [ ] リントエラーがないことを確認
- [ ] ドキュメントの更新（必要に応じて）

🤖 Generated with [Claude Code](https://claude.ai/code)`,
  head: "feature-branch-name",
  base: "main"
})
```

### 4. PR作成後の確認

- PR URLを確認
- CI/CDの実行状況をチェック
- レビュー依頼が必要な場合は適切な人にアサイン

## ブランチ命名規則

- `feature/` - 新機能追加
- `fix/` - バグ修正
- `refactor/` - リファクタリング
- `docs/` - ドキュメント更新
- `test/` - テスト追加・修正

## PRタイトル例

- `機能追加: ユーザー認証機能の実装`
- `修正: ログイン処理のバグを修正`
- `リファクタリング: API処理の共通化`
- `ドキュメント: READMEの更新`

## Notes

- プレースホルダーは使用禁止
- 実装が困難な場合は作業を中止してユーザーに報告
- TDD原則に従い、テストファーストで開発
- GitHub Issueをチェックリストとして活用