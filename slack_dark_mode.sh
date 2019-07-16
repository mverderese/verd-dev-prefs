#! /usr/bin/env bash

npm install -g asar

JS="
// First make sure the wrapper app is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Fetch our CSS in parallel ahead of time
  const cssPath =
    'https://raw.githubusercontent.com/caiceA/slack-raw/master/slack-4';
  let cssPromise = fetch(cssPath).then((response) => response.text());

  let customCustomCSS = \`
   :root {
      /* Modify these to change your theme colors: */
      --primary: #CCC;
      --text: #999;
      --background: #222;
      --background-elevated: #444;
   }
   \`;

  // Insert a style tag into the wrapper view
  cssPromise.then((css) => {
    let s = document.createElement('style');
    s.type = 'text/css';
    s.innerHTML = css + customCustomCSS;
    document.head.appendChild(s);
  });
});"

SLACK_RESOURCES_DIR="/Applications/Slack.app/Contents/Resources"
SLACK_FILE_PATH="${SLACK_RESOURCES_DIR}/app.asar.unpacked/dist/ssb-interop.bundle.js"

echo "Adding Dark Theme Code to Slack... "
echo "This script requires sudo privileges." && echo "You'll need to provide your password."

sudo npx asar extract ${SLACK_RESOURCES_DIR}/app.asar ${SLACK_RESOURCES_DIR}/app.asar.unpacked
sudo tee -a "${SLACK_FILE_PATH}" > /dev/null <<< "$JS"
sudo npx asar pack ${SLACK_RESOURCES_DIR}/app.asar.unpacked ${SLACK_RESOURCES_DIR}/app.asar