% Main File
% Producing a part with online control

clear; close all;clc

rng(12)

global L nsam 

nsam = 1000;
nrepeat = 1;

%% Parameters

V = 60;
f = 0.058;
Din = 100;
Df = 98;
L = 100;
theta = 15;

global lower_limit upper_limit

lower_limit = 97.98;
upper_limit = 98.02;

comp_std = 0.0005; 
sensor_dia = 0.0025;
timestep = 0.25;

theta_std = 0.1;

comp = 0.9*0.5*(Df-lower_limit);

kw = 8.2961e-5;
alphaw_mean = 2.747;
betaw_mean = 1.473;
gammaw = 1.261;
sigmaw = 0.43;

alphaw_std = 0.01*alphaw_mean;
betaw_std = 0.01*betaw_mean;

alphaw_true = normrnd(alphaw_mean, alphaw_std, nrepeat, 1);
betaw_true = normrnd(betaw_mean, betaw_std, nrepeat, 1);
kw_true = normrnd(kw, 0.01*kw, nrepeat, 1);
gammaw_true = normrnd(gammaw, 0.01*gammaw, nrepeat, 1);
sigmaw_true = normrnd(sigmaw, 0.01*sigmaw, nrepeat, 1);

theta_true = normrnd(theta, theta_std, nrepeat, 1);

Relcomm = 0.95;
RelResource = 0.96;
Rel_fail = 0.9;


%% Calculate wear per time step

depth = DepthCut(Din, Df, comp);
timepart = TimePart(Din, depth, L, V, f); % time in sec

ntimesteps = ceil(timepart/timestep);

%% Generate samples (wear)

alphaw_sam = zeros(nsam, ntimesteps+2);
betaw_sam = zeros(nsam, ntimesteps+2);

alphaw_sam(:,1) = normrnd(alphaw_mean, alphaw_std, nsam, 1);
betaw_sam(:,1) = normrnd(betaw_mean, betaw_std,nsam,1);

%% 

depth = DepthCut(Din, Df, comp);
timepart = TimePart(Din, depth, L, V, f);

diameter_true = cell(nrepeat,1);

length_repeat = cell(nrepeat,1);
wear_repeat = cell(nrepeat,1);
comp_repeat = cell(nrepeat,1);
drift_repeat = cell(nrepeat,1);

for k=1:nrepeat
    
    %% Initialize variables
    tstep = zeros(ntimesteps+1,1);
    tstep(1:ntimesteps-1) = timestep;
    tstep(ntimesteps) = timepart - (ntimesteps-1)*tstep(1);
    tstep(ntimesteps+1) = timepart - (ntimesteps-1)*tstep(1);

    diameterfinal_step = zeros(nsam,ntimesteps+1);
    wear_step = zeros(nsam, ntimesteps+1);
    drift_step = zeros(ntimesteps+1,1);

    length_step = zeros(1,ntimesteps+1);
    time_step = zeros(1, ntimesteps+1);
    postwear = zeros(nsam, ntimesteps+1);
    comp_step = zeros(1,ntimesteps+1);
    depth_step = zeros(1,ntimesteps+1);
    twi_step = zeros(nsam, ntimesteps+1);
    
    comp_step_true = zeros(1,ntimesteps+1);
    depth_step_true = zeros(1, ntimesteps+1);
    length_step_true = zeros(1, ntimesteps+1);

    comp_step_true(1) = comp + normrnd(0,comp_std,1,1);
    depth_step_true(1) = DepthCut(Din, Df, comp_step_true(1));
    
    
    comp_step(1) = comp;
    depth_step(1) = DepthCut(Din, Df, comp_step(1));
    
    wear_step_true = zeros(1, ntimesteps+1);
    drift_step_true = zeros(1,ntimesteps+1);
    diameterfinal_step_true = zeros(1,ntimesteps+1);
    diameterfinal_step_sensor = zeros(1,ntimesteps+1);
    twi_step_true = zeros(1,ntimesteps+1);
    
    %% Computational uncertainty

    % 2  1-way communication uncertainty
    % 1 resource availability
    % The above at each timestep

    % 3 tries --> 2 success
    % 2 tries --> 1 success
    % 0 success, 1 failure

    %% Laser to Comm

    Rel_laser_computer = Relcomm*Relcomm + Relcomm*(1-Relcomm)*Rel_fail + (1-Relcomm)*Rel_fail*Relcomm; % Laser to Computer
    Rel_computer_comp = Relcomm + (1-Relcomm)*Rel_fail; % Computer to Control unit

    Rel_laser_computer_sam = randsample([0 1], ntimesteps+1, 'true',[Rel_laser_computer 1-Rel_laser_computer]);
    Rel_computer_comp_sam = randsample([0 1], ntimesteps+1, 'true',[Rel_computer_comp 1-Rel_computer_comp]);
    Rel_resource_sam = randsample([0 1], ntimesteps+1, 'true',[RelResource 1-RelResource]);

    Total_comp_rel = Rel_laser_computer_sam+Rel_computer_comp_sam+Rel_resource_sam;
    Total_calibration_rel = Rel_laser_computer_sam + Rel_computer_comp_sam;

    %% Loop through all time steps

    alphaw_sam(:,2) = alphaw_sam(:,1);
    betaw_sam(:,2) = betaw_sam(:,1);

    depth_step(2) = depth_step(1);
    comp_step(2) = comp_step(1);
    
    depth_step_true(2) = depth_step_true(1);
    comp_step_true(2) = comp_step_true(1);

    diameterfinal_step_true(1) = DiameterTurning(Df, comp_step_true(1),0);% initially there is no wear/drift
    
    %% Loop through all time steps
    % Prediction: We use the same theta
    % Observation: We use different theta
    
    diameter_total = [diameterfinal_step_true(1)];
    length_total = [0];
    
    for i=2:ntimesteps % There are ntimesteps+1, we will do the last one separately
    
        i
        
        time_step(i) = (i-1)*timestep;
        length_step(i) = length_step(i-1) + LengthWithTime(V, f, timestep, Din, depth_step(i));
        length_step_true(i) = length_step(i-1) + LengthWithTime(V, f, timestep, Din, depth_step_true(i));

        %% Step 1: Prediction

        for j=1:nsam
            twi_step(j,i) = Estimate_t_w_i(V, f, depth_step(i), wear_step(j,i-1), kw, alphaw_sam(j,i), betaw_sam(j,i), gammaw, sigmaw);
            wear_step(j,i) = WearWithTime(V,f,depth_step(i),twi_step(j,i)+timestep,kw, alphaw_sam(j,i), betaw_sam(j,i), gammaw, sigmaw);
            drift_step(j,i) = DriftWear(wear_step(j,i), pi*theta/180);
            diameterfinal_step(j,i) = DiameterTurning(Df, comp_step(i), drift_step(j,i));   
        end

        %% Step 2: Observation

        twi_step_true(i) = Estimate_t_w_i(V, f, depth_step_true(i), wear_step_true(i-1), kw_true(k), alphaw_true(k), betaw_true(k), gammaw_true(k), sigmaw_true(k));
        wear_step_true(i) = WearWithTime(V,f,depth_step_true(i),twi_step_true(i)+timestep,kw_true(k), alphaw_true(k), betaw_true(k), gammaw_true(k), sigmaw_true(k));
        drift_step_true(i) = DriftWear(wear_step_true(i), pi*theta_true(k)/180);
        diameterfinal_step_true(i) = DiameterTurning(Df, comp_step_true(i), drift_step_true(i));

        diameterfinal_step_sensor(i) = normrnd(diameterfinal_step_true(i), sensor_dia,1,1);

        %% Step 3: Calibration

        weights = normpdf(diameterfinal_step_sensor(i),diameterfinal_step(:,i), sensor_dia);
        norm_weights = weights/sum(weights);

        indices = 1:nsam;
        post_indices = randsample(indices, nsam, 'true', transpose(norm_weights));

        if Total_calibration_rel(i)==0
            alphaw_sam(:,i+1) = alphaw_sam(post_indices,i);  % these are used for the next time step
            betaw_sam(:,i+1) = betaw_sam(post_indices,i);
            wear_step(:,i+1) =  wear_step(post_indices,i);
        else
            alphaw_sam(:,i+1) = alphaw_sam(:,i);  % these are used for the next time step
            betaw_sam(:,i+1) = betaw_sam(:,i);
            wear_step(:,i+1) =  wear_step(:,i);
        end
        
         
        %% Step 4: Optimization to compute compensation for the next time step

        xinit = comp_step(i);
        lb = 0;
        ub = 0.1;
        
        
        if i==ntimesteps
            lfinal = L-length_step(i);
            [xval, fxval] = fmincon(@(x) TotalLossFunc_Final(x, wear_step(:,i+1), V, f,kw, alphaw_sam(:,i+1), betaw_sam(:,i+1), gammaw, sigmaw, pi*theta/180, Din, Df,lfinal), xinit, [],[],[],[], lb, ub, @(x) TotalCons_Final(x, wear_step(:,i+1), V, f,kw, alphaw_sam(:,i+1), betaw_sam(:,i+1), gammaw, sigmaw, pi*theta/180, Din, Df,lfinal));
            depth1 = DepthCut(Din, Df, xval);
            tstep(i) = TimePart(Din, depth1, lfinal, V, f);
            tstep(i+1) = tstep(i);
        else
            [xval, fxval] = fmincon(@(x) TotalLossFunc(x, wear_step(:,i+1), V, f,kw, alphaw_sam(:,i+1), betaw_sam(:,i+1), gammaw, sigmaw, pi*theta/180, Din, Df,tstep(i)), xinit, [],[],[],[], lb, ub, @(x) TotalCons(x, wear_step(:,i+1), V, f,kw, alphaw_sam(:,i+1), betaw_sam(:,i+1), gammaw, sigmaw, pi*theta/180, Din, Df,tstep(i)));
        end
        
        
        if Total_comp_rel(i) == 0
            comp_step_true(i+1) = xval + normrnd(0, comp_std, 1,1);
            comp_step(i+1) = xval;
        else
            comp_step(i+1) = comp_step(i);
            comp_step_true(i+1) = comp_step_true(i)+normrnd(0, comp_std, 1,1);
        end

        depth_step(i+1) = DepthCut(Din, Df, comp_step(i+1));
        depth_step_true(i+1) = DepthCut(Din, Df, comp_step_true(i+1));
        
        diameter_temp = [diameterfinal_step_true(i) Df-2*comp_step_true(i+1) + drift_step_true(i)];
        diameter_total = [diameter_total diameter_temp];
        length_total = [length_total [length_step(i) length_step(i)]];

    end
    
    
    i = ntimesteps+1;

    time_step(i) = timepart;
    length_step(i) = L;

    for j=1:nsam
        twi_step(j,i) = Estimate_t_w_i(V, f, depth_step(i), wear_step(j,i-1), kw, alphaw_sam(j,i), betaw_sam(j,i), gammaw, sigmaw);
        wear_step(j,i) = WearWithTime(V,f,depth_step(i),twi_step(j,i)+tstep(i),kw, alphaw_sam(j,i), betaw_sam(j,i), gammaw, sigmaw);
        drift_step(j,i) = DriftWear(wear_step(j,i), pi*theta/180);
        diameterfinal_step(j,i) = DiameterTurning(Df, comp_step(i), drift_step(j,i));   
    end

    %% Step 2: Observation

    twi_step_true(i) = Estimate_t_w_i(V, f, depth_step_true(i), wear_step_true(i-1), kw_true(k), alphaw_true(k), betaw_true(k), gammaw_true(k), sigmaw_true(k));
    wear_step_true(i) = WearWithTime(V,f,depth_step_true(i),twi_step_true(i)+tstep(i),kw_true(k), alphaw_true(k), betaw_true(k), gammaw_true(k), sigmaw_true(k));
    drift_step_true(i) = DriftWear(wear_step_true(i), pi*theta_true(k)/180);
    diameterfinal_step_true(i) = DiameterTurning(Df, comp_step_true(i), drift_step_true(i));

    diameterfinal_step_sensor(i) = normrnd(diameterfinal_step_true(i), sensor_dia,1,1);

    weights = normpdf(diameterfinal_step_sensor(i),diameterfinal_step(:,i), sensor_dia);
    norm_weights = weights/sum(weights);

    indices = 1:nsam;
    post_indices = randsample(indices, nsam, 'true', transpose(norm_weights));
    if Total_calibration_rel(i)==0
        alphaw_sam(:,i+1) = alphaw_sam(post_indices,i);  % these are used for the next time step
        betaw_sam(:,i+1) = betaw_sam(post_indices,i);
        wear_step(:,i+1) =  wear_step(post_indices,i);
    else
        alphaw_sam(:,i+1) = alphaw_sam(:,i);  % these are used for the next time step
        betaw_sam(:,i+1) = betaw_sam(:,i);
        wear_step(:,i+1) =  wear_step(:,i);
    end
   


    %% Collect both initial and final diameters for each segment

    diameter_total = [diameter_total diameterfinal_step_true(end)];
    length_total = [length_total L];
    
    diameter_true{k} = diameter_total;
    length_repeat{k} = length_total;
    wear_repeat{k} = wear_step_true;
    comp_repeat{k} = comp_step_true;
    drift_repeat{k} = drift_step_true;
end

save('OneDiameter_Data.mat')








