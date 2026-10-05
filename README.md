# Shihtzu v3

A cartoon shih tzu that **lives on your desktop**, walking along the bottom edge of the screen (on top of the Dock), outside any terminal window.

A terminal can only draw inside its own window, so the dog is a small native macOS overlay app (transparent, click-through, no Dock icon). The zsh plugin just sends it events, which means it works in **any terminal that runs zsh**: VS Code, IntelliJ, iTerm2, Terminal.app, Warp...

## Install

```zsh
./install.sh        # compiles the overlay with swiftc (needs Xcode Command Line Tools)
source ~/.zshrc
```

The dog starts the first time a shell opens. A 🐾 menu-bar item lets you hide it or quit.

## What it does

- Wanders, sits, sniffs, and naps (with floating z's) on its own
- Command succeeds -> happy hop with hearts, then a zoomie across the screen
- Command fails -> droopy ears, worried brows, a sweat drop
- Idle CPU is low (a sleeping dog redraws at ~10 fps)

## Pick your shih tzu

A look is three independent choices that you can mix freely: a **coat**, a **groom** (haircut) and an **accessory**.

```zsh
shihtzu list                  # every choice, with the current one marked *
shihtzu coat chocolate        # change the coat
shihtzu groom lion            # change the haircut
shihtzu accessory crown       # change the accessory
shihtzu coat                  # list just the coats (same for groom / accessory)
shihtzu random                # surprise me: random coat, groom and accessory
shihtzu reset                 # back to the default look
```

Changes apply to the running dog immediately and are saved to `~/.terminal-animals/config`, so your last choice is the default for every new terminal and every restart. `shihtzu reset` clears your saved choices and returns to the original look.

### Coats

| Name | Look | Name | Look |
| --- | --- | --- | --- |
| `classic` (default) | White & brown | `silver-white` | Silver & white |
| `white-black` | White & black | `grey-white` | Grey & white |
| `golden-white` | Golden & white | `brindle` | Brindle |
| `cream` | Cream | `red-white` | Red & white |
| `gold` | Solid gold | `apricot-white` | Apricot & white |
| `chocolate` | Chocolate brown | `tricolor` | Black, white & gold |
| `liver-white` | Liver & white | `brown-white-black` | Brown, white & black |
| `black` | Black | `white-brown-ears` | Mostly white, brown ears |
| `black-gold` | Black & gold | `white-black-ears` | Mostly white, black ears |
| `white-golden-face` | White body, golden face | `white-chocolate-ears` | White body, chocolate ears |

### Grooms

| Name | Look |
| --- | --- |
| `topknot` (default) | Top-knot with a bow |
| `puppy` | Short puppy cut |
| `teddy` | Fluffy teddy-bear cut |
| `long` | Long flowing coat |
| `round` | Round teddy-face cut |
| `lion` | Lion cut with a mane |
| `ponytails` | Two small ponytails |

### Accessories

`none` (default), `flowers` (hair clips), `cap`, `scarf`, `glasses`, `crown`.

## Other commands

```zsh
shihtzu on | off     # show / hide the dog
shihtzu start | quit # launch / stop the overlay
shihtzu-chance 50    # % of commands the dog reacts to
```

## How it works

All art is drawn in code (no image assets). The overlay is split by responsibility:

| File | Role |
| --- | --- |
| `overlay/main.swift` | Entry point: one-shot CLI commands, single-instance check, app launch |
| `overlay/App.swift` | Overlay window, menu-bar item, event-file polling |
| `overlay/Dog.swift` | Dog state and behaviour (moods, movement, particles) |
| `overlay/DogDrawing.swift` | Rendering: body, head, grooms and accessories |
| `overlay/Coat.swift`, `Groom.swift` | Catalogs of coats, grooms and accessories |
| `overlay/Appearance.swift` | The chosen look, loaded from the config file |
| `overlay/Variant.swift` | Shared protocol for catalog entries (`key`, `title`, lookup by name) |
| `overlay/CLI.swift`, `Snapshot.swift` | `--list`, `--show`, `--snapshot`, `--gallery` |
| `terminal-animals.plugin.zsh` | `preexec`/`precmd` hooks append `cmd <exit-code>` to `~/.terminal-animals/run/events`; the `shihtzu` command writes the config and sends `reload` |

### Adding a variant

- **Coat** — add one `parti(...)` or `solid(...)` line to `Coat.all` in `Coat.swift`.
- **Groom** — add a `Groom(...)` entry to `Groom.all`; head, ear, cheek and crown sizes are plain parameters.
- **Accessory** — add a case to `Accessory`, then draw it in `DogDrawing.swift`.

The `shihtzu` command, `--list` and the gallery pick it up automatically.

### Previewing

```zsh
terminal-animals-overlay --gallery out.png                    # every coat, groom and accessory
terminal-animals-overlay --snapshot out.png                   # every mood, current look
terminal-animals-overlay --snapshot out.png --coat black --groom lion --accessory crown
```

macOS only.
