(
SynthDef('wrprevm', {|out, rate, start, wrp, freq, wsize, dens, randr,
		room, rtime, ramp, damp, iamp, buf, amp, wamp, azim, elev |
	var input, warpsig, revsig, w, x, y;
	input = PlayBuf.ar(1, buf, rate, 1, start * BufFrames.kr(buf), 1);
	warpsig = Warp0.ar(
		buffer: buf,
		warpFactor: [wrp, wrp*15/16],
		freqScale: freq,
		windowSize: wsize,
		overlaps: dens,
		windowRandRatio: randr
	);
	revsig = GVerb.ar(warpsig, room, rtime,
		drylevel: damp, earlyreflevel: ramp * 0.5, taillevel: ramp);
	#w, x, y = PanB.ar(input * iamp, azim, elev) + BiPanB2.ar(revsig[0] * amp, revsig[1] * amp, azim/pi)
	+ PanB.ar(warpsig * wamp, azim, elev);
	Out.ar(out, LeakDC.ar(DecodeB2.ar(2, w, x, y)));
}).add;


SynthDef('revwrpm', {|out, rate, start, wrp, freq, wsize, dens, randr,
		room, rtime, ramp, damp, iamp, wamp, buf, amp, azim, elev|
	var input, warpsig, revsig, w, x, y;
	input = PlayBuf.ar(1, buf, rate, 1, start * BufFrames.kr(buf), 1);
	revsig = GVerb.ar(input, room, rtime,
		drylevel: damp, earlyreflevel: ramp * 0.5, taillevel: ramp);
	warpsig = WarpIn.ar(
		in: revsig,
		buffer: LocalBuf(BufFrames.kr(buf) * (1.0 / wrp), 2),
		warpFactor: [wrp, wrp*15/16],
		freqScale: freq,
		windowSize: wsize,
		overlaps: dens,
		windowRandRatio: randr
	);
	#w, x, y = PanB.ar(input * iamp, azim, elev) + BiPanB2.ar(revsig[0] * amp, revsig[1] * amp, azim/pi)
	+ PanB.ar(warpsig * wamp, azim, elev);
	Out.ar(out, LeakDC.ar(DecodeB2.ar(2, w, x, y)));
}).add;

)

(
~wrp0 = Synth.tail(~matrix.group, 'wrprevm', ['out', 0, 'rate', 1, 'start', 0, 'wrp', 0.1, 'freq', 1.0, 'wsize', 0.1, 'dens', 6, 'randr', 0.03, 'room', 100, 'rtime', 6.0, 'ramp', 0.1, 'damp', 0, 'iamp', 0.0, 'buf', ~gesbufs[36], 'amp', 0.0, 'wamp', 0.0]);

Pdef('swrp0',
	Pbind(
		\type, \set, \id, ~wrp0.nodeID, \delta, Pn(0.2, inf),
		\azim, Pwhite(-pi, pi, inf),
		\elev, Pbrown(-0.5pi, 0.5pi, 0.1pi, inf),
		\args, #[azim, elev]
	)
).play
)

~wrp0.set('amp', 1.0, 'wamp', 0.0, 'iamp', 1.0, 'ramp', 0.0, 'rate', 1.0, 'freq', 1.0, 'wrp', 0.1)

~wrp0.free; Pdef('swrp0').clear

(
~wrp2 = Synth.tail(~matrix.group, 'revwrpm', ['out', 0, 'rate', 1, 'start', 0, 'wrp', 0.1, 'freq', 1.0, 'wsize', 0.1, 'dens', 6, 'randr', 0.03, 'room', 100, 'rtime', 6.0, 'ramp', 0.1, 'damp', 0, 'iamp', 0.0, 'buf', ~gesbufs[11], 'amp', 0.0, 'wamp', 0.0]);

Pdef('swrp2',
	Pbind(
		\type, \set, \id, ~wrp2.nodeID, \delta, Pn(0.5, inf),
		\azim, Pseq([-pi, pi], inf),
		\elev, Pbrown(-0.5pi, 0.5pi, 0.1pi, inf),
		\args, #[azim, elev]
	)
).play
)

~wrp2.set('amp', 1.0, 'wamp', 0.0, 'iamp', 0.7, 'ramp', 0.0, 'rate', 1.0, 'freq', 1.0, 'wrp', 0.1)

~wrp2.free; Pdef('swrp2').clear

