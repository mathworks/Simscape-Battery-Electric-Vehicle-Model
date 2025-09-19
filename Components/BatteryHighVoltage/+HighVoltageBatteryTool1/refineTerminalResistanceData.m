%[text] # Refine terminal resistance data
%[text] Refine SOC data points with the specified interval and generate smoothly interpolated terminal resistance data.
%[text] ## Options
%[text] Temperature: a vector of temperatures.
%[text] SOC: a vector of SOC data points.
%[text] SOCInterval: an interval to create refined SOC data points.
%[text] TerminalResistance: a 2D matrix with columns for temperature and rows for terminal resistance.
function Result = refineTerminalResistanceData(NameValuePair)

arguments (Input)
  NameValuePair.Temperature (1,:) {CodeTool1.mustBeSimscapeValueStrictAscend} = simscape.Value([0, 25, 60], "degC")
  NameValuePair.SOC (:,1) {mustBeBetween(NameValuePair.SOC, 0, 1, "closed"), CodeTool1.mustBeStrictAscend} = [0; 0.05; 0.15; 0.4; 0.8; 1]
  NameValuePair.SOCInterval (1,1) {mustBeBetween(NameValuePair.SOCInterval, 0, 0.2, "open")} = 0.01
  NameValuePair.TerminalResistance {CodeTool1.mustBeSimscapeValuePositive} = simscape.Value([0.47 0.17 0.13; 0.45 0.12 0.005; 0.218 0.072 0.04; 0.101 0.053 0.037; 0.086 0.044 0.03; 0.1 0.033 0.024], "Ohm")
end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "refineTerminalResistanceData:";

t = NameValuePair.Temperature;
soc = NameValuePair.SOC;
ds = NameValuePair.SOCInterval;
r0 = NameValuePair.TerminalResistance;

if height(soc) ~= height(r0)
  id = errorID + "SocAndTerminalResistanceSizeMismatch";
  msg = CodeTool1.i18n("SOC vector and TerminalResistance matrix must have the same number of rows.");

  throw(MException(id, msg))

end  % if

if width(r0) ~= width(t)
  id = errorID + "TerminalResistanceAndTemperatureSizeMismatch";
  msg = CodeTool1.i18n("TerminalResistance matrix and Temperature vector must have the same number of columns.");

  throw(MException(id, msg))

end  % if

if ds > (soc(end) - soc(1))/2
  id = errorID + "SOCIntervalTooLarge";
  msg = CodeTool1.i18n("SOC interval is too large to insert data points.");

  throw(MException(id, msg))

end  % if

refined_soc =  transpose(soc(1) : ds : soc(end));

refined_r0 = nan(numel(refined_soc), numel(t));
for t_idx = 1 : numel(t)
  refined_r0(:,t_idx) = interp1(soc, value(r0(:,t_idx)), refined_soc, "makima");
end  % for

Result = table(refined_soc, simscape.Value(refined_r0, unit(r0)), 'VariableNames',["SOC", "TerminalResistance"]);

% Add a custom property to a table.
Result = addprop(Result, {'TerminalResistanceTemperature'}, {'table'});
Result.Properties.CustomProperties.TerminalResistanceTemperature = t;

end  % function
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
