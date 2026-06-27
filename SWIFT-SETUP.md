# Установка Swift на Linux

Документ описывает, **как именно был установлен Swift в этом окружении** (CachyOS,
Arch-подобный дистрибутив, без root-доступа), и какие есть **альтернативы** для
других случаев. Для запуска кода из `task-1/` нужен Swift 5.9+.

---

## TL;DR — что в итоге сработало здесь

Среда: CachyOS (Arch-based), `glibc 2.43`, x86_64, **без passwordless sudo**.
Готовых пакетов/менеджеров не подошло, поэтому распаковали официальный tarball
в домашний каталог и доставили пару системных библиотек симлинками.

```bash
# 1. Скачать официальный тулчейн (сборка под Ubuntu 22.04 — совместима по glibc)
curl -fSL -o /tmp/swift.tar.gz \
  https://download.swift.org/swift-6.0.3-release/ubuntu2204/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE-ubuntu22.04.tar.gz

# 2. Распаковать в $HOME (без root)
mkdir -p ~/swift-toolchain
tar xzf /tmp/swift.tar.gz -C ~/swift-toolchain --strip-components=1

# 3. Доставить недостающие библиотеки симлинками (Arch именует их иначе)
mkdir -p ~/swift-libs
ln -sf /usr/lib/libncursesw.so.6 ~/swift-libs/libncurses.so.6   # нужен swiftc
ln -sf /usr/lib/libxml2.so.16     ~/swift-libs/libxml2.so.2      # нужен SwiftPM (swift run)

# 4. Прописать пути (можно добавить в ~/.zshrc / ~/.bashrc)
export PATH="$HOME/swift-toolchain/usr/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/swift-libs:/usr/lib"

# 5. Проверить
swiftc --version          # Swift version 6.0.3 (swift-6.0.3-RELEASE)
```

Запуск проекта:

```bash
cd task-1
swift run                                   # SwiftPM: соберёт пакет и запустит
# или без SwiftPM:
swiftc Sources/Zoo/*.swift -o zoo && ./zoo
```

> Предупреждения вида `libxml2.so.2: no version information available` —
> безвредны: это лишь несовпадение версионных символов, модуль Foundation XML
> в проекте не используется.

---

## Почему именно так (что не сработало)

| Способ | Результат здесь | Причина |
| --- | --- | --- |
| **swiftly** (офиц. менеджер тулчейнов) | ❌ `Unable to find release information from /etc/os-release` | Поддерживает только Ubuntu/Debian/Fedora/RHEL/Amazon Linux; CachyOS (`ID=cachyos`) не распознаётся |
| **AUR-пакет** (`paru -S swift-bin`) | ❌ | `paru` требует `sudo` для установки, а passwordless sudo недоступен |
| **Официальный tarball + симлинки** | ✅ | Полностью userspace, root не нужен |

Конкретные недостающие библиотеки на Arch/CachyOS:
- `libncurses.so.6` → в системе есть `libncursesw.so.6` (wide-вариант) — симлинк решает;
- `libxml2.so.2` → в системе `libxml2.so.16` (новый ABI) — симлинк работает с предупреждениями.

---

## Альтернативы по дистрибутивам

### 1. swiftly — рекомендуемый официальный путь (Ubuntu/Debian/Fedora/RHEL/Amazon Linux)

Менеджер тулчейнов Swift (как `rustup` для Rust). Ставит и переключает версии,
не требует root.

```bash
curl -O https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz
tar zxf swiftly-$(uname -m).tar.gz
./swiftly init                # скачает последний release toolchain
. ~/.local/share/swiftly/env.sh
swiftly install latest        # или конкретную версию: swiftly install 6.0.3
swift --version
```

> На Arch/CachyOS `swiftly init` падает на чтении `/etc/os-release` — используйте tarball (TL;DR выше) или Docker.

### 2. Arch / CachyOS — через AUR (нужен sudo)

```bash
paru -S swift-bin        # бинарный пакет: распаковывает офиц. tarball и патчит под Arch
# или
yay -S swift-bin
```

`swift-bin` сам подтягивает зависимости (ncurses, libxml2 и т.д.) — чище, чем ручные
симлинки, но требует прав на установку пакетов.

### 3. Docker — кросс-дистрибутивно, без засорения системы

Самый простой способ получить чистое окружение на любом Linux:

```bash
# Разовый запуск симуляции в контейнере с примонтированным репозиторием
docker run --rm -it -v "$PWD":/work -w /work/task-1 swift:6.0.3 swift run

# Или интерактивно
docker run --rm -it -v "$PWD":/work -w /work swift:6.0.3 bash
```

Образы: `swift:latest`, `swift:6.0.3`, `swift:5.10` и т.д. на Docker Hub.

### 4. Ubuntu/Debian — официальный tarball вручную

```bash
# Зависимости рантайма
sudo apt-get install -y binutils libc6-dev libcurl4 libedit2 libgcc-9-dev \
  libpython3 libsqlite3-0 libstdc++-9-dev libxml2 libz3-dev pkg-config \
  tzdata zlib1g-dev

curl -fSL -O https://download.swift.org/swift-6.0.3-release/ubuntu2204/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE-ubuntu22.04.tar.gz
tar xzf swift-6.0.3-RELEASE-ubuntu22.04.tar.gz
export PATH="$PWD/swift-6.0.3-RELEASE-ubuntu22.04/usr/bin:$PATH"
```

### 5. Fedora / RHEL

```bash
sudo dnf install swift-lang      # в репозиториях Fedora
# либо swiftly / официальный tarball для соответствующей версии ОС
```

---

## Полезные ссылки

- Установка Swift на Linux: <https://www.swift.org/install/linux/>
- Все сборки и версии: <https://www.swift.org/download/>
- swiftly: <https://www.swift.org/swiftly/>
- Docker-образы: <https://hub.docker.com/_/swift>

---

## Удаление (для userspace-установки из TL;DR)

```bash
rm -rf ~/swift-toolchain ~/swift-libs
# и убрать строки export PATH/LD_LIBRARY_PATH из ~/.zshrc (~/.bashrc)
```
