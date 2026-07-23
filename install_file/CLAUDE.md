# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库性质

这是一个 Arch Linux PKGBUILD 集合，每个子目录是一个独立的 AUR/本地软件包构建目录。仓库本身**不是** git 仓库（只有 `claude-code/` 子目录内嵌了 `.git`），各包之间相互独立，没有共享构建系统。

## 常用命令

每个包目录内使用标准 `makepkg` 工作流：

```bash
# 在某个包目录（如 claude-code/）内
makepkg -sf              # 构建并安装（含依赖安装、强制重建）
makepkg -o               # 仅执行 prepare()/build()，解压源码到 src/
makepkg -e               # 仅重新执行 package()，复用已有 src/
makepkg -g >> PKGBUILD   # 重新生成校验和（更新 source 后用）
makepkg --printsrcinfo > .SRCINFO   # 重新生成 .SRCINFO
namcap PKGBUILD          # 静态检查 PKGBUILD 规范
namcap <pkg>-<ver>-*.pkg.tar.zst   # 检查构建产物
```

`claude-code/update-version.sh` 是专用于该包的版本 bumps 脚本：从 `downloads.claude.ai` 抓取 `latest` 版本号和 manifest.json 中的 SHA256，更新 PKGBUILD 的 `pkgver`/`pkgrel`/`sha256sums_*`，并重新生成 `.SRCINFO`。需要 `jq` 和 `curl`。

## 包分类与构建特点

| 子目录 | 类型 | 关键点 |
|--------|------|--------|
| `dwm/` | 源码编译 (suckless) | 本地 fork：`src/config.h` 在 `prepare()` 中覆盖上游 config.h；`patches/dwm-autostart-*.diff` 是自定义补丁；产物含 xsessions desktop 文件 |
| `waybar/` | 源码编译 (meson) | 应用本地补丁 `src/lua-ipc-trimmed.patch`；`-Dexperimental=true`、`-Dcava=disabled`；`backup()` 中声明了两个配置文件 |
| `claude-code/` | 二进制重打包 | 下载预编译的 Bun 单文件可执行；`package()` 写一个 `DISABLE_AUTOUPDATER=1` 的 wrapper；`options=('!strip')` 否则会破坏嵌入的 JS/resources |
| `anylisten/` | 二进制重打包 | 直接下载上游 `.pacman` 包，`package()` 仅 `cp -r opt/ usr/` |
| `baidunetdisk/` | deb 重打包 | 解 `data.tar.xz`，应用 desktop 文件补丁，注入中文 Name，移动 `/opt` 到 `/usr/lib` |
| `zotero/` | tarball 重打包 | 解压到 `/opt/zotero`，`/usr/bin/zotero` 为符号链接，安装多尺寸图标 |
| `wechat/`、`qq/` | AppImage 重打包 | `prepare()` 用 `--appimage-extract` 解压；**注意**解压出的 `squashfs-root` 目录权限为 700，必须 `find ... -exec chmod 755` 后才能复制到系统；`package()` 生成 `/usr/bin/<pkg>` wrapper 调用 `/opt/<pkg>/AppRun` |

## 编辑约定

- 修改 `wechat`/`qq` 这类 AppImage 包时，`pkgname` 在多处 sed/heredoc 中硬编码（如 `Icon=/opt/qq/qq.png`、`Exec=/opt/wechat/AppRun`），不要假设 `${pkgname}` 已被一致使用——改名时需手工核对每处字面量。
- `dwm/src/config.h` 是构建输入，修改它后需 `makepkg -sf` 重建；`src/dwm/` 是解压后的源码树，不要直接编辑其中的生成文件。
- 更新版本时务必同步更新 `sha256sums`/`b2sums`；可先用 `'SKIP'` 占位再 `makepkg -g` 生成。
- `options=('!strip')` 对自包含二进制（Bun、AppImage、Electron）是必需的，删除会破坏运行时。
