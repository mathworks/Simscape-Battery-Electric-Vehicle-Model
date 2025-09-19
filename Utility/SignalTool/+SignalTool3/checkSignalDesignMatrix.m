function Result = checkSignalDesignMatrix(GivenMatrix)
% Check that the given matrix is valid as a signal design matrix.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  GivenMatrix (:,3) {mustBeMatrix, mustBeNumeric} = [0 2 0; 4 nan 4; 7 9 3]
end  % arguments

arguments (Output)
  Result struct
end  % arguments

errorID = "checkSignalDesignMatrix:";

% Check X data points

x_points = GivenMatrix(:, [1 2]);

if not(issorted(x_points(:,1), "strictascend"))
  Result.IsValid = false;
  Result.ErrorID = errorID + "XStartVectorNotAscending";
  Result.Message = CodeTool1.i18n("X start vector must be strictly asending.");

  return

end  % if

tmp_vec = x_points(:,2);
logical_index = not(isnan(tmp_vec));
if any(logical_index)
  tmp_vec = tmp_vec(logical_index);

  if not(issorted(tmp_vec, "strictascend"))
    Result.IsValid = false;
    Result.ErrorID = errorID + "XEndVectorNotAscending";
    Result.Message = CodeTool1.i18n("X end vector must be strictly asending.");

    return

  end  % if

  dx = x_points(:,2) - x_points(:,1);

  cond_dx_is_nan = isnan(dx);
  cond_dx_is_pos = dx > 0;
  violating = not(cond_dx_is_nan | cond_dx_is_pos);
  logical_index = find(violating, 2);

  if not(isempty(logical_index))
    Result.IsValid = false;
    Result.ErrorID = errorID + "InvalidX";
    Result.Message = CodeTool1.i18n("X start is after X end, which is invalid, at rows: ") + num2str(logical_index');

    return

  end  % if

end  % if

% Check F(X) data points

f_points = GivenMatrix(:, 3);

if not(all(not(isnan(f_points))))
  Result.IsValid = false;
  Result.ErrorID = errorID + "invalidF";
  Result.Message = CodeTool1.i18n("F data cannot have NaN.");

  return

end  % if

Result.IsValid = true;
Result.ErrorID = "";
Result.Message = "";
end  % function
