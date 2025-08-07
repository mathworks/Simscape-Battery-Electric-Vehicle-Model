function setupAppConfigFromConfigStruct(AppConfigObj, ConfigStruct)
%%
% This function takes an app-config class object and a corresponding struct data
% and updates the class using the struct.
% The struct is expected to be created by readstruct reading a JSON file
% containing app-config information.
% This function ignores struct fields that are not required by app-config,
% which allows users to use their custom fields in the struct.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  AppConfigObj (1,1) {LiteApp7.Utility.mustBeAppConfig}
  ConfigStruct (1,1) struct
end

error_id = "setupAppConfigFromConfigStruct:failed";

struct_field_strings = string(fieldnames(ConfigStruct));

num_fields = numel(struct_field_strings);
assert(num_fields > 0, error_id, CodeTool1.i18n("Struct without field is not accepted."))

num_props = numel(properties(AppConfigObj));

property_strings = string(properties(AppConfigObj));

% First-pass, error check.
% Make sure that all properties are defined in the struct.
% Report issues all at once. Do not report issues one at a time because
% user has to repeat fix and run multiple times, which can be very annoying.
not_found = true(num_props, 1);
for pp = 1 : num_props
  target_property = property_strings(pp);
  if ismember(target_property, struct_field_strings)
    not_found(pp) = false;
  end  % if
end  % for
if any(not_found)
  missing_props = property_strings(not_found);
  error_text = CodeTool1.i18n("Required properties were not found: " + join(missing_props, ", "));

  throw(MException(error_id, error_text))

end  % if

% Second-pass, copy.
% Set up the properties of app-config object while ignoring struct fields that are not required.
for pp = 1 : num_props
  target_property = property_strings(pp);
  AppConfigObj.(target_property) = ConfigStruct.(target_property);
end  % for

end  % function
