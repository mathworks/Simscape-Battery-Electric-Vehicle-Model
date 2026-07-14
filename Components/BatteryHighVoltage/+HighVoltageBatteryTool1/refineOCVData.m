%[text] # Refine data representing open circuit voltage (OCV)
%[text] Refine SOC data points with the specified SOC interval and generate smoothly interpolated OCV data.
%[text] ## Options
%[text] Temperature: a vector of temperatures.
%[text] SOC: a vector of SOC data points.
%[text] SOCInterval: an interval to create refined SOC data points.
%[text] OCV: a 2D matrix with columns for temperature and rows for OCV.
function Result = refineOCVData(NameValuePair)

arguments (Input)
  NameValuePair.Temperature (1,:) {bev1mus.CodeUtil.mustBeSimscapeValueStrictAscend} = simscape.Value([0, 25, 60], "degC")
  NameValuePair.SOC (:,1) {mustBeBetween(NameValuePair.SOC, 0, 1, "closed"), bev1mus.CodeUtil.mustBeStrictAscend} = [0; 0.1; 0.15; 0.25; 0.75; 0.9; 1]
  NameValuePair.SOCInterval (1,1) {mustBeBetween(NameValuePair.SOCInterval, 0, 0.2, "open")} = 0.01
  NameValuePair.OCV = simscape.Value([2.8, 2.9, 3.0; 3.0, 3.1, 3.3; 3.1, 3.2, 3.4; 3.3, 3.4, 3.6; 3.4, 3.5, 3.7; 3.5, 3.6, 3.8; 3.6, 3.9, 4.15], "V")
end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "refineOCVData:";

t = NameValuePair.Temperature;
soc = NameValuePair.SOC;
ocv = NameValuePair.OCV;
ds = NameValuePair.SOCInterval;

if height(soc) ~= height(ocv)
  id = errorID + "SocAndOcvSizeMismatch";
  msg = bev1mus.CodeUtil.i18n("SOC vector and OCV matrix must have the same number of rows.");

  throw(MException(id, msg))

end  % if

if width(ocv) ~= width(t)
  id = errorID + "OcvAndTemperatureSizeMismatch";
  msg = bev1mus.CodeUtil.i18n("Temperature vector and OCV matrix must have the same number of columns.");

  throw(MException(id, msg))

end  % if

if ds > (soc(end) - soc(1))/2
  id = errorID + "SOCIntervalTooLarge";
  msg = bev1mus.CodeUtil.i18n("SOC interval is too large to insert data points.");

  throw(MException(id, msg))

end  % if

refined_soc =  transpose(soc(1) : ds : soc(end));

refined_ocv = nan(numel(refined_soc), numel(t));
for t_idx = 1 : numel(t)
  refined_ocv(:,t_idx) = interp1(soc, value(ocv(:,t_idx)), refined_soc, "makima");
end  % for

Result = table(refined_soc, simscape.Value(refined_ocv, unit(ocv)), 'VariableNames',["SOC", "OCV"]);

% Add a custom property to a table.
Result = addprop(Result, {'OCVTemperature'}, {'table'});
Result.Properties.CustomProperties.OCVTemperature = t;

end  % function
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
