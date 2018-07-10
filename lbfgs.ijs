coclass 'jlbfgs'
3 : 0''
if. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  liblbfgs=: (jpath'~bin/../libexec/android-libs/',arch,'/liblbfgs.so')
else.
  ext=. (('Darwin';'Linux') i. <UNAME) pick ;:'dylib so dll'
  liblbfgs=: jpath '~addons/math/lbfgs/lib/',(IFRASPI#'raspberry/'),'liblbfgs',((-.IF64)#'_32'),'.',ext
end.
)
binreq=: 100
relreq=: 807
checklibrary=: 3 : 0
if. +./ IFIOS,(-.IF64),UNAME-:'Android' do.
  sminfo 'L-BFGS';'The math/lbfgs addon is not available for this platform.' return.
end.
if. -. fexist liblbfgs do.
  getbinmsg 'The math/lbfgs binary has not yet been installed.',LF2,'To install, ' return.
end.
)
getbin=: 3 : 0
if. +./ IFIOS,(-.IF64),UNAME-:'Android' do. return. end.
require 'pacman'
path=. 'http://www.jsoftware.com/download/lbfgsbin/',(":relreq),'/'
arg=. HTTPCMD_jpacman_
tm=. TIMEOUT_jpacman_
dq=. dquote_jpacman_ f.
to=. liblbfgs_jlbfgs_
if. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  fm=. path,'android/libs/',z=. arch,'/liblbfgs.so'
  'res p'=. httpget_jpacman_ fm
  if. res do.
    smoutput 'Connection failed: ',z return.
  end.
  (<to) 1!:2~ 1!:1 <p
  2!:0 ::0: 'chmod 644 ', dquote to
  1!:55 ::0: <p
  smoutput 'L-BFGS binary installed.'
  return.
end.
fm=. path,(IFRASPI#'raspberry/'),1 pick fpathname to
lg=. jpath '~temp/getbin.log'
cmd=. arg rplc '%O';(dquote to);'%L';(dquote lg);'%t';'3';'%T';(":tm);'%U';fm
res=. ''
fail=. 0
try.
  fail=. _1-: res=. shellcmd cmd
  2!:0 ::0:^:(UNAME-:'Linux') 'chmod 644 ', dquote to
catch. fail=. 1 end.
if. fail +. 0 >: fsize to do.
  if. _1-:msg=. freads lg do.
    if. (_1-:msg) +. 0=#msg=. res do. msg=. 'Unexpected error' end. end.
  ferase to,lg
  smoutput 'Connection failed: ',msg
else.
  ferase lg
  smoutput 'L-BFGS binary installed.'
end.
)
getbinmsg=: 3 : 0
msg=. y,' run the getbin_jlbfgs_'''' line written to the session.'
smoutput '   getbin_jlbfgs_'''''
sminfo 'L-BFGS';msg
)
shellcmd=: 3 : 0
if. IFUNIX do.
  hostcmd_j_ y
else.
  spawn_jtask_ y
end.
)
setulb=: ('"',liblbfgs,'" setulb_ ',(IFWIN#'+'),' n *x *x *d *d *d *x *d *d *d *d *d *x *c *x *c *x *x *d')&cd
lbfgs=: ('"',liblbfgs,'" lbfgs_ ',(IFWIN#'+'),' n *x *x *d *d *d *x *d *x *d *d *d *x')&cd

setulb_z_=: setulb_jlbfgs_
lbfgs_z_=: lbfgs_jlbfgs_
checklibrary$0
cocurrent 'base'
