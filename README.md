[![Build Status](https://travis-ci.org/kamatama41/kopsenv.svg?branch=master)](https://travis-ci.org/kamatama41/kopsenv)

# kopsenv
[Kops](https://www.kops.io/) version manager inspired by [rbenv](https://github.com/rbenv/rbenv)

## Support
Currently kopsenv supports the following OSes
- Mac OS X (64bit)
- Linux
 - 64bit
 - Arm
- Windows (64bit) - only tested in git-bash

## Installation
### Automatic
Install via Homebrew

  ```sh
  $ brew install kopsenv
  ```

Install via puppet

Using puppet module [sergk-kopsenv](https://github.com/SergK/puppet-kopsenv)

```sh
include ::kopsenv
```

### Manual
1. Check out kopsenv into any path (here is `${HOME}/.kopsenv`)

  ```sh
  $ git clone https://github.com/kamatama41/kopsenv.git ~/.kopsenv
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
- `min-required` is a syntax to recursively scan your Kops files to detect which version is minimally required. See [required_version](https://www.kops.io/docs/configuration/kops.html) docs. Also [see min-required](#min-required) section below.

```sh
$ kopsenv install 0.7.0
$ kopsenv install latest
$ kopsenv install latest:^0.8
$ kopsenv install min-required
$ kopsenv install
```

If shasum is present in the path, kopsenv will verify the download against Hashicorp's published sha256 hash. If [keybase](https://keybase.io/) is available in the path it will also verify the signature for those published hashes using hashicorp's published public key.

#### .kops-version
If you use [.kops-version](#kops-version), `kopsenv install` (no argument) will install the version written in it.

#### min-required

Please note that we don't do semantic version range parsing but use first ever found version as the candidate for minimally required one. It is up to the user to keep the definition reasonable. I.e.
```
// this will detect 0.12.3
kops {
  required_version  = "<0.12.3, >= 0.10.0"
}
```

```
// this will detect 0.10.0
kops {
  required_version  = ">= 0.10.0, <0.12.3"
}
```


### Specify architecture

Architecture other than the default amd64 can be specified with the `KOPSENV_ARCH` environment variable

```sh
KOPSENV_ARCH=arm kopsenv install 0.7.9
```

### kopsenv use &lt;version>
Switch a version to use

`latest` is a syntax to use the latest installed version

`latest:<regex>` is a syntax to use latest installed version matching regex (used by grep -e)

`min-required` will switch to the version minimally required by your kops sources (see above `kopsenv install`)

```sh
$ kopsenv use min-required
$ kopsenv use 0.7.0
$ kopsenv use latest
$ kopsenv use latest:^0.8
```

### kopsenv uninstall &lt;version>
Uninstall a specific version of Kops
`latest` is a syntax to uninstall latest version
`latest:<regex>` is a syntax to uninstall latest version matching regex (used by grep -e)
```sh
$ kopsenv uninstall 0.7.0
$ kopsenv uninstall latest
$ kopsenv uninstall latest:^0.8
```

### kopsenv list
List installed versions
```sh
% kopsenv list
* 0.10.7 (set by /opt/kopsenv/version)
  0.9.0-beta2
  0.8.8
  0.8.4
  0.7.0
  0.7.0-rc4
  0.6.16
  0.6.2
  0.6.1
```

### kopsenv list-remote
List installable versions
```sh
% kopsenv list-remote
0.9.0-beta2
0.9.0-beta1
0.8.8
0.8.7
0.8.6
0.8.5
0.8.4
0.8.3
0.8.2
0.8.1
0.8.0
0.8.0-rc3
0.8.0-rc2
0.8.0-rc1
0.8.0-beta2
0.8.0-beta1
0.7.13
0.7.12
...
```

## .kops-version
If you put `.kops-version` file on your project root, or in your home directory, kopsenv detects it and use the version written in it. If the version is `latest` or `latest:<regex>`, the latest matching version currently installed will be selected.

```sh
$ cat .kops-version
0.6.16

$ kops --version
Kops v0.6.16

Your version of Kops is out of date! The latest version
is 0.7.3. You can update by downloading from www.kops.io

$ echo 0.7.3 > .kops-version

$ kops --version
Kops v0.7.3

$ echo latest:^0.8 > .kops-version

$ kops --version
Kops v0.8.8
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
- [kopsenv itself](https://github.com/kamatama41/kopsenv/blob/master/LICENSE)
- [rbenv](https://github.com/rbenv/rbenv/blob/master/LICENSE)
  - kopsenv partially uses rbenv's source code
