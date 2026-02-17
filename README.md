## 💻 Workstation setup
This is an opinionated dev setup for Mac and Ubuntu.

<img width="1920" alt="nvim-tmux" src="https://github.com/user-attachments/assets/9816d8bf-22be-43be-92f4-95d0a402edf6">

### MacOS settings setup

- Keyboard -> Input Sources -> change language to CMD + Space
- Keyboard -> Spotlight - change to CMD + Shift + Space
- Keyboard -> Function keys -> Turn on "Use F1.. as function keys"
- Keyboard -> Mission control -> turn off `Mission Control` and `Application windows`, `Show Desktop`
  - change `move left/right a space` to use CMD instead of CTRL
    (so that tmux leader key would work fine)
- Mouse -> disable natural scrolling
- Keyboard -> Key Repeat -> Fast
- Keyboard -> Delay Until Repeat -> Short
- Keyboard -> Text Input -> Disable most things
- Keyboard -> Accessibility -> Disable VoiceOver
- Control Center
    - Sound -> Always Show in Menu Bar
    - Battery -> Show Percentage
    - Date -> Display time with seconds
    - Weather -> Show in menu

### TMux setup
run tmux and install it:
`F1` + `I`

### Maccy app setup
- Launch at setup
- Open with Shift+CMD+V (shifted paste)
- Fuzzy search
- Paste automatically

### Karabiner-Elements (Keyboard Customization)

Karabiner-Elements enables custom keyboard shortcuts for Windows/Linux compatibility.

**Installation:**
```bash
./macos/install-karabiner.sh
```

**Configured shortcuts:**
- <kbd>Ctrl</kbd> <kbd>Insert</kbd> → Copy (maps to <kbd>Cmd</kbd> <kbd>C</kbd>)
- <kbd>Shift</kbd> <kbd>Insert</kbd> → Paste (maps to <kbd>Cmd</kbd> <kbd>V</kbd>)

**Manual setup required after installation:**
1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Grant permission to **karabiner_grabber** and **karabiner_observer**
3. You may need to restart your Mac for changes to take effect

4. In karabiner-elements settings -> virtual keyboard, change your keyboard to ANSI (to have ~ character working correctly)

**Note:** These shortcuts require a keyboard with an Insert key (common on external/Windows keyboards). If using a Mac keyboard without Insert, you can remap another key in Karabiner's UI.

#### Window management shortcuts (with Rectangle)

- <kbd>§</kbd> - center window
- <kbd>Shift</kbd> <kbd>§</kbd> - restore window position
- <kbd>Shift</kbd> <kbd>+</kbd> - increase window
- <kbd>Shift</kbd> <kbd>-</kbd> - decrease window
- <kbd>Shift</kbd> <kbd>F1</kbd> - move window left-top
- <kbd>Shift</kbd> <kbd>F2</kbd> - move window right-top
- <kbd>Shift</kbd> <kbd>F3</kbd> - move window left-bottom
- <kbd>Shift</kbd> <kbd>F4</kbd> - move window right-bottom

#### Warp terminal shortcuts

- <kbd>Cmd</kbd> <kbd>+</kbd> - increase font
- <kbd>Cmd</kbd> <kbd>-</kbd> - decrease font
- <kbd>Cmd</kbd> <kbd>t</kbd> - open tab
- <kbd>Cmd</kbd> <kbd>n</kbd> - open new window

### Apps

To install, run: `./macos/install-ui-apps.sh`

**Keyboard customization:**
```bash
./macos/install-karabiner.sh  # Install Karabiner-Elements for custom keyboard shortcuts
```

Others need manual installation:

- Goland
- Docker4Mac
- [Postman](https://www.postman.com/downloads/)
- [OpenVPN](https://openvpn.net/downloads/openvpn-connect-latest.dmg)
- Discord
- [Monocle](https://monokle.io/download) to access k8s logs
- Microsoft TODO

### Fonts

- Install [Jetbrains Mono Nerdfont](https://www.nerdfonts.com/font-downloads) or original [Jetbrains Mono](https://www.jetbrains.com/lp/mono/)
  - Update iTerm and IDEs to use it to see nice icons
  - Use ligatures

### Git settings

```bash
git config --global user.name "Artjom Kurapov"
git config --global user.email "artkurapov@gmail.com"
git config --global pull.rebase false

# generate key for github
ssh-keygen -t rsa -b 4096 -C "artkurapov@gmail.com"
open "https://github.com/settings/keys"
cat ~/.ssh/id_rsa.pub
```

### Installation

```bash
chmod +x install.sh

# Optional: Backup existing configs before installation
./backup.sh

git clone git@github.com:tot-ra/ai-workstation.git ~/git/ai-workstation
~/git/ai-workstation/install.sh
echo "source ~/git/ai-workstation/mount.sh" >> ~/.zshrc

# link nvim and tmux configs to be linked to github repo
ln -s ~/git/ai-workstation/.tmux.conf ~/.tmux.conf
ln -s ~/git/ai-workstation/.config/nvim ~/.config/nvim

# now add this key to github --> https://github.com/settings/ssh/new
```

**Features:**
- ✅ Idempotent - safe to run multiple times
- 📝 Detailed logging in `~/.workstation-logs/`
- 🔄 Version management via `versions.env`
- 🛡️ Security best practices built-in
- 💾 Backup script for existing configs

### Manual steps after installation

- run `tmux` and run <kbd>F1</kbd> <kbd>I</kbd> to install plugins
- run `lazygit` first time to activate
- run nvim and from cmd mode run (where you'll need to install plugins):

```
:Lazy
:LazyExtras
:Copilot auth
:Mason
```

### Version Management

Edit `versions.env` to customize software versions:
```bash
# Example: Change Node.js default version
NODE_VERSION_DEFAULT="18"

# Example: Use different Go version
GO_VERSION="1.21"
```

### Project Structure

```
workstation/
├── install.sh              # Main installation script (Mac)
├── backup.sh               # Backup existing configurations
├── common-functions.sh     # Shared helper functions
├── versions.env            # Version management
├── checksums.env           # Security checksums
├── install-*.sh            # Component-specific installers
├── .config/                # Application configs
│   ├── nvim/              # Neovim/LazyVim config
│   └── wezterm/           # Wezterm terminal config
├── ubuntu/                 # Ubuntu-specific scripts
├── CHANGELOG.md            # Version history
├── SECURITY.md             # Security guidelines
└── README.md               # This file
```

## Custom keyboard shortcuts

- <kbd>F1</kbd> - tmux
- <kbd>F12</kbd> - toggle fullscreen (wezterm)

### TMux

Leader (<kbd>F1</kbd>) and:

- <kbd>:</kbd> `new` - create new session
- <kbd>w</kbd> - choose window
- <kbd>\*</kbd> - clears history and terminal
- <kbd>?</kbd> - show key bindings
- <kbd>r</kbd> - reload config
- <kbd>I</kbd> - install plugins
- <kbd>:</kbd> - command mode
- <kbd>$</kbd> - rename session
- <kbd>d</kbd> - detach from session

- <kbd>[</kbd> - enter copy mode
  - <kbd>Space</kbd> - start selection
  - <kbd>Enter</kbd> - copy selection
  - <kbd>]</kbd> - paste selection

#### Sessions

- `tmux ls` - list sessions
- `tmux new -s my-session` - create session
- `tmux a` - attach to new session
- `tmux a -t my-session` - attach to session by name

#### Tmux Windows

- <kbd>F1</kbd> <kbd>+</kbd> - create window
- <kbd>F1</kbd> <kbd>-</kbd> - split window horizontally
- <kbd>F1</kbd> <kbd>|</kbd> - split window vertically
- <kbd>Ctrl</kbd> <kbd>Shift</kbd> right - next window
- <kbd>Ctrl</kbd> <kbd>Shift</kbd> left - previous window
- <kbd>,</kbd> - rename window
- <kbd>.</kbd> - move window

#### Panes

- <kbd>Ctrl</kbd> <kbd>arrows</kbd> - moves between panes (including within nvim)
- <kbd>"</kbd> - split window to panes horizontally
- <kbd>%</kbd> - split window to panes vertically
- <kbd>z</kbd> - zoom pane (toggle)
- <kbd>!</kbd> - move pane to own window
- <kbd>o</kbd> - switch session (interactive with [plugin](https://github.com/omerxx/tmux-sessionx))

### Neovim

- <kbd>F3</kbd> - find string
- <kbd>F4</kbd> - find file
- <kbd>:50</kbd> - go to line 50
- <kbd>F11</kbd> - toggle DB UI
- <kbd>Space</kbd> is set as leader
  - <kbd>gd</kbd> - go to definition
  - <kbd>e</kbd> - toggle tree view
- <kbd>Tab</kbd> - accept completion
- <kbd>Alt</kbd> <kbd>left/right</kbd> - switch between tabs
- <kbd>Alt</kbd> <kbd></kbd>up</kbd> - close tab
- <kbd>Alt</kbd> <kbd>down</kbd> - pin tab
- <kbd>Ctrl</kbd> <kbd>I</kbd> - go to previous location
  - <kbd>Ctrl</kbd> <kbd>O</kbd> - go to next location

#### Movement

- <kbd>s</kbd> - jump to characters (flash plugin)
- <kbd>gg</kbd> - go to top of the file
  - <kbd>G</kbd> - go to end of the file
- <kbd>20G</kbd> - go to line 20
- <kbd>5j</kbd> - go up 5 lines
  - <kbd>5k</kbd> - go down 5 lines
- <kbd>w</kbd> jump to next word
  - <kbd>b</kbd> jump back to previous word
- <kbd>f</kbd> - find character
  - <kbd>;</kbd> next
- <kbd>m</kbd> - bookmark line (for harpoon)
  - <kbd>TAB</kbd> - toggle bookmark list
- <kbd>/</kbd> - search
  - <kbd>n</kbd> - next hit
- <kbd>f(</kbd> - jump to next bracket

#### Code folding

- <kbd>za</kbd> - Toggle between closing and opening the fold under the cursor.
- <kbd>zR</kbd> - Open all folds in the current buffer.
- <kbd>zM</kbd> - Close all folds in the current buffer.

#### Commenting

- <kbd>gcc</kbd> - comment line

#### Replace

```
:%s/from/to/gc
```

#### Insert mode

- <kbd>F2</kbd> - search/replace (nvim) with LSP
- <kbd>I</kbd> - switch to insert mode + go to beginning of the line
- <kbd>A</kbd> - switch to insert mode + go to end of the line
- <kbd>i</kbd> - switch to insert mode
- <kbd>o</kbd> - switch to insert mode + add new line after current one

#### Visual mode

- <kbd>y</kbd> - copy (yield)
- <kbd>p</kbd> - paste
- <kbd>d</kbd> - cut
- <kbd>dd</kbd> - delete line
- <kbd>u</kbd> - undo
- <kbd>w</kbd> - select word

### Git

- <kbd>Space</kbd> <kbd>gg</kbd> - toggle lazygit

## 🔧 Troubleshooting

### Installation Issues

#### NVM not found after installation
**Problem**: `nvm: command not found` after running install script

**Solution**: 
```bash
# Restart your terminal or source the config
source ~/.zshrc

# Verify NVM is loaded
command -v nvm
```

#### Tmux plugins not installing
**Problem**: Tmux plugins don't install when pressing F1 + I

**Solution**:
```bash
# Ensure TPM is installed
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Restart tmux
tmux kill-server
tmux

# Press F1 + I to install plugins
```

#### Brew installation fails
**Problem**: Homebrew packages fail to install

**Solution**:
```bash
# Update brew
brew update

# Diagnose issues
brew doctor

# Check installation logs
cat ~/.workstation-logs/install-*.log
```

#### Neovim plugins not loading
**Problem**: Neovim starts but plugins are missing

**Solution**:
```bash
# Open neovim and run
nvim

# In nvim command mode, run:
:Lazy
:Lazy sync

# Check for errors
:checkhealth
```

### Runtime Issues

#### Zsh completions not working
**Problem**: Tab completion doesn't work in zsh

**Solution**:
```bash
# Fix permissions
compaudit | xargs chmod g-w,o-w

# Rebuild completion cache
rm ~/.zcompdump*
exec zsh
```

#### Git authentication fails
**Problem**: Cannot push/pull from GitHub

**Solution**:
```bash
# Check if SSH key exists
ls -la ~/.ssh/id_rsa.pub

# If not, generate one
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# Add to GitHub: https://github.com/settings/ssh/new
cat ~/.ssh/id_rsa.pub
```

#### Docker/Kubernetes not working
**Problem**: kubectl or docker commands fail

**Solution**:
```bash
# Ensure OrbStack is running
open -a OrbStack

# Check kubectl context
kubectl config current-context

# Verify docker
docker ps
```

#### Python/Node version issues
**Problem**: Wrong Python or Node version active

**Solution**:
```bash
# For Node (using nvm)
nvm use 20
nvm alias default 20

# For Python (if using pyenv)
pyenv global 3.11
```

### Configuration Issues

#### Powerlevel10k not loading
**Problem**: Terminal prompt doesn't show p10k theme

**Solution**:
```bash
# Reconfigure p10k
p10k configure

# Ensure it's in .zshrc
grep powerlevel10k ~/.zshrc

# If missing, add it
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
```

#### Tmux configuration not applied
**Problem**: Tmux doesn't use custom config

**Solution**:
```bash
# Ensure symlink exists
ls -la ~/.tmux.conf

# If not, create it
ln -sf ~/git/workstation/.tmux.conf ~/.tmux.conf

# Reload tmux config (inside tmux)
# Press F1 + r
```

#### Nvim configuration conflicts
**Problem**: Custom nvim config conflicts with LazyVim

**Solution**:
```bash
# Backup your config
mv ~/.config/nvim ~/.config/nvim.backup

# Link to workstation config
ln -s ~/git/workstation/.config/nvim ~/.config/nvim

# Restart nvim and run
:Lazy restore
```

#### Karabiner keyboard shortcuts not working
**Problem**: Control+Insert and Shift+Insert shortcuts don't work

**Solution**:
```bash
# Check if Karabiner is running
ps aux | grep karabiner

# Verify permissions in System Settings
# Go to: Privacy & Security → Accessibility
# Ensure karabiner_grabber and karabiner_observer are checked

# Check if your keyboard has an Insert key
# External/Windows keyboards usually have it
# Mac keyboards typically don't

# View current configuration
cat ~/.config/karabiner/karabiner.json

# Restart Karabiner
killall karabiner_grabber karabiner_observer
# Or restart from the menu bar icon

# If still not working, you may need to restart your Mac
```

### Performance Issues

#### Zsh slow startup
**Problem**: Terminal takes long to open

**Solution**:
```bash
# Profile zsh startup
time zsh -i -c exit

# Disable plugins temporarily to identify culprit
# Comment out plugins in ~/.zshrc one by one

# Common culprits:
# - nvm (use lazy loading)
# - Too many plugins
```

#### Nvim slow to start
**Problem**: Neovim takes several seconds to open

**Solution**:
```bash
# Profile nvim startup
nvim --startuptime startup.log

# Review which plugins are slow
cat startup.log | sort -k2 -n

# Consider lazy-loading slow plugins
```

### Getting Help

If you're still stuck:

1. **Check logs**: Installation logs are in `~/.workstation-logs/`
2. **Search issues**: Check [GitHub issues](https://github.com/tot-ra/mac-work/issues)
3. **Create issue**: Open a new issue with:
   - Your OS version (`sw_vers` on Mac, `lsb_release -a` on Ubuntu)
   - Error messages from logs
   - Steps to reproduce

### Common Commands for Debugging

```bash
# Check what's using a port
lsof -i :3000

# Check system info (Mac)
sw_vers
system_profiler SPSoftwareDataType

# Check disk space
df -h

# Check running processes
ps aux | grep <process-name>

# View installation logs
tail -f ~/.workstation-logs/install-*.log

# Check brew services
brew services list
```

