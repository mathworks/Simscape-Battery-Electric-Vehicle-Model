# Elevation Profile

Given road grade in percent $G$,
road inclination angle $\theta$ is computed as follows.

$$ \theta = \textrm{atan} ( G/100 ) $$

Given curvilinear position $s$,
horizontal position $x$ and elevation $E$ are computed as follows.

$$ x = s \cdot \cos ( \theta ) $$

$$ E = s \cdot \sin ( \theta ) $$

For example, 100 unit distance (e.g., meters or feet) in the curvilinear distance $s$
corresponds to the following horizontal distances for various road grades.

| Grade $G$ (%) | Horizontal position $x$ | Elevation $E$ |
|---------------|-------------------------|---------------|
| 0 | 100 | 0 |
| 1 | 99.995 | 0.99995 |
| 2 | 99.980 | 1.9996 |
| 3 | 99.955 | 2.9987 |
| 5 | 99.875 | 4.9938 |
| 7 | 99.756 | 6.9829 |
| 10 | 99.504 | 9.9504 |
| 15 | 98.894 | 14.834 |
| 20 | 98.058 | 19.612 |
| 30 | 95.783 | 28.735 |
| 40 | 92.848 | 37.139 |




---

Curvilinear speed $V_s(x)$

Elevation $E$


---

The Road Profile block in Simscape Driveline

- https://www.mathworks.com/help/sdl/ref/roadprofile.html

Parameters

- Horizontal distance for vertical profile
- Vertical profile
- Profile interpolation method

_Copyright 2026 The MathWorks, Inc._
