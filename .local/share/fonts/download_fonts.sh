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

