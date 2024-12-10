Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -Function ForwardWord

Set-Alias -Name g -Value git

function fd {
    $code_dir = "$HOME\dev\"
    $path = gci -path $code_dir -name -recurse -directory -depth 2 | fzf
    if ($path) {
        Set-Location $code_dir$path
    }
}

function prompt {
    $p = $executionContext.SessionState.Path.CurrentLocation
    $osc7 = ""
    if ($p.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $p.ProviderPath -Replace "\\", "/"
        $osc7 = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}${ansi_escape}\"
    }
    "${osc7}PS $p$('>' * ($nestedPromptLevel + 1)) ";
}
