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

$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME | path join ".local" "bin"))

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
