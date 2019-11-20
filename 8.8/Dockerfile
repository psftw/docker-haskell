## Dockerfile for a haskell environment
FROM       debian:stretch

## ensure locale is set during build
ENV LANG            C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg ca-certificates dirmngr curl git && \
    rm -rf /var/lib/apt/lists/*

## embed GHC Debian package and Stack signing keys
ADD *_KEYS /

RUN apt-key add DEB_KEYS && \
    echo 'deb http://downloads.haskell.org/debian stretch main' > /etc/apt/sources.list.d/ghc.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends ghc-8.8.1 cabal-install-3.0 \
        zlib1g-dev libtinfo-dev libsqlite3-dev g++ netbase xz-utils make openssh-client && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fSL https://github.com/commercialhaskell/stack/releases/download/v2.1.3/stack-2.1.3-linux-x86_64.tar.gz -o stack.tar.gz && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v2.1.3/stack-2.1.3-linux-x86_64.tar.gz.asc -o stack.tar.gz.asc && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --import STACK_KEYS && \
    gpg --batch --trusted-key 0x575159689BEFB442 --verify stack.tar.gz.asc stack.tar.gz && \
    tar -xf stack.tar.gz -C /usr/local/bin --strip-components=1 && \
    /usr/local/bin/stack config set system-ghc --global true && \
    /usr/local/bin/stack config set install-ghc --global false && \
    rm -rf "$GNUPGHOME" /stack.tar.gz.asc /stack.tar.gz

ENV PATH /root/.cabal/bin:/root/.local/bin:/opt/cabal/3.0/bin:/opt/ghc/8.8.1/bin:$PATH

## run ghci by default unless a command is specified
CMD ["ghci"]
