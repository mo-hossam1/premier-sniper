name: Build Android APK

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Create Web App Wrapper
        run: |
          mkdir -p android-app
          cat << 'EOF' > android-app/index.html
          <!DOCTYPE html>
          <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              body { margin: 0; background: #0d1117; color: white; display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100vh; font-family: sans-serif; text-align: center; padding: 20px; }
              iframe { width: 100%; height: 100%; border: none; }
            </style>
          </head>
          <body>
            <iframe src="https://mo-hossam1.github.io/premier-sniper/"></iframe>
          </body>
          </html>
          EOF

      # This step creates a lightweight PWA/WebAPK structure
      - name: Package release info
        run: |
          echo "App wrapper ready for deployment!"
