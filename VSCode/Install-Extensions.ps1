$extensions = @(
    'amazonwebservices.aws-toolkit-vscode'
    'aws-scripting-guy.cform'
    'BriteSnow.vscode-toggle-quotes'
    'CoenraadS.bracket-pair-colorizer-2'
    'DanielThielking.aws-cloudformation-yaml'
    'DavidAnson.vscode-markdownlint'
    'eamodio.gitlens'
    'emilast.LogFileHighlighter'
    'fabianlauer.vs-code-xml-format'
    'jakeboone02.mediawiki'
    'kddejong.vscode-cfn-lint'
    'ms-azuretools.vscode-docker'
    'ms-mssql.mssql'
    'ms-python.python'
    'ms-vscode.cpptools'
    'ms-vscode.csharp'
    'ms-vscode.powershell'
    'nbdeg.vscode-gmusic'
    'nobuhito.printcode'
    'oderwat.indent-rainbow'
    'rafaelmaiolla.diff'
    'redhat.vscode-yaml'
    'ryu1kn.partial-diff'
    'streetsidesoftware.code-spell-checker'
    'tberman.json-schema-validator'
    'Tyriar.shell-launcher'
    'vangware.dark-plus-material'
    'vscode-icons-team.vscode-icons'
    'yatki.vscode-surround'
)

foreach ($ext in $extensions)
{
    code --install-extension $ext --force
}