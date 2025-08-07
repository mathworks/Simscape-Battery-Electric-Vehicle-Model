function Result = getXYVectorsFromSignalDesignMatrix(SignalDesignMatrix)
%% Get x and y vectors from signal design matrix
% This function converts the specified signal design matrix to x vector
% and y vector and returns them.

% Optionally adds mid-points for smoothing. This works for a continuous case.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  % N-by-3 matrix. Each row is [x1 x2 y].
  % x1 is X start data point.
  % x2 is X end data point, which can be nan.
  % y is Y data point.
  SignalDesignMatrix (:,3) {mustBeMatrix, mustBeNumeric} = [0 2 0; 4 nan 4; 7 9 3]

end  % arguments

arguments (Output)

  Result table

end  % arguments

error_id = "getXYVectorsFromDesignMatrix:";

num_rows = height(SignalDesignMatrix);

% Check X data points

x_points = SignalDesignMatrix(:, [1 2]);

assert( issorted(x_points(:,1), "strictascend"), ...
  error_id + "XStartVectorNotAscending", ...
  CodeTool1.i18n("X start vector must be strictly asending."))

tmp_vec = x_points(:,2);
logical_index = not(isnan(tmp_vec));
if any(logical_index)
  tmp_vec = tmp_vec(logical_index);

  assert( issorted(tmp_vec, "strictascend"), ...
    error_id + "XEndVectorNotAscending", ...
    CodeTool1.i18n("X end vector must be strictly asending."))

  dx = x_points(:,2) - x_points(:,1);

  cond_dx_is_nan = isnan(dx);
  cond_dx_is_pos = dx > 0;
  violating = not(cond_dx_is_nan | cond_dx_is_pos);
  logical_index = find(violating);

  assert( isempty(logical_index), ...
    error_id + "InvalidX", ...
    CodeTool1.i18n("X start is after X end, which is invalid, at these rows: ") + num2str(logical_index'))

end  % if

% Check Y data points

y_points = SignalDesignMatrix(:, 3);

assert( all(not(isnan(y_points))), ...
  error_id + "invalidY", ...
  CodeTool1.i18n("Y data cannot have NaN."))

% Build data

% If transformed_data.Refine(i) is true,
% apply interpolation to the data between i and i+1.
transformed_data = struct('X', [], 'Y',[], 'Added',[], 'Refine',[]);

idx = 1;
for r = 1 : num_rows

  % xp(1) is X start point. Must exist.
  % xp(2) is X end point. May not exist.
  % yp is Y data point. Must exist.
  xp = x_points(r, :);
  yp = y_points(r);

  transformed_data(idx).X = xp(1);
  transformed_data(idx).Y = yp;
  transformed_data(idx).Added = false;
  transformed_data(idx).Refine = false;

  idx = idx + 1;

  if isnan(xp(2))
    % X end point, xp(2), is not defined.
    % This point is used for interpolation.

    transformed_data(idx-1).Refine = true;

  else
    % X end point, xp(2), is defined.
    % This point is part of flat segment and not used for interpolation.

    % Add mid-point.
    transformed_data(idx).Added = true;
    transformed_data(idx).X = (xp(1) + xp(2)) / 2;
    transformed_data(idx).Y = yp;
    transformed_data(idx).Refine = false;

    idx = idx + 1;

    % Add end point.
    transformed_data(idx).Added = false;
    transformed_data(idx).X = xp(2);
    transformed_data(idx).Y = yp;
    transformed_data(idx).Refine = true;

    idx = idx + 1;

  end  % if
end  % for
transformed_data(end).Refine = false;

dx = diff([transformed_data.X]);

assert( all(dx > 0), ...
  error_id + "XNotAscending", ...
  CodeTool1.i18n("X data points are not strictly ascending."))

Result = struct2table(transformed_data);

end  % function
