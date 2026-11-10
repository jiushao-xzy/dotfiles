wget https://github.com/lxgw/LxgwWenKai/releases/download/v1.522/lxgw-wenkai-v1.522.tar.gz
tar -xf lxgw-wenkai-v1.522.tar.gz
rm lxgw-wenkai-v1.522.tar.gz

git clone https://github.com/fontmgr/MesloLGSNF.git
mv MesloLGSNF/fonts fonts
rm -rf  MesloLGSNF
mv fonts MesloLGSNF


wget https://github.com/be5invis/Sarasa-Gothic/releases/download/v1.0.40/Sarasa-SuperTTC-1.0.40.7z
7z x Sarasa-SuperTTC-1.0.40.7z
mkdir Sarasa
mv Sarasa-SuperTTC.ttc Sarasa
rm Sarasa-SuperTTC-1.0.40.7z

 # Noto Color Emoji（补 emoji 字形，如 dsh-tui 终端标题里的 🐋）
wget -O noto-emoji.pkg.tar.zst https://mirrors.tuna.tsinghua.edu.cn/archlinux/extra/os/x86_64/noto-fonts-emoji-1%3A20260924-1-any.pkg.tar.zst
tar --zstd -xf noto-emoji.pkg.tar.zst usr/share/fonts/noto/NotoColorEmoji.ttf
mv usr/share/fonts/noto/NotoColorEmoji.ttf .
rm -rf usr noto-emoji.pkg.tar.zst
