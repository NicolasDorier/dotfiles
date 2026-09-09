const fs = require("node:fs/promises");
const os = require("node:os");
const path = require("node:path");
const vscode = require("vscode");

const runtimeFile = path.join(
  process.env.XDG_RUNTIME_DIR || os.tmpdir(),
  `vscode-focused-workspace-${process.getuid()}`,
);

function activeWorkspacePath() {
  const editorUri = vscode.window.activeTextEditor?.document.uri;
  const editorFolder = editorUri && vscode.workspace.getWorkspaceFolder(editorUri);
  const folder = editorFolder || vscode.workspace.workspaceFolders?.[0];

  return folder?.uri.scheme === "file" ? folder.uri.fsPath : undefined;
}

async function publishFocusedWorkspace() {
  if (!vscode.window.state.focused) {
    return;
  }

  const workspacePath = activeWorkspacePath();
  if (!workspacePath) {
    await fs.rm(runtimeFile, { force: true });
    return;
  }

  const temporaryFile = `${runtimeFile}.${process.pid}`;
  await fs.writeFile(temporaryFile, `${workspacePath}\n`, { mode: 0o600 });
  await fs.rename(temporaryFile, runtimeFile);
}

function publishSafely() {
  publishFocusedWorkspace().catch((error) => {
    console.error("Failed to publish the focused workspace folder", error);
  });
}

function activate(context) {
  context.subscriptions.push(
    vscode.window.onDidChangeWindowState((state) => {
      if (state.focused) {
        publishSafely();
      }
    }),
    vscode.window.onDidChangeActiveTextEditor(publishSafely),
    vscode.workspace.onDidChangeWorkspaceFolders(publishSafely),
  );

  publishSafely();
}

module.exports = { activate };
