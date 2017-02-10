# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

process.env.PATH += ':' + process.env.HOME + '/homebrew/bin/'
process.env.PATH += ':/usr/local/bin'
process.env.GOPATH = process.env.HOME + '/go'

# Remove problematic environment variables that interfere with sub-shells
delete process.env[k] for k of process.env when k.startsWith('BASH_FUNC_')
# Ensure LANG is set for subprocesses
process.env.LANG = 'en_US.UTF-8' unless process.env.LANG
