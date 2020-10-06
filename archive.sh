set -x

rm -rf archive.zip
zip -Z store -r archive.zip . -x "*.DS_Store" -x "archive.sh" -x "__*" -x "_built/*" -x "*/dist/*" -x ".*" -x "*/.*" -x "*.zip"