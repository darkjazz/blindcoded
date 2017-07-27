b = Bc()

Wrp(\w0, 36)
Wrp(\w0, 36)

Wrp.set(\w0, \iamp, 1.0)
Dj.amp(\r0, 0.5, 1.0)
Dj.dur(\r0, 0.1, 0.4)

Dj.on(\r0, 0.1)
Dj.dur(\r0, 0.01, 0.1)

Dj.dur(\b4, 2.0, 4.0)
Dj.amp(\b4, 0.3, 0.6)

Dj.on(\b4, 0.3)
Dj.dur(\r0, 0.1, 0.5)

Wrp.free(\w0)
Dj.dur(\b4, 1.0, 2.0)
Dj.recall(\b4)
Wrp(\w1, 0)
Wrp.set(\w1, \ra, 1.0)


Pb(\a, \bf, Pw(1, 4, 3))
Pb(\a, \am, Pw(0.3, 1.5))
Pb.on(\a, \dr, Pw(0.3, 1.0))

Dj.off(\r0)
Dj.off(\b4)
Wrp.free(\w1)