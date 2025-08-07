function SignalDesignMatrix = generateSignalDesignMatrixFromTraceProperties(NameValuePair)
% Generate a signal design matrix from signal trace properties with a random seed.
% The generated trace consists of flat segments that are smoothly interpolated.
% This function generates data using a random number generator.
%
% This function is designed as a better alternative of the SignalDesignUtility.buildXYData function
% which was used by the Trace Generator block in the Signal Designer.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.RandomSeed (1,1) {mustBeInteger, mustBePositive} = 2

  % ---------------------------------------------------------------------------
  % Options for initial flat segment and transition.

  NameValuePair.FInitialValue (1,1) double = 0
  NameValuePair.XInitialFlatLength (1,1) {mustBePositive} = 2

  NameValuePair.XInitialTransitionLength (1,1) {mustBePositive} = 3

  % ---------------------------------------------------------------------------
  % Options for flat segments and transitions excluding the initial and final ones.

  % Number of transitions excluding the initial and final transitions, N_t.
  NameValuePair.NumTransitions (1,1) {mustBeInteger, mustBePositive} = 2 ...
  % Note that the number of flat segments excluding the initial and final segments, N_f,
  % is N_t + 1.

  NameValuePair.TransitionXRange (1,2) {mustBePositive} = [2 3]
  NameValuePair.FlatXRange (1,2) {mustBePositive} = [2 4]

  NameValuePair.FRange (1,2) double = [1 8]

  % ---------------------------------------------------------------------------
  % Options for final transition and flat segment.

  NameValuePair.XFinalTransitionLength (1,1) {mustBePositive} = 3

  NameValuePair.FFinalValue (1,1) double = 0
  NameValuePair.XFinalFlatLength (1,1) {mustBePositive} = 2

end  % arguments

arguments (Output)
  SignalDesignMatrix (:, 3) double
end  % arguments

% -----------------------------------------------------------------------------
% The first row of the signal design matrix.

x_ini_start = 0;

dx_ini_flat = NameValuePair.XInitialFlatLength - x_ini_start;

initial_row = [x_ini_start, dx_ini_flat, NameValuePair.FInitialValue];

% -----------------------------------------------------------------------------
% Rows except for the first and final of the signal design matrix.

rng(NameValuePair.RandomSeed)

num_transitions = NameValuePair.NumTransitions;
num_flat_segments = num_transitions + 1;

dx_ini_transition = NameValuePair.XInitialTransitionLength;

% Flat segment start points in relative value
x_start_relative = randi(NameValuePair.TransitionXRange, num_flat_segments, 1);
x_start_relative(1) = 0;

% Flat segment end points in relative value
x_end_relative = randi(NameValuePair.FlatXRange, num_flat_segments, 1);

% Zip two vectors.
x_zip = nan(num_flat_segments*2, 1);
x_zip(1:2:end-1) = x_start_relative;
x_zip(2:2:end) = x_end_relative;

% Compute values relative to the initial point.
x_accum = (cumsum(x_zip) + dx_ini_flat + dx_ini_transition);

% Flat segment start points relative to the inital point.
x_start = x_accum(1:2:end);

% Flat segment end points relative to the inital point.
x_end = x_accum(2:2:end);

f = randi(NameValuePair.FRange, num_flat_segments, 1);

middle_rows = horzcat(x_start, x_end, f);

% -----------------------------------------------------------------------------
% The final row of the signal design matrix.

x_final_transition = NameValuePair.XFinalTransitionLength;
x_final_start = x_end(end) + x_final_transition;
x_final_end = x_final_start + NameValuePair.XFinalFlatLength;

final_row = [ x_final_start, x_final_end, NameValuePair.FFinalValue ];

% -----------------------------------------------------------------------------
% Build the entire design matrix.

SignalDesignMatrix = vertcat(initial_row, middle_rows, final_row);

end  % function
