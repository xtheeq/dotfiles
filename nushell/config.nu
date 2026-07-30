$env.config.show_banner = false
$env.config.keybindings ++= [
	{
		name: accept_completion
		modifier: none
		keycode: tab
		mode: [emacs vi_normal vi_insert]
		event: { send: historyhintcomplete }
	}
]

alias z = zellij

def --env --wrapped e [...args] {
  let has_chooser_file = ($args | any {|arg|
    let value = ($arg | into string)
    ($value == '--chooser-file') or ($value | str starts-with '--chooser-file=')
  })

  if $has_chooser_file {
    let status_code = (
      try {
        run-external "/home/atheeq/.cargo/bin/elio" ...$args
        $env.LAST_EXIT_CODE
      } catch {|e| ($e.exit_code? | default 127) }
    )

    $env.LAST_EXIT_CODE = $status_code
    return
  }

  if (($args | length) > 0) and (
    (($args.0 | into string) == 'shell') or
    (($args.0 | into string) | str starts-with '-')
  ) {
    let result = (
      try {
        run-external "/home/atheeq/.cargo/bin/elio" ...$args | complete
      } catch {|e| { stdout: "", stderr: ($e.msg? | default ""), exit_code: ($e.exit_code? | default 127) } }
    )

    if ($result.stderr | is-not-empty) {
      print -e --no-newline $result.stderr
    }

    $env.LAST_EXIT_CODE = $result.exit_code

    if (is-terminal --stdout) {
      if ($result.stdout | is-not-empty) {
        print --no-newline $result.stdout
      }
      return
    }

    return $result.stdout
  }

  let tmp = (mktemp -t "elio-cwd.XXXXXX")
  let command_args = (["--cwd-file", $tmp] ++ $args)

  let status_code = (
    try {
      run-external "/home/atheeq/.cargo/bin/elio" ...$command_args
      $env.LAST_EXIT_CODE
    } catch {|e| ($e.exit_code? | default 127) }
  )

  let cwd = if ($tmp | path exists) { open --raw $tmp } else { "" }
  rm -f $tmp

  if ($cwd | is-not-empty) and ($cwd != $env.PWD) and (($cwd | path type) == 'dir') {
    cd $cwd
  }

  $env.LAST_EXIT_CODE = $status_code
}

source ~/.zoxide.nu

