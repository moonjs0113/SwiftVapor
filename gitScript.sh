clear
echo $1
git add .
git status
git commit -m "{$1}"
git push origin main
