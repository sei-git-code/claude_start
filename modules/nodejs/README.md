# Node.js

Context7 MCP（npx経由で起動）の前提。

## 導入
```bash
winget install OpenJS.NodeJS.LTS   # Windows
# または brew install node          # Mac
# または apt-get install nodejs npm # Linux
```
インストール直後は現在のシェルにPATHが反映されないことがある。新しいターミナルを開くか、`export PATH="$PATH:/c/Program Files/nodejs"`（Windows/Git Bashの場合）で一時的に通す。
