# Installing on another system (for testing)

Zero dependencies for the core (POSIX `sh`). Safe: non-destructive, no network. See SECURITY.md.

## Option A — agent-neutral core (recommended)
```sh
git clone https://github.com/pupa3066/context-configuration-builder.git
cd context-configuration-builder
sh install-core.sh                 # scaffolds ~/.context-config-builder (skips existing files)
sh adapters/kiro.sh apply          # or claude-code.sh / cursor.sh / generic.sh
```

## Option B — Kiro-native
```sh
sh install.sh                      # installs into ~/.kiro directly
```

## Verify it works without touching your real setup
```sh
sh demo/demo.sh                    # clean-room walkthrough in a temp dir; changes nothing
```

## Custom locations (isolate a test)
```sh
CCB_HOME=/tmp/ccb-test sh install-core.sh
CCB_HOME=/tmp/ccb-test KIRO_HOME=/tmp/kiro-test sh adapters/kiro.sh apply
```

## Manage projects & rules
```sh
sh scripts/add-project.sh my-project
sh scripts/rules-builder.sh add "Confirm before bulk deletes" --section Repository
sh scripts/rules-builder.sh list
```

## Uninstall
Delete `~/.context-config-builder` (and any adapter output like `~/.kiro/steering/*` you added).
