function Result = checkWebLocalHTMLInFile(FileName, NameValuePair)

arguments (Input)
  FileName (1,1) string = ""
  NameValuePair.DisplayInfo (1,1) logical = true
end  % arguments

arguments (Output)
  Result table
end  % arguments

% errorID = "checkWebLocalHtml:";

lines = readlines(FileName, WhitespaceRule="trim");

logical_index = matches(lines, wildcardPattern + "web(""" + wildcardPattern + ".html"")" + wildcardPattern);

if not(any(logical_index))
  Result = table.empty;

  return

end  % if

LineNumber = find(logical_index)';

num_files = numel(LineNumber);

CodeText = lines(logical_index);

LocalHTMLFile = extractBetween(CodeText, "web(""", """)");

Found = false(num_files, 1);
for ii = 1 : num_files
  target_html = LocalHTMLFile(ii);

  fullpath = string( which(target_html));
  if fullpath == ""
    Found(ii) = false;
  else
    if startsWith(target_html, "http")
      Found(ii) = false;
    else
      Found(ii) = true;
    end  % if
  end  % if
end  % for

Result = table(LineNumber, LocalHTMLFile, Found, CodeText);

end  % function
