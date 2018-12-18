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
setulb=: ('"',liblbfgs,'" setulb_ ',(IFWIN#'+'),' n &x &x &d &d &d &x &d &d &d &d &d &x &c &x &c &x &x &d')&cd
lbfgs=: ('"',liblbfgs,'" lbfgs_ ',(IFWIN#'+'),' n *x *x *d *d *d *x *d *x *d *d *d *x')&cd

setulb_z_=: setulb_jlbfgs_
lbfgs_z_=: lbfgs_jlbfgs_
'ITERCT N M X LB UB NBH F G FACTR PGTOL WA IWA TASK IPRINT CSAVE LSAVE ISAVE DSAVE'=: i. 19
lbfgsmin=: 1 : 0
lbfgsret_jlbfgs_ @: (((exeulb_jlbfgs_ @: ((F,G)}~ (0}~ ,&.>@:{.) @: u @: (X&{::))) ` (exeulb_jlbfgs_) `]) @.(('FG',:'NE') i. 2 {. TASK&{::)^:_) @: lbfgssetup_jlbfgs_ "1
)
exeulb=: >:&.>@:{. 0} (setulb_jlbfgs_ @: }.)

DEFAULTS=: 7;1e7;(2-2);_1
lbfgssetup=: 3 : 0
(0$a:) lbfgssetup y
:
if. 32 = 3!:0 y do. 'initvals bounds'=. 2 {. y
else. bounds=. __ _ #"0~ #initvals=. y
end.
assert. ($bounds) -: 2 ,~ $initvals [ 'bounds length error'
x=. boxxopen x
assert. 5 > #x [ 'parms length error'
assert. #@> x [ 'parms not scalars'
'corr termeps gradeps debug'=. (a:&= {"0 1 ,.&DEFAULTS) 4 {. x
n=. #initvals
m=. 3 >. <. corr
dataarea=. < ,n
dataarea=. dataarea , < 15!:15 ,m
dataarea=. dataarea , < 15!:15 initvals
dataarea=. dataarea , <"(1) 15!:15 bounds
dataarea=. dataarea , < 15!:15 (0 1 3 2) {~ +/ 2 1 * __ _ ~: bounds
dataarea=. dataarea , < 15!:15 ,2.2-2.2
dataarea=. dataarea , < 15!:15 n$2.2-2.2
dataarea=. dataarea , < 15!:15 ,termeps+2.2-2.2
dataarea=. dataarea , < 15!:15 ,gradeps+2.2-2.2
dataarea=. dataarea , < 15!:15 ((n*(2*m)+5) + m * 8 + 11 * m)$2.2-2.2
dataarea=. dataarea , < 15!:15 (3*n)$2-2
dataarea=. dataarea , < 15!:15 (60){.'START'
dataarea=. dataarea , < 15!:15 ,_1
dataarea=. dataarea , < 15!:15 (60) # ' '
dataarea=. dataarea , < 15!:15 (4) # 2-2
dataarea=. dataarea , < 15!:15 (44) # 2-2
dataarea=. dataarea , < 15!:15 (29) # 2.2-2.2
if. 0 {:: dataarea=. setulb dataarea do. 'Error executing setulb in lbfgsmin' 13!:8 (8) end.
(<0) 0} dataarea
)
lbfgsret=: 3 : 0
('CO' -.@:-: 2 {. TASK {:: y);(X{::y);({.F{::y);TASK{::y
)

lbfgsmin_z_=: lbfgsmin_jlbfgs_
checklibrary$0
cocurrent 'base'
