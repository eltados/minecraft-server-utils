remote='<path to world files>'
local='<path to copy of world files>'
modes='smooth-lighting,cave'
public='<path to output location>'

rsync -r $remote $local

overviewer.py --rendermodes=$modes $local $public
