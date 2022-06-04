# ianoff's dotfiles

Uses [Dotbot](https://github.com/anishathalye/dotbot) as a submodule, as described in that project's docs. I have written my own config in `install.conf.yaml`.

## Install
Go in the folder, run `install`. Restart shells to source.

## Plugins
Includes custom zsh plugins I've written for myself over the years.

### 1Password Plugin
Utilities for boostrapping secrets from 1Password password manager into the shell, so I don't have the commit them to a repo, but also don't have to worry about deleting them from the face of the earth if I need to do a reinstall.

See [https://developer.1password.com/docs/cli/](https://developer.1password.com/docs/cli/) for details on how to install and authenticate with 1Pass.

Included commands:
 - `savesecrets` - uses `op inject` to get stuff out of 1pass and save it to a file to be sources into the shell (ideally into a folder that's gitignored, as shown here). This only needs to be done periodically.
 - `loadsecrets` - just checks for the file and sources it.
 - `killsecrets` - rm -rf

### Healthvana & Ianoff Plugins
Just a collection of commands I use about a thousand times a day for random stuff. Likely not useful to anyone else on the planet. 😅

## Themes

Some silly themes I made for my shell, based on existing omz themes.

It'd be cool if I added a script to auto install [powerline](https://github.com/powerline/fonts) fonts and [iTerm2 themes](https://github.com/mbadolato/iTerm2-Color-Schemes) at some point; I usually just do this manually.