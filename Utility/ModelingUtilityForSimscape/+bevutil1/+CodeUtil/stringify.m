function Result = stringify(data, NameValuePair)
% Convert a scalar, a vector, or a array to a printable text.
%
% The passed data is casted to string. No evaluation is made.
%
% Examples:
%   a scalar 2 -> "2"
%   a row vector [1 2] -> "[1, 2]"
%   a column vector [3; 4] -> "[3; 4]"
%   a 2-dimensional matrix [5 6; 7 8] -> "[5, 6; 7, 8]"
%
% For a 3D-, or higher-dimensional matrix, the size is returned as a printable text.
% For example, for a 3D matrix with 2 rows, 3 columns, 4 pages, "2 x 3 x 4".
%
% Set true to the WithoutSpace option to avoid using white spaces.
% For example, WithoutSpace=true for [1 2 3] returns "[1,2,3]".

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Input)
  data {mustBeA(data, ["double", "simscape.Value"])} = 0
  NameValuePair.WithoutSpace (1,1) logical = false
end  % arguments

arguments (Output)
  Result (1,1) string
end  % arguments

if isa(data, "simscape.Value")
  x = value(data);
  x_str = bevutil1.CodeUtil.stringify(x);
  Result = x_str + " (" + string(unit(data)) + ")";

  return

end  % if

if NameValuePair.WithoutSpace
  str = "";
else
  str = " ";
end  % if

if isscalar(data)
  Result = string(data);

elseif isvector(data)
  if height(data) == 1
    % Row vector
    Result = "[" + join(string(data), ","+str) + "]";
  else
    % Column vector
    Result = "[" + join(string(data), ";"+str) + "]";
  end  % if

elseif ismatrix(data)
  Result = "[" + join(join(string(data), ","+str), ";"+str) + "]";

else
  % High-dimensional data. Return the size in text.
  Result = join(string(size(data)), str+"x"+str);

end  % if

end  % function
