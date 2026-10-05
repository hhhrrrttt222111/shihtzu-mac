# Shihtzu v3

A cartoon shih tzu (or poodle, corgi, husky... see [Pick your dog](#pick-your-dog)) that **lives on your desktop**, walking along the bottom edge of the screen (on top of the Dock), outside any terminal window.

A terminal can only draw inside its own window, so the dog is a small native macOS overlay app (transparent, click-through, no Dock icon). The zsh plugin just sends it events, which means it works in **any terminal that runs zsh**: VS Code, IntelliJ, iTerm2, Terminal.app, Warp...

## Install

### First time setup

**Requirements:** macOS and Xcode Command Line Tools.

Check if you have the compiler:
```zsh
xcode-select --install    # if needed
```

Clone and install:
```zsh
git clone https://github.com/yourusername/shihtzu-mac.git
cd shihtzu-mac
./install.sh              # compiles the overlay and installs the zsh plugin
source ~/.zshrc           # or open a new terminal tab
```

The dog starts when the first shell opens. A 🐾 menu-bar item lets you hide it or quit.

### Update

If changes are pushed to the repo, pull them and reinstall:

```zsh
cd /path/to/shihtzu-mac
git pull
./install.sh              # recompiles and replaces the overlay
```

The installer stops any running overlay so the new build takes over immediately. No manual restart needed.

You can also reinstall from any branch:
```zsh
git checkout some-branch
./install.sh
```

## What it does

- Wanders, sits, sniffs, and naps (with floating z's) on its own
- Click a sleeping dog and it wakes up and goes for a walk
- Command succeeds -> happy hop with hearts, then a zoomie across the screen
- Command fails -> droopy ears, worried brows, a sweat drop
- Idle CPU is low (a sleeping dog redraws at ~10 fps)

## Pick your dog

The shih tzu is the default, but you can switch to another **breed** at any time. On top of a breed you choose a **coat**, a **groom** (haircut), an **accessory** and a **size** — all independent, so mix freely.

```zsh
shihtzu list                  # every choice, with the current one marked *
shihtzu breed poodle          # change the breed (coat and groom reset to that breed's defaults)
shihtzu coat black            # coats and grooms are specific to the current breed
shihtzu groom teddy
shihtzu accessory crown       # accessories and sizes work on every breed
shihtzu breed                 # list just the breeds (same for coat / groom / accessory / size)
shihtzu bigger | smaller      # step the size up or down
shihtzu size large            # or pick a size directly (xsmall ... xlarge)
shihtzu random                # random coat, groom and accessory for the current breed
shihtzu random all            # ...and a random breed too
shihtzu reset                 # back to the default shih tzu
```

Changes apply to the running dog immediately and are saved to `~/.terminal-animals/config`, so your last choice is the default for every new terminal and every restart. `shihtzu reset` clears your saved choices and returns to the original shih tzu.

### Breeds

| Name | Breed | Coats | Grooms |
| --- | --- | --- | --- |
| `shihtzu` (default) | Shih Tzu | 20 | 7 |
| `poodle` | Poodle | 8 | 4 |
| `bernedoodle` | Bernedoodle | 5 | 4 |
| `golden-retriever` | Golden Retriever | 3 | 3 |
| `labrador` | Labrador Retriever | 5 | 3 |
| `german-shepherd` | German Shepherd | 4 | 3 |
| `husky` | Siberian Husky | 4 | 3 |
| `corgi` | Pembroke Corgi | 4 | 2 |
| `dachshund` | Dachshund | 5 | 2 |
| `beagle` | Beagle | 3 | 2 |
| `pug` | Pug | 4 | 1 |
| `pomeranian` | Pomeranian | 6 | 3 |
| `border-collie` | Border Collie | 4 | 2 |
| `dalmatian` | Dalmatian | 2 | 1 |

### Explore all configurations

Each breed has its own coats and grooms. Run these commands to see what's available:

```zsh
shihtzu coat                  # list coats for the current breed
shihtzu groom                 # list grooms for the current breed
shihtzu breed poodle          # switch to a breed
shihtzu coat                  # now shows poodle coats
```

You can also preview all configurations at once:

```zsh
terminal-animals-overlay --gallery out.png                     # current breed's options
terminal-animals-overlay --gallery out.png --breed poodle      # poodle's options
terminal-animals-overlay --breeds out.png                      # all 14 breeds
```

### Shih tzu coats

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

### Shih tzu grooms

| Name | Look |
| --- | --- |
| `topknot` (default) | Top-knot with a bow |
| `puppy` | Short puppy cut |
| `teddy` | Fluffy teddy-bear cut |
| `long` | Long flowing coat |
| `round` | Round teddy-face cut |
| `lion` | Lion cut with a mane |
| `ponytails` | Two small ponytails |

### Poodle coats

| Name | Look |
| --- | --- |
| `white` | White |
| `black` | Black |
| `apricot` | Apricot |
| `cream` | Cream |
| `red` | Red |
| `silver` | Silver |
| `chocolate` | Chocolate |
| `parti` | Black & White Parti |

### Poodle grooms

| Name | Look |
| --- | --- |
| `puppy` | Fluffy puppy cut |
| `pompom` | Top-puff |
| `teddy` | Teddy-bear cut |
| `show` | Show cut with mane |

### Bernedoodle coats

| Name | Look |
| --- | --- |
| `tricolor` | Tricolor (black, tan, white) |
| `chocolate-tricolor` | Chocolate tricolor |
| `parti` | Black & white parti |
| `sable` | Sable |
| `merle` | Merle |

### Bernedoodle grooms

| Name | Look |
| --- | --- |
| `natural` | Fluffy natural |
| `teddy` | Teddy-bear cut |
| `puppy` | Short puppy cut |
| `shaggy` | Long shaggy coat |

### Golden Retriever coats

| Name | Look |
| --- | --- |
| `golden` | Golden |
| `light-golden` | Light golden |
| `dark-golden` | Dark golden |

### Golden Retriever grooms

| Name | Look |
| --- | --- |
| `natural` | Natural feathered coat |
| `trimmed` | Summer trim |
| `puppy` | Fluffy puppy |

### Sizes (all breeds)

`xsmall`, `small`, `medium` (default), `large`, `xlarge` — 0.85x to 1.45x. The range is capped on purpose: the dog stays readable at the small end and always fits the overlay at the large end. `shihtzu bigger` / `smaller` move one step and stop at the limits. `shihtzu random` leaves the size alone.

### Other breeds

The remaining breeds also have their own coats and grooms:

- **Labrador Retriever** — 5 coats (yellow, black, chocolate, fox red, silver), 3 grooms
- **German Shepherd** — 4 coats (black & tan, sable, black, white), 3 grooms
- **Siberian Husky** — 4 coats (grey & white, black & white, red & white, white), 3 grooms
- **Corgi** — 4 coats (red & white, fawn, sable, tricolor), 2 grooms
- **Dachshund** — 5 coats (red, black & tan, chocolate & tan, cream, dapple), 2 grooms
- **Beagle** — 3 coats (tricolor, lemon & white, red & white), 2 grooms
- **Pug** — 4 coats (fawn, black, apricot, silver), 1 groom
- **Pomeranian** — 6 coats (orange, cream, black, white, sable, orange & white), 3 grooms
- **Border Collie** — 4 coats (black & white, red & white, tricolor, blue merle), 2 grooms
- **Dalmatian** — 2 coats (black spots, liver spots), 1 groom

Use `shihtzu breed <name>` to switch to any breed, then `shihtzu coat` and `shihtzu groom` to explore its options.

### Accessories (all breeds)

`none` (default), `flowers` (hair clips), `cap`, `scarf`, `glasses`, `crown`. These work on every breed.

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
| `overlay/App.swift` | Overlay window, menu-bar item, event-file polling, click handling |
| `overlay/Dog.swift` | Dog state and behaviour (moods, movement, particles) |
| `overlay/DogDrawing.swift` | Rendering the body, legs, markings and tail |
| `overlay/DogHead.swift` | Rendering the head: ears, muzzle, eyes, face markings |
| `overlay/DogAccessories.swift` | Rendering accessories |
| `overlay/DrawingPrimitives.swift` | Shared outline-style drawing helpers and colours |
| `overlay/Breed.swift`, `Anatomy.swift` | A breed and its build (body, legs, muzzle, ear and tail style) |
| `overlay/Breeds/*.swift` | Each breed's coats and grooms, grouped by family |
| `overlay/Coat.swift`, `Groom.swift`, `Size.swift` | Coat colours/markings, grooming styles, accessories and sizes |
| `overlay/Appearance.swift` | The chosen look, loaded from the config file |
| `overlay/Variant.swift` | Shared protocol for selectable choices (`key`, `title`, lookup by name) |
| `overlay/CLI.swift`, `Snapshot.swift` | `--list`, `--show`, `--snapshot`, `--gallery`, `--breeds` |
| `terminal-animals.plugin.zsh` | `preexec`/`precmd` hooks append `cmd <exit-code>` to `~/.terminal-animals/run/events`; the `shihtzu` command writes the config and sends `reload` |

### Adding a variant

- **Coat** — add a `.make(...)` line to the breed's `coats` in `overlay/Breeds/`. Only the fur colour is required; shades are derived, and `markings` add saddle, blaze, mask, spots, bib, socks, eyebrows or stripes.
- **Groom** — add a `Groom(...)` entry to the breed's `grooms`; head, ear, cheek and crown sizes are plain parameters.
- **Breed** — add a `static let` for it in a file under `overlay/Breeds/`, describe its build with `Anatomy(...)` (body and leg size, muzzle length, ear style, tail style, curly coat, eye colour), give it coats and grooms, and list it in `Breed.all`.
- **Accessory** — add a case to `Accessory`, then draw it in `DogAccessories.swift`.

The `shihtzu` command, `--list` and the previews pick it up automatically.

### Previewing

```zsh
terminal-animals-overlay --breeds out.png                     # every breed in its default look
terminal-animals-overlay --gallery out.png --breed poodle     # every coat, groom and accessory of a breed
terminal-animals-overlay --snapshot out.png                   # every mood, current look
terminal-animals-overlay --snapshot out.png --breed husky --coat black-white --groom fluffy --accessory crown --size xlarge
```

macOS only.
