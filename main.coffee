# FPU model
 # $\ddot{x} =  x_{k+1}-2x_k+x_{k-1} + \alpha \left( (x_{k+1}-x_k)^2 - (x_{k-1}-x_k)^2 \right)$

n = 16  # Number of springs (try 8 or 32)

# Mass displacements (from rest) and velocity.

fig = $blab.massFigure  # Imported figure/plot function (click to view)
    n: n
    height: 200
    yaxes: [
        {pos: "left", min: -2, max: 4, color: "blue"}  # displacement
        {pos: "right", min: -1, max: 2, color: "red"} # velocity
    ]

 # <a href="http://goo.gl/QWHlFR">FPU state equations</a>
fpu = (t, x, a) -> # expressed as first order system
    L = (x[k+1]-2*x[k]+x[k-1] for k in [1...n])
    N = a*((x[k+1]-x[k]).pow(2)-(x[k-1]-x[k]).pow(2) for k in [1...n])
    [0].concat(x[n+2...2*n+1]).concat([0, 0]).concat(L+N).concat([0])

# Runge Kutta
{rk, ode} = $blab.ode #; Imported RK functions (click to view)
numSnapshots = 500
h = 0.1 # integration step
ts = [0..numSnapshots]*h #; time
x0 = sin(linspace(0,2*pi,n+1)).concat((0 for [1..n+1])) #; Initial cond.
x = ode(rk[4], fpu, ts, x0, 0.25) #;

    # Imported d3 visualization (click to view).
springsAndMasses = new $blab.SpringsAndMasses("ms_container", n) #;

# i-th snapshot of springs/masses position.
snapshot = (i) ->
    disp = x[i][0..n] # displacement
    vel = x[i][n+1..2*n+2] # velocity
    # Plot in Eval (top right), every 5th snapshot
    $blab.massPlot [0..n], disp, vel, fig unless i % 5
    # d3 animation
    springsAndMasses.plot(disp, abs(vel))
    i < numSnapshots-1  # Condition to continue simulation
    
# Rest position
snapshot 0

# Animate position of masses.
# Imported simulation function (click to view).
# Delayed start for MathJax initialization etc.
$blab.simulate {step: snapshot, delay: 3000} #;

