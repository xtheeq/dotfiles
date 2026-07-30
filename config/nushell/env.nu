$env.EDITOR = "hx"
$env.JAVA_HOME = "/usr/lib/jvm/java-17-temurin-jdk"
$env.ANDROID_HOME = ($env.HOME | path join "Android" "Sdk")
$env.PATH = ($env.PATH | split row (char esep) | prepend [
  ($env.ANDROID_HOME | path join "emulator")
  ($env.ANDROID_HOME | path join "platform-tools")
])

zoxide init --cmd cd nushell | save -f ~/.zoxide.nu

# pnpm
$env.PNPM_HOME = "/home/atheeq/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.PNPM_HOME | path join "bin") )
# pnpm end
