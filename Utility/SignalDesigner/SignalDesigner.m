classdef SignalDesigner < handle
%% Signal Designer class implementation

% Copyright 2022 The MathWorks, Inc.

properties
  % Signal specifications

  Type {mustBeMember(Type, ["PieceWiseConstant", "ContinuousMultiStep", "Continuous"])} = "PieceWiseConstant"

  Title {mustBeTextScalar} = ""
  Description {mustBeTextScalar} = ""

  XName {mustBeTextScalar} = "X"
  XVarName {mustBeTextScalar} = "X"
  XUnit {mustBeTextScalar} = "1"

  YName {mustBeTextScalar} = "Y"
  YVarName {mustBeTextScalar} = "Y"
  YUnit {mustBeTextScalar} = "1"

  XYData double

  % For continuous data
  DeltaX (1,1) double {mustBePositive} = 0.1

  % Properties for saving signal spec
  SpecFilename {mustBeTextScalar} = ""
  XSaveFormat {mustBeTextScalar} = "%0.2f"
  YSaveFormat {mustBeTextScalar} = "%0.4f"

  % ----- Internally generated properties -----

  TransformedData table
  Data table

  % For continous data
  XRefined (:,1) double
  YRefined (:,1) double
  InterpolatedData table

end  % properties

methods
%%


function sigObj = SignalDesigner(SignalType)
%%

arguments
  SignalType {mustBeMember(SignalType, ["PieceWiseConstant", "ContinuousMultiStep", "Continuous"])} = "PieceWiseConstant"
end

sigObj.Type = SignalType;

if sigObj.Type == "PieceWiseConstant" || sigObj.Type == "Continuous"
  sigObj.XYData = [ 0 0 ; 1 0 ];
else  % ContinuousMultiStep
  sigObj.XYData = [ 0 1 0 ];
end

update(sigObj);

end  % function


function update(sigObj)
%%

arguments
  sigObj (1,1) SignalDesigner
end

switch sigObj.Type

case "ContinuousMultiStep"

  sigObj.TransformedData = transformDataPoints(sigObj, sigObj.XYData);
  sigObj.InterpolatedData = interpolateDataPoints(sigObj, sigObj.TransformedData);
  sigObj.Data = eliminateRedundantDataPoints(sigObj, sigObj.InterpolatedData);

case "PieceWiseConstant"

  % Check X data points
  xPoints = sigObj.XYData(:, 1);
  assert( issorted(xPoints, "strictascend"), ...
    "X must be strictly asending.")

  % Check Y data points
  yPoints = sigObj.XYData(:, 2);
  assert( all(not(isnan(yPoints))), ...
    "Y data cannot have NaN.")

  % Build data
  newData = table(xPoints, yPoints);
  newData.Properties.VariableNames = [sigObj.XVarName, sigObj.YVarName];
  newData.Properties.VariableUnits = [sigObj.XUnit, sigObj.YUnit];
  sigObj.Data = newData;

case "Continuous"

  dx = sigObj.DeltaX;

  % Check X data points
  xPoints = sigObj.XYData(:, 1);
  assert( numel(xPoints) >= 2 , ...
    "Only one row is defined, but Continuous signal type requires at least 2 rows.")
  assert( issorted(xPoints, "strictascend"), ...
    "X must be strictly asending.")

  % Check that delta x makes sense for interpolation.
  min_diff_x = min(diff(xPoints));
  assert(dx <= min_diff_x/2, ...
    "Interpolation step size dx must be smaller than or equal to the half of mininum value of diff(X)." ...
    + newline + "dx/2 = " + dx + " " ...
    + newline + "min(diff(x)) = " + min_diff_x/2 )

  % Check Y data points
  yPoints = sigObj.XYData(:, 2);
  assert( all(not(isnan(yPoints))), ...
    "Y data cannot have NaN.")

  % Build data
  x_refined = transpose(xPoints(1) : dx : xPoints(end));
  if abs(x_refined(end) - xPoints(end)) > 10*eps
    x_refined(end + 1) = xPoints(end);
  end
  y_refined = interp1(xPoints, yPoints, x_refined, "makima");
  sigObj.InterpolatedData = table(x_refined, y_refined);
  sigObj.InterpolatedData.Properties.VariableNames = [sigObj.XVarName sigObj.YVarName];
  sigObj.InterpolatedData.Properties.VariableUnits = [sigObj.XUnit sigObj.YUnit];
  sigObj.Data = sigObj.InterpolatedData;
  sigObj.XRefined = x_refined;
  sigObj.YRefined = y_refined;

end  % switch

end  % function


function fig = plotDataPoints(sigObj, nvpairs)
%% Plots generated data points.

arguments
  sigObj (1,1) SignalDesigner

  % Debug=true shows intermediate points
  nvpairs.Debug (1,1) logical = false
end

update(sigObj);

plotMoreForDebug = nvpairs.Debug;

fig = figure;
fig.Position(3:4) = [800 400];
hold on
grid on
axis padded

if sigObj.Title ~= ""
  title(sigObj.Title)
end

switch sigObj.Type

case "ContinuousMultiStep"

  if plotMoreForDebug

    % Generated trace
    plot(sigObj.Data.(sigObj.XVarName), sigObj.Data.(sigObj.YVarName), LineWidth=1);

    % Final data points ... interpolated, no redundancy in data points
    sc = scatter(sigObj.Data.(sigObj.XVarName), sigObj.Data.(sigObj.YVarName), 36*3);
    sc.Marker = "+";
    sc.LineWidth = 1.5;

    % Interpolated points
    % There may not exist interpolated data points.
    if height(sigObj.InterpolatedData) >= 1
      sc = scatter(sigObj.InterpolatedData.(sigObj.XVarName), sigObj.InterpolatedData.(sigObj.YVarName), 36*2);
      sc.Marker = "x";
      sc.LineWidth = 2;
    end

    % User data
    lix = sigObj.TransformedData.Added == false;  % logical index
    xTmp = sigObj.TransformedData.X;
    yTmp = sigObj.TransformedData.Y;
    sc = scatter(xTmp(lix), yTmp(lix), 36*4);
    sc.Marker = "o";
    sc.LineWidth = 2;

    if height(sigObj.InterpolatedData) >= 1
      legend(["Generated trace", "Final data points", "Interpolated", "Data points"], Location="best")
    else
      legend(["Generated trace", "Final data points", "Data points"], Location="best")
    end

  else  % not debug

    % Interpolated points without redundancy
    plot(sigObj.Data.(sigObj.XVarName), sigObj.Data.(sigObj.YVarName), LineWidth=2);

    % User data
    lix = sigObj.TransformedData.Added == false;  % logical index
    xTmp = sigObj.TransformedData.X;
    yTmp = sigObj.TransformedData.Y;
    sc = scatter(xTmp(lix), yTmp(lix), 36*1.5);
    sc.Marker = "o";
    sc.LineWidth = 2;

    legend(["Generated trace", "Data points"], Location="best")
  end  % if

case "PieceWiseConstant"

  st = stairs(sigObj.Data, sigObj.XVarName, sigObj.YVarName);
  st.LineWidth = 2;

  sc = scatter(sigObj.Data, sigObj.XVarName, sigObj.YVarName);
  sc.Marker = "o";
  sc.SizeData = 36*2;
  sc.LineWidth = 2;

  legend(["Generated trace", "Data points"], Location="best")

case "Continuous"

  if plotMoreForDebug

    % Generated trace
    plot(sigObj.Data.(sigObj.XVarName), sigObj.Data.(sigObj.YVarName), LineWidth=1);

    % Interpolated points
    sc = scatter(sigObj.InterpolatedData.(sigObj.XVarName), sigObj.InterpolatedData.(sigObj.YVarName), 36*2);
    sc.Marker = "x";
    sc.LineWidth = 2;

    % User data
    xPoints = sigObj.XYData(:, 1);
    yPoints = sigObj.XYData(:, 2);
    sc = scatter(xPoints, yPoints, 36*1.5);
    sc.Marker = "o";
    sc.SizeData = 36*2;
    sc.LineWidth = 2;

    if height(sigObj.InterpolatedData) >= 1
      legend(["Generated trace", "Interpolated", "Data points"], Location="best")
    else
      legend(["Generated trace", "Data points"], Location="best")
    end

  else  % not debug

    % Generated trace
    plot(sigObj.Data.(sigObj.XVarName), sigObj.Data.(sigObj.YVarName), LineWidth=2);

    % User data
    xPoints = sigObj.XYData(:, 1);
    yPoints = sigObj.XYData(:, 2);
    sc = scatter(xPoints, yPoints, 36*1.5);
    sc.Marker = "o";
    sc.LineWidth = 2;

    legend(["Generated trace", "Data points"], Location="best")
  end  % if


end  % switch

xLabelStr = sigObj.XName;
if sigObj.Data.Properties.VariableUnits(1) ~= "1"
  xLabelStr = xLabelStr + " (" + sigObj.Data.Properties.VariableUnits(1) + ")";
end
xlabel(xLabelStr)

yLabelStr = sigObj.YName;
if sigObj.Data.Properties.VariableUnits(2) ~= "1"
  yLabelStr = yLabelStr + " (" + sigObj.Data.Properties.VariableUnits(2) + ")";
end
ylabel(yLabelStr)

end  % function


function saveSpec(sigObj, SpecFilename)
%% Saves signal specification to JSON file.

arguments
  sigObj (1,1) SignalDesigner
  SpecFilename {mustBeTextScalar}
end

% SpecFilename is saved to sigObj. saveData function uses it.
sigObj.SpecFilename = SpecFilename;

signalSpec = [];
signalSpec.Type = sigObj.Type;
signalSpec.Title = sigObj.Title;
signalSpec.Description = sigObj.Description;
signalSpec.XName = sigObj.XName;
signalSpec.XVarName = sigObj.XVarName;
signalSpec.XUnit = sigObj.XUnit;
signalSpec.YName = sigObj.YName;
signalSpec.YVarName = sigObj.YVarName;
signalSpec.YUnit = sigObj.YUnit;
signalSpec.XSaveFormat = sigObj.XSaveFormat;
signalSpec.YSaveFormat = sigObj.YSaveFormat;
if sigObj.Type == "ContinuousMultiStep" || sigObj.Type == "Continuous"
  signalSpec.DeltaX = sigObj.DeltaX;
end
signalSpec.XYData = sigObj.XYData;

jsonStr = string(jsonencode(signalSpec, PrettyPrint=true));

% The above jsonStr can be saved to file, but
% each element of a row is placed in separate lines
% with many unnecessary white spaces due to the PrettyPrint=true option.
% The code below combine those lines to a more compact yet readable style.
jsonStrFirstPart = extractBefore(jsonStr, newline + whitespacePattern + "[" + newline) + newline;

if sigObj.Type == "PieceWiseConstant" || sigObj.Type == "Continuous"
  ptn = whitespacePattern + "[" + newline ...
    + whitespacePattern + digitsPattern + "," + newline ... x
    + whitespacePattern + digitsPattern + newline;   % y

else  % ContinuousMultiStep
  ptn = whitespacePattern + "[" + newline ...
    + whitespacePattern + digitsPattern + "," + newline ... x1
    + whitespacePattern + (digitsPattern | caseInsensitivePattern("null")) + "," + newline ... x2
    + whitespacePattern + digitsPattern + newline;  % y

end  % if

jsonStrDataPoints = extract(jsonStr, ptn);
jsonStrDataPoints = erase(jsonStrDataPoints, [newline whitespacePattern]) + "]," + newline;
jsonStrDataPoints(end) = replace(jsonStrDataPoints(end), "],", "]");

% join uses a white space as a default delmiter, which
% we don't need, thus specifying "" in the second argument.
jsonStrDataPoints = join(jsonStrDataPoints, "");

jsonStr = jsonStrFirstPart + jsonStrDataPoints + "]}";

fid = fopen(SpecFilename, "w");
fprintf(fid, "%s", jsonStr);
fclose(fid);

end  % function


function specStruct = loadSpec(sigObj, SpecFilename)
%% Reads signal spec file and updates signal object.

arguments
  sigObj (1,1) SignalDesigner
  SpecFilename {mustBeTextScalar}
end

jsonStr = fileread(SpecFilename);

specStruct = jsondecode(jsonStr);

% JSON supports fewer data types than MATLAB.
% For example, string in MATLAB is saved as charactor vector in JSON
% because there is no string type in JSON.
% thus jsondecode returns charactor vector for texts.
% You must convert them to string explicitly if necessary.

sigObj.Type = string(specStruct.Type);
sigObj.Title = string(specStruct.Title);
sigObj.Description = string(specStruct.Description);
sigObj.XName = string(specStruct.XName);
sigObj.XVarName = string(specStruct.XVarName);
sigObj.XUnit = string(specStruct.XUnit);
sigObj.YName = string(specStruct.YName);
sigObj.YVarName = string(specStruct.YVarName);
sigObj.YUnit = string(specStruct.YUnit);
sigObj.SpecFilename = string(SpecFilename);

if sigObj.Type == "ContinuousMultiStep" || sigObj.Type == "Continuous"
 sigObj.DeltaX = specStruct.DeltaX;
end

end  % function


function saveData(sigObj, DataFilename)
%% Saves generated signal data to M file.

arguments
  sigObj (1,1) SignalDesigner
  DataFilename {mustBeTextScalar}
end

xDataStr = sprintf(sigObj.XSaveFormat + " ", sigObj.Data.(sigObj.XVarName));
xDataStr = "[ " + xDataStr + "]";

yDataStr = sprintf(sigObj.YSaveFormat + " ", sigObj.Data.(sigObj.YVarName));
yDataStr = "[ " + yDataStr + "]";

dataStr = ...
  "% " + sigObj.Description + newline + ...
  "% X: " + sigObj.XName + " (" + sigObj.XUnit + ")" + newline + ...
  "% Y: " + sigObj.YName + " (" + sigObj.YUnit + ")" + newline + ...
  "% Spec file: " + sigObj.SpecFilename + newline + ...
  sigObj.XVarName + " = " + xDataStr + ";" + newline + ...
  sigObj.YVarName + " = " + yDataStr + ";" + newline;

fid = fopen(DataFilename, "w");
fprintf(fid, "%s", dataStr);
fclose(fid);

end  % function


function result = transformDataPoints(~, xyData)
%% Transforms compact xy-data points to a format suitable for processing
% Converts a row in [x1 x2 y] format into [x1 y; x2 y] format.
% Optionally adds mid-points for smoothing.
% Works with continuous and timedcontinuous cases.

arguments
  ~

  % N-by-3 matrix. Each row is [x1 x2 y].
  % x1 is X start data point.
  % x2 is X end data point, which can be nan.
  % y is Y data point.
  xyData (:,3) double
end

numInputRows = height(xyData);

% Check X data points

xPoints = xyData(:, [1 2]);

assert(issorted(xPoints(:,1), "strictascend"), ...
  "X start vector must be strictly asending.")

tmpVec = xPoints(:,2);
lix = not(isnan(tmpVec));  % logical index
if any(lix)
  tmpVec = tmpVec(lix);
  assert(issorted(tmpVec, "strictascend"), ...
    "X end vector must be strictly asending.")

  dx = xPoints(:,2) - xPoints(:,1);

  cond_dx_is_nan = isnan(dx);
  cond_dx_is_pos = dx > 0;
  violating = not(cond_dx_is_nan | cond_dx_is_pos);
  lix = find(violating);  % logical index
  assert(isempty(lix), ...
    "X start is after X end, which is invalid, at these rows: " + num2str(lix'));

end  % if

% Check Y data points

yPoints = xyData(:, 3);

assert(all( not(isnan( yPoints )) ), ...
  "Y data cannot have NaN.")

% Build data

% If transformedData.Refine(i) is true,
% apply interpolation to the data between i and i+1.
transformedData = struct('X', [], 'Y',[], 'Added',[], 'Refine',[]);

idx = 1;
for r = 1 : numInputRows

  % xp(1) is X start point. Must exist.
  % xp(2) is X end point. May not exist.
  % yp is Y data point. Must exist.
  xp = xPoints(r, :);
  yp = yPoints(r);

  transformedData(idx).X = xp(1);
  transformedData(idx).Y = yp;
  transformedData(idx).Added = false;
  transformedData(idx).Refine = false;

  idx = idx + 1;

  if isnan(xp(2))
    % X end point, xp(2), is not defined.
    % This point is used for interpolation.

    transformedData(idx-1).Refine = true;

  else
    % X end point, xp(2), is defined.
    % This point is part of flat segment and not used for interpolation.

    % Add mid-point.
    transformedData(idx).Added = true;
    transformedData(idx).X = (xp(1) + xp(2)) / 2;
    transformedData(idx).Y = yp;
    transformedData(idx).Refine = false;

    idx = idx + 1;

    % Add end point.
    transformedData(idx).Added = false;
    transformedData(idx).X = xp(2);
    transformedData(idx).Y = yp;
    transformedData(idx).Refine = true;

    idx = idx + 1;

  end  % if
end  % for
transformedData(end).Refine = false;

dx = diff([transformedData.X]);
assert(all(dx > 0), "X data points are not strictly ascending.")

result = struct2table(transformedData);

end  % function


function result = interpolateDataPoints(sigObj, transformedData)
%% Interpolates data points.
% This takes transformed data points, not a user-specified matrix.

arguments
  sigObj (1,1) SignalDesigner
  transformedData (:,4)
end

x_1 = transformedData.X(1);
x_end = transformedData.X(end);
x_delta = sigObj.DeltaX;

% Check that delta x makes sense for interpolation.
% This check must be made in interpolating segments only.
indices = find(transformedData.Refine == true);

if isempty(indices)
  result = table(Size=[0, 2], VariableTypes=["double", "double"]);
  return  % <======================================================= RETURN
end

nextElementIndices = indices + 1;
xPoints = transformedData.X;
dx = xPoints(nextElementIndices) - xPoints(indices);
assert(x_delta <= min(dx)/2, ...
  "Delta X must be smaller than the half of min(dx) in interpolating segments." ...
  + newline + "Delta X = " + x_delta + " " ...
  + newline + "min(dx)/2 = " + min(dx)/2 )

x_refined = transpose(x_1 : x_delta : x_end);
if abs(x_refined(end) - x_end) > 10*eps
  x_refined(end + 1) = x_end;
end

y_refined = interp1(transformedData.X, transformedData.Y, x_refined, "makima");

sigObj.XRefined = x_refined;
sigObj.YRefined = y_refined;

interpolatedData = table(x_refined, y_refined);
interpolatedData.Properties.VariableNames = [sigObj.XVarName sigObj.YVarName];
interpolatedData.Properties.VariableUnits = [sigObj.XUnit sigObj.YUnit];

result = interpolatedData;

end  % function


function result = eliminateRedundantDataPoints(sigObj, interpolatedData)
%% Eliminates redundant data points generated by interpolation.

arguments
  sigObj (1,1) SignalDesigner
  interpolatedData (:,2) table
end

newData = table(Size=[0, 2], VariableTypes=["double", "double"]);
newData.Properties.VariableNames = [sigObj.XVarName sigObj.YVarName];
newData.Properties.VariableUnits = [sigObj.XUnit sigObj.YUnit];

idx = 1;
while idx < height(sigObj.TransformedData)

  if sigObj.TransformedData.Refine(idx) == true
    % Use interpolated points.
    xRange = (sigObj.TransformedData.X(idx) <= sigObj.XRefined) ...
              & (sigObj.XRefined <= sigObj.TransformedData.X(idx+1));
    % Avoid duplicating the same row.
    newData = [newData(1:end-1, :); interpolatedData(xRange, :)];
    idx = idx + 1;

  else
    % Interpolated points contain redundant points in flat segments.
    % Avoid including those redundant points.

    % We must skip the internally added mid-point.
    % Thus, idx+2 rather than idx+1 is used.
    tmpData = table( ...
                [sigObj.TransformedData.X(idx); sigObj.TransformedData.X(idx+2)], ...
                [sigObj.TransformedData.Y(idx); sigObj.TransformedData.Y(idx+2)], ...
                VariableNames = [sigObj.XVarName, sigObj.YVarName] );
    tmpData.Properties.VariableUnits = [sigObj.XUnit, sigObj.YUnit];

    % Avoid duplicating the same row.
    newData = [newData(1:end-1, :); tmpData];
    idx = idx + 2;

  end
end

assert(issorted(newData.(sigObj.XVarName), "strictascend"))

result = newData;

end  % function

end  % methods

end  % classdef
