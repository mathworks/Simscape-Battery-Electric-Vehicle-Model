%[text] # Calculate ampere-hour rating
function Charge = getAmpereHourRating(NameValuePair)

arguments (Input)
  NameValuePair.Capacity (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePair.Capacity, "kWh"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan} ...
    = simscape.Value(40, "kWh")
  NameValuePair.Voltage (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(NameValuePair.Voltage, "V"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan} ...
    = simscape.Value(400, "V")
  NameValuePair.StateOfCharge (1,1) double ...
    {mustBeInRange(NameValuePair.StateOfCharge, 0, 1, "inclusive")} ... %#ok<MUSTINRANGE>
    = 1.0  %#ok<MUSTINRANGE>
end  % arguments

arguments (Output)
  Charge (1,1) simscape.Value ...
    {simscape.mustBeCommensurateUnit(Charge, "A*hr"), bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan}
end  % arguments

voltage = NameValuePair.Voltage;
capacity = NameValuePair.Capacity;
soc = NameValuePair.StateOfCharge;

Charge = soc * capacity / voltage;
Charge = convert(Charge, "Ah");

end  % function
%[text] *Copyright 2023-2026 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
