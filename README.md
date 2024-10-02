# AstroNvim Config

**NOTE:** This is for AstroNvim v4+

## Installing without Nixg

```sh
git clone git@github.com:nicklayb/astronvim.git ~/.config/nvim
```

## Installing as part as NixOS's flake

### 1. Add as Input

```nix
{ }: {
  inputs = {
    astronvim = { url = "github:nicklayb/astronvim", flake = false };
  };
}
```

### 2. Add to Home Manager

```nix
{ }: {
  home.nboisvert.xdg.configFile."nvim".source = import inputs.astronvim;
}
```

### How to update it

1. Clone as seperate nvim config `git clone git@github.com:nicklayb/astronvim.git ~/.config/nvim-astro`
2. Update the seperate config
3. Run nvim with this specific config `NVIM_APPNAME=nvim-astro nvim`
4. Check everything works
5. Commit, push
6. Update NixOS Flake and rebuild system
