# Tank Drain Model Simulation

This repository contains a set of MATLAB scripts and functions used to simulate tank drainage processes and validate the models against experimental data. The code models the dynamics of water levels in tanks, considering the effects of different drainage coefficients (Cd), and compares simulated results with experimental data for both the top and bottom tanks.

## Code Overview

### Main Components:
1. **Load Data**: The script loads experimental validation data and prepares the time vector.
   - **Validation Data**: Loads data from `TT_DynamicValidationData_1.txt` for model validation. The data contains measurements for top tank height, bottom tank height, and voltage command over time.

2. **Modeling**:
   - **CP5_Model1**: Defines a linear resistance model to simulate the top and bottom tank dynamics based on given inputs and validation data. The model solves for the heights of both tanks (`Htop`, `Hbottom`) over time and calculates the root mean square error (RMSE) between the model predictions and experimental data.
   - **Top Tank Drain and Bottom Tank Drain**: These sections simulate the drainage of water from the top and bottom tanks using ODEs (Ordinary Differential Equations) and compare the simulation results with experimental data for different Cd values.
   
3. **Optimization**:
   - **optimize_model3**: An optimization function that uses `fminsearch` to find the best-fitting parameters for the model by minimizing the difference between experimental data and model predictions.

### Input Files
- `TT_DynamicValidationData_1.txt`: Contains experimental data for model validation (top tank height, bottom tank height, and command voltage over time).
- `TT_TopTankDrain_0.295in_3.txt`: Contains experimental data for top tank drainage.
- `TT_BottomTankDrain_10mm_4.txt`: Contains experimental data for bottom tank drainage.

### Functions:
- **TopOde**: ODE function for simulating the drainage of the top tank.
- **BottomOde**: ODE function for simulating the drainage of the bottom tank.
- **expfun**: Internal function used by the optimization routine to calculate the error between experimental and simulated data.

### Output:
- The simulation results include:
  - Plots comparing experimental data with model predictions for top and bottom tank heights.
  - RMSE values for both top and bottom tanks as an indicator of the model's accuracy.
  - Optimization results for best-fitting parameters.
