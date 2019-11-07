# flying-inverted-pendulum
Matlab simulation of a flying inverted pendulum. The implementation is based on M. Hehn and R. D’Andrea "A Flying Inverted Pendulum". The simulation consists of a script for initializing the simulation and finding the LQR gains, a Simulink simulation of the quadrotor + pendulum dynamics and a script for animating and plotting the simulation results. 

## Results
### Constant position regulation
![Result](results/fip3.gif)

| | | |
|:-------------------------:|:-------------------------:|:-------------------------:|
|<img width="1604" src="results/fip4.gif">  xz |  <img width="1604" src="results/fip5.gif"> yz|<img width="1604" src="results/fip6.gif"> xy|

![Attitude](results/att.png)
![Quadrotor position](results/x.png)
![Pole position](results/rs.png)

![Result](results/fip2.gif)
Constant position regulation with sinusoidal input

### Circular trajectory tracking
Coming soon
