s.boot

~paths = "/home/pi/snd/*".pathMatch.keep(11);

~bufs = ~paths.collect({|path| Buffer.read(s, path) })

~bufs.collect(_.duration).do(_.postln)


SynthDef(\bitSt2, {|out, efx, amp, emp, buf, dur|
	var sig;
	sig = Normalizer.ar(
		PlayBuf.ar(2, buf, BufRateScale.ir(buf) * 1.neg, 1, BufFrames.kr(buf)),
		amp) * EnvGen.kr(\env.kr(Env.newClear(8).asArray), timeScale: dur, doneAction: 2);
	Out.ar(out, sig * amp)
}).add;

Synth(\bitSt2, ['out', 0, 'efx', 512, 'amp', rrand(0.4, 1.0), 'emp', 0.0, 'buf', ~bufs.choose, 'dur', exprand(1.0, 2.0), 'env', [Env.perc, Env.sine].choose] );


Tdef('tex', {
	10.do({
		Synth(\bitSt2, ['out', ~decoder.bus, 'efx', 512, 'amp', rrand(0.4, 1.0), 'emp', 0.0, 'buf', ~matrix.buffers['evo'][rrand(50, 45)], 'dur', exprand(0.3, 0.7), 'env', [Env.perc, Env.sine].choose] );
		rrand(0.1, 0.4).wait
	})
})
.play


SynthDef('revwrpm', {|out, rate, start, wrp, freq, wsize, dens, randr,
		room, rtime, ramp, damp, iamp, wamp, buf, amp, rx, ry, rz |
	var input, warpsig, revsig, bf;
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
	bf = FoaEncode.ar(input * iamp, FoaEncoderMatrix.newDirection) +
	FoaEncode.ar(revsig * amp, FoaEncoderMatrix.newStereo) +
	FoaEncode.ar(warpsig * wamp, FoaEncoderMatrix.newStereo);
	bf = FoaTransform.ar(bf, 'focus', pi/3);
	bf = FoaTransform.ar(bf, 'rtt', rx, ry, rz);
	Out.ar(out, LeakDC.ar(bf));
}).add;



(
~wrp0 = Synth.tail(~matrix.group, 'wrprevm', ['out', ~decoder.bus, 'rate', 1, 'start', 0, 'wrp', 0.1, 'freq', 1.0, 'wsize', 0.1, 'dens', 6, 'randr', 0.03, 'room', 100, 'rtime', 6.0, 'ramp', 0.1, 'damp', 0, 'iamp', 0.0, 'buf', ~gesbufs[36], 'amp', 0.0, 'wamp', 0.0, 'rx', 0, 'ry', 0, 'rz', 0]);

Pdef('swrp0',
	Pbind(
		\type, \set, \id, ~wrp0.nodeID, \delta, Pn(0.2, inf),
		\rx, Pbrown(0, 2pi, 0.125pi, inf),
		\ry, Pbrown(0, 2pi, 0.125pi, inf),
		\rz, Pbrown(0, 2pi, 0.125pi, inf),
		\args, #[rx, ry, rz]
	)
).play
)

~wrp0.set('amp', 1.0, 'wamp', 0.0, 'iamp', 0.0, 'ramp', 0.0, 'rate', 1.0, 'freq', 1.0, 'wrp', 0.1)

~wrp0.free; Pdef('swrp0').clear
