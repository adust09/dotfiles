# composition
https://qiita.com/yutkat/items/c6c7584d9795799ee164

# Linter
- React.js, Typescriptを使用する想定
- 固有のCSS in JS設定は含まない
- JSON形式に統一して管理
- 以下のスクリプトを`package.json`に書いておくと便利

```json
  "scripts": {
    "lint": "next lint --ignore-path .gitignore",
    "lint:fix": "next lint --ignore-path .gitignore --fix",
    "lint:style": "stylelint --ignore-path .gitignore './**/*.{css,scss}'",
    "lint:style:fix": "stylelint --ignore-path .gitignore --fix './**/*.{css,scss}'",
    "format": "prettier --write --ignore-path .gitignore './**/*.{js,jsx,ts,tsx,json,css,scss}'"
  }
```

# Github Actions
- CIはpush, PR作成時に実行する
- 失敗時にdiscordに通知するので、webhookを別途設定する
