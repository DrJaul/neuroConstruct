COMMENT

   **************************************************
   File generated by: neuroConstruct v1.5.1 
   **************************************************


ENDCOMMENT


?  This is a NEURON mod file generated from a ChannelML file

?  Unit system of original ChannelML file: SI Units

COMMENT
    ChannelML file describing a synaptic mechanism
ENDCOMMENT

? Creating NMDA like synaptic mechanism, based on NEURON source impl of Exp2Syn
    

TITLE Channel: NMDA

COMMENT
    Example of an NMDA receptor synaptic mechanism, based on Maex DeSchutter 1998, Gabbiani et al, 1994
ENDCOMMENT


UNITS {
    (nA) = (nanoamp)
    (mV) = (millivolt)
    (uS) = (microsiemens)
}

    
NEURON {
    POINT_PROCESS NMDA
    RANGE tau_rise, tau_decay 
    GLOBAL total
    

    RANGE mg_conc, eta, gamma, gblock
    GLOBAL total


    RANGE i, e, gmax
    NONSPECIFIC_CURRENT i
    RANGE g, factor

}

PARAMETER {
    gmax = 0.0001873087796
    tau_rise = 1 (ms) <1e-9,1e9>
    tau_decay = 13.3333 (ms) <1e-9,1e9>
    e = 0  (mV)
mg_conc = 1.2 
              
    eta = 0.5206857564 
              
    gamma = 0.062
}


ASSIGNED {
    v (mV)
    i (nA)
    g (uS)
    factor 
    total (uS)
    gblock
}

STATE {
    A (uS)
    B (uS)
}

INITIAL {
    LOCAL tp
    total = 0
    
    if (tau_rise == 0) {
        tau_rise = 1e-9  : will effectively give a single exponential timecourse synapse
    }
    
    if (tau_rise/tau_decay > .999999) {
        tau_rise = .999999*tau_decay : will result in an "alpha" synapse waveform
    }
    A = 0
    B = 0
    tp = (tau_rise*tau_decay)/(tau_decay - tau_rise) * log(tau_decay/tau_rise)
    factor = -exp(-tp/tau_rise) + exp(-tp/tau_decay)
    factor = 1/factor
}

BREAKPOINT {
    SOLVE state METHOD cnexp
    gblock = 1 / (1+ (mg_conc * eta * exp(-1 * gamma * v)))
    g = gmax * gblock * (B - A)
    i = g*(v - e)
        

}


DERIVATIVE state {
    A' = -A/tau_rise
    B' = -B/tau_decay 
}

NET_RECEIVE(weight (uS)) {
    
    state_discontinuity(A, A + weight*factor
)
    state_discontinuity(B, B + weight*factor
)

    
    
}

