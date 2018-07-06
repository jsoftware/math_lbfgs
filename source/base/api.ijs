NB. api

NB. =========================================================
NB. api prototype
setulb=: ('"',liblbfgs,'" setulb_ ',(IFWIN#'+'),' n *x *x *d *d *d *x *d *d *d *d *d *x *c *x *c *x *x *d')&cd
lbfgs=: ('"',liblbfgs,'" lbfgs_ ',(IFWIN#'+'),' n *x *x *d *d *d *x *d *x *d *d *d *x')&cd

setulb_z_=: setulb_jlbfgs_
lbfgs_z_=: lbfgs_jlbfgs_
