function Result = getVectorsFromSignalDesignMatrix(SignalDesignMatrix)
% Get x and f(x) vectors from signal design matrix.
%
% This function converts the specified signal design matrix to
% x vector and f(x) vector and returns them.
%
% A signal design matrix is an N-by-3 matrix, i.e., each row has a form of [ x_s, x_e, f ].
%
% - x_s is x start data point.
% - x_e is x end data point, which can be nan.
% - f is f(x) data point.
%
% Optionally adds mid-points for smoothing. This works for a continuous case.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  SignalDesignMatrix (:,3) {mustBeMatrix, mustBeNumeric} = [0 2 0; 4 nan 4; 7 9 3]
end  % arguments

arguments (Output)
  Result (:,4) table
end  % arguments

errorID = "getVectorsFromDesignMatrix:";

check_result = bev1mus.SignalUtil.checkSignalDesignMatrix(SignalDesignMatrix);
if not(check_result.IsValid)

  id = check_result.ErrorID;
  msg = check_result.Message;

  throw(MException(id, msg))

end  % if

%{
% Check X data points

x_points = SignalDesignMatrix(:, [1 2]);

assert( issorted(x_points(:,1), "strictascend"), ...
  errorID + "XStartVectorNotAscending", ...
  bev1mus.CodeUtil.i18n("X start vector must be strictly asending."))

tmp_vec = x_points(:,2);
logical_index = not(isnan(tmp_vec));
if any(logical_index)
  tmp_vec = tmp_vec(logical_index);

  assert( issorted(tmp_vec, "strictascend"), ...
    errorID + "XEndVectorNotAscending", ...
    bev1mus.CodeUtil.i18n("X end vector must be strictly asending."))

  dx = x_points(:,2) - x_points(:,1);

  cond_dx_is_nan = isnan(dx);
  cond_dx_is_pos = dx > 0;
  violating = not(cond_dx_is_nan | cond_dx_is_pos);
  logical_index = find(violating);

  assert( isempty(logical_index), ...
    errorID + "InvalidX", ...
    bev1mus.CodeUtil.i18n("X start is after X end, which is invalid, at these rows: ") + num2str(logical_index'))

end  % if

% Check F(X) data points

f_points = SignalDesignMatrix(:, 3);

assert( all(not(isnan(f_points))), ...
  errorID + "invalidF", ...
  bev1mus.CodeUtil.i18n("F data cannot have NaN."))
%}

% Build data
x_points = SignalDesignMatrix(:, [1 2]);
f_points = SignalDesignMatrix(:, 3);

% If transformed_data.Refine(i) is true,
% apply interpolation to the data between i and i+1.
transformed_data = struct("X", [], "F",[], "Added",[], "Refine",[]);

num_rows = height(SignalDesignMatrix);

idx = 1;
for r = 1 : num_rows

  % xp(1) is X start point. Must exist.
  % xp(2) is X end point. May not exist.
  % fp is F data point. Must exist.
  xp = x_points(r, :);
  fp = f_points(r);

  transformed_data(idx).X = xp(1);
  transformed_data(idx).F = fp;
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
    transformed_data(idx).F = fp;
    transformed_data(idx).Refine = false;

    idx = idx + 1;

    % Add end point.
    transformed_data(idx).Added = false;
    transformed_data(idx).X = xp(2);
    transformed_data(idx).F = fp;
    transformed_data(idx).Refine = true;

    idx = idx + 1;

  end  % if
end  % for
transformed_data(end).Refine = false;

dx = diff([transformed_data.X]);

assert( all(dx > 0), ...
  errorID + "XNotAscending", ...
  bev1mus.CodeUtil.i18n("X data points are not strictly ascending."))

Result = struct2table(transformed_data);

end  % function
