# ronin

[![CI](https://github.com/ronin-rb/ronin/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin.svg)](https://codeclimate.com/github/ronin-rb/ronin)

* [Website](https://ronin-rb.dev)
* [Source](https://github.com/ronin-rb/ronin)
* [Issues](https://github.com/ronin-rb/ronin/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

[Ronin][website] is a free and Open Source [Ruby] toolkit for security research
and development. Ronin contains many different [CLI commands](#snopsis) and
[Ruby libraries][ronin-rb] for a variety of security tasks, such as
encoding/decoding data, filter IPs/hosts/URLs, querying ASNs, querying DNS,
HTTP, scanning for web vulnerabilities, spidering websites, install 3rd party
repositories of exploits and/or payloads, run exploits, generating new exploits,
managing local databases, fuzzing data, and much more.

### Who is Ronin for?

* CTF players
* Bug bounty hunters
* Security Researchers
* Security Engineers
* Developers
* Students

### What does Ronin provide?

* A toolkit of useful commands.
* A fully-loaded Ruby REPL.
* An ecosystem of high-quality security related Ruby libraries, API, and
  commands.

### What can you do with Ronin?

* Quickly process and query various data using the `ronin` commands.
* Efficiently work with code and data in the `ronin irb` Ruby REPL.
* Rapidly prototype Ruby scripts using [ronin-support] and other `ronin`
  libraries.
* Install 3rd-party [git] repositories of exploits, payloads, or other code,
  using [ronin-repos].
* Import and query data using the [ronin-db] database.
* Fuzz data using [ronin-fuzzer].
* Use common payloads or write your own using [ronin-payloads].
* Write/run exploits using [ronin-exploits].
* Scan for web vulnerabilities using [ronin-vulns].

## Synopsis

```
Usage: ronin [options] [COMMAND [ARGS...]]

Options:
    -h, --help                       Print help information

Arguments:
    [COMMAND]                        The command name to run
    [ARGS ...]                       Additional arguments for the command

Commands:
    asn
    banner-grab
    bitflip
    cert-dump
    cert-gen
    cert-grab
    decode, dec
    decrypt
    dns
    email-addr
    encode, enc
    encrypt
    entropy
    escape
    extract
    grep
    help
    hexdump
    highlight
    hmac
    homoglyph
    host
    http
    ip
    iprange
    irb
    md5
    netcat, nc
    new
    proxy
    public-suffix-list
    quote
    rot
    sha1
    sha256
    sha512
    strings
    tld-list
    tips
    typo
    typosquat
    unescape
    unhexdump
    unquote
    url
    xor

Additional Ronin Commands:
    $ ronin-repos
    $ ronin-db
    $ ronin-web
    $ ronin-fuzzer
    $ ronin-payloads
    $ ronin-exploits
    $ ronin-vulns
```

List ronin commands:

```shell
$ ronin help
```

View a man-page for a command:

```shell
$ ronin help COMMAND
```

Get a random tip on how to use `ronin`:

```shell
$ ronin tips
```

Open the Ronin Ruby REPL:

```shell
$ ronin irb
```

### See Also

* [ronin-repos](https://github.com/ronin-rb/ronin-repos#synopsis)
* [ronin-db](https://github.com/ronin-rb/ronin-db#synopsis)
* [ronin-web](https://github.com/ronin-rb/ronin-web#synopsis)
* [ronin-fuzzer](https://github.com/ronin-rb/ronin-fuzzer#synopsis)
* [ronin-payloads](https://github.com/ronin-rb/ronin-payloads#synopsis)
* [ronin-exploits](https://github.com/ronin-rb/ronin-exploits#synopsis)
* [ronin-vulns](https://github.com/ronin-rb/ronin-vulns#synopsis)

## Requirements

* [gcc] / [clang]
* [make]
* [git]
* [libsqlite3]
* [libxml2]
* [libxslt]
* [Ruby] >= 3.0.0
* [open_namespace] ~> 0.4
* [rouge] ~> 3.0
* [async-io] ~> 1.0
* [wordlist] ~> 1.0
* [ronin-support] ~> 1.0
* [ronin-core] ~> 0.1
* [ronin-repos] ~> 0.1
* [ronin-db] ~> 0.1
* [ronin-fuzzer] ~> 0.1
* [ronin-web] ~> 1.0
* [ronin-code-asm] ~> 1.0
* [ronin-code-sql] ~> 2.0
* [ronin-payloads] ~> 0.1
* [ronin-exploits] ~> 1.0
* [ronin-vulns] ~> 0.1

## Install

```shell
$ gem install ronin
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin/fork)
2. Clone It!
3. `cd ronin`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2006-2023 Hal Brodigan (postmodern.mod3 at gmail.com)

Ronin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin.  If not, see <https://www.gnu.org/licenses/>.

[website]: https://ronin-rb.dev/
[ronin-rb]: https://github.com/ronin-rb/

[gcc]: http://gcc.gnu.org/
[clang]: http://clang.llvm.org/
[git]: https://git-scm.com/
[make]: https://www.gnu.org/software/automake/
[libxml2]: https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home
[libxslt]: http://xmlsoft.org/libxslt/index.html
[libsqlite3]: https://www.sqlite.org/index.html
[Ruby]: https://www.ruby-lang.org
[open_namespace]: https://github.com/postmodern/open_namespace#readme
[rouge]: https://github.com/rouge-ruby/rouge#readme
[async-io]: https://github.com/socketry/async-io#readme
[wordlist]: https://github.com/postmodern/wordlist.rb#readme

[ronin-support]: https://github.com/ronin-rb/ronin-support#readme
[ronin-repos]: https://github.com/ronin-rb/ronin-repos#readme
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme
[ronin-db]: https://github.com/ronin-rb/ronin-db#readme
[ronin-fuzzer]: https://github.com/ronin-rb/ronin-fuzzer#readme
[ronin-web]: https://github.com/ronin-rb/ronin-web#readme
[ronin-code-asm]: https://github.com/ronin-rb/ronin-code-asm#readme
[ronin-code-sql]: https://github.com/ronin-rb/ronin-code-sql#readme
[ronin-payloads]: https://github.com/ronin-rb/ronin-payloads#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-vulns]: https://github.com/ronin-rb/ronin-vulns#readme
