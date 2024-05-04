#frfr="/users/juancho/frfx/dwld/hola 1/hola2/hola 3"
#frfr2="/users/juancho/frfx/dwld/hola 1/hola2/hola 3/hola4"
#var00="${frfr%/*}"
#var01="${frfr##/*/}"
#var02="${frfr2%/*}"
#var03="${frfr2##/*/}"
xfrfr="/users/juancho/frfx/dwld/hola 1/hola2/hola 3"
xfrfr2="/users/juancho/frfx/dwld/hola 1/hola2/hola 3/hola4"
xvar00="$(dirname "$xfrfr")"
xvar01="$(basename "$xfrfr")"
xvar02="$(dirname "$xfrfr2")"
xvar03="$(basename "$xfrfr2")"


echo $xvar00
echo $xvar01
echo $xvar02
echo $xvar03
