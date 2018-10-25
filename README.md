# kopsenv

[Kops](https://github.com/kubernetes/kops) version manager inspired by [tfenv](https://github.com/Zordrak/tfenv).

## Support

Currently kopsenv supports the following OSes, on x86-64 bit archtecture only:

- Mac OS X
- Linux
- Windows - only tested in git-bash

## Installation

### git

1. Check out kopsenv into any path (here is `${HOME}/.kopsenv`)

  ```sh
  $ git clone https://github.com/kilna/kopsenv.git ~/.kopsenv
  ```

2. Add `~/.kopsenv/bin` to your `$PATH` any way you like

  ```sh
  $ echo 'export PATH="$HOME/.kopsenv/bin:$PATH"' >> ~/.bash_profile
  ```

  OR you can make symlinks for `kopsenv/bin/*` scripts into a path that is already added to your `$PATH` (e.g. `/usr/local/bin`) `OSX/Linux Only!`

  ```sh
  $ ln -s ~/.kopsenv/bin/* /usr/local/bin
  ```
  
  On Ubuntu/Debian touching `/usr/local/bin` might require sudo access, but you can create `${HOME}/bin` or `${HOME}/.local/bin` and on next login it will get added to the session `$PATH`
  or by running `. ${HOME}/.profile` it will get added to the current shell session's `$PATH`.
  
  ```sh
  $ mkdir -p ~/.local/bin/
  $ . ~/.profile
  $ ln -s ~/.kopsenv/bin/* ~/.local/bin
  $ which kopsenv
  ```

## Usage

### kopsenv install [version]

Install a specific version of Kops. Available options for version:

- `i.j.k` exact version to install
- `latest` is a syntax to install latest version
- `latest:<regex>` is a syntax to install latest version matching regex (used by grep -e)

```sh
$ kopsenv install 1.10.0
$ kopsenv install latest
$ kopsenv install latest:^1.9
$ kopsenv install
```

#### .kops-version

If you use [.kops-version](#kops-version), `kopsenv install` (no argument) will install the version written in it.


### kopsenv use &lt;version>

Switch a version to use

`latest` is a syntax to use the latest installed version

`latest:<regex>` is a syntax to use latest installed version matching regex (used by grep -e)

```sh
$ kopsenv use 1.10.0
$ kopsenv use latest
$ kopsenv use latest:^1.9
```

### kopsenv uninstall &lt;version>

Uninstall a specific version of Kops

`latest` is a syntax to uninstall latest version
`latest:<regex>` is a syntax to uninstall latest version matching regex (used by grep -e)

```sh
$ kopsenv uninstall 1.10.0
$ kopsenv uninstall latest
$ kopsenv uninstall latest:^1.9
```

### kopsenv list

List installed versions

```sh
% kopsenv list
* 1.10.0 (set by /opt/kopsenv/version)
  1.9.2
  1.9.1
  1.9.0
  1.8.1
```

### kopsenv list-remote

List installable versions

```sh
$ kopsenv list-remote
1.10.0
1.9.2
1.9.1
1.9.0
1.8.1
1.8.0
1.7.1
1.7.0
...
```

## .kops-version

If you put `.kops-version` file on your project root, or in your home directory, kopsenv detects it and use the version written in it. If the version is `latest` or `latest:<regex>`, the latest matching version currently installed will be selected.

```sh
$ cat .kops-version
1.9.2

$ kops version client
Version 1.9.2

$ echo 1.10.0 > .kops-version

$ kops version client
Version 1.10.0

$ echo latest:^1.8 > .kops-version

$ kops version client
Version 1.8.1
```

## Upgrading

```sh
$ git --git-dir=~/.kopsenv/.git pull
```

## Uninstalling

```sh
$ rm -rf /some/path/to/kopsenv
```

## LICENSE

- [kopsenv](https://github.com/kilna/kopsenv/blob/master/LICENSE)

Code was in turn derived from:

- [tfenv](https://github.com/Zordrak/tfenv/blob/master/LICENSE)
- [rbenv](https://github.com/rbenv/rbenv/blob/master/LICENSE)

